//
//  NotificationTableViewCell.swift
//  UCLanTimetable
//
//  Created by Salah Eddin Alshaal on 30/06/16.
//  Copyright © 2016 Salah Eddin Alshaal. All rights reserved.
//

import UIKit
import MGSwipeTableCell

class NotificationTableViewCell: MGSwipeTableCell {
    // UI Binding

    @IBOutlet weak var NotiTitleLabel: UILabel!
    @IBOutlet weak var NotiLegendView: UIView!
    @IBOutlet weak var NotiDateLabel: UILabel!
    @IBOutlet weak var NotiTypeLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
