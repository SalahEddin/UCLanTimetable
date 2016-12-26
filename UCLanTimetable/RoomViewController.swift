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
    @IBAction func calendarViewOtpion_Changed(_ sender: UISegmentedControl) {
        switch calSegmentedControl.selectedSegmentIndex {
        case 0:
            calendarView.changeMode(.weekView)
        case 1:
            calendarView.changeMode(.monthView)
        default:
            break
        }
    }
    // data
    var selectedDate = Foundation.Date()
    var selectedRoom = "134"
    var CalendarEvents: [TimeTableSession] = []
    var roomPickerDataSoruce: [Room] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // tabbar covering table
        let tabBarHeight = self.tabBarController?.tabBar.bounds.height
        self.edgesForExtendedLayout = UIRectEdge.all
        self.eventsTableView.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: tabBarHeight!, right: 0.0)

        if !Reachability.isConnectedToNetwork() {
            //notify user to connect online
            let alert = UIAlertController(title: "Offline Mode", message: "You're not connected to a network, connect to access latest updates and changes", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Continue in Offline Mode", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)

        } else {
            self.roomPicker.dataSource = self
            self.roomPicker.delegate = self
            EventAPI.listRooms(listRoomsCallback)
        }

        // update date label
        selectedDateLabel.text = DateUtils.FormatCalendarChoiceDate(Foundation.Date())

        //intial view
        reloadDayViewSession()

    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        menuView.commitMenuViewUpdate()
        //calendarView.changeMode(.MonthView)
        calendarView.commitCalendarViewUpdate()
    }

    func listRoomsCallback(_ rooms: [Room]) -> Void {
        self.roomPickerDataSoruce = rooms
        self.roomPicker.reloadAllComponents()
        if rooms.count <= 0 {
            // self.eventsTableView.backgroundView = UIImageView(image: UIImage(named: "no_events-1.jpg"))
        }
    }

    func callback(_ sess: [TimeTableSession]) -> Void {
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
        return .monthView
    }

    /// Required method to implement!
    func firstWeekday() -> Weekday {
        return .monday
    }

    func weekdaySymbolType() -> WeekdaySymbolType {
        // Mon, Tue
        return .short
    }

    func shouldShowWeekdaysOut() -> Bool {
        return true
    }

    func didSelectDayView(_ dayView: CVCalendarDayView, animationDidFinish: Bool) {
        print("\(dayView.date.commonDescription) is selected!")
        // update local var selectedDate
        selectedDate = dayView.date.convertedDate(calendar: Calendar.current)!
        // update date label
        selectedDateLabel.text = DateUtils.FormatCalendarChoiceDate(selectedDate)

        reloadDayViewSession()
    }

    func reloadDayViewSession() {
        // Code to refresh table view
        if Reachability.isConnectedToNetwork() {
            print("connected")
            let DateInFormat = DateUtils.FormatToAPIDate(selectedDate)

            EventAPI.loadTimetableSessions(selectedRoom, startDate: DateInFormat, endDate: DateInFormat, by: Misc.USER_TYPE.room, callback: callback)
        } else {
            // offline mode
            print("disconnected")
            //notify user to connect online
            let alert = UIAlertController(title: "Offline Mode", message: "couldn't load your timetable, please make sure you're connected to the Internet", preferredStyle: UIAlertControllerStyle.alert)
            let settingsAction = UIAlertAction(title: "Go to Network Settings", style: .default) { (_) -> Void in
                UIApplication.shared.open(URL(string:"prefs:root=WIFI")!, options: [:], completionHandler: nil)
            }

            let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
            alert.addAction(settingsAction)
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
        }
                eventsTableView.reloadData()
    }


}

// MARK:- UITableViewDelegate & UITableViewDataSource
extension RoomViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CalendarEvents.count//CalendarEvents.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "cell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! CalEventTableViewCell
        cell.ModuleName.text = "\(CalendarEvents[indexPath.row].mODULE_CODE!) - \(CalendarEvents[indexPath.row].mODULE_NAME!)"
        cell.EventTime.text = "\(CalendarEvents[indexPath.row].sTART_TIME_FORMATTED!)-\(CalendarEvents[indexPath.row].eND_TIME_FORMATTED!)"
        cell.EventDetails.text = "\(CalendarEvents[indexPath.row].dESCRIPTION!) - \(CalendarEvents[indexPath.row].lECTURER_NAME!)"

        if DateUtils.hasDatePassed(CalendarEvents[indexPath.row]) {
            cell.ModuleName.textColor = UIColor.gray
            cell.EventTime.textColor = UIColor.gray
            cell.EventTime.font = UIFont(name:"HelveticaNeue", size: (cell.EventTime?.font.pointSize)!)
            cell.EventDetails.textColor = UIColor.gray
        } else {
            //todo color and bold
            cell.ModuleName.textColor = UIColor.red
            cell.EventTime.textColor = UIColor.black
            cell.EventTime.font = UIFont(name:"HelveticaNeue Bold", size: (cell.EventTime?.font.pointSize)!)
            cell.EventDetails.textColor = UIColor.darkGray
        }

        return cell
    }
}
// MARK:-  UIPickerViewDataSource & UIPickerViewDelegate
extension RoomViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return roomPickerDataSoruce.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return roomPickerDataSoruce[row].rOOM_CODE
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedRoom = String(roomPickerDataSoruce[row].rOOM_ID!)
        print("fired")
        reloadDayViewSession()
    }
}
