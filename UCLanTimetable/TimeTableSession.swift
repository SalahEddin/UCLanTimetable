import Foundation

public final class TimeTableSession {
	public var sESSION_DATE_TIME_START : String?
	public var sESSION_DATE_TIME_END : String?
	public var tIMETABLE_ID : Int?
	public var iNSTANCE_ID : Int?
	public var sESSION_ID : Int?
	public var pERIOD_ID : Int?
	public var pERIOD_NAME : String?
	public var mODULE_ID : Int?
	public var mODULE_CODE : String?
	public var mODULE_NAME : String?
	public var sESSION_DATE : String?
	public var sESSION_DATE_FORMATTED : String?
	public var dAY_OF_WEEK : String?
	public var sTART_TIME : START_TIME?
	public var eND_TIME : END_TIME?
	public var sTART_TIME_FORMATTED : String?
	public var eND_TIME_FORMATTED : String?
	public var dURATION : Int?
	public var lECTURER_ID : Int?
	public var lECTURER_NAME : String?
	public var rOOM_ID : Int?
	public var rOOM_CODE : String?
	public var sESSION_TYPE_ID : Int?
	public var sESSION_DESCRIPTION : String?
	public var gROUP_NAME : String?
	public var dESCRIPTION : String?
	public var eVENT_TYPE : Int?
	public var eVENT_TYPE_NAME : String?


    public class func modelsFromDictionaryArray(array:NSArray) -> [TimeTableSession]
    {
        var models:[TimeTableSession] = []
        for item in array
        {
            models.append(TimeTableSession(dictionary: item as! NSDictionary)!)
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

		sESSION_DATE_TIME_START = dictionary["SESSION_DATE_TIME_START"] as? String
		sESSION_DATE_TIME_END = dictionary["SESSION_DATE_TIME_END"] as? String
		tIMETABLE_ID = dictionary["TIMETABLE_ID"] as? Int
		iNSTANCE_ID = dictionary["INSTANCE_ID"] as? Int
		sESSION_ID = dictionary["SESSION_ID"] as? Int
		pERIOD_ID = dictionary["PERIOD_ID"] as? Int
		pERIOD_NAME = dictionary["PERIOD_NAME"] as? String
		mODULE_ID = dictionary["MODULE_ID"] as? Int
		mODULE_CODE = dictionary["MODULE_CODE"] as? String
		mODULE_NAME = dictionary["MODULE_NAME"] as? String
		sESSION_DATE = dictionary["SESSION_DATE"] as? String
		sESSION_DATE_FORMATTED = dictionary["SESSION_DATE_FORMATTED"] as? String
		dAY_OF_WEEK = dictionary["DAY_OF_WEEK"] as? String
		if (dictionary["START_TIME"] != nil) { sTART_TIME = START_TIME(dictionary: dictionary["START_TIME"] as! NSDictionary) }
		if (dictionary["END_TIME"] != nil) { eND_TIME = END_TIME(dictionary: dictionary["END_TIME"] as! NSDictionary) }
		sTART_TIME_FORMATTED = dictionary["START_TIME_FORMATTED"] as? String
		eND_TIME_FORMATTED = dictionary["END_TIME_FORMATTED"] as? String
		dURATION = dictionary["DURATION"] as? Int
		lECTURER_ID = dictionary["LECTURER_ID"] as? Int
		lECTURER_NAME = dictionary["LECTURER_NAME"] as? String
		rOOM_ID = dictionary["ROOM_ID"] as? Int
		rOOM_CODE = dictionary["ROOM_CODE"] as? String
		sESSION_TYPE_ID = dictionary["SESSION_TYPE_ID"] as? Int
		sESSION_DESCRIPTION = dictionary["SESSION_DESCRIPTION"] as? String
		gROUP_NAME = dictionary["GROUP_NAME"] as? String
		dESCRIPTION = dictionary["DESCRIPTION"] as? String
		eVENT_TYPE = dictionary["EVENT_TYPE"] as? Int
		eVENT_TYPE_NAME = dictionary["EVENT_TYPE_NAME"] as? String
	}

		
/**
    Returns the dictionary representation for the current instance.
    
    - returns: NSDictionary.
*/
	public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()

		dictionary.setValue(self.sESSION_DATE_TIME_START, forKey: "SESSION_DATE_TIME_START")
		dictionary.setValue(self.sESSION_DATE_TIME_END, forKey: "SESSION_DATE_TIME_END")
		dictionary.setValue(self.tIMETABLE_ID, forKey: "TIMETABLE_ID")
		dictionary.setValue(self.iNSTANCE_ID, forKey: "INSTANCE_ID")
		dictionary.setValue(self.sESSION_ID, forKey: "SESSION_ID")
		dictionary.setValue(self.pERIOD_ID, forKey: "PERIOD_ID")
		dictionary.setValue(self.pERIOD_NAME, forKey: "PERIOD_NAME")
		dictionary.setValue(self.mODULE_ID, forKey: "MODULE_ID")
		dictionary.setValue(self.mODULE_CODE, forKey: "MODULE_CODE")
		dictionary.setValue(self.mODULE_NAME, forKey: "MODULE_NAME")
		dictionary.setValue(self.sESSION_DATE, forKey: "SESSION_DATE")
		dictionary.setValue(self.sESSION_DATE_FORMATTED, forKey: "SESSION_DATE_FORMATTED")
		dictionary.setValue(self.dAY_OF_WEEK, forKey: "DAY_OF_WEEK")
		dictionary.setValue(self.sTART_TIME?.dictionaryRepresentation(), forKey: "START_TIME")
		dictionary.setValue(self.eND_TIME?.dictionaryRepresentation(), forKey: "END_TIME")
		dictionary.setValue(self.sTART_TIME_FORMATTED, forKey: "START_TIME_FORMATTED")
		dictionary.setValue(self.eND_TIME_FORMATTED, forKey: "END_TIME_FORMATTED")
		dictionary.setValue(self.dURATION, forKey: "DURATION")
		dictionary.setValue(self.lECTURER_ID, forKey: "LECTURER_ID")
		dictionary.setValue(self.lECTURER_NAME, forKey: "LECTURER_NAME")
		dictionary.setValue(self.rOOM_ID, forKey: "ROOM_ID")
		dictionary.setValue(self.rOOM_CODE, forKey: "ROOM_CODE")
		dictionary.setValue(self.sESSION_TYPE_ID, forKey: "SESSION_TYPE_ID")
		dictionary.setValue(self.sESSION_DESCRIPTION, forKey: "SESSION_DESCRIPTION")
		dictionary.setValue(self.gROUP_NAME, forKey: "GROUP_NAME")
		dictionary.setValue(self.dESCRIPTION, forKey: "DESCRIPTION")
		dictionary.setValue(self.eVENT_TYPE, forKey: "EVENT_TYPE")
		dictionary.setValue(self.eVENT_TYPE_NAME, forKey: "EVENT_TYPE_NAME")

		return dictionary
	}

}