//
//  TabBarController.swift
//  Networking
//
//  Created by Evgeniy Petlitskiy on 20.04.21.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        configure()
    }
    
    private func configure() {
        
        let menu = createNavController(with: MenuViewController(), title: "Menu", image: #imageLiteral(resourceName: "blank"))
        let profile = createNavController(with: ProfileViewController(), title: "Profile", image: #imageLiteral(resourceName: "blank"))
        
        self.viewControllers = [menu, profile]
    }
    
    private func createNavController(with viewController: UIViewController, title: String, image: UIImage) -> UINavigationController {
        
        let navController = UINavigationController(rootViewController: viewController)
        viewController.navigationItem.title = title
        navController.tabBarItem.title = title
        navController.tabBarItem.image = image
        
        return navController
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
