//
//  Badge.swift
//  UCLanTimetable
//
//  Created by Salah Eddin Alshaal on 21/07/16.
//  Copyright © 2016 Salah Eddin Alshaal. All rights reserved.
//

import Foundation

open class Badge {
    public var bADGE_ID: Int?
    public var bADGE_NAME: String?
    public var bADGE_DESCRIPTION: String?
    public var bADGE_URL: String?
    public var bADGE_CALCULATION: String?
    public var bADGE_TRIGGER: Int?
    public var cAMPAIGN_ID: Int?
    public var cAMPAIGN_NAME: String?
    public var pROGRAMME_NAME: String?
    public var pROGRAMME_CODE: String?
    public var cREATE_DATE: String?
    public var pREDECESSOR_BADGE_ID: String?
    /**
     Returns an array of models based on given dictionary.
     
     Sample usage:
     let json4Swift_Base_list = Json4Swift_Base.modelsFromDictionaryArray(someDictionaryArrayFromJSON)
     
     - parameter array:  NSArray from JSON dictionary.
     
     - returns: Array of Json4Swift_Base Instances.
     */
    public class func modelsFromDictionaryArray(array: NSArray) -> [Badge] {
        var models: [Badge] = []
        for item in array {
            models.append(Badge(dictionary: item as! NSDictionary)!)
        }
        return models
    }

    /**
     Constructs the object based on the given dictionary.
     
     Sample usage:
     let json4Swift_Base = Json4Swift_Base(someDictionaryFromJSON)
     
     - parameter dictionary:  NSDictionary from JSON.
     
     - returns: Json4Swift_Base Instance.
     */
    required public init?(dictionary: NSDictionary) {

        bADGE_ID = dictionary["BADGE_ID"] as? Int
        bADGE_NAME = dictionary["BADGE_NAME"] as? String
        bADGE_DESCRIPTION = dictionary["BADGE_DESCRIPTION"] as? String
        bADGE_URL = dictionary["BADGE_URL"] as? String
        bADGE_CALCULATION = dictionary["BADGE_CALCULATION"] as? String
        bADGE_TRIGGER = dictionary["BADGE_TRIGGER"] as? Int
        cAMPAIGN_ID = dictionary["CAMPAIGN_ID"] as? Int
        cAMPAIGN_NAME = dictionary["CAMPAIGN_NAME"] as? String
        pROGRAMME_NAME = dictionary["PROGRAMME_NAME"] as? String
        pROGRAMME_CODE = dictionary["PROGRAMME_CODE"] as? String
        cREATE_DATE = dictionary["CREATE_DATE"] as? String
        pREDECESSOR_BADGE_ID = dictionary["PREDECESSOR_BADGE_ID"] as? String
    }
    /**
     Returns the dictionary representation for the current instance.
     
     - returns: NSDictionary.
     */
    public func dictionaryRepresentation() -> NSDictionary {

        let dictionary = NSMutableDictionary()

        dictionary.setValue(self.bADGE_ID, forKey: "BADGE_ID")
        dictionary.setValue(self.bADGE_NAME, forKey: "BADGE_NAME")
        dictionary.setValue(self.bADGE_DESCRIPTION, forKey: "BADGE_DESCRIPTION")
        dictionary.setValue(self.bADGE_URL, forKey: "BADGE_URL")
        dictionary.setValue(self.bADGE_CALCULATION, forKey: "BADGE_CALCULATION")
        dictionary.setValue(self.bADGE_TRIGGER, forKey: "BADGE_TRIGGER")
        dictionary.setValue(self.cAMPAIGN_ID, forKey: "CAMPAIGN_ID")
        dictionary.setValue(self.cAMPAIGN_NAME, forKey: "CAMPAIGN_NAME")
        dictionary.setValue(self.pROGRAMME_NAME, forKey: "PROGRAMME_NAME")
        dictionary.setValue(self.pROGRAMME_CODE, forKey: "PROGRAMME_CODE")
        dictionary.setValue(self.cREATE_DATE, forKey: "CREATE_DATE")
        dictionary.setValue(self.pREDECESSOR_BADGE_ID, forKey: "PREDECESSOR_BADGE_ID")

        return dictionary
    }
}
