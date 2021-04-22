//
//  LoginViewController.swift
//  Networking
//
//  Created by Evgeniy Petlitskiy on 14.04.21.
//

import UIKit
import FBSDKLoginKit
import FirebaseAuth

class LoginViewController: UIViewController {
    
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "logo")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let networkingLabel: UILabel = {
        let label = UILabel()
        label.text = "Networking App"
        label.font = UIFont(name: "AppleSDGothicNeo-Light", size: 40)
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let fbLoginButton: FBLoginButton = {
        let button = FBLoginButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let customFbLoginButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemBlue
        button.setTitle("Login with Facebook", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 4
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleCustomFbLogin), for: .touchUpInside)
        return button
    }()

    
    //MARK: - VC Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()

        fbLoginButton.delegate = self
        
        setupViews()
        setupLayout()
    }
    
    //MARK: - Setup User Interface functions
    
    private func setupViews() {
        view.addSubview(logoImageView)
        view.addSubview(networkingLabel)
        view.addSubview(fbLoginButton)
        view.addSubview(customFbLoginButton)
    }
    
    private func setupLayout() {
        
        logoImageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        logoImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80).isActive = true
        
        networkingLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        networkingLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 35).isActive = true
        networkingLabel.widthAnchor.constraint(equalToConstant: view.bounds.width / 5 * 3).isActive = true
        
        fbLoginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        fbLoginButton.topAnchor.constraint(equalTo: networkingLabel.bottomAnchor, constant: 35).isActive = true
        fbLoginButton.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        customFbLoginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        customFbLoginButton.topAnchor.constraint(equalTo: fbLoginButton.bottomAnchor, constant: 20).isActive = true
        customFbLoginButton.heightAnchor.constraint(equalToConstant: 35).isActive = true
        customFbLoginButton.widthAnchor.constraint(equalToConstant: 300).isActive = true
    }

}

extension LoginViewController: LoginButtonDelegate {
    
    
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        if error != nil {
            print(error!)
            return
        }
        signIntoFirebase()
        openMainVC()
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        print("Successfully logged out from facebook")
    }
    
    func openMainVC() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func handleCustomFbLogin() {
        
        LoginManager().logIn(permissions: ["public_profile", "email"], from: self) { (result, error) in
            
            if error != nil {
                print(error!.localizedDescription)
                return
            }
            
            guard let result = result  else { return }
                
            if result.isCancelled { return }
            else {
                self.signIntoFirebase()
                self.openMainVC()
            }
        }
    }
    
    private func signIntoFirebase() {
        let credential = FacebookAuthProvider.credential(withAccessToken: AccessToken.current!.tokenString)
        Auth.auth().signIn(with: credential) { (result, error) in

            if let error = error {
                print("Something went wrong with FB user: \(error.localizedDescription)")
                return
            }
            
            print("Succesfully logged in with FB user: \(result!)")
        }
    }
}
