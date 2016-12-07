//
//  DateUtils.swift
//  UCLanTimetable
//
//  Created by Salah Eddin Alshaal on 29/07/16.
//  Copyright © 2016 Salah Eddin Alshaal. All rights reserved.
//

import Foundation

open class DateUtils {

    static func parseFormattedDate(_ str: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        return dateFormatter.date(from: str)!
    }

    static func hasDatePassed(_ session: TimeTableSession) -> Bool {
        // current date time
        let today = Date()
        // session datetime
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
        let date = dateFormatter.date(from: "\(session.sESSION_DATE_FORMATTED!) \(session.eND_TIME_FORMATTED!)")
        return today.compare(date!) == ComparisonResult.orderedDescending // today after date
    }

    static func isDateSame(_ session: TimeTableSession, CVSelected: Date) -> Bool {
        // current date time
        //        let commonDateFormatter = NSDateFormatter()
        //        commonDateFormatter.dateFormat = "yyyy-MM-dd"
        //        let selected = commonDateFormatter.dateFromString(CVSelected)!
        let selected = CVSelected
        // session datetime
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let date = dateFormatter.date(from: "\(session.sESSION_DATE_FORMATTED!)")
        return selected.compare(date!) == ComparisonResult.orderedSame // today after date
    }
    static func FormatExamCell(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd"
        return dateFormatter.string(from: date)
    }
    static func FormatCalendarChoiceDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM, yyyy"
        return dateFormatter.string(from: date)
    }

    static func FormatToAPIDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: date)
    }

}

extension Date {
    init?(jsonDate: String) {
        let prefix = "/Date("
        let suffix = ")/"
        let scanner = Scanner(string: jsonDate)

        // Check prefix:
        if scanner.scanString(prefix, into: nil) {

            // Read milliseconds part:
            var milliseconds: Int64 = 0
            if scanner.scanInt64(&milliseconds) {
                // Milliseconds to seconds:
                var timeStamp = TimeInterval(milliseconds)/1000.0

                // Read optional timezone part:
                var timeZoneOffset: Int = 0
                if scanner.scanInt(&timeZoneOffset) {
                    let hours = timeZoneOffset / 100
                    let minutes = timeZoneOffset % 100
                    // Adjust timestamp according to timezone:
                    timeStamp += TimeInterval(3600 * hours + 60 * minutes)
                }

                // Check suffix:
                if scanner.scanString(suffix, into: nil) {
                    // Success! Create Date and return.
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
