//
//  Misc.swift
//  UCLanTimetable
//
//  Created by Salah Eddin Alshaal on 20/07/16.
//  Copyright © 2016 Salah Eddin Alshaal. All rights reserved.
//

import Foundation
import Alamofire

public class Misc {
    public enum SESSION_TYPE {  case EXAM
        case NOTIFICATION
        case ALL}
    
    static func hasDatePassed(session: TimeTableSession) -> Bool {
        // current date time
        let today = NSDate()
        // session datetime
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
        let date = dateFormatter.dateFromString("\(session.sESSION_DATE_FORMATTED!) \(session.eND_TIME_FORMATTED!)")
        return today.compare(date!) == NSComparisonResult.OrderedDescending // today after date
    }
    
    static func loadTimetableSessions(startDate: String, endDate: String, type: SESSION_TYPE = .ALL, callback: ([TimeTableSession])->Void ){
        //clear array
        var sessions: [TimeTableSession] = []
        
        let params = [
            "securityToken": "e84e281d4c9b46f8a30e4a2fd9aa7058",
            "STUDENT_ID": 622,
            "START_DATE_TIME":startDate,
            "END_DATE_TIME":endDate]
        
        print("before \(sessions.count)")
        
        Alamofire.request(.GET, "https://cyprustimetable.uclan.ac.uk/TimetableAPI/TimetableWebService.asmx/getTimetableByStudent", parameters: (params as! [String : AnyObject]))
            .responseJSON { response in
                
                print(response.result)   // result of response serialization
                if let JSON = response.result.value as? [[String: AnyObject]] {
                    for item in JSON{
                        if(type == .EXAM && item["SESSION_DESCRIPTION"]!.isEqual("Examination") ){
                            sessions += [TimeTableSession(dictionary: item)!]
                        }
                        else if(type == .ALL){
                            sessions += [TimeTableSession(dictionary: item)!]
                        }
                    }
                    print("got \(sessions.count)")
                    callback(sessions)
                }
        }
        print("after \(sessions.count)")
    }
}
