//
//  BadgeAPI.swift
//  UCLanTimetable
//
//  Created by Salah Eddin Alshaal on 23/12/2016.
//  Copyright © 2016 Salah Eddin Alshaal. All rights reserved.
//

import Foundation
import Alamofire

open class BadgeAPI {

    static func listBadges(studentId: String, _ callback: @escaping (([Badge]) -> Void )) {
        var badges: [Badge] = []
        let params: [String : AnyObject] = ["securityToken": UCLanAPI.SecurityToken as AnyObject,
                                            "STUDENT_ID": studentId as AnyObject]
        let APICall = UCLanAPI.ENDPOINT + UCLanAPI.listBadges
        Alamofire.request(APICall, parameters: params)
            .responseJSON {  response in
                print(response.result)   // result of response serialization
                if let JSON = response.result.value as? [[String: AnyObject]] {
                    for item in JSON {
                        badges += [Badge(dictionary: item as NSDictionary)!]
                    }
                }
                //print("got \(sessions.count)")
                DispatchQueue.main.async(execute: { () -> Void in
                    callback(badges)
                })
        }
    }

    static func getAvgAttendance(studentId: String, _ callback: @escaping ((Attendance) -> Void )) {
        var attendance: [Attendance] = []
        let params: [String : AnyObject] = ["securityToken": UCLanAPI.SecurityToken as AnyObject,
                                            "STUDENT_ID": studentId as AnyObject]
        let APICall = UCLanAPI.ENDPOINT + UCLanAPI.getAvgAttendance
        Alamofire.request(APICall, parameters: params)
            .responseJSON {  response in
                print(response.result)   // result of response serialization
                if let JSON = response.result.value as? [[String: AnyObject]] {
                    for item in JSON {
                        attendance += [Attendance(dictionary: item as NSDictionary)!]
                    }
                }
                //print("got \(sessions.count)")
                DispatchQueue.main.async(execute: { () -> Void in
                    callback(attendance[0])
                })
        }
    }

}
