import Foundation

/* For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar */

open class Notification {
    open var nOTIFICATION_ID: Int?
    open var uSER_ID: Int?
    open var nOTIFICATION_TITLE: String?
    open var nOTIFICATION_TEXT: String?
    open var nOTIFICATION_TYPE_ID: Int?
    open var nOTIFICATION_TYPE_NAME: String?
    open var nOTIFICATION_URL: String?
    open var cREATE_DATE: String?
    open var pUBLISH_DATE: String?
    open var eXPIRY_DATE: String?
    open var nOTIFICATION_STATUS: Int?
    open var iMPORTANT: Int?

    open var isRead: Bool
    open var isDeleted: Bool
    open var isArchived: Bool
    /**
     Returns an array of models based on given dictionary.

     Sample usage:
     let Notification_list = Notification.modelsFromDictionaryArray(someDictionaryArrayFromJSON)

     - parameter array:  NSArray from JSON dictionary.

     - returns: Array of Notification Instances.
     */
    open class func modelsFromDictionaryArray(_ array: NSArray) -> [Notification] {
        var models: [Notification] = []
        for item in array {
            models.append(Notification(dictionary: item as! NSDictionary)!)
        }
        return models
    }

    /**
     Constructs the object based on the given dictionary.

     Sample usage:
     let Notification = Notification(someDictionaryFromJSON)

     - parameter dictionary:  NSDictionary from JSON.

     - returns: Notification Instance.
     */
    required public init?(dictionary: NSDictionary) {

        nOTIFICATION_ID = dictionary["NOTIFICATION_ID"] as? Int
        uSER_ID = dictionary["USER_ID"] as? Int
        nOTIFICATION_TITLE = dictionary["NOTIFICATION_TITLE"] as? String
        nOTIFICATION_TEXT = dictionary["NOTIFICATION_TEXT"] as? String
        nOTIFICATION_TYPE_ID = dictionary["NOTIFICATION_TYPE_ID"] as? Int
        nOTIFICATION_TYPE_NAME = dictionary["NOTIFICATION_TYPE_NAME"] as? String
        nOTIFICATION_URL = dictionary["NOTIFICATION_URL"] as? String
        cREATE_DATE = dictionary["CREATE_DATE"] as? String
        pUBLISH_DATE = dictionary["PUBLISH_DATE"] as? String
        eXPIRY_DATE = dictionary["EXPIRY_DATE"] as? String
        nOTIFICATION_STATUS = dictionary["NOTIFICATION_STATUS"] as? Int
        iMPORTANT = dictionary["IMPORTANT"] as? Int

        let x = UInt8(nOTIFICATION_STATUS!)
        isRead = (x & 0b00000001 == 1)
        isDeleted = (x>>1 & 0b00000001 == 1)
        isArchived = (x>>2 & 0b00000001 == 1)
    }

    open func calculateStatus() {
        let x = UInt8(nOTIFICATION_STATUS!)
        isRead = (x & 0b00000001 == 1)
        isDeleted = (x>>1 & 0b00000001 == 1)
        isArchived = (x>>2 & 0b00000001 == 1)
    }

    /**
     Returns the dictionary representation for the current instance.

     - returns: NSDictionary.
     */
    open func dictionaryRepresentation() -> NSDictionary {

        let dictionary = NSMutableDictionary()

        dictionary.setValue(self.nOTIFICATION_ID, forKey: "NOTIFICATION_ID")
        dictionary.setValue(self.uSER_ID, forKey: "USER_ID")
        dictionary.setValue(self.nOTIFICATION_TITLE, forKey: "NOTIFICATION_TITLE")
        dictionary.setValue(self.nOTIFICATION_TEXT, forKey: "NOTIFICATION_TEXT")
        dictionary.setValue(self.nOTIFICATION_TYPE_ID, forKey: "NOTIFICATION_TYPE_ID")
        dictionary.setValue(self.nOTIFICATION_TYPE_NAME, forKey: "NOTIFICATION_TYPE_NAME")
        dictionary.setValue(self.nOTIFICATION_URL, forKey: "NOTIFICATION_URL")
        dictionary.setValue(self.cREATE_DATE, forKey: "CREATE_DATE")
        dictionary.setValue(self.pUBLISH_DATE, forKey: "PUBLISH_DATE")
        dictionary.setValue(self.eXPIRY_DATE, forKey: "EXPIRY_DATE")
        dictionary.setValue(self.nOTIFICATION_STATUS, forKey: "NOTIFICATION_STATUS")
        dictionary.setValue(self.iMPORTANT, forKey: "IMPORTANT")

        return dictionary
    }

}
