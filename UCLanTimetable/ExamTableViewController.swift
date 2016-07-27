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
    let offlineExamStorageKey = "exams"
    var CalendarEvents:[TimeTableSession] = []
    var OfflineCalendarEvents:[TimeTableSession]? = nil
    var dataSavedAvailable = false
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
        
        reloadExams()
    }
    func callback(sess: [TimeTableSession]) -> Void {
        self.CalendarEvents = sess
        self.pullToRefreshControl.endRefreshing()
        self.tableView.reloadData()
        
        var sessDict : [NSDictionary] = []
        
        for item in sess {
            sessDict += [item.dictionaryRepresentation()]
        }
        
        // store data for offline use
        let examsData = NSKeyedArchiver.archivedDataWithRootObject(sessDict)
        NSUserDefaults.standardUserDefaults().setObject(examsData, forKey: offlineExamStorageKey)
    }
    
    
    func reloadExams(){
        // Code to refresh table view
        if(Reachability.isConnectedToNetwork()){
            print("connected")
            let id = String(Misc.loadUser()!.aCCOUNT_ID!)
            Misc.loadTimetableSessions(id, startDate: "2015-01-01", endDate: "2017-01-01", type: Misc.SESSION_TYPE.EXAM, by: Misc.USER_TYPE.STUDENT, callback: callback)
        }
        else{
            // offline mode
            print("disconnected")
            
            //clear dataset
            CalendarEvents.removeAll()
            
            // load saved sessions once
            if(OfflineCalendarEvents == nil){
                let timetableDataDict = NSUserDefaults.standardUserDefaults().objectForKey(offlineExamStorageKey) as? NSData
                
                if timetableDataDict != nil{
                    dataSavedAvailable = true
                    let timetableDataDict = NSKeyedUnarchiver.unarchiveObjectWithData(timetableDataDict!) as? [NSDictionary]
                    OfflineCalendarEvents = []
                    for item in timetableDataDict! {
                        OfflineCalendarEvents! += [TimeTableSession(dictionary: item)!]
                    }
                }
            }
            
            if(dataSavedAvailable){
                CalendarEvents = OfflineCalendarEvents!
            }
            else{
                // No previous data found
                
                //notify user to connect online
                let alert = UIAlertController(title: "Offline Mode", message: "couldn't load your exams, please make sure you're connected to the Internet", preferredStyle: UIAlertControllerStyle.Alert)
                
                let settingsAction = UIAlertAction(title: "Go to Network Settings", style: .Default) { (_) -> Void in
                    UIApplication.sharedApplication().openURL(NSURL(string:"prefs:root=WIFI")!)
                }
                
                let cancelAction = UIAlertAction(title: "Cancel", style: .Default, handler: nil)
                alert.addAction(settingsAction)
                alert.addAction(cancelAction)
                
                self.presentViewController(alert, animated: true, completion: nil)
            }
            
            // stop refreshing if it is.
            if(pullToRefreshControl.refreshing){
                pullToRefreshControl.endRefreshing()
            }
            tableView.reloadData()
        }
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
        reloadExams()
    }
    
}
