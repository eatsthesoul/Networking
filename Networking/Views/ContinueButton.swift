//
//  ContinueButton.swift
//  Networking
//
//  Created by Evgeniy Petlitskiy on 29.04.21.
//

import UIKit

class ContinueButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor(white: 1, alpha: 0.4)
        self.setTitle("Continue", for: .normal)
        self.setTitleColor(CAGradientLayer.bottomColor, for: .normal)
        self.titleLabel?.font = .boldSystemFont(ofSize: 16)
        self.layer.cornerRadius = 6
    }
    
    convenience init() {
        self.init(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
