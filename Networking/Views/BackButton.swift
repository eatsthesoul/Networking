//
//  BackButton.swift
//  Networking
//
//  Created by Evgeniy Petlitskiy on 29.04.21.
//

import UIKit

class BackButton: UIButton {

    init() {
        super.init(frame: CGRect(x: 30, y: 55, width: 30, height: 30))
        
        let backImage = UIImage(named: "back")
        self.setBackgroundImage(backImage, for: .normal)
        self.backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
