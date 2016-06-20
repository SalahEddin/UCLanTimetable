//
//  IndexViewController.swift
//  UCLanTimetable
//
//  Created by Salah Eddin Alshaal on 15/06/16.
//  Copyright © 2016 Salah Eddin Alshaal. All rights reserved.
//

import UIKit
import CVCalendar

class IndexViewController: UIViewController {
    
    @IBOutlet weak var menuView: CVCalendarMenuView!
    @IBOutlet weak var calView: CVCalendarView!
    @IBOutlet weak var msgLabel: UILabel!
    
    @IBOutlet weak var eventsTableView: UITableView!
    
    var CalendarEvents:[CalendarEvent] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        //self.view.layoutIfNeeded()
        
        //self.eventsTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "CalenderEventTableViewCell")
        
//        eventsTableView.delegate = self
//        eventsTableView.dataSource = self
//        
        CalendarEvents = [CalendarEvent]()
        let ev1 = CalendarEvent(mName: "Computing", mCode: "CO2303", room: "CY007", lec: "P. Andreou", time: "10:00 - 11:00")
        let ev2 = CalendarEvent(mName: "Computings", mCode: "CO2303", room: "CY007", lec: "P. Andreou", time: "13:00 - 17:00")
        CalendarEvents += [ev1,ev2]
    }
    
    @IBAction func ck(sender: AnyObject) {
        msgLabel.text = "yes"
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
        
        CalendarEvents[0].ModuleCode = dayView.date.commonDescription
        eventsTableView.reloadData()
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
        cell.ModuleName.text = CalendarEvents[indexPath.row].ModuleCode
        cell.EventTime.text = CalendarEvents[indexPath.row].Time
        cell.EventDetails.text = "\(CalendarEvents[indexPath.row].Room) - \(CalendarEvents[indexPath.row].Lecturer)"
        
        return cell
        
    }
}
