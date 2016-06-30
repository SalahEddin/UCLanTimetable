//
//  NotificationTableViewCell.swift
//  UCLanTimetable
//
//  Created by Salah Eddin Alshaal on 30/06/16.
//  Copyright © 2016 Salah Eddin Alshaal. All rights reserved.
//

import UIKit

class NotificationTableViewCell: UITableViewCell {

    @IBOutlet weak var NotiTypeLabel: UILabel!
    @IBOutlet weak var NotiDateLabel: UILabel!
    @IBOutlet weak var NotiDetailsLabel: UILabel!
    
    var moreDetailsLink: NSURL = NSURL(fileURLWithPath: "http://google.com")
    
    @IBAction func Link_Clicked(sender: AnyObject) {
        UIApplication.sharedApplication().openURL(moreDetailsLink)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
