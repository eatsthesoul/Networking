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
    
    private var provider: String?
    private var currentUser: UserProfile?
    
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
    
    private let logoutButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemBlue
        button.setTitle("Log out", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 16)
        button.layer.cornerRadius = 4
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(logOut), for: .touchUpInside)
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
        view.addSubview(logoutButton)
    }
    
    private func setupLayout() {
        
        label.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100).isActive = true
        label.widthAnchor.constraint(equalToConstant: 300).isActive = true
        
        spinnerForLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        spinnerForLabel.topAnchor.constraint(equalTo: label.topAnchor, constant: 45).isActive = true
        
        logoutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        logoutButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30).isActive = true
        logoutButton.widthAnchor.constraint(equalToConstant: 300).isActive = true
        logoutButton.heightAnchor.constraint(equalToConstant: 35).isActive = true
    }

}

extension ProfileViewController {
    
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
                self.currentUser = UserProfile(uid: userID, data: userInfo)
                
                self.label.text = self.getLabelText()
                
                self.spinnerForLabel.stopAnimating()
                
            } withCancel: { (error) in
                
                print(error.localizedDescription)
            }
        }
    }
    
    private func getCurrentProvider() {
        
        guard let providerData = Auth.auth().currentUser?.providerData else { return }
        
        providerData.forEach { (userInfo) in
            self.provider = userInfo.providerID
        }
    }
    
    //label functions
    private func getLabelText() -> String {
        
        getCurrentProvider()
        let text = "\(self.currentUser?.name ?? "Noname")\nLogged in with \(convertProviderForLabel())"
        return text
    }
    
    private func convertProviderForLabel() -> String {
        
        switch provider {
        case "facebook.com":
            return "Facebook"
        case "google.com":
            return "Google"
        default:
            return ""
        }
    }
    
    //log out functionality
    @objc private func logOut() {
        
        switch self.provider {
        
        case "facebook.com":
            LoginManager().logOut()
            print("User logged out of Facebook")
            openLoginVC()
            
        case "google.com":
            do {
                try Auth.auth().signOut()
            } catch let signOutError as NSError {
                print ("Error signing out: %@", signOutError)
                return
            }
            print("User logged out of Google")
            openLoginVC()
            
        default:
            break
        }
    }
}
