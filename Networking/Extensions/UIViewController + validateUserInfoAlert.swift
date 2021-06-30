//
//  UIViewController + validateUserInfoAlert.swift
//  Networking
//
//  Created by Evgeniy Petlitskiy on 4.05.21.
//

import UIKit

extension UIViewController {
    
    func createUserInfoAlert(with message: String) {
        let alert = UIAlertController(title: "Error!",
                                      message: message,
                                      preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "OK", style: .cancel)
        alert.addAction(ok)
        
        present(alert, animated: true, completion: nil)
    }
}
