//
//  UserProfile.swift
//  Networking
//
//  Created by Evgeniy Petlitskiy on 22.04.21.
//

import Foundation

struct UserProfile {
    
    let id: String?
    let name: String?
    let email: String?
    
    init(data: [String: Any]) {
        
        let id = data["id"] as? String
        let name = data["name"] as? String
        let email = data["email"] as? String
        
        self.id = id
        self.name = name
        self.email = email
    }
    
    init?(uid: String, data: [String: Any]) {
        
        guard let name = data["name"] as? String,
              let email = data["email"] as? String
        else { return nil }
        
        self.id = uid
        self.name = name
        self.email = email
    }
    
    init(id: String, name: String, email: String?) {
        self.id = id
        self.name = name
        self.email = email
    }
}
