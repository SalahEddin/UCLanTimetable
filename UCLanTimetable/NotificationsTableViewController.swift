//
//  NotificationsTableViewController.swift
//  UCLanTimetable
//
//  Created by Salah Eddin Alshaal on 30/06/16.
//  Copyright © 2016 Salah Eddin Alshaal. All rights reserved.
//

import UIKit
import MGSwipeTableCell

class NotificationsViewController: UIViewController {
    // UI binding
    @IBOutlet weak var filterSegmentedControl: UISegmentedControl!
    @IBOutlet weak var notifsTableView: UITableView!

    var notifications: [Notification] = []
    var allNotifications: [Notification] = []
    var pullToRefreshControl: UIRefreshControl!

    let user_id = Misc.loadUser()!.uSER_ID!

    // passed
    var notificationParam: Notification? = nil
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()

        pullToRefreshControl = UIRefreshControl()
        pullToRefreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        self.notifsTableView.addSubview(pullToRefreshControl)

        reloadNotifications()
    }

    func reloadNotifications() {
        NotificationAPI.loadNotifications(String(user_id), callback: notifsCallback)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func notifsCallback(_ notifs: [Notification]) {
        allNotifications.removeAll()
        allNotifications.append(contentsOf: notifs)
        notifications.removeAll()
        notifications.append(contentsOf: allNotifications)
        self.notifsTableView.reloadData()
    }

    func refresh(_ sender: AnyObject) {
        // Code to refresh table view
        reloadNotifications()
        pullToRefreshControl.endRefreshing()
    }

    @IBAction func notificationFilter_Changed(_ sender: AnyObject) {
        switch filterSegmentedControl.selectedSegmentIndex {
        case 0:
            notifications = allNotifications
        case 1:
            notifications = allNotifications.filter {item in
                return item.isRead
            }
        case 2:
            notifications = allNotifications.filter {item in
                return !item.isRead
            }
        case 3:
            notifications = allNotifications.filter {item in
                return item.isArchived
            }
        default:
            break
        }
        notifsTableView.reloadData()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        if segue.identifier == "NotifCellSegue" {
            let DestViewController = segue.destination as? DetailedNotificationViewController
            if DestViewController != nil {
                DestViewController!.notification = notificationParam!
            }
        }
    }
}

//MARK: - UITableViewDelegate & UITableViewDataSource
extension NotificationsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        notificationParam = notifications[indexPath.row]
        self.performSegue(withIdentifier: "NotifCellSegue", sender: self)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count//CalendarEvents.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reuseIdentifier = "notificationCell"
        var cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? NotificationTableViewCell

        if cell == nil {
            cell = NotificationTableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: reuseIdentifier)
        }
        // cell!.delegate = self //optional
        let rowItem = notifications[indexPath.row]

        ///////////////////////////////////
        //UI Binding
        ////////////

        // Configure the cell...
        let publishDate =  Date(jsonDate: rowItem.pUBLISH_DATE!)!
        // format displayed date
        let df = DateFormatter(); df.dateFormat = "dd MMMM, yyyy"

        cell!.NotiDateLabel.text = df.string(from: publishDate)
        cell!.NotiTypeLabel.text = rowItem.nOTIFICATION_TYPE_NAME
        cell!.NotiTitleLabel.text = rowItem.nOTIFICATION_TITLE

        //configure left buttons (Delete)
        let deleteButton = MGSwipeButton(title: "Delete", icon: UIImage(named:"delete_filled.png"), backgroundColor: UIColor(netHex: 0xc0392b), callback: {
            (sender: MGSwipeTableCell!) -> Bool in
            print("Convenience callback for swipe buttons!")
            NotificationAPI.changeStatus(rowItem.nOTIFICATION_ID!, newStatus: NotificationAPI.Status.deleted, callback: self.statusChangedCallback)
            return true
        })
        cell!.leftButtons = [deleteButton]
        cell!.leftSwipeSettings.transition = MGSwipeTransition.border

        //configure right buttons (Archive & Mark as read)
        var rightButtons: [MGSwipeButton] = []

        let isRead = rowItem.isRead
        let isArchived = rowItem.isArchived

        if isArchived {
            let archiveButton = MGSwipeButton(title: "Unarchive", backgroundColor: UIColor(netHex: 0x95a5a6), callback: {
                (sender: MGSwipeTableCell!) -> Bool in
                NotificationAPI.changeStatus(rowItem.nOTIFICATION_ID!, newStatus: NotificationAPI.Status.unread, callback: self.statusChangedCallback)
                print("Convenience callback for swipe buttons!")
                return true
            })
            rightButtons += [archiveButton]

        } else {
            let archiveButton = MGSwipeButton(title: "Archive", backgroundColor: UIColor(netHex: 0x95a5a6), callback: {
                (sender: MGSwipeTableCell!) -> Bool in
                NotificationAPI.changeStatus(rowItem.nOTIFICATION_ID!, newStatus: NotificationAPI.Status.archived, callback: self.statusChangedCallback)
                print("Convenience callback for swipe buttons!")
                return true
            })
            rightButtons += [archiveButton]
            // not archived, check if read
            if isRead {
                let markButton = MGSwipeButton(title: "Mark as unread", backgroundColor: UIColor(netHex: 0x2980b9), callback: {
                    (sender: MGSwipeTableCell!) -> Bool in
                    NotificationAPI.changeStatus(rowItem.nOTIFICATION_ID!, newStatus: NotificationAPI.Status.unread, callback: self.statusChangedCallback)
                    print("Convenience callback for swipe buttons!")
                    return true
                })
                rightButtons += [markButton]
            } else {
                //not read
                // mark as read
                let markButton = MGSwipeButton(title: "Mark as read", backgroundColor: UIColor(netHex: 0x2980b9), callback: {
                    (sender: MGSwipeTableCell!) -> Bool in
                    NotificationAPI.changeStatus(rowItem.nOTIFICATION_ID!, newStatus: NotificationAPI.Status.read, callback: self.statusChangedCallback)
                    print("Convenience callback for swipe buttons!")
                    return true
                })
                rightButtons += [markButton]
            }
        }

        if rowItem.iMPORTANT! == 0 {
            cell!.NotiLegendView.isHidden = true
        }

        rowItem.calculateStatus()
        if rowItem.isRead || rowItem.isArchived {
            cell!.NotiTitleLabel.font = UIFont(name:"HelveticaNeue", size: (cell!.NotiTitleLabel?.font.pointSize)!)
            cell!.NotiDateLabel.font = UIFont(name:"HelveticaNeue", size: (cell!.NotiDateLabel?.font.pointSize)!)
            cell!.NotiDateLabel.textColor = UIColor.lightGray
            cell!.NotiTypeLabel.textColor = UIColor.lightGray
        } else {
            cell!.NotiTitleLabel.font = UIFont(name:"HelveticaNeue-Bold", size: (cell!.NotiTitleLabel?.font.pointSize)!)
            cell!.NotiDateLabel.font = UIFont(name:"HelveticaNeue-Bold", size: (cell!.NotiDateLabel?.font.pointSize)!)
            cell!.NotiDateLabel.textColor = UIColor(netHex: 0xc0392b)
            cell!.NotiTypeLabel.textColor = UIColor.darkGray
        }

        cell!.rightButtons = rightButtons
        cell!.rightSwipeSettings.transition = MGSwipeTransition.border

        //tableView.estimatedRowHeight = 150.0
        //tableView.rowHeight = UITableViewAutomaticDimension

        return cell!
    }

    override func viewWillAppear(_ animated: Bool) {
        reloadNotifications()
    }
    func statusChangedCallback() {
        reloadNotifications()
    }
}
