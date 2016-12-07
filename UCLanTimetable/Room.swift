//
//  Room.swift
//  UCLanTimetable
//
//  Created by Salah Eddin Alshaal on 26/07/16.
//  Copyright © 2016 Salah Eddin Alshaal. All rights reserved.
//

import Foundation

open class Room {
    open var rOOM_ID: Int?
    open var rOOM_CODE: String?
    open var bARCODE: String?
    open var cAPACITY: Int?
    open var rOOM_TYPE_ID: Int?
    open var rOOM_TYPE_NAME: String?
    open var bOOKABLE: Int?
    open var bOOKABLE_DESCRIPTION: String?

    /**
     Returns an array of models based on given dictionary.

     Sample usage:
     let json4Swift_Base_list = Json4Swift_Base.modelsFromDictionaryArray(someDictionaryArrayFromJSON)

     - parameter array:  NSArray from JSON dictionary.

     - returns: Array of Json4Swift_Base Instances.
     */
    open class func modelsFromDictionaryArray(_ array: NSArray) -> [Room] {
        var models: [Room] = []
        for item in array {
            models.append(Room(dictionary: item as! NSDictionary)!)
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

        rOOM_ID = dictionary["ROOM_ID"] as? Int
        rOOM_CODE = dictionary["ROOM_CODE"] as? String
        bARCODE = dictionary["BARCODE"] as? String
        cAPACITY = dictionary["CAPACITY"] as? Int
        rOOM_TYPE_ID = dictionary["ROOM_TYPE_ID"] as? Int
        rOOM_TYPE_NAME = dictionary["ROOM_TYPE_NAME"] as? String
        bOOKABLE = dictionary["BOOKABLE"] as? Int
        bOOKABLE_DESCRIPTION = dictionary["BOOKABLE_DESCRIPTION"] as? String
    }


    /**
     Returns the dictionary representation for the current instance.

     - returns: NSDictionary.
     */
    open func dictionaryRepresentation() -> NSDictionary {

        let dictionary = NSMutableDictionary()

        dictionary.setValue(self.rOOM_ID, forKey: "ROOM_ID")
        dictionary.setValue(self.rOOM_CODE, forKey: "ROOM_CODE")
        dictionary.setValue(self.bARCODE, forKey: "BARCODE")
        dictionary.setValue(self.cAPACITY, forKey: "CAPACITY")
        dictionary.setValue(self.rOOM_TYPE_ID, forKey: "ROOM_TYPE_ID")
        dictionary.setValue(self.rOOM_TYPE_NAME, forKey: "ROOM_TYPE_NAME")
        dictionary.setValue(self.bOOKABLE, forKey: "BOOKABLE")
        dictionary.setValue(self.bOOKABLE_DESCRIPTION, forKey: "BOOKABLE_DESCRIPTION")

        return dictionary
    }

}
