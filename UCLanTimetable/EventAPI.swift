//
//  EventAPI.swift
//  UCLanTimetable
//
//  Created by Salah Eddin Alshaal on 28/07/16.
//  Copyright © 2016 Salah Eddin Alshaal. All rights reserved.
//

import Foundation
import Alamofire

open class EventAPI {
    // MARK: API
    static func listRooms(_ callback: @escaping (([Room]) -> Void )) {
        var rooms: [Room] = []
        let params: [String : AnyObject] = ["securityToken": UCLanAPI.SecurityToken as AnyObject]
        let APICall = UCLanAPI.ENDPOINT + UCLanAPI.listRooms
        Alamofire.request(APICall, parameters: params)
            .responseJSON {  response in
                print(response.result)   // result of response serialization
                if let JSON = response.result.value as? [[String: AnyObject]] {
                    for item in JSON {
                        rooms += [Room(dictionary: item as NSDictionary)!]
                    }
                }
                //print("got \(sessions.count)")
                DispatchQueue.main.async(execute: { () -> Void in
                    callback(rooms)
                })
        }

    }

    static func getUserLogin(_ username: String, pass: String, callback: @escaping ((AuthenticatedUser?) -> Void)) {
        var user: AuthenticatedUser? = nil
        //todo hash password, conf
        let params: [String : AnyObject] = [
            "securityToken": UCLanAPI.SecurityToken as AnyObject,
            "USERNAME": username as AnyObject,
            "PASSWORD":pass as AnyObject]
        let APICall = UCLanAPI.ENDPOINT + UCLanAPI.login

        Alamofire.request(APICall, parameters: params)
            .responseJSON {  response in
                print(response.result)   // result of response serialization
                if let JSON = response.result.value as? [String: AnyObject] {
                    user = AuthenticatedUser(dictionary: JSON as NSDictionary)

                    DispatchQueue.main.async(execute: { () -> Void in
                        callback(user)
                    })
                } else {
                    DispatchQueue.main.async(execute: { () -> Void in
                        callback(nil)
                    })
                }
        }
    }

    static func loadTimetableSessions(_ id: String, startDate: String = "", endDate: String = "", by: Misc.USER_TYPE, callback: @escaping ([TimeTableSession]) -> Void ) {
        //clear array
        var sessions: [TimeTableSession] = []
        var params: [String: AnyObject] = [:]
        var APICall: String = ""

        switch by {
        case .student:
            // student
            APICall = UCLanAPI.ENDPOINT + UCLanAPI.getTimetableByStudent
            params = [
                "securityToken": UCLanAPI.SecurityToken as AnyObject,
                "STUDENT_ID": id as AnyObject,
                "START_DATE_TIME":startDate as AnyObject,
                "END_DATE_TIME":endDate as AnyObject]
            break
        case .lecturer:
            APICall = UCLanAPI.ENDPOINT + UCLanAPI.getTimetableByLecturer
            params = [
                "securityToken": UCLanAPI.SecurityToken as AnyObject,
                "LECTURER_ID": id as AnyObject,
                "START_DATE_TIME":startDate as AnyObject,
                "END_DATE_TIME":endDate as AnyObject]
            break
        case .room:
            APICall = UCLanAPI.ENDPOINT + UCLanAPI.getTimetableByRoom
            params = [
                "securityToken": UCLanAPI.SecurityToken as AnyObject,
                "ROOM_ID": id as AnyObject,
                "START_DATE_TIME":startDate as AnyObject,
                "END_DATE_TIME":endDate as AnyObject]
            break
        case .exam:
            APICall = UCLanAPI.ENDPOINT + UCLanAPI.getUpcomingExams
            params = [
                "securityToken": UCLanAPI.SecurityToken as AnyObject,
                "STUDENT_ID": id as AnyObject]
            break
        }

        Alamofire.request(APICall, parameters: (params))
            .responseJSON { response in

                print(response.result)   // result of response serialization
                if let JSON = response.result.value as? [[String: AnyObject]] {
                    for item in JSON {
                        sessions += [TimeTableSession(dictionary: item as NSDictionary)!]
                    }
                    DispatchQueue.main.async(execute: { () -> Void in
                        callback(sessions)
                    })
                }
        }
    }
}
