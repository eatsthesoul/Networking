//
//  MenuCollectionViewCell.swift
//  Networking
//
//  Created by Evgeniy Petlitskiy on 23.03.21.
//

import UIKit

class MenuCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "MenuCellIdentifier"
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor(red: (255/255.0), green: (255/255.0), blue:(255/255.0), alpha: 0.2)
        label.font = UIFont(name: "Party LET", size: 50)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.layer.cornerRadius = 10
        label.layer.masksToBounds = true
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(nameLabel)
        nameLabel.anchor(top: topAnchor,
                         leading: leadingAnchor,
                         bottom: bottomAnchor,
                         trailing: trailingAnchor,
                         padding: .init(top: 0, left: 20, bottom: 0, right: 20))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
