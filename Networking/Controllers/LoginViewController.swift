//
//  LoginViewController.swift
//  Networking
//
//  Created by Evgeniy Petlitskiy on 14.04.21.
//

import UIKit

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

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        setupLayout()
    }
    
    //MARK: - Setup User Interface functions
    
    private func setupViews() {
        view.addSubview(logoImageView)
        view.addSubview(networkingLabel)
    }
    
    private func setupLayout() {
        
        logoImageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        logoImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80).isActive = true
        
        networkingLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        networkingLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 35).isActive = true
        networkingLabel.widthAnchor.constraint(equalToConstant: view.bounds.width / 5 * 3).isActive = true
    }

}
