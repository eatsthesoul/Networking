//
//  ProfileViewController.swift
//  Networking
//
//  Created by Evgeniy Petlitskiy on 15.04.21.
//

import UIKit

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
    }
    
    private func setupLayout() {
        
        label.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100).isActive = true
        label.widthAnchor.constraint(equalToConstant: 300).isActive = true
        
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
