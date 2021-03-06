//
//  LoginViewController.swift
//  zScanner
//
//  Created by Jakub Skořepa on 13/07/2019.
//  Copyright © 2019 Institut klinické a experimentální medicíny. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

protocol LoginViewDelegate: BaseCoordinator {
    func successfulLogin(with login: LoginDomainModel)
}

class LoginViewController: BaseViewController, ErrorHandling {

    // MARK: Instance part
    private unowned let coordinator: LoginViewDelegate
    private let viewModel: LoginViewModel
    
    init(viewModel: LoginViewModel, coordinator: LoginViewDelegate, services: [ViewControllerService] = []) {
        self.coordinator = coordinator
        self.viewModel = viewModel
        super.init(coordinator: coordinator, services: services)
    }

    override func loadView() {
        super.loadView()
        
        setupView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBindings()
    }
    
    // MARK: Helpers
    
    private let disposeBag = DisposeBag()
    
    private func setupBindings() {
        usernameTextField.placeholder = viewModel.usernameField.title
        usernameTextField.rx.text
            .orEmpty
            .bind(to: viewModel.usernameField.text)
            .disposed(by: disposeBag)
        
        usernameTextField.rx.controlEvent(.editingDidEndOnExit).subscribe { [weak self] _ in
            _ = self?.passwordTextField.becomeFirstResponder()
        }.disposed(by: disposeBag)
        
        passwordTextField.placeholder = viewModel.passwordField.title
        passwordTextField.rx.text
            .orEmpty
            .bind(to: viewModel.passwordField.text)
            .disposed(by: disposeBag)
        
        passwordTextField.passwordToggleButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.viewModel.passwordField.protected.toggle()
            })
            .disposed(by: disposeBag)
        
        passwordTextField.rx.controlEvent(.editingDidEndOnExit).subscribe { [weak self] _ in
            self?.viewModel.signin()
        }.disposed(by: disposeBag)
        
        viewModel.passwordField.protected
            .bind(to: passwordTextField.protected)
            .disposed(by: disposeBag)
        
        viewModel.isValid
            .bind(to: loginButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        loginButton.rx.tap
            .do(onNext: { [weak self] in
                self?.usernameTextField.resignFirstResponder()
                self?.passwordTextField.resignFirstResponder()
            })
            .subscribe(onNext: { [weak self] in
                self?.viewModel.signin()
            })
            .disposed(by: disposeBag)
        
        viewModel.status
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] status in
                if status == .loading {
                    self?.loading.startAnimating()
                } else {
                    self?.loading.stopAnimating()
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.status
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [unowned self] status in
                switch status {
                case .success:
                    self.coordinator.successfulLogin(with: self.viewModel.loginModel)
                case .error(let error):
                    self.handleError(error, okCallback: nil, retryCallback: nil)
                default:
                    break
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func setupView() {
        view.addSubview(container)
        
        container.snp.makeConstraints { make in
            make.centerX.equalTo(safeArea)
            make.centerY.equalTo(safeArea).offset(-100)
            make.width.equalTo(200)
        }
        
        container.addSubview(logoView)
        logoView.snp.makeConstraints { make in
            make.top.centerX.equalToSuperview()
            make.width.equalTo(140)
            make.height.equalTo(125)
        }
        
        container.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(logoView.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
            make.right.left.equalToSuperview()
        }
        
        container.addSubview(usernameTextField)
        usernameTextField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.right.left.equalToSuperview()
            make.height.greaterThanOrEqualTo(30)
        }

        container.addSubview(passwordTextField)
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(usernameTextField.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.left.right.equalToSuperview()
            make.height.greaterThanOrEqualTo(30)
        }
        
        container.addSubview(loginButton)
        loginButton.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(40)
            make.bottom.centerX.equalToSuperview()
            make.right.left.equalToSuperview().inset(20)
        }
        
        loginButton.addSubview(loading)
        loading.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(12)
        }
        
        titleLabel.text = "login.screen.title".localized

        view.addSubview(creditStackView)
        creditStackView.snp.makeConstraints { make in
            make.top.equalTo(container.snp.bottom).offset(100)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        let bindworksStackView = getCompanyStackView(logo: scaleImage(sourceImage: #imageLiteral(resourceName: "bindWorksLogo"), scaledToWidth: 150), text: "about.copyright.bindworks.title".localized)
        creditStackView.addArrangedSubview(bindworksStackView)
     
        let teskaLabsStackView = getCompanyStackView(logo: scaleImage(sourceImage: #imageLiteral(resourceName: "teskaLabsLogo"), scaledToWidth: 150), text: "about.copyright.teskalabs.title".localized)
        creditStackView.addArrangedSubview(teskaLabsStackView)
        teskaLabsStackView.snp.makeConstraints { make in
            make.height.equalTo(bindworksStackView.snp.height)
        }
    }
    
    private func getCompanyStackView(logo: UIImage, text: String) -> UIStackView {
        let companyStackView = UIStackView()
        companyStackView.axis = .vertical
        companyStackView.alignment = .center
        companyStackView.spacing = 0
        companyStackView.addArrangedSubview(getCompanyText(text: text))
        companyStackView.addArrangedSubview(getCompanyLogo(image: logo))
        return companyStackView
    }
    
    private func getCompanyLogo(image: UIImage) -> UIImageView {
        let companyLogo = UIImageView(image: image)
        companyLogo.contentMode = .scaleAspectFit
        companyLogo.tintColor = .primary
        return companyLogo
    }
    
    private func getCompanyText(text: String) -> UILabel {
        let companyText = UILabel()
        companyText.text = text
        companyText.textAlignment = .center
        companyText.textColor = .primary
        companyText.font = .credit
        return companyText
    }
    
    //Change the width of the image in that ratio
    func scaleImage(sourceImage:UIImage, scaledToWidth: CGFloat) -> UIImage {
        let oldWidth = sourceImage.size.width
        let scaleFactor = scaledToWidth / oldWidth

        let newHeight = sourceImage.size.height * scaleFactor
        let newWidth = oldWidth * scaleFactor

        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        sourceImage.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
    private lazy var logoView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "medicalcLogo")
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .white
        imageView.backgroundColor = .white
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .primary
        label.font = .headline
        label.textAlignment = .center
        return label
    }()
    
    private lazy var usernameTextField: UITextField = {
        let textField = UITextField()
        textField.textContentType = .username
        textField.autocapitalizationType = .none
        textField.delegate = self
        textField.font = .body
        return textField
    }()
    
    private lazy var passwordTextField: PasswordTextField = {
        let textField = PasswordTextField()
        textField.textContentType = .password
        textField.isSecureTextEntry = true
        textField.delegate = self
        textField.font = .body
        return textField
    }()

    private lazy var loginButton: PrimaryButton = {
        let button = PrimaryButton()
        button.setTitle("login.button.title".localized, for: .normal)
        return button
    }()
    
    private lazy var loading: UIActivityIndicatorView = {
        let loading = UIActivityIndicatorView(style: .white)
        loading.hidesWhenStopped = true
        return loading
    }()
        
    private lazy var container: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var creditStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.spacing = 0
        return stackView
    }()
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.setBottomBorder()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.setBottomBorder(show: false)
    }
}
