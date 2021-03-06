//
//  SplashViewController.swift
//  zScanner
//
//  Created by Jakub Skořepa on 07/09/2019.
//  Copyright © 2019 Institut klinické a experimentální medicíny. All rights reserved.
//

import UIKit
import SeaCat

protocol SeaCatSplashCoordinator: BaseCoordinator {
    func seaCatInitialized()
}

class SeaCatSplashViewController: BaseViewController, ErrorHandling {
    
    private unowned let coordinator: SeaCatSplashCoordinator

    init(coordinator: SeaCatSplashCoordinator) {
        self.coordinator = coordinator
        super.init(coordinator: coordinator)
    }

    override func loadView() {
        guard let launchScreen = UIStoryboard(name: "LaunchScreen", bundle: nil).instantiateInitialViewController() else {
            super.loadView()
            return
        }
        
        let launchView = launchScreen.view
        launchScreen.view = nil
        view = launchView
        
        setupView()
    }

    override func viewDidAppear(_ animated: Bool) {
        checkInternetConnection()
    }
    
    // MARK: SeaCat
    private var seaCatTimer: Timer?
    private let reachability = try! Reachability()
    
    private func checkInternetConnection() {
        if reachability.connection == .unavailable {
            NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(note:)), name: .reachabilityChanged, object: reachability)
            try? reachability.startNotifier()
            
            infoLabel.text = "splash.waitingForInternet.message".localized
            handleError(RequestError(.noInternetConnection), okCallback: nil, retryCallback: nil)
        } else {
            initializeSeaCat()
        }
    }
    
    @objc func reachabilityChanged(note: Notification) {
        guard let reachability = note.object as? Reachability else { return }

        switch reachability.connection {
        case .cellular, .wifi:
            reachability.stopNotifier()
            NotificationCenter.default.removeObserver(self, name: .reachabilityChanged, object: reachability)
            initializeSeaCat()
        case .unavailable, .none:
            break
        }
    }
   
    private func initializeSeaCat() {
        infoLabel.text = "splash.waitingForSeaCat.message".localized
        
        seaCatTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(seaCatStateChanged), userInfo: nil, repeats: true)
        seaCatStateChanged()
    }

    @objc private func seaCatStateChanged() {
        if SeaCat.ready {
            seaCatTimer?.invalidate()

            DispatchQueue.main.async {
                self.coordinator.seaCatInitialized()
            }
        }
    }

    private func setupView() {
        guard let copyright = view.subviews.last(where: { $0 is UILabel }) else { return }
        
        view.addSubview(container)
        container.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(copyright.snp.top).offset(-30)
        }
        
        container.addSubview(infoLabel)
        infoLabel.snp.makeConstraints { make in
            make.top.bottom.left.equalToSuperview()
        }
        
        container.addSubview(loading)
        loading.snp.makeConstraints { make in
            make.right.centerY.equalToSuperview()
            make.left.equalTo(infoLabel.snp.right).offset(8)
        }
    }
    
    private lazy var container = UIView()
    
    private lazy var infoLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .footnote
        return label
    }()
    
    private lazy var loading: UIActivityIndicatorView = {
        let loading = UIActivityIndicatorView(style: .gray)
        loading.startAnimating()
        return loading
    }()
}
