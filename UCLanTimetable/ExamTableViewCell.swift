//
//  ExamTableViewCell.swift
//  UCLanTimetable
//
//  Created by Salah Eddin Alshaal on 30/06/16.
//  Copyright © 2016 Salah Eddin Alshaal. All rights reserved.
//

import UIKit

class ExamTableViewCell: UITableViewCell {

    @IBOutlet weak var ExamTitleLabel: UILabel!
    @IBOutlet weak var ExamDateLabel: UILabel!
    @IBOutlet weak var ExamRoomLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
