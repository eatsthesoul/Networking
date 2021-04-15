//
//  LoginViewController.swift
//  Networking
//
//  Created by Evgeniy Petlitskiy on 14.04.21.
//

import UIKit
import FBSDKLoginKit

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




    override func viewDidLoad() {
        super.viewDidLoad()

        fbLoginButton.delegate = self
        
        
        setupViews()
        setupLayout()
        
        if let token = AccessToken.current, !token.isExpired {
            print("User is logged in")
        }
    }
    
    //MARK: - Setup User Interface functions
    
    private func setupViews() {
        view.addSubview(logoImageView)
        view.addSubview(networkingLabel)
        view.addSubview(fbLoginButton)
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
    }

}

extension LoginViewController: LoginButtonDelegate {
    
    
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        if error != nil {
            print(error!)
            return
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        print("Successfully logged out from facebook")
    }
    
    
}
