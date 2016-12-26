//
//  BadgeCell.swift
//  UCLanTimetable
//
//  Created by Salah Eddin Alshaal on 21/07/16.
//  Copyright © 2016 Salah Eddin Alshaal. All rights reserved.
//

import UIKit

class BadgeViewCell: UICollectionViewCell {
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var image: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //badgeSVGWebView.delegate = self
    }
}
