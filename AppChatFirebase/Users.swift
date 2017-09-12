//
//  Users.swift
//  AppChatFirebase
//
//  Created by QTS Coder on 9/11/17.
//  Copyright © 2017 David. All rights reserved.
//

import Foundation
import UIKit

let userDefault = UserDefaults.standard

struct User {
    let id:String!
    let email:String!
    let fullname:String!
    let linkavatar:String!
    let online : String!
    
    init() {
        id = ""
        email = ""
        fullname = ""
        linkavatar = ""
        online = ""
    }
    init(id:String, email:String, fullname:String, linkAvatar:String, online: String) {
        self.id = id
        self.email = email
        self.fullname = fullname
        self.linkavatar = linkAvatar
        self.online  = online
        
    }
}
