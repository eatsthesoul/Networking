//
//  ProfileViewController.swift
//  Networking
//
//  Created by Evgeniy Petlitskiy on 15.04.21.
//

import UIKit
import FBSDKLoginKit
import FirebaseAuth

class ProfileViewController: UIViewController {
    
    let label: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AppleSDGothicNeo-Light", size: 30)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Logged in with Facebook"
        return label
    }()
    
    private let fbLogoutButton: FBLoginButton = {
        let button = FBLoginButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let background = CAGradientLayer.backgroundGradient()
        background.frame = self.view.bounds
        self.view.layer.insertSublayer(background, at: 0)

        setupViews()
        setupLayout()
        
    }
    
    
    
    private func setupViews() {
        view.addSubview(label)
        view.addSubview(fbLogoutButton)
        
        fbLogoutButton.delegate = self
    }
    
    private func setupLayout() {
        
        label.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100).isActive = true
        label.widthAnchor.constraint(equalToConstant: 300).isActive = true
        
        fbLogoutButton.anchor(top: nil,
                              leading: view.leadingAnchor,
                              bottom: view.safeAreaLayoutGuide.bottomAnchor,
                              trailing: view.trailingAnchor,
                              padding: .init(top: 0, left: 70, bottom: 20, right: 70))
    }

}

extension ProfileViewController: LoginButtonDelegate {
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        if error != nil {
            print(error!)
            return
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        openLoginVC()
    }
    
    func openLoginVC() {
        
        do {
            try Auth.auth().signOut()
            
            let loginVC = LoginViewController()
            loginVC.modalPresentationStyle = .fullScreen
            self.present(loginVC, animated: false, completion: nil)
            
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
}
