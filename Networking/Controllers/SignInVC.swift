//
//  SignInVC.swift
//  Networking
//
//  Created by Evgeniy Petlitskiy on 28.04.21.
//

import UIKit

class SignInVC: UIViewController {
    
    private let backButton: UIButton = {
        let button = BackButton()
        button.addTarget(self, action: #selector(backButtonHandler), for: .touchUpInside)
        return button
    }()
    
    private let signInLabel: UILabel = {
        let label = UILabel()
        label.text = "Sign In"
        label.font = .boldSystemFont(ofSize: 25)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
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
    
    //sign up button
    private let signUpButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.setTitle("Sign Up", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.setTitleColor(.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(signUpHandler), for: .touchUpInside)
        return button
    }()


    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        setupLayout()
        
    }
    
    //MARK: - Setup User Interface methods
    
    private func setupViews() {
        view.addSubview(backButton)
        view.addSubview(signInLabel)
        
        view.addSubview(emailLabel)
        view.addSubview(emailTextField)
        view.addSubview(emailUnderline)
        
        view.addSubview(passwordLabel)
        view.addSubview(passwordTextField)
        view.addSubview(passwordUnderline)
        
        view.addSubview(signUpButton)
    }
    
    private func setupLayout() {
        
        //label
        signInLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,
                                         constant: view.bounds.height / 15).isActive = true
        signInLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        //email
        emailLabel.anchor(top: signInLabel.bottomAnchor,
                          leading: view.leadingAnchor,
                          bottom: nil,
                          trailing: nil,
                          padding: .init(top: 20, left: 50, bottom: 0, right: 0))
        
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
                             trailing: nil,
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
        
        //signUp button
        signUpButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        signUpButton.topAnchor.constraint(equalTo: passwordUnderline.bottomAnchor, constant: 50).isActive = true
        signUpButton.heightAnchor.constraint(equalToConstant: 35).isActive = true
        signUpButton.widthAnchor.constraint(equalToConstant: 300).isActive = true
        
    }
    
    //MARK: - Handlers
    
    @objc private func signUpHandler() {
        let signUpVC = SignUpVC()
        signUpVC.modalPresentationStyle = .fullScreen
        present(signUpVC, animated: true, completion: nil)
    }
    
    @objc private func backButtonHandler() {
        self.dismiss(animated: true, completion: nil)
    }
}
