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
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var publishLabel: UILabel!
    @IBOutlet weak var expiryLabel: UILabel!
    @IBOutlet weak var desc: UITextView!
    @IBOutlet weak var markButton: UIButton!
    @IBOutlet weak var archiveButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    @IBAction func mark_Clicked(sender: AnyObject) {
        notification!.calculateStatus()
        changeStatus(notification!.isRead ?  NotificationAPI.Status.UNREAD : NotificationAPI.Status.READ)
    }
    @IBAction func delete_Clicked(sender: AnyObject) {
        //todo
    }
    @IBAction func archive_Clicked(sender: AnyObject) {
        notification!.calculateStatus()
        changeStatus(notification!.isArchived ?  NotificationAPI.Status.UNREAD :NotificationAPI.Status.ARCHIVED)
    }
    
    func changeStatus(status: NotificationAPI.Status) {
        NotificationAPI.changeStatus(notification!.nOTIFICATION_ID!, newStatus: status ,callback: self.statusChangedCallback)
    }
    
    func statusChangedCallback(){
        reloadNotification()
    }
    
    func reloadNotification() {
        NotificationAPI.getNotification(notification!.nOTIFICATION_ID!, callback: reloadedCallback)
    }
    
    func reloadedCallback(item: Notification) -> Void {
        notification = item
        titleLabel.text = notification!.nOTIFICATION_TITLE!
        typeLabel.text = notification!.nOTIFICATION_TYPE_NAME!
        desc.text = notification!.nOTIFICATION_TEXT!
        
        let publishDate = NSDate(jsonDate: notification!.pUBLISH_DATE!)!
        let expiryDate = NSDate(jsonDate: notification!.eXPIRY_DATE!)!
        
        publishLabel.text = "Publish Date: \(DateUtils.FormatCalendarChoiceDate(publishDate))"
        expiryLabel.text = "Expiry Date: \(DateUtils.FormatCalendarChoiceDate(expiryDate))"
        
        notification!.calculateStatus()
        
        if notification!.isRead {
            markButton.setTitle("Mark as unread", forState: .Normal)
        }
        else{
            markButton.setTitle("Mark as read", forState: .Normal)
        }
        
        if notification!.isArchived {
            archiveButton.setTitle("Unarchive", forState: .Normal)
        }
        else{
            archiveButton.setTitle("Archive", forState: .Normal)
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        changeStatus(NotificationAPI.Status.READ)
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
