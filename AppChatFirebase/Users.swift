//
//  Users.swift
//  AppChatFirebase
//
//  Created by QTS Coder on 9/11/17.
//  Copyright © 2017 David. All rights reserved.
//

import Foundation
import UIKit

struct User {
    let id:String!
    let email:String!
    let fullname:String!
    let linkavatar:String!
    
    init() {
        id = ""
        email = ""
        fullname = ""
        linkavatar = ""
    }
    init(id:String, email:String, fullname:String, linkAvatar:String) {
        self.id = id
        self.email = email
        self.fullname = fullname
        self.linkavatar = linkAvatar
    }
}
