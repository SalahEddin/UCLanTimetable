//
//  AboutViewController.swift
//  UCLanTimetable
//
//  Created by Salah Eddin Alshaal on 27/07/16.
//  Copyright © 2016 Salah Eddin Alshaal. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {
    
    @IBOutlet weak var inspireImageView: UIImageView!
    @IBOutlet weak var uclanImageView: UIImageView!
    @IBOutlet weak var versionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // tap on inspire image
        let inspiresSingleTap = UITapGestureRecognizer(target: self, action:#selector(inspireClicked))
        inspiresSingleTap.numberOfTapsRequired = 1
        inspireImageView.userInteractionEnabled = true
        inspireImageView.addGestureRecognizer(inspiresSingleTap)
        
        // tap on uclan image
        let uclanSingleTap = UITapGestureRecognizer(target: self, action:#selector(uclanClicked))
        uclanSingleTap.numberOfTapsRequired = 1
        inspireImageView.userInteractionEnabled = true
        inspireImageView.addGestureRecognizer(uclanSingleTap)
        
        // tap on version 7 times (easter egg)
        let easter = UITapGestureRecognizer(target: self, action:#selector(uclanClicked))
        easter.numberOfTapsRequired = 5
        versionLabel.userInteractionEnabled = true
        versionLabel.addGestureRecognizer(easter)
        
    }
    
    func inspireClicked() {
        let url = NSURL(string: "http://inspirecenter.org/")!
        UIApplication.sharedApplication().openURL(url)
    }
    func uclanClicked() {
        let url = NSURL(string: "http://www.uclancyprus.ac.cy/en/")!
        UIApplication.sharedApplication().openURL(url)
    }
    
    func easterClicked() {
        let url = NSURL(string: "http://www.uclancyprus.ac.cy/en/")!
        UIApplication.sharedApplication().openURL(url)
    }
}
