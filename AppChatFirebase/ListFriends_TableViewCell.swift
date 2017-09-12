//
//  ListFriends_TableViewCell.swift
//  AppChatFirebase
//
//  Created by QTS Coder on 9/11/17.
//  Copyright © 2017 David. All rights reserved.
//

import UIKit

class ListFriends_TableViewCell: UITableViewCell {

    @IBOutlet weak var signStatus: RoundView!
    @IBOutlet weak var onlineStatus: UILabel!
    @IBOutlet weak var img_avatarFriend: RoundImageView!
    @IBOutlet weak var lbl_friendName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
