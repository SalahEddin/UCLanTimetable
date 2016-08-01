//
//  EventAPI.swift
//  UCLanTimetable
//
//  Created by Salah Eddin Alshaal on 28/07/16.
//  Copyright © 2016 Salah Eddin Alshaal. All rights reserved.
//

import Foundation
import Alamofire

public class EventAPI{
    // MARK: API
    static func listRooms(callback: (([Room])->Void )){
        var rooms: [Room] = []
        let params: [String : AnyObject] = ["securityToken": UCLanAPI.SecurityToken]
        let APICall = UCLanAPI.ENDPOINT + UCLanAPI.listRooms
        Alamofire.request(.GET, APICall, parameters: params)
            .responseJSON{  response in
                print(response.result)   // result of response serialization
                if let JSON = response.result.value as? [[String: AnyObject]] {
                    for item in JSON{
                        rooms += [Room(dictionary: item)!]
                    }
                }
                //print("got \(sessions.count)")
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    callback(rooms)
                })
        }
        
    }
    
    static func getUserLogin(username: String, pass: String, callback: ((AuthenticatedUser?)->Void)){
        var user: AuthenticatedUser? = nil
        //todo hash password, conf
        let params: [String : AnyObject] = [
            "securityToken": UCLanAPI.SecurityToken,
            "USERNAME": username,
            "PASSWORD":pass]
        let APICall = UCLanAPI.ENDPOINT + UCLanAPI.login
        
        Alamofire.request(.GET, APICall, parameters: params)
            .responseJSON{  response in
                print(response.result)   // result of response serialization
                if let JSON = response.result.value as? [String: AnyObject] {
                    user = AuthenticatedUser(dictionary: JSON)
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        callback(user)
                    })
                }
                else{
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        callback(nil)
                    })
                }
        }
    }
    
    static func loadTimetableSessions(id: String, startDate: String = "", endDate: String = "", by: Misc.USER_TYPE, callback: ([TimeTableSession])->Void ){
        //clear array
        var sessions: [TimeTableSession] = []
        var params : [String: AnyObject] = [:]
        var APICall: String = ""
        
        switch by {
        case .STUDENT:
            // student
            APICall = UCLanAPI.ENDPOINT + UCLanAPI.getTimetableByStudent
            params = [
                "securityToken": UCLanAPI.SecurityToken,
                "STUDENT_ID": id,
                "START_DATE_TIME":startDate,
                "END_DATE_TIME":endDate]
            break
        case .LECTURER:
            APICall = UCLanAPI.ENDPOINT + UCLanAPI.getTimetableByLecturer
            params = [
                "securityToken": UCLanAPI.SecurityToken,
                "LECTURER_ID": id,
                "START_DATE_TIME":startDate,
                "END_DATE_TIME":endDate]
            break
        case .ROOM:
            APICall = UCLanAPI.ENDPOINT + UCLanAPI.getTimetableByRoom
            params = [
                "securityToken": UCLanAPI.SecurityToken,
                "ROOM_ID": id,
                "START_DATE_TIME":startDate,
                "END_DATE_TIME":endDate]
            break
        case .EXAM:
            APICall = UCLanAPI.ENDPOINT + UCLanAPI.getUpcomingExams
            params = [
                "securityToken": UCLanAPI.SecurityToken,
                "STUDENT_ID": id]
            break
        }
        
        Alamofire.request(.GET, APICall, parameters: (params))
            .responseJSON { response in
                
                print(response.result)   // result of response serialization
                if let JSON = response.result.value as? [[String: AnyObject]] {
                    for item in JSON{
                        sessions += [TimeTableSession(dictionary: item)!]
                    }
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        callback(sessions)
                    })
                }
        }
    }
}
