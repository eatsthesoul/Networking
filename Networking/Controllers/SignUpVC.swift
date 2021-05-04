//
//  SignUpVC.swift
//  Networking
//
//  Created by Evgeniy Petlitskiy on 29.04.21.
//

import UIKit
import Firebase

class SignUpVC: UIViewController {
    
    private var username = String()
    private var email = String()
    private var password = String()
    private var confirmedPassword = String()
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: view.frame)
        return scrollView
    }()
    
    lazy var backButton: UIButton = {
        let button = BackButton()
        button.frame.origin = CGPoint(x: view.bounds.width / 15, y: topPadding + 20)
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
        button.center = CGPoint(x: view.center.x, y: view.frame.height - 80)
        button.addTarget(self, action: #selector(continueButtonHandler), for: .touchUpInside)
        return button
    }()
    
    
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
        view.addSubview(scrollView)
        
        scrollView.addSubview(backButton)
        scrollView.addSubview(signUpLabel)
        
        scrollView.addSubview(usernameLabel)
        scrollView.addSubview(usernameTextField)
        scrollView.addSubview(usernameUnderline)
        
        scrollView.addSubview(emailLabel)
        scrollView.addSubview(emailTextField)
        scrollView.addSubview(emailUnderline)
        
        scrollView.addSubview(passwordLabel)
        scrollView.addSubview(passwordTextField)
        scrollView.addSubview(passwordUnderline)
        
        scrollView.addSubview(confirmPasswordLabel)
        scrollView.addSubview(confirmPasswordTextField)
        scrollView.addSubview(confirmPasswordUnderline)
        
        scrollView.addSubview(continueButton)
    }
    
    private func setupLayout() {
        
        //signUpLabel
        signUpLabel.topAnchor.constraint(equalTo: scrollView.topAnchor,
                                         constant: topPadding + 45).isActive = true
        signUpLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        
        //username
        usernameLabel.anchor(top: signUpLabel.bottomAnchor,
                             leading: view.leadingAnchor,
                             bottom: nil,
                             trailing: nil,
                             padding: .init(top: 30, left: 50, bottom: 0, right: 0))
        
        usernameTextField.anchor(top: usernameLabel.bottomAnchor,
                                 leading: view.leadingAnchor,
                                 bottom: nil,
                                 trailing: view.trailingAnchor,
                                 padding: .init(top: 8, left: 50, bottom: 0, right: 50))
        
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
                          padding: .init(top: 25, left: 50, bottom: 0, right: 0))
        
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
        
        //confirm password
        confirmPasswordLabel.anchor(top: passwordUnderline.bottomAnchor,
                                    leading: view.leadingAnchor,
                                    bottom: nil,
                                    trailing: nil,
                                    padding: .init(top: 25, left: 50, bottom: 0, right: 0))
        
        confirmPasswordTextField.anchor(top: confirmPasswordLabel.bottomAnchor,
                                        leading: view.leadingAnchor,
                                        bottom: nil,
                                        trailing: view.trailingAnchor,
                                        padding: .init(top: 8, left: 50, bottom: 0, right: 50))
        
        confirmPasswordUnderline.anchor(top: confirmPasswordTextField.bottomAnchor,
                                        leading: confirmPasswordTextField.leadingAnchor,
                                        bottom: nil,
                                        trailing: confirmPasswordTextField.trailingAnchor,
                                        padding: .init(top: 3, left: 0, bottom: 0, right: 0),
                                        size: .init(width: 0, height: 1))
    }
    
    
    //MARK: - Other methods
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    //MARK: - Handlers
    
    @objc private func backButtonHandler() {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    //MARK: - Sign up request methods
    
    @objc private func continueButtonHandler() {
        continueButton.startSpinner()
        gettingUserInfo()
        validatePassword()
        signUpRequest()
    }
    
    private func gettingUserInfo() {
        
        self.username = usernameTextField.text!
        self.email = emailTextField.text!
        self.password = passwordTextField.text!
        self.confirmedPassword = confirmPasswordTextField.text!
    }
    
    private func validatePassword() {
        
        //password is short
        if password.count < 6 {
            
            createUserInfoAlert(with: "Your password is short. This must contain at least 6 characters")
            continueButton.stopSpinner()
            return
            
        //passwords are different
        } else if password != confirmedPassword {
            
            createUserInfoAlert(with: "You entered two different passwords. Please try again")
            continueButton.stopSpinner()
            return
            
        } else {
            
            signUpRequest()
        }
    }

    
    private func signUpRequest() {
        
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            
            if let error = error {
                self.createUserInfoAlert(with: error.localizedDescription)
                self.continueButton.stopSpinner()
                self.continueButton.setButton(enabled: true)
                return
            }
            
            print("User is logged in")
            
            //other user data saving
            if let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest() {
                changeRequest.displayName = self.username
                changeRequest.commitChanges { (error) in
                    
                    if let error = error {
                        print(error.localizedDescription)
                        self.continueButton.stopSpinner()
                        self.continueButton.setButton(enabled: true)
                        return
                    }
                    
                    print("User data was saved")
                    self.presentingViewController?.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
                }
            }
        }
    }

    
    //MARK: - Continue button activity methods
    
    private func textFieldsObserveSetup() {
        usernameTextField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        emailTextField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        confirmPasswordTextField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
    }
    
    @objc private func textFieldChanged() {
        
        guard
            let username = usernameTextField.text,
            let email = emailTextField.text,
            let password = passwordTextField.text,
            let confirmPassword = confirmPasswordTextField.text
        else { return }
        
        let formFilled = !(username.isEmpty) && !(email.isEmpty) && !(password.isEmpty) && !(confirmPassword.isEmpty)
        
        continueButton.setButton(enabled: formFilled)
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
        let keyboardHeight = keyboardFrame.height
        
        moveViews(with: keyboardHeight)
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        
        returnViewsBack()
    }
    
    private func moveViews(with keyboardHeight: CGFloat) {
        
        let difference = scrollView.frame.height - confirmPasswordUnderline.frame.origin.y - 1 - 16 - continueButton.frame.height - 16 - keyboardHeight
        
        if difference < 0 {
            //scrollView moving
            let contentInsents = UIEdgeInsets(top: difference, left: 0, bottom: 0, right: 0)
            scrollView.contentInset = contentInsents
            scrollView.scrollIndicatorInsets = contentInsents
            
            //continue button moving
            continueButton.center = CGPoint(x: scrollView.center.x,
                                            y: confirmPasswordUnderline.frame.origin.y + 1 + 16 + continueButton.frame.height / 2)
        } else {
            //only continue button moving
            continueButton.center = CGPoint(x: scrollView.center.x,
                                            y: scrollView.frame.height - keyboardHeight - 16.0 - continueButton.frame.height / 2)
        }
    }
    
    private func returnViewsBack() {
        continueButton.center = CGPoint(x: view.center.x, y: view.frame.height - 80)
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
}

//MARK: - UIGestureRecognizerDelegate
extension SignUpVC: UIGestureRecognizerDelegate {
    
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

//MARK: - UITextFieldDelegate
extension SignUpVC: UITextFieldDelegate {
    
    private func textFieldsDelegatesSetup() {
        usernameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        confirmPasswordTextField.delegate = self
    }
    
    //hide keyboard with return tap
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}

