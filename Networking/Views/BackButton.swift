//
//  BackButton.swift
//  Networking
//
//  Created by Evgeniy Petlitskiy on 29.04.21.
//

import UIKit

class BackButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let backImage = UIImage(named: "back")
        self.setBackgroundImage(backImage, for: .normal)
        self.backgroundColor = .clear
    }
    
    convenience init() {
        self.init(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
