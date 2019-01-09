//
//  participantCell.swift
//  ChrismastDinner
//
//  Created by VICTOR ALVAREZ LANTARON on 9/1/19.
//  Copyright © 2019 victorSL. All rights reserved.
//

import UIKit

class ParticipantCell: UITableViewCell {
    
    @IBOutlet var cellName: UILabel!
    @IBOutlet var checkMoney: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
