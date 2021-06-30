//
//  CAGradientLayer + backgroundGradient.swift
//  Networking
//
//  Created by Evgeniy Petlitskiy on 20.04.21.
//

import UIKit

extension CAGradientLayer {
    
    static let topColor = UIColor(red: (0/255.0), green: (153/255.0), blue:(51/255.0), alpha: 1)
    static let bottomColor = UIColor(red: (0/255.0), green: (153/255.0), blue:(255/255.0), alpha: 1)

    static func backgroundGradient() -> CAGradientLayer {
        
        let gradientColors: [CGColor] = [topColor.cgColor, bottomColor.cgColor]
        let gradientLocations: [NSNumber] = [0.0, 1.0]

        let gradientLayer: CAGradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientColors
        gradientLayer.locations = gradientLocations

        return gradientLayer

    }
}
