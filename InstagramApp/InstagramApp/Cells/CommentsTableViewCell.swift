//
//  CommentsTableViewCell.swift
//  InstagramApp
//
//  Created by Melih on 17.12.2019.
//  Copyright © 2019 BasakMelih. All rights reserved.
//

import UIKit

class CommentsTableViewCell: UITableViewCell {
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
