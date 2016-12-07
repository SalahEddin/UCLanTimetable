//
//  CalEventTableViewCell.swift
//  UCLanTimetable
//
//  Created by Salah Eddin Alshaal on 20/06/16.
//  Copyright © 2016 Salah Eddin Alshaal. All rights reserved.
//

import UIKit

class CalEventTableViewCell: UITableViewCell {

    @IBOutlet weak var ModuleName: UILabel!
    @IBOutlet weak var EventTime: UILabel!
    @IBOutlet weak var EventDetails: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
