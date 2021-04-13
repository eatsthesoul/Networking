//
//  GetRequestTableViewCell.swift
//  Networking
//
//  Created by Evgeniy Petlitskiy on 14.03.21.
//

import UIKit



class GetRequestTableViewCell: UITableViewCell {

    static let identifier = "GetRequestIdentifier"
    
    let email: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16)
        return label
    }()
    
    let name: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16)
        return label
    }()
    
    let message: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        addSubview(name)
        addSubview(email)
        addSubview(message)
        
        email.anchor(top: topAnchor,
                    leading: leadingAnchor,
                    bottom: nil,
                    trailing: trailingAnchor,
                    padding: .init(top: 10, left: 20, bottom: 0, right: 10))
        
        name.anchor(top: email.bottomAnchor,
                     leading: leadingAnchor,
                     bottom: nil,
                     trailing: trailingAnchor,
                     padding: .init(top: 10, left: 20, bottom: 0, right: 10))
        
        message.anchor(top: name.bottomAnchor,
                       leading: leadingAnchor,
                       bottom: bottomAnchor,
                       trailing: trailingAnchor,
                       padding: .init(top: 10, left: 20, bottom: 10, right: 10))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: API
    
    func registerMessage(with comment: Comment) {
        self.name.text = comment.name
        self.email.text = comment.email
        self.message.text = comment.body
    }
}
