//
//  API.swift
//  UCLanTimetable
//
//  Created by Salah Eddin Alshaal on 28/07/16.
//  Copyright © 2016 Salah Eddin Alshaal. All rights reserved.
//

import Foundation
import Alamofire

public class NotificationAPI {
    public enum Status: Int{
        case DELETED = 2
        case ARCHIVED = 4
        case READ = 1
        case UNREAD = 0
        static var UNARCHIVED: Status{return UNREAD}
        //case UNARCHIVED = 0
    }
    
    static func isNotificationRead(status: Int) -> Bool {
        // least signignificant
        let x = UInt8(status)
        return (x & 0b00000001 == 1)
    }
    
    static func isNotificationDeleted(status: Int) -> Bool {
        // second digit
        let x = UInt8(status)
        return (x>>1 & 0b00000001 == 1)
    }
    
    static func isNotificationArchived(status: Int) -> Bool {
        // third digit
        let x = UInt8(status)
        return (x>>2 & 0b00000001 == 1)
    }
    static func changeStatus(id: Int, newStatus: Status, callback:()->Void){
        let params: [String : AnyObject] = [
            "securityToken": UCLanAPI.SecurityToken,
            "NOTIFICATION_ID": id,
            "NOTIFICATION_STATUS":newStatus.rawValue
        ]
        let APICall = UCLanAPI.ENDPOINT + UCLanAPI.updateNotificationsStatus
        
        Alamofire.request(.GET, APICall, parameters: params)
            .responseJSON{  response in
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    callback()
                })
        }
    }
    static func loadNotifications(userId: String,callback: (([Notification])->Void )){
        var notifs: [Notification] = []
        let params: [String : AnyObject] = ["securityToken": UCLanAPI.SecurityToken,"USER_ID": userId]
        let APICall = UCLanAPI.ENDPOINT + UCLanAPI.getNotifications
        
        Alamofire.request(.GET, APICall, parameters: params)
            .responseJSON{  response in
                print(response.result)   // result of response serialization
                if let JSON = response.result.value as? [[String: AnyObject]] {
                    for item in JSON{
                        notifs += [Notification(dictionary: item)!]
                    }
                }
                //print("got \(sessions.count)")
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    callback(notifs)
                })
        }
    }
    
}