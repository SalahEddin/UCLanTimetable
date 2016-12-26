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
    @IBOutlet weak var calSegmentedControl: UISegmentedControl!
    @IBOutlet weak var selectedDateLabel: UILabel!

    @IBAction func calendarViewOtpion_Changed(sender: UISegmentedControl) {
        switch calSegmentedControl.selectedSegmentIndex {
        case 0:
            calView.changeMode(.weekView)
        case 1:
            calView.changeMode(.monthView)
        default:
            break
        }
    }
    // modify the view

    var pullToRefreshControl: UIRefreshControl!
    var selectedDate = Date()
    var CalendarEvents: [TimeTableSession] = []
    var OfflineCalendarEvents: [TimeTableSession]? = nil
    var dataSavedAvailable = false

    override func viewDidLoad() {
        super.viewDidLoad()

        // tabbar covering table
        let tabBarHeight = self.tabBarController?.tabBar.bounds.height
        self.edgesForExtendedLayout = UIRectEdge.all
        self.eventsTableView.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: tabBarHeight!, right: 0.0)

        // Do pull to refresh setup here.
        pullToRefreshControl = UIRefreshControl()
        pullToRefreshControl!.attributedTitle = NSAttributedString(string: "Pull to refresh")
        pullToRefreshControl.addTarget(self, action: #selector(self.refresh(sender:)), for: .valueChanged)
        self.eventsTableView.addSubview(pullToRefreshControl)

        CalendarEvents = [TimeTableSession]()

        if !Reachability.isConnectedToNetwork() {
            //notify user to connect online
            let alert = UIAlertController(title: "Offline Mode", message: "You're not connected to a network, connect to access latest updates and changes", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Continue in Offline Mode", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }

        // set to today
        selectedDateLabel.text = DateUtils.FormatCalendarChoiceDate(Date())

        reloadDayViewSession()
    }

    func refresh(sender: AnyObject) {
        reloadDayViewSession()
    }

    func reloadDayViewSession() {
        // Code to refresh table view
        if Reachability.isConnectedToNetwork() {

            let DateInFormat = DateUtils.FormatToAPIDate(selectedDate)
            let user = Misc.loadUser()!
            let id = String(user.aCCOUNT_ID!)

            var userType = Misc.USER_TYPE.lecturer
            if user.aCCOUNT_TYPE_ID==KEYS.studentTypeId {
                userType = Misc.USER_TYPE.student
            }

            EventAPI.loadTimetableSessions(id, startDate: DateInFormat, endDate: DateInFormat, by: userType, callback: callback)
        } else {
            // offline mode
            print("disconnected")

            //clear dataset
            CalendarEvents.removeAll()

            // load saved sessions once
            if OfflineCalendarEvents == nil {
                let timetableDataDict = UserDefaults.standard.object(forKey: KEYS.offlineTimetableStorageKey) as? NSData

                if timetableDataDict != nil {
                    dataSavedAvailable = true
                    let timetableDataDict = NSKeyedUnarchiver.unarchiveObject(with: timetableDataDict! as Data) as? [NSDictionary]
                    OfflineCalendarEvents = []
                    for item in timetableDataDict! {
                        OfflineCalendarEvents! += [TimeTableSession(dictionary: item)!]
                    }
                }
            }

            if dataSavedAvailable {
                for item in OfflineCalendarEvents! {
                    // add sessions that match selected calendar date
                    if DateUtils.isDateSame(item, CVSelected: selectedDate) {
                        CalendarEvents += [item]
                    }
                }
            } else {
                // No previous data found

                //notify user to connect online
                let alert = UIAlertController(title: "Offline Mode", message: "couldn't load your timetable, please make sure you're connected to the Internet", preferredStyle: UIAlertControllerStyle.alert)
                let settingsAction = UIAlertAction(title: "Go to Network Settings", style: .default) { (_) -> Void in
                    UIApplication.shared.open(NSURL(string:"prefs:root=WIFI")! as URL, options: [:],completionHandler: nil)
                }

                let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
                alert.addAction(settingsAction)
                alert.addAction(cancelAction)
                self.present(alert, animated: true, completion: nil)
            }

            // stop UI refreshing if it is.
            if pullToRefreshControl.isRefreshing {
                pullToRefreshControl.endRefreshing()
            }
            eventsTableView.reloadData()
        }
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
        // todo check if data is very old
        let offlineDict = UserDefaults.standard.object(forKey: KEYS.offlineTimetableStorageKey) as? NSData
        // if not, then load it
        if offlineDict == nil {
           downloadForOffline()
        }

    }

    func downloadForOffline() {
        // today's date
        let today = DateUtils.FormatToAPIDate(Date())
        // get events till after 1 month
        let endDate = NSCalendar.current.date(byAdding: .month, value: 1, to: Date())

        let endDateFormatted = DateUtils.FormatToAPIDate(endDate!)

        //get user
        let user = Misc.loadUser()!
        let id = String(user.aCCOUNT_ID!)

        var userType = Misc.USER_TYPE.lecturer
        if user.aCCOUNT_TYPE_ID==KEYS.studentTypeId {
            userType = Misc.USER_TYPE.student
        }

        EventAPI.loadTimetableSessions(id, startDate: today, endDate: endDateFormatted, by: userType, callback: offlineSaveCallback)
    }

    func offlineSaveCallback(sess: [TimeTableSession]) -> Void {
        var sessDict: [NSDictionary] = []

        for item in sess {
            sessDict += [item.dictionaryRepresentation()]
        }

        // store data for offline use
        let examsData = NSKeyedArchiver.archivedData(withRootObject: sessDict)
        UserDefaults.standard.set(examsData, forKey: KEYS.offlineTimetableStorageKey)
    }
}

// MARK: - CVCalendarViewDelegate & CVCalendarMenuViewDelegate

extension IndexViewController: CVCalendarViewDelegate, CVCalendarMenuViewDelegate {

    func dotMarker(sizeOnDayView dayView: DayView) -> CGFloat {
        print("yep")
        return CGFloat(21)
    }

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

}

//MARK: -UITableViewDelegate & UITableViewDataSource
extension IndexViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CalendarEvents.count//CalendarEvents.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "cell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! CalEventTableViewCell
        cell.ModuleName.text = "\(CalendarEvents[indexPath.row].mODULE_CODE!) - \(CalendarEvents[indexPath.row].mODULE_NAME!)"
        cell.EventTime.text = "\(CalendarEvents[indexPath.row].sTART_TIME_FORMATTED!)-\(CalendarEvents[indexPath.row].eND_TIME_FORMATTED!)"
        cell.EventDetails.text = "\(CalendarEvents[indexPath.row].rOOM_CODE!) - \(CalendarEvents[indexPath.row].lECTURER_NAME!)"

        if DateUtils.hasDatePassed(CalendarEvents[indexPath.row]) {
            cell.ModuleName.textColor = UIColor.gray
            cell.EventTime.textColor = UIColor.gray
            cell.EventTime.font = UIFont(name:"HelveticaNeue", size: (cell.EventTime?.font.pointSize)!)
            cell.EventDetails.textColor = UIColor.gray
        }
        //        else{
        //            //todo color and bold
        //            cell.ModuleName.textColor = UIColor.redColor()
        //            cell.EventTime.textColor = UIColor.blackColor()
        //            cell.EventTime.font = UIFont(name:"HelveticaNeue Bold", size: (cell.EventTime?.font.pointSize)!)
        //            cell.EventDetails.textColor = UIColor.darkGrayColor()
        //        }

        return cell
    }
}
