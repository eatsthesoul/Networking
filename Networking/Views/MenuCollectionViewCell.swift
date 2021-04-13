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
        label.backgroundColor = .systemGray2
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
                         padding: .init(top: 0, left: 50, bottom: 0, right: 50))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
