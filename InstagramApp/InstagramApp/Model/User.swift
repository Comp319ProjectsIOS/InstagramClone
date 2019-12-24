//
//  User.swift
//  InstagramApp
//
//  Created by Başak Çörtük on 5.12.2019.
//  Copyright © 2019 BasakMelih. All rights reserved.
//

import Foundation

struct User: Equatable {
    var userName: String?
    var uid: String?
    var imageRef: String?
    
    static func ==(lhs: User, rhs: User) -> Bool {
        return lhs.uid == rhs.uid
    }
}
