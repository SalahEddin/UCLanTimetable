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
    
}

extension NSDate {
    convenience init?(jsonDate: String) {
        let prefix = "/Date("
        let suffix = ")/"
        let scanner = NSScanner(string: jsonDate)
        
        // Check prefix:
        if scanner.scanString(prefix, intoString: nil) {
            
            // Read milliseconds part:
            var milliseconds : Int64 = 0
            if scanner.scanLongLong(&milliseconds) {
                // Milliseconds to seconds:
                var timeStamp = NSTimeInterval(milliseconds)/1000.0
                
                // Read optional timezone part:
                var timeZoneOffset : Int = 0
                if scanner.scanInteger(&timeZoneOffset) {
                    let hours = timeZoneOffset / 100
                    let minutes = timeZoneOffset % 100
                    // Adjust timestamp according to timezone:
                    timeStamp += NSTimeInterval(3600 * hours + 60 * minutes)
                }
                
                // Check suffix:
                if scanner.scanString(suffix, intoString: nil) {
                    // Success! Create NSDate and return.
                    self.init(timeIntervalSince1970: timeStamp)
                    return
                }
            }
        }
        
        // Wrong format, return nil. (The compiler requires us to
        // do an initialization first.)
        self.init(timeIntervalSince1970: 0)
        return nil
    }
}