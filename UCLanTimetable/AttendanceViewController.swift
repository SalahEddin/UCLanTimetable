//
//  AttendanceViewController.swift
//  UCLanTimetable
//
//  Created by Salah Eddin Alshaal on 23/06/16.
//  Copyright © 2016 Salah Eddin Alshaal. All rights reserved.
//

import UIKit

class AttendanceViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    private let reuseIdentifier = "BadgeCell"
    //private let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
    
    var badges : [Badge] = []
    //[]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tabBarHeight = self.tabBarController?.tabBar.bounds.height
        self.edgesForExtendedLayout = UIRectEdge.All
        self.scrollView.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: tabBarHeight!, right: 0.0)
        
        //badgesCollectionView.delegate = self
        
        badges += [Badge(link: "dummy_badge", badgeName: "badge name", badgeDesc: "Lerom Ipsum"),
                   Badge(link: "dummy_badge", badgeName: "badge name 2", badgeDesc: "Lerom Ipsum"),
                   Badge(link: "dummy_badge", badgeName: "badge name 3", badgeDesc: "Lerom Ipsum"),
                   Badge(link: "dummy_badge", badgeName: "badge name 2", badgeDesc: "Lerom Ipsum"),
                   Badge(link: "dummy_badge", badgeName: "badge name 4", badgeDesc: "Lerom Ipsum"),
                   Badge(link: "dummy_badge", badgeName: "badge name 5", badgeDesc: "Lerom Ipsum")]
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
}

//extension AttendanceViewController: UICollectionViewDataSource, UICollectionViewDelegate {
//    
//    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return badges.count
//    }
//    
//    //2
//    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
//        return 1
//    }
//    
//    //3
//    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! BadgeCell
//        
//        cell.backgroundColor = UIColor.blueColor()
//        cell.badgeLabel.text = badges[indexPath.row].name
//        print(indexPath)
//        //cell.badgeImage.image = UIImage(contentsOfFile: "exit-32")
//        //        let path: String = NSBundle.mainBundle().pathForResource("dummy_badge", ofType: "svg")!
//        //        let url: NSURL = NSURL.fileURLWithPath(path)
//        //        let request: NSURLRequest = NSURLRequest(URL: url)
//        //        cell.badgeSVGWebView.loadRequest(request)
//        // let scaleFactor = cell.badgeSVGWebView.
//        //        cell.badgeSVGWebView.scrollView
//        //        cell.badgeSVGWebView.scalesPageToFit = false
//        // Configure the cell
//        return cell
//    }
//}

//extension AttendanceViewController: UICollectionViewDelegateFlowLayout{
//    
//    func collectionView(collectionView: UICollectionView,
//                        layout collectionViewLayout: UICollectionViewLayout,
//                               insetForSectionAtIndex section: Int) -> UIEdgeInsets {
//        return sectionInsets
//    }
//}
