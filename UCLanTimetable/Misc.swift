//
//  Misc.swift
//  UCLanTimetable
//
//  Created by Salah Eddin Alshaal on 20/07/16.
//  Copyright © 2016 Salah Eddin Alshaal. All rights reserved.
//

import Foundation
import Keychain
import SystemConfiguration



public class KEYS {
    public static let user = "user"
    public static let username = "username"
    public static let pass = "pass"
    public static let offlineTimetableStorageKey = "timetable"
    public static let offlineExamStorageKey = "exams"
    public static let studentTypeId = 5
}

public class Misc {

    public enum USER_TYPE {
        case EXAM
        case STUDENT
        case LECTURER
        case ROOM}

    // MARK: IO
    static func loadUser() -> AuthenticatedUser? {
        var user: AuthenticatedUser? = nil
        let storedUserString = Keychain.load(KEYS.user)
        if  storedUserString != nil {
            do {
                let data = storedUserString!.dataUsingEncoding(NSUTF8StringEncoding)
                // here "decoded" is the dictionary decoded from JSON data
                let decoded = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as? [String:AnyObject]
                user = AuthenticatedUser(dictionary: decoded!)

            } catch let error as NSError {
                print(error)
            }
        }
        return user
    }
    static func saveUser(user: AuthenticatedUser?) -> Bool {

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

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")

        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }

    convenience init(netHex: Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
}
