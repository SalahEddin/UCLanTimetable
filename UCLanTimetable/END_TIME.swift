import Foundation

/* For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar */

open class END_TIME: NSObject {
	open var ticks: Int?
	open var days: Int?
	open var hours: Int?
	open var milliseconds: Int?
	open var minutes: Int?
	open var seconds: Int?
	open var totalDays: Double?
	open var totalHours: Int?
	open var totalMilliseconds: Int?
	open var totalMinutes: Int?
	open var totalSeconds: Int?

/**
    Returns an array of models based on given dictionary.

    Sample usage:
    let eND_TIME_list = END_TIME.modelsFromDictionaryArray(someDictionaryArrayFromJSON)

    - parameter array:  NSArray from JSON dictionary.

    - returns: Array of END_TIME Instances.
*/
    open class func modelsFromDictionaryArray(_ array: NSArray) -> [END_TIME] {
        var models: [END_TIME] = []
        for item in array {
            models.append(END_TIME(dictionary: item as! NSDictionary)!)
        }
        return models
    }

/**
    Constructs the object based on the given dictionary.

    Sample usage:
    let eND_TIME = END_TIME(someDictionaryFromJSON)

    - parameter dictionary:  NSDictionary from JSON.

    - returns: END_TIME Instance.
*/
	required public init?(dictionary: NSDictionary) {

		ticks = dictionary["Ticks"] as? Int
		days = dictionary["Days"] as? Int
		hours = dictionary["Hours"] as? Int
		milliseconds = dictionary["Milliseconds"] as? Int
		minutes = dictionary["Minutes"] as? Int
		seconds = dictionary["Seconds"] as? Int
		totalDays = dictionary["TotalDays"] as? Double
		totalHours = dictionary["TotalHours"] as? Int
		totalMilliseconds = dictionary["TotalMilliseconds"] as? Int
		totalMinutes = dictionary["TotalMinutes"] as? Int
		totalSeconds = dictionary["TotalSeconds"] as? Int
	}


/**
    Returns the dictionary representation for the current instance.

    - returns: NSDictionary.
*/
	open func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()

		dictionary.setValue(self.ticks, forKey: "Ticks")
		dictionary.setValue(self.days, forKey: "Days")
		dictionary.setValue(self.hours, forKey: "Hours")
		dictionary.setValue(self.milliseconds, forKey: "Milliseconds")
		dictionary.setValue(self.minutes, forKey: "Minutes")
		dictionary.setValue(self.seconds, forKey: "Seconds")
		dictionary.setValue(self.totalDays, forKey: "TotalDays")
		dictionary.setValue(self.totalHours, forKey: "TotalHours")
		dictionary.setValue(self.totalMilliseconds, forKey: "TotalMilliseconds")
		dictionary.setValue(self.totalMinutes, forKey: "TotalMinutes")
		dictionary.setValue(self.totalSeconds, forKey: "TotalSeconds")

		return dictionary
	}

}
