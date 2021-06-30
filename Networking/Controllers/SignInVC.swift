//
//  SignInVC.swift
//  Networking
//
//  Created by Evgeniy Petlitskiy on 28.04.21.
//

import UIKit
import Firebase

class SignInVC: UIViewController {
    
    lazy var backButton: UIButton = {
        let button = BackButton()
        button.frame.origin = CGPoint(x: view.bounds.width / 15, y: topPadding + 20)
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
    
    lazy var continueButton: ContinueButton = {
        let button = ContinueButton()
        button.center = CGPoint(x: view.center.x, y: view.frame.height - 80)
        button.addTarget(self, action: #selector(continueButtonHandler), for: .touchUpInside)
        return button
    }()


    //MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupLayout()
        
        textFieldsObserveSetup()
        textFieldsDelegatesSetup()
        swipeDownGesture()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        keyboardObserveSetup()
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
        
        view.addSubview(continueButton)
    }
    
    private func setupLayout() {
        
        //label
        signInLabel.topAnchor.constraint(equalTo: view.topAnchor,
                                         constant: topPadding + 45).isActive = true
        signInLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        //email
        emailLabel.anchor(top: signInLabel.bottomAnchor,
                          leading: view.leadingAnchor,
                          bottom: nil,
                          trailing: nil,
                          padding: .init(top: 30, left: 50, bottom: 0, right: 0))
        
        emailTextField.anchor(top: emailLabel.bottomAnchor,
                              leading: view.leadingAnchor,
                              bottom: nil,
                              trailing: view.trailingAnchor,
                              padding: .init(top: 8, left: 50, bottom: 0, right: 50))
        
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
                             padding: .init(top: 25, left: 50, bottom: 0, right: 0))
        
        passwordTextField.anchor(top: passwordLabel.bottomAnchor,
                                 leading: view.leadingAnchor,
                                 bottom: nil,
                                 trailing: view.trailingAnchor,
                                 padding: .init(top: 8, left: 50, bottom: 0, right: 50))
        
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
    
    //MARK: - Keyboard methods
    
    private func keyboardObserveSetup() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillAppear),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    @objc private func keyboardWillAppear(notification: NSNotification) {
        
        let userInfo = notification.userInfo!
        let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        continueButton.center = CGPoint(x: view.center.x,
                                        y: view.frame.height - keyboardFrame.height - 16.0 - continueButton.frame.height / 2)
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        
        continueButton.center = CGPoint(x: view.center.x, y: view.frame.height - 80)
    }
    

    //MARK: - Continue button activity methods
    
    private func textFieldsObserveSetup() {
        emailTextField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
    }
    
    @objc private func textFieldChanged() {
        
        guard
            let email = emailTextField.text,
            let password = passwordTextField.text
        else { return }
        
        let formFilled = !(email.isEmpty) && !(password.isEmpty)
        
        continueButton.setButton(enabled: formFilled)
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

    @objc private func continueButtonHandler() {
        
        guard let email = emailTextField.text,
              let password = passwordTextField.text
        else { return }
        
        continueButton.startSpinner()
        
        //sign in with email
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
             
            if let error = error {
                self.createUserInfoAlert(with: error.localizedDescription)
                self.continueButton.stopSpinner()
                return
            }
            
            print("Succesfully logged in with Email")
            self.presentingViewController?.presentingViewController?.dismiss(animated: true)
        }
    }
}

extension SignInVC: UIGestureRecognizerDelegate {
    
    //hide keyboard with swipe down gesture
    private func swipeDownGesture() {
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(hideKeyboard))
        swipeDown.delegate = self
        swipeDown.direction =  UISwipeGestureRecognizer.Direction.down
        self.view.addGestureRecognizer(swipeDown)
    }
    
    @objc private func hideKeyboard() {
        view.endEditing(true)
    }
}

extension SignInVC: UITextFieldDelegate {
    
    private func textFieldsDelegatesSetup() {
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    //hide keyboard with return tap
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}
