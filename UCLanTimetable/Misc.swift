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



open class KEYS {
    open static let user = "user"
    open static let username = "username"
    open static let pass = "pass"
    open static let offlineTimetableStorageKey = "timetable"
    open static let offlineExamStorageKey = "exams"
    open static let studentTypeId = 5
}

open class Misc {

    public enum USER_TYPE {
        case exam
        case student
        case lecturer
        case room}

    // MARK: IO
    static func loadUser() -> AuthenticatedUser? {
        var user: AuthenticatedUser? = nil
        let storedUserString = Keychain.load(KEYS.user)
        if  storedUserString != nil {
            do {
                let data = storedUserString!.data(using: String.Encoding.utf8)
                // here "decoded" is the dictionary decoded from JSON data
                let decoded = try JSONSerialization.jsonObject(with: data!, options: []) as? [String:AnyObject]
                user = AuthenticatedUser(dictionary: decoded! as NSDictionary)

            } catch let error as NSError {
                print(error)
            }
        }
        return user
    }
    static func saveUser(_ user: AuthenticatedUser?) -> Bool {

        var success = false
        // serialise user as JSON, then save to keychain
        let dic = user!.dictionaryRepresentation()
        var userDatastring: String? = nil

        do {
            // here "jsonData" is the dictionary encoded in JSON data
            let jsonData = try JSONSerialization.data(withJSONObject: dic, options: JSONSerialization.WritingOptions.prettyPrinted)
            userDatastring = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
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

open class Reachability {
    class func isConnectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
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

extension UIImageView {
    func downloadedFrom(url: URL, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { () -> Void in
                self.image = image
            }
            }.resume()
    }
    func downloadedFrom(link: String, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloadedFrom(url: url, contentMode: mode)
    }
}
