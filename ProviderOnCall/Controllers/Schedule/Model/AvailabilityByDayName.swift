/* 
Copyright (c) 2020 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

import Foundation
 
/* For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar */

public class AvailabilityByDayName {
	public var id : Int?
	public var dayId : Int?
	public var dayName : String?
	public var startTime : String?
	public var endTime : String?
	public var staffAvailabilityTypeID : Int?
	public var staffID : Int?
	public var isActive : Bool?
	public var isDeleted : Bool?
    public var isAvailable : Bool?
    public var date : String?

/**
    Returns an array of models based on given dictionary.
    
    Sample usage:
    let availabilityByDayName_list = AvailabilityByDayName.modelsFromDictionaryArray(someDictionaryArrayFromJSON)

    - parameter array:  NSArray from JSON dictionary.

    - returns: Array of AvailabilityByDayName Instances.
*/
    public class func modelsFromDictionaryArray(array:NSArray) -> [AvailabilityByDayName]
    {
        var models:[AvailabilityByDayName] = []
        for item in array
        {
            models.append(AvailabilityByDayName(dictionary: item as! NSDictionary)!)
        }
        return models
    }

/**
    Constructs the object based on the given dictionary.
    
    Sample usage:
    let availabilityByDayName = AvailabilityByDayName(someDictionaryFromJSON)

    - parameter dictionary:  NSDictionary from JSON.

    - returns: AvailabilityByDayName Instance.
*/
	required public init?(dictionary: NSDictionary) {

		id = dictionary["id"] as? Int
		dayId = dictionary["dayId"] as? Int
		dayName = dictionary["dayName"] as? String
		startTime = dictionary["startTime"] as? String
		endTime = dictionary["endTime"] as? String
        date = dictionary["date"] as? String
		staffAvailabilityTypeID = dictionary["staffAvailabilityTypeID"] as? Int
		staffID = dictionary["staffID"] as? Int
		isActive = dictionary["isActive"] as? Bool
		isDeleted = dictionary["isDeleted"] as? Bool
        isAvailable = dictionary["isAvailable"] as? Bool

	}

		
/**
    Returns the dictionary representation for the current instance.
    
    - returns: NSDictionary.
*/
	public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()

		dictionary.setValue(self.id, forKey: "id")
		dictionary.setValue(self.dayId, forKey: "dayId")
		dictionary.setValue(self.dayName, forKey: "dayName")
		dictionary.setValue(self.startTime, forKey: "startTime")
		dictionary.setValue(self.endTime, forKey: "endTime")
		dictionary.setValue(self.staffAvailabilityTypeID, forKey: "staffAvailabilityTypeID")
		dictionary.setValue(self.staffID, forKey: "staffID")
		dictionary.setValue(self.isActive, forKey: "isActive")
		dictionary.setValue(self.isDeleted, forKey: "isDeleted")
        dictionary.setValue(self.isAvailable, forKey: "isAvailable")
        dictionary.setValue(self.date, forKey: "date")

		return dictionary
	}

}
