//
//  API.swift
//  UCLanTimetable
//
//  Created by Salah Eddin Alshaal on 28/07/16.
//  Copyright © 2016 Salah Eddin Alshaal. All rights reserved.
//

import Foundation
import Alamofire

open class NotificationAPI {
    public enum Status: Int {
        case deleted = 2
        case archived = 4
        case read = 1
        case unread = 0
        static var UNARCHIVED: Status {return unread}
        //case UNARCHIVED = 0
    }

    static func isNotificationRead(_ status: Int) -> Bool {
        // least signignificant
        let x = UInt8(status)
        return (x & 0b00000001 == 1)
    }

    static func isNotificationDeleted(_ status: Int) -> Bool {
        // second digit
        let x = UInt8(status)
        return (x>>1 & 0b00000001 == 1)
    }

    static func isNotificationArchived(_ status: Int) -> Bool {
        // third digit
        let x = UInt8(status)
        return (x>>2 & 0b00000001 == 1)
    }
    static func changeStatus(_ id: Int, newStatus: Status, callback:@escaping () -> Void) {
        let params: [String : AnyObject] = [
            "securityToken": UCLanAPI.SecurityToken as AnyObject,
            "NOTIFICATION_ID": id as AnyObject,
            "NOTIFICATION_STATUS":newStatus.rawValue as AnyObject
        ]
        let APICall = UCLanAPI.ENDPOINT + UCLanAPI.updateNotificationsStatus

        Alamofire.request(APICall, parameters: params)
            .responseJSON {  response in
                print(response.result)
                DispatchQueue.main.async(execute: { () -> Void in
                    callback()
                })
        }
    }

    static func getNotification(_ id: Int, callback: @escaping (Notification) -> Void) {
        let params: [String : AnyObject] = ["securityToken": UCLanAPI.SecurityToken as AnyObject, "NOTIFICATION_ID": id as AnyObject]
        let APICall = UCLanAPI.ENDPOINT + UCLanAPI.getNotificationById

        Alamofire.request(APICall, parameters: params)
            .responseJSON {  response in
                print(response.result)   // result of response serialization
                if let JSON = response.result.value as? [String: AnyObject] {
                    DispatchQueue.main.async(execute: { () -> Void in
                        callback(Notification(dictionary: JSON as NSDictionary)!)
                    })
                }
        }
    }

    static func loadNotifications(_ userId: String, callback: @escaping (([Notification]) -> Void )) {
        var notifs: [Notification] = []
        let params: [String : AnyObject] = ["securityToken": UCLanAPI.SecurityToken as AnyObject, "USER_ID": userId as AnyObject]
        let APICall = UCLanAPI.ENDPOINT + UCLanAPI.getNotifications

        Alamofire.request(APICall, parameters: params)
            .responseJSON {  response in
                print(response.result)   // result of response serialization
                if let JSON = response.result.value as? [[String: AnyObject]] {
                    for item in JSON {
                        notifs += [Notification(dictionary: item as NSDictionary)!]
                    }
                }
                //print("got \(sessions.count)")
                DispatchQueue.main.async(execute: { () -> Void in
                    callback(notifs)
                })
        }
    }
    
}
