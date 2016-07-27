//
//  Misc.swift
//  UCLanTimetable
//
//  Created by Salah Eddin Alshaal on 20/07/16.
//  Copyright © 2016 Salah Eddin Alshaal. All rights reserved.
//

import Foundation
import Alamofire
import Keychain
import SystemConfiguration

public class APIs{
    public static let ENDPOINT = "https://cyprustimetable.uclan.ac.uk/TimetableAPI/TimetableWebService.asmx/"
    public static let SecurityToken = "e84e281d4c9b46f8a30e4a2fd9aa7058"
    public static let listRooms = "app_getRooms"
    public static let login = "app_login"
    public static let getTimetableByStudent = "app_getTimetableByStudent"
    public static let getTimetableByRoom = "app_getTimetableByRoom"
}

public class KEYS{
    public static let user = "user"
    public static let username = "username"
    public static let pass = "pass"
}

public class Misc {
    
    public enum SESSION_TYPE {  case EXAM
        case NOTIFICATION
        case ALL}
    public enum USER_TYPE {  case EXAM
        case STUDENT
        case ROOM}
    
    static func loadUser() -> AuthenticatedUser? {
        var user: AuthenticatedUser? = nil
        let storedUserString = Keychain.load(KEYS.user)
        if  storedUserString != nil{
            do {
                let data = storedUserString!.dataUsingEncoding(NSUTF8StringEncoding)
                // here "decoded" is the dictionary decoded from JSON data
                let decoded = try NSJSONSerialization.JSONObjectWithData(data! , options: []) as? [String:AnyObject]
                user = AuthenticatedUser(dictionary: decoded!)
                
            } catch let error as NSError {
                print(error)
            }
        }
        return user
    }
    static func saveUser(user: AuthenticatedUser?) -> Bool{
        
        var success = false
        // serialise user as JSON, then save to keychain
        let dic = user!.dictionaryRepresentation()
        var userDatastring: String? = nil
        
        do {
            // here "jsonData" is the dictionary encoded in JSON data
            let jsonData = try NSJSONSerialization.dataWithJSONObject(dic, options: NSJSONWritingOptions.PrettyPrinted)
            userDatastring = NSString(data: jsonData, encoding: NSUTF8StringEncoding)! as String
            // save to keychain
            if Keychain.save(userDatastring!, forKey: KEYS.user) {
                // if saving is successful
                success = true
            }
            
        } catch let error as NSError {
            print(error)
        }
        return success
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
    
    static func listRooms(callback: (([Room])->Void )){
        var rooms: [Room] = []
        let params: [String : AnyObject] = ["securityToken": APIs.SecurityToken]
        let APICall = APIs.ENDPOINT + APIs.listRooms
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
            "securityToken": APIs.SecurityToken,
            "USERNAME": username,
            "PASSWORD":pass]
        let APICall = APIs.ENDPOINT + APIs.login
        
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
    
    static func loadTimetableSessions(id: String, startDate: String, endDate: String, type: SESSION_TYPE = .ALL, by: USER_TYPE = .STUDENT, callback: ([TimeTableSession])->Void ){
        //clear array
        var sessions: [TimeTableSession] = []
        
        // student
        var params: [String : AnyObject] = [
            "securityToken": APIs.SecurityToken,
            "STUDENT_ID": id,
            "START_DATE_TIME":startDate,
            "END_DATE_TIME":endDate]
        var APICall = APIs.ENDPOINT + APIs.getTimetableByStudent
        // if room
        if(by == USER_TYPE.ROOM){
            APICall = APIs.ENDPOINT + APIs.getTimetableByRoom
            params = [
                "securityToken": APIs.SecurityToken,
                "ROOM_ID": id,
                "START_DATE_TIME":startDate,
                "END_DATE_TIME":endDate]
        }
        
        
        Alamofire.request(.GET, APICall, parameters: (params))
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
                    //print("got \(sessions.count)")
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        callback(sessions)
                    })
                }
        }
    }
}

public class Reachability {
    class func isConnectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(sizeofValue(zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        let defaultRouteReachability = withUnsafePointer(&zeroAddress) {
            SCNetworkReachabilityCreateWithAddress(nil, UnsafePointer($0))
        }
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
}
