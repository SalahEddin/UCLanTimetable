//
//  AttendanceViewController.swift
//  UCLanTimetable
//
//  Created by Salah Eddin Alshaal on 23/06/16.
//  Copyright © 2016 Salah Eddin Alshaal. All rights reserved.
//

import UIKit

class AttendanceViewController: UIViewController {

    @IBOutlet weak var attendanceLabel: UILabel!
    @IBOutlet weak var attendanceProgress: UIProgressView!
    @IBOutlet weak var badgeCount: UILabel!
    @IBOutlet weak var studentName: UILabel!
    @IBOutlet weak var colView: UICollectionView!
    fileprivate let reuseIdentifier = "BadgeViewCell"
    open static let offlineBadgeStorageKey = "badge"

    var badges: [Badge] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        //let tabBarHeight = self.tabBarController?.tabBar.bounds.height
        //self.edgesForExtendedLayout = UIRectEdge.all
        //self.colView.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: tabBarHeight!, right: 0.0)

        colView.delegate = self
        reloadBadges()
        getAttendance()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }

    func getAttendance() {
        // Code to refresh table view
        if Reachability.isConnectedToNetwork() {
            // load user id
            let id = String(Misc.loadUser()!.aCCOUNT_ID!)
            // load events
            BadgeAPI.getAvgAttendance(studentId: id, attendanceCallback)
        } else {
            /// offline mode
            // todo
        }
    }

    func reloadBadges() {
        // Code to refresh table view
        if Reachability.isConnectedToNetwork() {
            // load user id
            let id = String(Misc.loadUser()!.aCCOUNT_ID!)
            // load events
            BadgeAPI.listBadges(studentId: id, callback)
        } else {
            /// offline mode
            // todo
        }
    }

    func attendanceCallback(_ att: Attendance) -> Void {
        self.attendanceLabel.text = "Attendance: " + String(describing: att.aTTENDANCE_AVERAGE!) + "%"
        self.attendanceProgress.progress = Float(att.aTTENDANCE_AVERAGE!)/100
        
    }

    func callback(_ sess: [Badge]) -> Void {
        self.studentName.text = Misc.loadUser()!.fULLNAME
        self.badgeCount.text = String(sess.count) + " Badges"
        self.badges = sess
        self.colView.reloadData()

        var sessDict: [NSDictionary] = []

        for item in sess {
            sessDict += [item.dictionaryRepresentation()]
        }

        // store data for offline use
        let badgesData = NSKeyedArchiver.archivedData(withRootObject: sessDict)
        UserDefaults.standard.set(badgesData, forKey: AttendanceViewController.offlineBadgeStorageKey)
    }
}

extension AttendanceViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.reuseIdentifier, for: indexPath as IndexPath) as? BadgeViewCell

        if cell != nil {
        cell!.image.downloadedFrom(link: badges[indexPath.row].bADGE_URL!)
        cell!.name.text = badges[indexPath.row].bADGE_NAME
        }
        return cell!
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return badges.count
    }

    //2
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
}
