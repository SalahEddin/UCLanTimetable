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
    
    @IBOutlet weak var menuView: CVCalendarMenuView!
    @IBOutlet weak var calView: CVCalendarView!
    @IBOutlet weak var eventsTableView: UITableView!
    
    var pullToRefreshControl: UIRefreshControl!
    
    var CalendarEvents:[TimeTableSession] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // tabbar covering table
        let tabBarHeight = self.tabBarController?.tabBar.bounds.height
        self.edgesForExtendedLayout = UIRectEdge.All
        self.eventsTableView.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: tabBarHeight!, right: 0.0)
        
        // Do view setup here.
        pullToRefreshControl = UIRefreshControl()
        pullToRefreshControl!.attributedTitle = NSAttributedString(string: "Pull to refresh")
        pullToRefreshControl.addTarget(self, action: #selector(self.refresh(_:)), forControlEvents: .ValueChanged)
        self.eventsTableView.addSubview(pullToRefreshControl)
        
        CalendarEvents = [TimeTableSession]()
        loadDayTimetableSessions("2016-01-01")
    }
    
    func refresh(sender:AnyObject) {
        // Code to refresh table view
        // todo check internet is available
        loadDayTimetableSessions("2016-01-01")
    }
    
    @IBAction func ck(sender: AnyObject) {
        calView.changeMode(.MonthView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        menuView.commitMenuViewUpdate()
        calView.commitCalendarViewUpdate()
    }
}

// MARK: - CVCalendarViewDelegate & CVCalendarMenuViewDelegate

extension IndexViewController: CVCalendarViewDelegate, CVCalendarMenuViewDelegate {
    
    /// Required method to implement!
    func presentationMode() -> CalendarMode {
        return .WeekView
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
        let formattedDate = "\(dayView.date.year)-\(dayView.date.month)-\(dayView.date.day)"
        print(formattedDate)
        Misc.loadTimetableSessions(formattedDate, endDate: formattedDate, type: Misc.SESSION_TYPE.ALL, callback: callback)
        // loadDayTimetableSessions(formattedDate)
    }
    
    func callback(sess: [TimeTableSession]) -> Void {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.CalendarEvents = sess
            self.pullToRefreshControl.endRefreshing()
            self.eventsTableView.reloadData()
            print(self.CalendarEvents.count)
        })
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
        
        return cell
    }
}

// MARK:- UITableViewDelegate & UITableViewDataSource
extension IndexViewController {
    func loadDayTimetableSessions(date: String) -> Void {
        //clear array
        self.CalendarEvents.removeAll()
        
        let params = [
            "securityToken": "e84e281d4c9b46f8a30e4a2fd9aa7058",
            "STUDENT_ID": 622,
            "START_DATE_TIME":date,
            "END_DATE_TIME":date]
        
        Alamofire.request(.GET, "https://cyprustimetable.uclan.ac.uk/TimetableAPI/TimetableWebService.asmx/getTimetableByStudent", parameters: (params as! [String : AnyObject]))
            .responseJSON { response in
                
                print(response.result)   // result of response serialization
                
                if let JSON = response.result.value as? [[String: AnyObject]] {
                    for item in JSON{
                        self.CalendarEvents += [TimeTableSession(dictionary: item)!]
                    }
                    self.eventsTableView.reloadData()
                }
                self.pullToRefreshControl.endRefreshing()
        }
    }
}
