//
//  AboutViewController.swift
//  zScanner
//
//  Created by Martin Georgiu on 11/08/2019.
//  Copyright © 2019 Institut klinické a experimentální medicíny. All rights reserved.
//

import UIKit

class AboutViewController: BaseViewController {
    
    // MARK: - Instance part
    private unowned let coordinator: MenuCoordinator
    
    init(coordinator: MenuCoordinator) {
        self.coordinator = coordinator
        super.init(coordinator: coordinator)
    }
    
    // MARK: Lifecycle
    override func loadView() {
        super.loadView()
        
        setupView()
    }
    
    // MARK: Helpers
    private func setupView() {
        navigationItem.title = "drawer.aboutApp.title".localized
      
        let medicalcLogo = getCompanyLogo(image: #imageLiteral(resourceName: "medicalcLogo"))
        stackView.addArrangedSubview(medicalcLogo)
        medicalcLogo.snp.makeConstraints { make in
            make.height.equalTo(102)
            make.width.equalTo(114)
        }
        
        stackView.addArrangedSubview(aboutHeader)
        stackView.addArrangedSubview(aboutParagraph)
        
        let ikemStackView = getCompanyStackView(logo: #imageLiteral(resourceName: "ikemLogo"), text: "about.copyright.ikem.title".localized)
        stackView.addArrangedSubview(ikemStackView)
       
        let bindworksStackView = getCompanyStackView(logo: #imageLiteral(resourceName: "bindworksLogo"), text: "about.copyright.bindworks.title".localized, firstImage: false)
        stackView.addArrangedSubview(bindworksStackView)
        
        let teskaLabsStackView = getCompanyStackView(logo: #imageLiteral(resourceName: "teskaLabsLogo"), text: "about.copyright.teskalabs.title".localized, firstImage: false)
        stackView.addArrangedSubview(teskaLabsStackView)
        
        stackView.addArrangedSubview(versionLabel)

        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        scrollView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.equalTo(scrollView.snp.top)
            make.leading.equalTo(scrollView.snp.leading)
            make.trailing.equalTo(scrollView.snp.trailing)
            make.bottom.equalTo(scrollView.snp.bottom)
            make.width.equalTo(scrollView.snp.width)
        }
        
        
    }
    
    private func getCompanyStackView(logo: UIImage, text: String, firstImage: Bool = true) -> UIStackView {
        let companyStackView = UIStackView()
        companyStackView.axis = .vertical
        companyStackView.alignment = .center
        companyStackView.spacing = 0
        
        if firstImage {
            companyStackView.addArrangedSubview(getCompanyLogo(image: logo))
            companyStackView.addArrangedSubview(getCompanyText(text: text))
        } else {
            companyStackView.addArrangedSubview(getCompanyText(text: text))
            companyStackView.addArrangedSubview(getCompanyLogo(image: logo))
        }
        
        return companyStackView
    }
  
    private func getCompanyLogo(image: UIImage) -> UIImageView {
        let companyLogo = UIImageView()
        companyLogo.image = image
        companyLogo.contentMode = .scaleAspectFit
        companyLogo.tintColor = .primary
        return companyLogo
    }
    
    private func getCompanyText(text: String) -> UILabel {
        let companyText = UILabel()
        companyText.text = text
        companyText.textAlignment = .center
        companyText.textColor = .primary
        companyText.font = .footnote
        return companyText
    }
    
    private lazy var aboutHeader: UILabel = {
        let label = UILabel()
        label.text = "about.header.title".localized
        label.textColor = .primary
        label.font = .headline
        return label
    }()
    
    private lazy var aboutParagraph: UILabel = {
        let label = UILabel()
        label.text = "about.info.paragraph".localized
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = .body
        label.textColor = .primary
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 30
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()
    
    private lazy var versionLabel: UILabel = {
        let label = UILabel()
        label.text = Bundle.main.formattedVersion
        label.textAlignment = .center
        label.textColor = .primary
        label.font = .footnote
        return label
    }()
}
