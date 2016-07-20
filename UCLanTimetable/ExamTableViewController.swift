//
//  ExamTableViewController.swift
//  UCLanTimetable
//
//  Created by Salah Eddin Alshaal on 30/06/16.
//  Copyright © 2016 Salah Eddin Alshaal. All rights reserved.
//

import UIKit
import Alamofire

class ExamTableViewController: UITableViewController {
    
    var CalendarEvents:[TimeTableSession] = []
    var pullToRefreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tabBarHeight = self.tabBarController?.tabBar.bounds.height
        self.edgesForExtendedLayout = UIRectEdge.All
        self.tableView.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: tabBarHeight!, right: 0.0)
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        pullToRefreshControl = UIRefreshControl()
        pullToRefreshControl!.attributedTitle = NSAttributedString(string: "Pull to refresh")
        pullToRefreshControl.addTarget(self, action: #selector(self.refresh(_:)), forControlEvents: .ValueChanged)
        self.tableView.addSubview(pullToRefreshControl)
        
        // load data
        Misc.loadTimetableSessions("2015-01-01", endDate: "2017-01-01", type: Misc.SESSION_TYPE.EXAM, callback: callback)
        //loadTimetableExams("2015-01-01",endDate: "2017-01-01")
    }
    func callback(sess: [TimeTableSession]) -> Void {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.CalendarEvents = sess
            self.pullToRefreshControl.endRefreshing()
            self.tableView.reloadData()
            print(self.CalendarEvents.count)
        })
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
        cell.ExamTitleLabel .text = "\(CalendarEvents[indexPath.row].mODULE_NAME!) - \(CalendarEvents[indexPath.row].mODULE_CODE!)"
        // todo parse and format date
        cell.ExamDateLabel.text = "\(CalendarEvents[indexPath.row].sESSION_DATE_FORMATTED!) \(CalendarEvents[indexPath.row].sTART_TIME_FORMATTED!)-\(CalendarEvents[indexPath.row].eND_TIME_FORMATTED!)"
        cell.ExamRoomLabel.text = "Room: \(CalendarEvents[indexPath.row].rOOM_CODE!)"
        
        if(Misc.hasDatePassed(CalendarEvents[indexPath.row])){
            cell.ExamTitleLabel.textColor = UIColor.grayColor()
            cell.ExamDateLabel.textColor = UIColor.grayColor()
            cell.ExamDateLabel.font = UIFont(name:"HelveticaNeue", size: (cell.ExamDateLabel?.font.pointSize)!)
            cell.ExamRoomLabel.textColor = UIColor.grayColor()
            
        }
        return cell
    }
    
    func refresh(sender:AnyObject) {
        // Code to refresh table view
        loadTimetableExams("2015-01-01",endDate: "2017-01-01")
    }
    
    func loadTimetableExams(startDate: String, endDate: String) -> Void {
        //clear array
        self.CalendarEvents.removeAll()
        
        let params = [
            "securityToken": "e84e281d4c9b46f8a30e4a2fd9aa7058",
            "STUDENT_ID": 622,
            "START_DATE_TIME":startDate,
            "END_DATE_TIME":endDate]
        
        Alamofire.request(.GET, "https://cyprustimetable.uclan.ac.uk/TimetableAPI/TimetableWebService.asmx/getTimetableByStudent", parameters: (params as! [String : AnyObject]))
            .responseJSON { response in
                
                print(response.result)   // result of response serialization
                
                if let JSON = response.result.value as? [[String: AnyObject]] {
                    for item in JSON{
                        if(item["SESSION_DESCRIPTION"]!.isEqual("Examination")){
                            self.CalendarEvents += [TimeTableSession(dictionary: item)!]
                        }
                    }
                    self.pullToRefreshControl.endRefreshing()
                    self.tableView.reloadData()
                }
        }
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
