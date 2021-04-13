//
//  Comment.swift
//  Networking
//
//  Created by Evgeniy Petlitskiy on 14.03.21.
//

import Foundation

struct Comment: Decodable {
    let postId: Int?
    let id: Int?
    let name: String
    let email: String
    let body: String
}
