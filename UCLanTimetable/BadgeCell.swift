//
//  BadgeCell.swift
//  UCLanTimetable
//
//  Created by Salah Eddin Alshaal on 21/07/16.
//  Copyright © 2016 Salah Eddin Alshaal. All rights reserved.
//

import UIKit

class BadgeCell: UICollectionViewCell, UIWebViewDelegate {

    // @IBOutlet weak var badgeSVGWebView: UIWebView!

    @IBOutlet weak var badgeImage: UIImageView!
    @IBOutlet weak var badgeLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //badgeSVGWebView.delegate = self
    }

    func webViewDidFinishLoad(_ webView: UIWebView) {
        print("webViewDidFinishLoad")
    }
}
