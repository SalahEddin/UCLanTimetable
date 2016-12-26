//
//  Attendance.swift
//  UCLanTimetable
//
//  Created by Salah Eddin Alshaal on 26/12/2016.
//  Copyright © 2016 Salah Eddin Alshaal. All rights reserved.
//

import Foundation

open class Attendance {
    public var mODULE_ID: Int?
    public var mODULE_CODE: String?
    public var mODULE_NAME: String?
    public var mODULE_INFO: String?
    public var sESSION_DATE: String?
    public var sTUDENT_ID: Int?
    public var sTUDENT_NAME: String?
    public var sTUDENT_INFO: String?
    public var uSERNAME: String?
    public var gNUMBER: String?
    public var iNTERNAL_STATUS: Int?
    public var aTTENDANCE_STATUS: String?
    public var sESSION_TYPE_NAME: String?
    public var gROUP_NAME: String?
    public var aTTENDANCE_PERCENTAGE: Int?
    public var aTTENDANCE_AVERAGE: Double?
    public var pARTICIPATION: Int?
    public var aTTENDANCES: Int?
    public var aBSENSES: Int?

    /**
     Returns an array of models based on given dictionary.
     
     Sample usage:
     let json4Swift_Base_list = Json4Swift_Base.modelsFromDictionaryArray(someDictionaryArrayFromJSON)
     
     - parameter array:  NSArray from JSON dictionary.
     
     - returns: Array of Json4Swift_Base Instances.
     */
    public class func modelsFromDictionaryArray(array: NSArray) -> [Attendance] {
        var models: [Attendance] = []
        for item in array {
            models.append(Attendance(dictionary: item as! NSDictionary)!)
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
        mODULE_ID = dictionary["MODULE_ID"] as? Int
        mODULE_CODE = dictionary["MODULE_CODE"] as? String
        mODULE_NAME = dictionary["MODULE_NAME"] as? String
        mODULE_INFO = dictionary["MODULE_INFO"] as? String
        sESSION_DATE = dictionary["SESSION_DATE"] as? String
        sTUDENT_ID = dictionary["STUDENT_ID"] as? Int
        sTUDENT_NAME = dictionary["STUDENT_NAME"] as? String
        sTUDENT_INFO = dictionary["STUDENT_INFO"] as? String
        uSERNAME = dictionary["USERNAME"] as? String
        gNUMBER = dictionary["GNUMBER"] as? String
        iNTERNAL_STATUS = dictionary["INTERNAL_STATUS"] as? Int
        aTTENDANCE_STATUS = dictionary["ATTENDANCE_STATUS"] as? String
        sESSION_TYPE_NAME = dictionary["SESSION_TYPE_NAME"] as? String
        gROUP_NAME = dictionary["GROUP_NAME"] as? String
        aTTENDANCE_PERCENTAGE = dictionary["ATTENDANCE_PERCENTAGE"] as? Int
        aTTENDANCE_AVERAGE = dictionary["ATTENDANCE_AVERAGE"] as? Double
        pARTICIPATION = dictionary["PARTICIPATION"] as? Int
        aTTENDANCES = dictionary["ATTENDANCES"] as? Int
        aBSENSES = dictionary["ABSENSES"] as? Int
    }
    /**
     Returns the dictionary representation for the current instance.
     
     - returns: NSDictionary.
     */
    public func dictionaryRepresentation() -> NSDictionary {
        let dictionary = NSMutableDictionary()
        dictionary.setValue(self.mODULE_ID, forKey: "MODULE_ID")
        dictionary.setValue(self.mODULE_CODE, forKey: "MODULE_CODE")
        dictionary.setValue(self.mODULE_NAME, forKey: "MODULE_NAME")
        dictionary.setValue(self.mODULE_INFO, forKey: "MODULE_INFO")
        dictionary.setValue(self.sESSION_DATE, forKey: "SESSION_DATE")
        dictionary.setValue(self.sTUDENT_ID, forKey: "STUDENT_ID")
        dictionary.setValue(self.sTUDENT_NAME, forKey: "STUDENT_NAME")
        dictionary.setValue(self.sTUDENT_INFO, forKey: "STUDENT_INFO")
        dictionary.setValue(self.uSERNAME, forKey: "USERNAME")
        dictionary.setValue(self.gNUMBER, forKey: "GNUMBER")
        dictionary.setValue(self.iNTERNAL_STATUS, forKey: "INTERNAL_STATUS")
        dictionary.setValue(self.aTTENDANCE_STATUS, forKey: "ATTENDANCE_STATUS")
        dictionary.setValue(self.sESSION_TYPE_NAME, forKey: "SESSION_TYPE_NAME")
        dictionary.setValue(self.gROUP_NAME, forKey: "GROUP_NAME")
        dictionary.setValue(self.aTTENDANCE_PERCENTAGE, forKey: "ATTENDANCE_PERCENTAGE")
        dictionary.setValue(self.aTTENDANCE_AVERAGE, forKey: "ATTENDANCE_AVERAGE")
        dictionary.setValue(self.pARTICIPATION, forKey: "PARTICIPATION")
        dictionary.setValue(self.aTTENDANCES, forKey: "ATTENDANCES")
        dictionary.setValue(self.aBSENSES, forKey: "ABSENSES")
        return dictionary
    }
}
