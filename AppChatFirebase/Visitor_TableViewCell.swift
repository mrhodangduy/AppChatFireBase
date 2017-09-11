//
//  Visitor_TableViewCell.swift
//  AppChatFirebase
//
//  Created by QTS Coder on 9/11/17.
//  Copyright © 2017 David. All rights reserved.
//

import UIKit

class Visitor_TableViewCell: UITableViewCell {

    @IBOutlet weak var img_Visitor: RoundImageView!
    @IBOutlet weak var lbl_VisitorMess: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        lbl_VisitorMess.layer.cornerRadius = 5
        lbl_VisitorMess.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
