//
//  CalenderEventTableViewCell.swift
//  UCLanTimetable
//
//  Created by Salah Eddin Alshaal on 16/06/16.
//  Copyright © 2016 Salah Eddin Alshaal. All rights reserved.
//

import UIKit

class CalenderEventTableViewCell: UITableViewCell {

    // MARK: cell components outlets
    @IBOutlet weak var moduleNameLabel: UILabel!
    @IBOutlet weak var moduleCodeLabel: UILabel!
    @IBOutlet weak var eventTimeLabel: UILabel!
    @IBOutlet weak var eventRoomLabel: UILabel!
    @IBOutlet weak var lecturerNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    

}
