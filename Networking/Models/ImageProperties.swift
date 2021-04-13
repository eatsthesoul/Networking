//
//  ImageProperties.swift
//  Networking
//
//  Created by Evgeniy Petlitskiy on 29.03.21.
//

import UIKit

struct ImageProperties {
    
    let key: String
    let data: Data
    
    init?(withImage image: UIImage, forKey key: String) {
        self.key = key
        guard let imageData = image.pngData() else { return nil }
        self.data = imageData
    }
}
 
