//
//  ExamTableViewController.swift
//  UCLanTimetable
//
//  Created by Salah Eddin Alshaal on 30/06/16.
//  Copyright © 2016 Salah Eddin Alshaal. All rights reserved.
//

import UIKit

class ExamTableViewController: UITableViewController {

    var CalendarEvents:[CalendarEvent] = []
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
        
        let ev1 = CalendarEvent(mName: "Computing", mCode: "CO2303", room: "CY007", lec: "P. Andreou", time: "Jun 6th 10:00 - 11:00")
        let ev2 = CalendarEvent(mName: "Software Development", mCode: "CO2303", room: "CY007", lec: "P. Andreou", time: "Sep 5th 13:00 - 17:00")
        CalendarEvents += [ev1,ev2]
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
        return CalendarEvents.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
        let cell = tableView.dequeueReusableCellWithIdentifier("examCell", forIndexPath: indexPath) as! ExamTableViewCell
        
        // Configure the cell...
        cell.ExamTitleLabel .text = "\(CalendarEvents[indexPath.row].ModuleCode) - \(CalendarEvents[indexPath.row].ModuleName)"
        cell.ExamDateLabel.text = "Time: \(CalendarEvents[indexPath.row].Time)"
        cell.ExamRoomLabel.text = "Room: \(CalendarEvents[indexPath.row].Room) - \(CalendarEvents[indexPath.row].Lecturer)"
        
        return cell
    }
 
    func refresh(sender:AnyObject) {
        // Code to refresh table view
        CalendarEvents += [CalendarEvent(mName: "Computing", mCode: "CO2303", room: "CY007", lec: "P. Andreou", time: "Jun 6th 10:00 - 11:00", details: "wwww", notificationType: "Room Change", link: NSURL(string: "http://reddit.com")! )]
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
