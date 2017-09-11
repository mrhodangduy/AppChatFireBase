//
//  Own_TableViewCell.swift
//  AppChatFirebase
//
//  Created by QTS Coder on 9/11/17.
//  Copyright © 2017 David. All rights reserved.
//

import UIKit

class Own_TableViewCell: UITableViewCell {

    @IBOutlet weak var img_Own: RoundImageView!
    @IBOutlet weak var lbl_OwnMess: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
