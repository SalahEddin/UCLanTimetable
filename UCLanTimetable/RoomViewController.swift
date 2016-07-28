//
//  RoomViewController.swift
//  UCLanTimetable
//
//  Created by Salah Eddin Alshaal on 27/07/16.
//  Copyright © 2016 Salah Eddin Alshaal. All rights reserved.
//
import UIKit
import Foundation
import CVCalendar

class RoomViewController: UIViewController {
    //UI Binding
    @IBOutlet weak var menuView: CVCalendarMenuView!
    @IBOutlet weak var calendarView: CVCalendarView!
    @IBOutlet weak var eventsTableView: UITableView!
    @IBOutlet weak var roomPicker: UIPickerView!
    @IBOutlet weak var calSegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var selectedDateLabel: UILabel!
    @IBAction func calendarViewOtpion_Changed(sender: UISegmentedControl) {
        switch calSegmentedControl.selectedSegmentIndex
        {
        case 0:
            calendarView.changeMode(.WeekView)
        case 1:
            calendarView.changeMode(.MonthView)
        default:
            break;
        }
    }
    // data
    var selectedDate = NSDate()
    var selectedRoom = "134"
    var CalendarEvents:[TimeTableSession] = []
    var roomPickerDataSoruce: [Room] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // tabbar covering table
        let tabBarHeight = self.tabBarController?.tabBar.bounds.height
        self.edgesForExtendedLayout = UIRectEdge.All
        self.eventsTableView.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: tabBarHeight!, right: 0.0)
        
        if(!Reachability.isConnectedToNetwork()){
            //notify user to connect online
            let alert = UIAlertController(title: "Offline Mode", message: "You're not connected to a network, connect to access latest updates and changes", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Continue in Offline Mode", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            
        }
        else{
            self.roomPicker.dataSource = self;
            self.roomPicker.delegate = self;
            Misc.listRooms(listRoomsCallback)
        }
        
        let df = NSDateFormatter()
        df.dateFormat = "dd MMMM, yyyy"
        selectedDateLabel.text = df.stringFromDate(NSDate())
        //intial view
        reloadDayViewSession()
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        menuView.commitMenuViewUpdate()
        //calendarView.changeMode(.MonthView)
        calendarView.commitCalendarViewUpdate()
    }
    
    func listRoomsCallback(rooms: [Room]) -> Void {
        self.roomPickerDataSoruce = rooms
        self.roomPicker.reloadAllComponents()
        if rooms.count <= 0 {
            // self.eventsTableView.backgroundView = UIImageView(image: UIImage(named: "no_events-1.jpg"))
        }
    }
    
    func callback(sess: [TimeTableSession]) -> Void {
        self.CalendarEvents = sess
        self.eventsTableView.reloadData()
        if sess.count <= 0 {
            // self.eventsTableView.backgroundView = UIImageView(image: UIImage(named: "no_events-1.jpg"))
        }
    }
    
}

// MARK: - CVCalendarViewDelegate & CVCalendarMenuViewDelegate

extension RoomViewController: CVCalendarViewDelegate, CVCalendarMenuViewDelegate {
    
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
    
    func reloadDayViewSession(){
        // Code to refresh table view
        if(Reachability.isConnectedToNetwork()){
            print("connected")
            
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let DateInFormat = dateFormatter.stringFromDate(selectedDate)
            Misc.loadTimetableSessions(selectedRoom, startDate: DateInFormat, endDate: DateInFormat, type: Misc.SESSION_TYPE.ALL, by: Misc.USER_TYPE.ROOM, callback: callback)
        }
        else{
            // offline mode
            print("disconnected")
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
                eventsTableView.reloadData()
    }
    
    
}

// MARK:- UITableViewDelegate & UITableViewDataSource
extension RoomViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CalendarEvents.count//CalendarEvents.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "cell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! CalEventTableViewCell
        cell.ModuleName.text = "\(CalendarEvents[indexPath.row].mODULE_CODE!) - \(CalendarEvents[indexPath.row].mODULE_NAME!)"
        cell.EventTime.text = "\(CalendarEvents[indexPath.row].sTART_TIME_FORMATTED!)-\(CalendarEvents[indexPath.row].eND_TIME_FORMATTED!)"
        cell.EventDetails.text = "\(CalendarEvents[indexPath.row].dESCRIPTION!) - \(CalendarEvents[indexPath.row].lECTURER_NAME!)"
        
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
// MARK:-  UIPickerViewDataSource & UIPickerViewDelegate
extension RoomViewController: UIPickerViewDataSource, UIPickerViewDelegate{
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return roomPickerDataSoruce.count;
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return roomPickerDataSoruce[row].rOOM_CODE
    }
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        selectedRoom = String(roomPickerDataSoruce[row].rOOM_ID!)
        print("fired")
        reloadDayViewSession()
    }
}
