//
//  AuthenticatedUser.swift
//  UCLanTimetable
//
//  Created by Salah Eddin Alshaal on 27/07/16.
//  Copyright © 2016 Salah Eddin Alshaal. All rights reserved.
//

import Foundation

open class AuthenticatedUser {
    open var uSER_ID: Int?
    open var eMAIL: String?
    open var fULLNAME: String?
    open var iS_ACTIVATED: String?
    open var aCCOUNT_TYPE_ID: Int?
    open var aCCOUNT_ID: Int?

    /**
     Returns an array of models based on given dictionary.

     Sample usage:
     let User_list = User_Base.modelsFromDictionaryArray(someDictionaryArrayFromJSON)

     - parameter array:  NSArray from JSON dictionary.

     - returns: Array of AuthenticatedUser_Base Instances.
     */
    open class func modelsFromDictionaryArray(_ array: NSArray) -> [AuthenticatedUser] {
        var models: [AuthenticatedUser] = []
        for item in array {
            models.append(AuthenticatedUser(dictionary: item as! NSDictionary)!)
        }
        return models
    }


    required public init?(dictionary: NSDictionary) {

        uSER_ID = dictionary["USER_ID"] as? Int
        eMAIL = dictionary["EMAIL"] as? String
        fULLNAME = dictionary["FULLNAME"] as? String
        iS_ACTIVATED = dictionary["IS_ACTIVATED"] as? String
        aCCOUNT_TYPE_ID = dictionary["ACCOUNT_TYPE_ID"] as? Int
        aCCOUNT_ID = dictionary["ACCOUNT_ID"] as? Int
    }


    /**
     Returns the dictionary representation for the current instance.

     - returns: NSDictionary.
     */
    open func dictionaryRepresentation() -> NSDictionary {

        let dictionary = NSMutableDictionary()

        dictionary.setValue(self.uSER_ID, forKey: "USER_ID")
        dictionary.setValue(self.eMAIL, forKey: "EMAIL")
        dictionary.setValue(self.fULLNAME, forKey: "FULLNAME")
        dictionary.setValue(self.iS_ACTIVATED, forKey: "IS_ACTIVATED")
        dictionary.setValue(self.aCCOUNT_TYPE_ID, forKey: "ACCOUNT_TYPE_ID")
        dictionary.setValue(self.aCCOUNT_ID, forKey: "ACCOUNT_ID")

        return dictionary
    }
}
