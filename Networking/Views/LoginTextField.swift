//
//  LoginTextField.swift
//  Networking
//
//  Created by Evgeniy Petlitskiy on 28.04.21.
//

import UIKit

class LoginTextField: UITextField {
    
    init(contentType: UITextContentType, keyboardType: UIKeyboardType) {
        super.init(frame: .zero)
        self.textContentType = contentType
        self.keyboardType = keyboardType
        self.backgroundColor = .clear
        self.textColor = .white
        self.font = .systemFont(ofSize: 18)
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
