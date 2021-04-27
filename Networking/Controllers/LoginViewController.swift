//
//  LoginViewController.swift
//  Networking
//
//  Created by Evgeniy Petlitskiy on 14.04.21.
//

import UIKit
import FBSDKLoginKit
import FirebaseAuth
import FirebaseDatabase
import GoogleSignIn

class LoginViewController: UIViewController {
    
    var userProfile: UserProfile?
    
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
//        button.translatesAutoresizingMaskIntoConstraints = false
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
    
    private let googleButton: GIDSignInButton = {
        let button = GIDSignInButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    //MARK: - VC Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fbLoginButton.delegate = self
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance()?.presentingViewController = self
        
        //background settings
//        let background = CAGradientLayer.backgroundGradient()
//        background.frame = self.view.bounds
//        self.view.layer.insertSublayer(background, at: 0)
        
        setupViews()
        setupLayout()
    }
    
    //MARK: - Setup User Interface functions
    
    private func setupViews() {
        view.addSubview(logoImageView)
        view.addSubview(networkingLabel)
        view.addSubview(fbLoginButton)
        view.addSubview(customFbLoginButton)
        view.addSubview(googleButton)
    }
    
    private func setupLayout() {
        
        logoImageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        logoImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 70).isActive = true
        
        networkingLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        networkingLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 30).isActive = true
        networkingLabel.widthAnchor.constraint(equalToConstant: view.bounds.width / 5 * 3).isActive = true
        
        //this stock Facebook button doesn't work correctly with Autolayout
        fbLoginButton.frame = CGRect(x: self.view.bounds.width / 2 - 150,
                                     y: 365,
                                     width: 300,
                                     height: 35)
        
        customFbLoginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        customFbLoginButton.topAnchor.constraint(equalTo: fbLoginButton.bottomAnchor, constant: 20).isActive = true
        customFbLoginButton.heightAnchor.constraint(equalToConstant: 35).isActive = true
        customFbLoginButton.widthAnchor.constraint(equalToConstant: 300).isActive = true
        
        googleButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        googleButton.topAnchor.constraint(equalTo: customFbLoginButton.bottomAnchor, constant: 20).isActive = true
        googleButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        googleButton.widthAnchor.constraint(equalToConstant: 305).isActive = true
    }
    
    func openMainVC() {
        self.dismiss(animated: true, completion: nil)
    }
}


//MARK: - Facebook SDK
extension LoginViewController: LoginButtonDelegate {
    
    //stock FB login button enter
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        if error != nil {
            print(error!)
            return
        }
        signIntoFirebase()
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        print("Successfully logged out from facebook")
    }
    
    //custom FB login button enter
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
            }
        }
    }
    
    //data transfer to Firebase
    private func signIntoFirebase() {
        let credential = FacebookAuthProvider.credential(withAccessToken: AccessToken.current!.tokenString)
        Auth.auth().signIn(with: credential) { (result, error) in
            
            if let error = error {
                print("Something went wrong with FB user: \(error.localizedDescription)")
                return
            }
            
            print("Succesfully logged in with FB user")
            
            self.fetchFacebookFields()
        }
    }
    
    //get facebook fields
    private func fetchFacebookFields() {
        GraphRequest.init(graphPath: "me", parameters: ["fields" : "id, name, email"]).start { (_, result, error) in
            
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let userData = result as? [String : Any] else { return }
            self.userProfile = UserProfile(data: userData)
            
            self.saveUserFieldsToFirebase()
        }
    }
    
    private func saveUserFieldsToFirebase() {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let userData = ["name": userProfile?.name, "email": userProfile?.email]
        let values = [uid: userData]
        
        Database.database().reference().child("users").updateChildValues(values) { (error, _) in
            
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            print("Successfully saved info into Firebase database")
            self.openMainVC()
        }
    }
}

//MARK: - Google SDK

extension LoginViewController: GIDSignInDelegate {
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        if let error = error {
            print("Failed to log into Google: ", error)
            return
        }
        
        print("Succesfully logged into Google")
        
        //retrieving Google user fields
        if let fullName = user.profile.name, let email = user.profile.email {
            let userData = ["name": fullName, "email": email]
            self.userProfile = UserProfile(data: userData)
        }
        
        //getting user credentials
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        //sign into Firebase
        Auth.auth().signIn(with: credential) { (result, error) in
            if let error = error {
                print("Something went wrong with Google user: ", error)
                return
            }
            
            print("Succsessfully logged into Firebase with Google user")
            self.saveUserFieldsToFirebase()
        }
    }
}
