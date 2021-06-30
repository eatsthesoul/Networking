//
//  LoginTextFieldLabel.swift
//  Networking
//
//  Created by Evgeniy Petlitskiy on 28.04.21.
//

import UIKit

class LoginTextFieldLabel: UILabel {

    init(with text: String) {
        super.init(frame: .zero)
        self.font = .systemFont(ofSize: 14)
        self.text = text
        self.textColor = .white
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
