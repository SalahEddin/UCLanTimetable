//
//  DateUtils.swift
//  UCLanTimetable
//
//  Created by Salah Eddin Alshaal on 29/07/16.
//  Copyright © 2016 Salah Eddin Alshaal. All rights reserved.
//

import Foundation

public class DateUtils {
    
    static func parseFormattedDate(str: String) -> NSDate{
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        return dateFormatter.dateFromString(str)!
    }
    
    static func hasDatePassed(session: TimeTableSession) -> Bool {
        // current date time
        let today = NSDate()
        // session datetime
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
        let date = dateFormatter.dateFromString("\(session.sESSION_DATE_FORMATTED!) \(session.eND_TIME_FORMATTED!)")
        return today.compare(date!) == NSComparisonResult.OrderedDescending // today after date
    }
    
    static func isDateSame(session: TimeTableSession, CVSelected: NSDate) -> Bool {
        // current date time
        //        let commonDateFormatter = NSDateFormatter()
        //        commonDateFormatter.dateFormat = "yyyy-MM-dd"
        //        let selected = commonDateFormatter.dateFromString(CVSelected)!
        let selected = CVSelected
        // session datetime
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let date = dateFormatter.dateFromString("\(session.sESSION_DATE_FORMATTED!)")
        return selected.compare(date!) == NSComparisonResult.OrderedSame // today after date
    }
    static func FormatExamCell(date: NSDate)->String{
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MMM dd"
        return dateFormatter.stringFromDate(date)
    }
    static func FormatCalendarChoiceDate(date: NSDate)->String{
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd MMMM, yyyy"
        return dateFormatter.stringFromDate(date)
    }
    
    static func FormatToAPIDate(date: NSDate)->String{
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.stringFromDate(date)
    }
    
    static func extractTimestamp(rawDate: String)->NSDate{
        var raw = rawDate
        let starRrange = raw.startIndex..<raw.startIndex.advancedBy(6)
        raw.removeRange(starRrange)
        let endRrange = raw.endIndex.advancedBy(-2)..<raw.endIndex
        raw.removeRange(endRrange)
        return NSDate(timeIntervalSince1970: (raw as NSString).doubleValue)
    }
}