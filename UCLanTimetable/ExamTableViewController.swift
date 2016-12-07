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
    var CalendarEvents: [TimeTableSession] = []
    var OfflineCalendarEvents: [TimeTableSession]? = nil
    var dataSavedAvailable = false
    var pullToRefreshControl: UIRefreshControl!

    var today = Date()

    override func viewDidLoad() {
        super.viewDidLoad()

        let tabBarHeight = self.tabBarController?.tabBar.bounds.height
        self.edgesForExtendedLayout = UIRectEdge.all
        self.tableView.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: tabBarHeight!, right: 0.0)

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()

        pullToRefreshControl = UIRefreshControl()
        pullToRefreshControl!.attributedTitle = NSAttributedString(string: "Pull to refresh")
        pullToRefreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        self.tableView.addSubview(pullToRefreshControl)

        reloadExams()
    }
    func callback(_ sess: [TimeTableSession]) -> Void {
        self.CalendarEvents = sess
        self.pullToRefreshControl.endRefreshing()
        self.tableView.reloadData()

        var sessDict: [NSDictionary] = []

        for item in sess {
            sessDict += [item.dictionaryRepresentation()]
        }

        // store data for offline use
        let examsData = NSKeyedArchiver.archivedData(withRootObject: sessDict)
        UserDefaults.standard.set(examsData, forKey: offlineExamStorageKey)
    }


    func reloadExams() {
        // Code to refresh table view
        if Reachability.isConnectedToNetwork() {
            // load user id
            let id = String(Misc.loadUser()!.aCCOUNT_ID!)
            // load events
            EventAPI.loadTimetableSessions(id, by: Misc.USER_TYPE.exam, callback: callback)
        } else {
            // offline mode

            //clear dataset
            CalendarEvents.removeAll()

            // load saved sessions once
            if OfflineCalendarEvents == nil {
                let timetableDataDict = UserDefaults.standard.object(forKey: offlineExamStorageKey) as? Data

                if timetableDataDict != nil {
                    dataSavedAvailable = true
                    let timetableDataDict = NSKeyedUnarchiver.unarchiveObject(with: timetableDataDict!) as? [NSDictionary]
                    OfflineCalendarEvents = []
                    for item in timetableDataDict! {
                        OfflineCalendarEvents! += [TimeTableSession(dictionary: item)!]
                    }
                }
            }

            if dataSavedAvailable {
                CalendarEvents = OfflineCalendarEvents!
            } else {
                // No previous data found

                //notify user to connect online
                let alert = UIAlertController(title: "Offline Mode", message: "couldn't load your exams, please make sure you're connected to the Internet", preferredStyle: UIAlertControllerStyle.alert)

                let settingsAction = UIAlertAction(title: "Go to Network Settings", style: .default) { (_) -> Void in
                    UIApplication.shared.openURL(URL(string:"prefs:root=WIFI")!)
                }

                let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
                alert.addAction(settingsAction)
                alert.addAction(cancelAction)

                self.present(alert, animated: true, completion: nil)
            }

            // stop refreshing if it is.
            if pullToRefreshControl.isRefreshing {
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

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return CalendarEvents.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "examCell", for: indexPath) as! ExamTableViewCell

        // Configure the cell...
        cell.ExamTitleLabel .text = "\(CalendarEvents[indexPath.row].mODULE_CODE!) - \(CalendarEvents[indexPath.row].mODULE_NAME!)"
        // parse and format date
        let parsedDate: Date = DateUtils.parseFormattedDate(CalendarEvents[indexPath.row].sESSION_DATE_FORMATTED!)
        let formattedDate = DateUtils.FormatExamCell(parsedDate)
        cell.ExamDateLabel.text = "\(formattedDate) \(CalendarEvents[indexPath.row].sTART_TIME_FORMATTED!)-\(CalendarEvents[indexPath.row].eND_TIME_FORMATTED!)"
        cell.ExamRoomLabel.text = "Room: \(CalendarEvents[indexPath.row].rOOM_CODE!)"

        if DateUtils.hasDatePassed(CalendarEvents[indexPath.row]) {
            cell.ExamTitleLabel.textColor = UIColor.gray
            cell.ExamDateLabel.textColor = UIColor.gray
            cell.ExamDateLabel.font = UIFont(name:"HelveticaNeue", size: (cell.ExamDateLabel?.font.pointSize)!)
            cell.ExamRoomLabel.textColor = UIColor.gray

        }
        return cell
    }

    func refresh(_ sender: AnyObject) {
        // Code to refresh table view
        reloadExams()
    }

}
