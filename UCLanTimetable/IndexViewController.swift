//
//  IndexViewController.swift
//  UCLanTimetable
//
//  Created by Salah Eddin Alshaal on 15/06/16.
//  Copyright © 2016 Salah Eddin Alshaal. All rights reserved.
//

import UIKit
import CVCalendar
import Alamofire

class IndexViewController: UIViewController {
    
    let offlineTimetableStorageKey = "timetable"
    
    @IBOutlet weak var menuView: CVCalendarMenuView!
    @IBOutlet weak var calView: CVCalendarView!
    @IBOutlet weak var eventsTableView: UITableView!
    @IBOutlet weak var calSegmentedControl: UISegmentedControl!
    @IBOutlet weak var selectedDateLabel: UILabel!
    
    @IBAction func calendarViewOtpion_Changed(sender: UISegmentedControl) {
        switch calSegmentedControl.selectedSegmentIndex
        {
        case 0:
            calView.changeMode(.WeekView)
        case 1:
            calView.changeMode(.MonthView)
        default:
            break;
        }
    }
    // modify the view
    
    var pullToRefreshControl: UIRefreshControl!
    var selectedDate = NSDate()
    var CalendarEvents:[TimeTableSession] = []
    var OfflineCalendarEvents:[TimeTableSession]? = nil
    var dataSavedAvailable = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // tabbar covering table
        let tabBarHeight = self.tabBarController?.tabBar.bounds.height
        self.edgesForExtendedLayout = UIRectEdge.All
        self.eventsTableView.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: tabBarHeight!, right: 0.0)
        
        // Do pull to refresh setup here.
        pullToRefreshControl = UIRefreshControl()
        pullToRefreshControl!.attributedTitle = NSAttributedString(string: "Pull to refresh")
        pullToRefreshControl.addTarget(self, action: #selector(self.refresh(_:)), forControlEvents: .ValueChanged)
        self.eventsTableView.addSubview(pullToRefreshControl)
        
        CalendarEvents = [TimeTableSession]()
        
        if(!Reachability.isConnectedToNetwork()){
            //notify user to connect online
            let alert = UIAlertController(title: "Offline Mode", message: "You're not connected to a network, connect to access latest updates and changes", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Continue in Offline Mode", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
        
        let df = NSDateFormatter()
        df.dateFormat = "dd MMMM, yyyy"
        selectedDateLabel.text = df.stringFromDate(NSDate())
        
        reloadDayViewSession()
    }
    
    func refresh(sender:AnyObject) {
        reloadDayViewSession()
    }
    
    func reloadDayViewSession(){
        // Code to refresh table view
        if(Reachability.isConnectedToNetwork()){
            print("connected")
            
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let DateInFormat = dateFormatter.stringFromDate(selectedDate)
            let id = String(Misc.loadUser()!.aCCOUNT_ID!)
            Misc.loadTimetableSessions(id, startDate: DateInFormat, endDate: DateInFormat, type: Misc.SESSION_TYPE.ALL, by: Misc.USER_TYPE.STUDENT, callback: callback)
        }
        else{
            // offline mode
            print("disconnected")
            
            //clear dataset
            CalendarEvents.removeAll()
            
            // load saved sessions once
            if(OfflineCalendarEvents == nil){
                let timetableDataDict = NSUserDefaults.standardUserDefaults().objectForKey(offlineTimetableStorageKey) as? NSData
                
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
                for item in OfflineCalendarEvents! {
                    // add sessions that match selected calendar date
                    if Misc.isDateSame(item,CVSelected: selectedDate)   {
                        CalendarEvents += [item]
                    }
                }
                
                
            }
            else{
                // No previous data found
                
                //notify user to connect online
                let alert = UIAlertController(title: "Offline Mode", message: "couldn't load your timetable, please make sure you're connected to the Internet", preferredStyle: UIAlertControllerStyle.Alert)
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
            eventsTableView.reloadData()
        }
    }
    
    @IBAction func ck(sender: AnyObject) {
        calView.changeMode(.MonthView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        menuView.commitMenuViewUpdate()
        calView.commitCalendarViewUpdate()
    }
    
    func callback(sess: [TimeTableSession]) -> Void {
        self.CalendarEvents = sess
        self.pullToRefreshControl.endRefreshing()
        self.eventsTableView.reloadData()
        if sess.count <= 0 {
            // self.eventsTableView.backgroundView = UIImageView(image: UIImage(named: "no_events-1.jpg"))
        }
        
        // after loading the day, check if the data for this period is available offline
        let timetableDataDict = NSUserDefaults.standardUserDefaults().objectForKey(offlineTimetableStorageKey) as? NSData
        
        if timetableDataDict == nil {
            // dynamic date
            let id = String(Misc.loadUser()?.aCCOUNT_ID!)
            Misc.loadTimetableSessions(id, startDate: "2016-05-05", endDate: "2017-01-01", type: Misc.SESSION_TYPE.ALL, callback: offlineSaveCallback)
        }
    }
    
    func offlineSaveCallback(sess: [TimeTableSession]) -> Void {
        var sessDict : [NSDictionary] = []
        
        for item in sess {
            sessDict += [item.dictionaryRepresentation()]
        }
        
        // store data for offline use
        let examsData = NSKeyedArchiver.archivedDataWithRootObject(sessDict)
        NSUserDefaults.standardUserDefaults().setObject(examsData, forKey: offlineTimetableStorageKey)
    }
}

// MARK: - CVCalendarViewDelegate & CVCalendarMenuViewDelegate

extension IndexViewController: CVCalendarViewDelegate, CVCalendarMenuViewDelegate {
    
    /// Required method to implement!
    func presentationMode() -> CalendarMode {
        return .MonthView
    }
    
    /// Required method to implement!
    func firstWeekday() -> Weekday {
        return .Monday
    }
    
    func weekdaySymbolType() -> WeekdaySymbolType {
        // Mon, Tue
        return .Short
    }
    
    func shouldShowWeekdaysOut() -> Bool {
        return true
    }
    
    func didSelectDayView(dayView: CVCalendarDayView, animationDidFinish: Bool) {
        print("\(dayView.date.commonDescription) is selected!")
        // update local var selectedDate
        selectedDate = dayView.date.convertedDate()!
        
        let df = NSDateFormatter()
        df.dateFormat = "dd MMMM, yyyy"
        selectedDateLabel.text = df.stringFromDate(selectedDate)
        
        reloadDayViewSession()
    }
    
}

// MARK:- UITableViewDelegate & UITableViewDataSource
extension IndexViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CalendarEvents.count//CalendarEvents.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "cell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! CalEventTableViewCell
        cell.ModuleName.text = "\(CalendarEvents[indexPath.row].mODULE_CODE!) - \(CalendarEvents[indexPath.row].mODULE_NAME!)"
        cell.EventTime.text = "\(CalendarEvents[indexPath.row].sTART_TIME_FORMATTED!)-\(CalendarEvents[indexPath.row].eND_TIME_FORMATTED!)"
        cell.EventDetails.text = "\(CalendarEvents[indexPath.row].rOOM_CODE!) - \(CalendarEvents[indexPath.row].lECTURER_NAME!)"
        
        if(Misc.hasDatePassed(CalendarEvents[indexPath.row])){
            cell.ModuleName.textColor = UIColor.grayColor()
            cell.EventTime.textColor = UIColor.grayColor()
            cell.EventTime.font = UIFont(name:"HelveticaNeue", size: (cell.EventTime?.font.pointSize)!)
            cell.EventDetails.textColor = UIColor.grayColor()
        }
        else{
            //todo color and bold
            cell.ModuleName.textColor = UIColor.redColor()
            cell.EventTime.textColor = UIColor.blackColor()
            cell.EventTime.font = UIFont(name:"HelveticaNeue Bold", size: (cell.EventTime?.font.pointSize)!)
            cell.EventDetails.textColor = UIColor.darkGrayColor()
        }
        
        return cell
    }
}
