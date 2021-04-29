//
//  SignUpVC.swift
//  Networking
//
//  Created by Evgeniy Petlitskiy on 29.04.21.
//

import UIKit

class SignUpVC: UIViewController {
    
    lazy var backButton: UIButton = {
        let button = BackButton()
        button.frame.origin = CGPoint(x: view.bounds.width / 15, y: view.bounds.height / 17)
        button.addTarget(self, action: #selector(backButtonHandler), for: .touchUpInside)
        return button
    }()
    
    private let signUpLabel: UILabel = {
        let label = UILabel()
        label.text = "Sign Up"
        label.font = .boldSystemFont(ofSize: 25)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //username
    private let usernameLabel = LoginTextFieldLabel(with: "USERNAME")
    private let usernameTextField = LoginTextField(contentType: .name, keyboardType: .default)
    private let usernameUnderline = UnderlineView()
    
    //email
    private let emailLabel = LoginTextFieldLabel(with: "EMAIL")
    private let emailTextField = LoginTextField(contentType: .emailAddress, keyboardType: .emailAddress)
    private let emailUnderline = UnderlineView()
    
    //password
    private let passwordLabel = LoginTextFieldLabel(with: "PASSWORD")
    private let passwordTextField: LoginTextField = {
        let textField = LoginTextField(contentType: .password, keyboardType: .default)
        textField.isSecureTextEntry = true
        return textField
    }()
    private let passwordUnderline = UnderlineView()
    
    //confirm password
    private let confirmPasswordLabel = LoginTextFieldLabel(with: "CONFIRM PASSWORD")
    private let confirmPasswordTextField: LoginTextField = {
        let textField = LoginTextField(contentType: .password, keyboardType: .default)
        textField.isSecureTextEntry = true
        return textField
    }()
    private let confirmPasswordUnderline = UnderlineView()
    
    //continue button
    lazy var continueButton: ContinueButton = {
        let button = ContinueButton()
        button.center = CGPoint(x: view.center.x, y: view.frame.height - 100)
        return button
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        setupLayout()
    }
    
    private func setupViews() {
        view.addSubview(backButton)
        view.addSubview(signUpLabel)
        
        view.addSubview(usernameLabel)
        view.addSubview(usernameTextField)
        view.addSubview(usernameUnderline)
        
        view.addSubview(emailLabel)
        view.addSubview(emailTextField)
        view.addSubview(emailUnderline)
        
        view.addSubview(passwordLabel)
        view.addSubview(passwordTextField)
        view.addSubview(passwordUnderline)
        
        view.addSubview(confirmPasswordLabel)
        view.addSubview(confirmPasswordTextField)
        view.addSubview(confirmPasswordUnderline)
        
        view.addSubview(continueButton)
    }

    private func setupLayout() {
        
        //signUpLabel
        signUpLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,
                                         constant: view.bounds.height / 15).isActive = true
        signUpLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        //username
        usernameLabel.anchor(top: signUpLabel.bottomAnchor,
                          leading: view.leadingAnchor,
                          bottom: nil,
                          trailing: nil,
                          padding: .init(top: 20, left: 50, bottom: 0, right: 0))
        
        usernameTextField.anchor(top: usernameLabel.bottomAnchor,
                              leading: view.leadingAnchor,
                              bottom: nil,
                              trailing: view.trailingAnchor,
                              padding: .init(top: 10, left: 50, bottom: 0, right: 50))
        
        usernameUnderline.anchor(top: usernameTextField.bottomAnchor,
                              leading: usernameTextField.leadingAnchor,
                              bottom: nil,
                              trailing: usernameTextField.trailingAnchor,
                              padding: .init(top: 3, left: 0, bottom: 0, right: 0),
                              size: .init(width: 0, height: 1))
        
        //email
        emailLabel.anchor(top: usernameUnderline.bottomAnchor,
                             leading: view.leadingAnchor,
                             bottom: nil,
                             trailing: nil,
                             padding: .init(top: 40, left: 50, bottom: 0, right: 0))
        
        emailTextField.anchor(top: emailLabel.bottomAnchor,
                                 leading: view.leadingAnchor,
                                 bottom: nil,
                                 trailing: view.trailingAnchor,
                                 padding: .init(top: 10, left: 50, bottom: 0, right: 50))
        
        emailUnderline.anchor(top: emailTextField.bottomAnchor,
                              leading: emailTextField.leadingAnchor,
                              bottom: nil,
                              trailing: emailTextField.trailingAnchor,
                              padding: .init(top: 3, left: 0, bottom: 0, right: 0),
                              size: .init(width: 0, height: 1))
        
        //password
        passwordLabel.anchor(top: emailUnderline.bottomAnchor,
                             leading: view.leadingAnchor,
                             bottom: nil,
                             trailing: view.trailingAnchor,
                             padding: .init(top: 40, left: 50, bottom: 0, right: 0))
        
        passwordTextField.anchor(top: passwordLabel.bottomAnchor,
                                 leading: view.leadingAnchor,
                                 bottom: nil,
                                 trailing: view.trailingAnchor,
                                 padding: .init(top: 10, left: 50, bottom: 0, right: 50))
        
        passwordUnderline.anchor(top: passwordTextField.bottomAnchor,
                              leading: passwordTextField.leadingAnchor,
                              bottom: nil,
                              trailing: passwordTextField.trailingAnchor,
                              padding: .init(top: 3, left: 0, bottom: 0, right: 0),
                              size: .init(width: 0, height: 1))
        
        //confirm password
        confirmPasswordLabel.anchor(top: passwordUnderline.bottomAnchor,
                             leading: view.leadingAnchor,
                             bottom: nil,
                             trailing: view.trailingAnchor,
                             padding: .init(top: 40, left: 50, bottom: 0, right: 0))
        
        confirmPasswordTextField.anchor(top: confirmPasswordLabel.bottomAnchor,
                                 leading: view.leadingAnchor,
                                 bottom: nil,
                                 trailing: view.trailingAnchor,
                                 padding: .init(top: 10, left: 50, bottom: 0, right: 50))
        
        confirmPasswordUnderline.anchor(top: confirmPasswordTextField.bottomAnchor,
                              leading: confirmPasswordTextField.leadingAnchor,
                              bottom: nil,
                              trailing: confirmPasswordTextField.trailingAnchor,
                              padding: .init(top: 3, left: 0, bottom: 0, right: 0),
                              size: .init(width: 0, height: 1))
    }
    
    //MARK: - Handlers
    
    @objc private func backButtonHandler() {
        self.dismiss(animated: true, completion: nil)
    }
}
