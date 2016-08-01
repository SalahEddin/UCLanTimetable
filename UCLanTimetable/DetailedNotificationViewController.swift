//
//  DetailedNotificationViewController.swift
//  UCLanTimetable
//
//  Created by Salah Eddin Alshaal on 01/08/16.
//  Copyright © 2016 Salah Eddin Alshaal. All rights reserved.
//

import UIKit

class DetailedNotificationViewController: UIViewController {

    public var notification: Notification? = nil
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var desc: UITextView!
    @IBOutlet weak var markButton: UIButton!
    @IBOutlet weak var archiveButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    @IBAction func mark_Clicked(sender: AnyObject) {
    }
    @IBAction func delete_Clicked(sender: AnyObject) {
    }
    @IBAction func archive_Clicked(sender: AnyObject) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        titleLabel.text = notification!.nOTIFICATION_TITLE
        desc.text = notification!.nOTIFICATION_TEXT
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
