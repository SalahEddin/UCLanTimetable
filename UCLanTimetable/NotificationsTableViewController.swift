//
//  NotificationsTableViewController.swift
//  UCLanTimetable
//
//  Created by Salah Eddin Alshaal on 30/06/16.
//  Copyright © 2016 Salah Eddin Alshaal. All rights reserved.
//

import UIKit
import MGSwipeTableCell

class NotificationsTableViewController: UITableViewController {
    
    var notifications:[Notification] = []
    var pullToRefreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        pullToRefreshControl = UIRefreshControl()
        pullToRefreshControl.addTarget(self, action: #selector(self.refresh(_:)), forControlEvents: .ValueChanged)
        self.tableView.addSubview(pullToRefreshControl)
        
        let user_id = Misc.loadUser()!.uSER_ID!
        Misc.loadNotifications(String(user_id), callback: notifsCallback)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return notifications.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let reuseIdentifier = "notificationCell"
        var cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier, forIndexPath: indexPath) as? NotificationTableViewCell
        
        if cell == nil
        {
            cell = NotificationTableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: reuseIdentifier)
        }
        
        // cell!.delegate = self //optional
        
        // Configure the cell...
        cell!.NotiDateLabel.text = "Time: \(notifications[indexPath.row].cREATE_DATE!)"
        cell!.NotiTypeLabel.text = notifications[indexPath.row].nOTIFICATION_TYPE_NAME
        cell!.NotiDetailsLabel.text = notifications[indexPath.row].nOTIFICATION_TEXT
        cell!.moreDetailsLink = NSURL(fileURLWithPath: notifications[indexPath.row].nOTIFICATION_URL!)
        cell!.NotiTitleLabel.text = notifications[indexPath.row].nOTIFICATION_TITLE
        
        //configure left buttons
        let deleteButton = MGSwipeButton(title: "Delete", icon: UIImage(named:"check.png"), backgroundColor: UIColor(netHex: 0xc0392b), callback: {
            (sender: MGSwipeTableCell!) -> Bool in
            print("Convenience callback for swipe buttons!")
            Misc.markAsDeleted()
            return true
        })
        cell!.leftButtons = [deleteButton]
        cell!.leftSwipeSettings.transition = MGSwipeTransition.Border
        
        //configure right buttons
        let archiveButton = MGSwipeButton(title: "Archive", backgroundColor: UIColor(netHex: 0x95a5a6), callback: {
            (sender: MGSwipeTableCell!) -> Bool in
            print("Convenience callback for swipe buttons!")
            return true
        })
        
        cell!.rightButtons =
            [archiveButton ,MGSwipeButton(title: "Mark as Read",backgroundColor: UIColor(netHex: 0x2980b9))]
        
        if(Misc.isNotificationRead(notifications[indexPath.row].nOTIFICATION_STATUS!)){
            cell!.rightButtons[1] = MGSwipeButton(title: "Mark as Unread",backgroundColor: UIColor.lightGrayColor())
        }
        
        cell!.rightSwipeSettings.transition = MGSwipeTransition.Border
        
        //tableView.estimatedRowHeight = 150.0
        //tableView.rowHeight = UITableViewAutomaticDimension
        
        return cell!
    }
    
    func notifsCallback(notifs :[Notification]){
        notifications.removeAll()
        notifications.appendContentsOf(notifs)
        self.tableView.reloadData()
    }
    
    func refresh(sender:AnyObject) {
        // Code to refresh table view
        
        self.tableView.reloadData()
        pullToRefreshControl.endRefreshing()
    }
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
     if editingStyle == .Delete {
     // Delete the row from the data source
     tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
     } else if editingStyle == .Insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
