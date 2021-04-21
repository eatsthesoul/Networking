//
//  TabBarController.swift
//  Networking
//
//  Created by Evgeniy Petlitskiy on 20.04.21.
//

import UIKit
import FBSDKLoginKit
import FirebaseAuth

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        checkLoggedIn()
        configure()
    }
    
    private func configure() {
        
        let menu = createNavController(with: MenuViewController(), title: "Menu", image: #imageLiteral(resourceName: "blank"))
        let profile = createNavController(with: ProfileViewController(), title: "Profile", image: #imageLiteral(resourceName: "profile"))
        
        self.viewControllers = [menu, profile]
    }
    
    private func createNavController(with viewController: UIViewController, title: String, image: UIImage) -> UINavigationController {
        
        let navController = UINavigationController(rootViewController: viewController)
        viewController.navigationItem.title = title
        navController.tabBarItem.title = title
        navController.tabBarItem.image = image
        
        return navController
    }
   

}

//MARK: - Facebook SDK

extension TabBarController {
    
    private func checkLoggedIn() {
        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
                let loginVC = LoginViewController()
                loginVC.modalPresentationStyle = .fullScreen
                self.present(loginVC, animated: false, completion: nil)
            }
            return
        }
    }
}

