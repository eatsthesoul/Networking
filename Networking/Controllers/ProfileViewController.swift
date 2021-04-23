//
//  ProfileViewController.swift
//  Networking
//
//  Created by Evgeniy Petlitskiy on 15.04.21.
//

import UIKit
import FBSDKLoginKit
import FirebaseAuth
import FirebaseDatabase

class ProfileViewController: UIViewController {
    
    let label: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AppleSDGothicNeo-Light", size: 30)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let spinnerForLabel: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.startAnimating()
        return spinner
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchUserInfo()
    }
    
    
    private func setupViews() {

        view.addSubview(label)
        view.addSubview(spinnerForLabel)
        view.addSubview(fbLogoutButton)
        
        fbLogoutButton.delegate = self
    }
    
    private func setupLayout() {
        
        label.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100).isActive = true
        label.widthAnchor.constraint(equalToConstant: 300).isActive = true
        
        spinnerForLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        spinnerForLabel.topAnchor.constraint(equalTo: label.topAnchor, constant: 45).isActive = true
        
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
    
    //log out of the profile
    private func openLoginVC() {
        
        do {
            try Auth.auth().signOut()
            
            let loginVC = LoginViewController()
            loginVC.modalPresentationStyle = .fullScreen
            self.present(loginVC, animated: false, completion: nil)
            
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
    //fetching user info from Firebase database
    private func fetchUserInfo() {
        
        if let currentUser = Auth.auth().currentUser {
            
            let userID = currentUser.uid
            let dataPath = Database.database().reference().child("users").child(userID)
            
            dataPath.observeSingleEvent(of: .value) { (snapshot) in
                
                guard let userInfo = snapshot.value as? [String : Any] else { return }
                guard let user = UserProfile(uid: userID, data: userInfo) else { return }
                self.label.text = "\(user.name ?? "")\nLogged in with Facebook"
                self.spinnerForLabel.stopAnimating()
                
            } withCancel: { (error) in
                
                print(error.localizedDescription)
            }
        }
    }
}
