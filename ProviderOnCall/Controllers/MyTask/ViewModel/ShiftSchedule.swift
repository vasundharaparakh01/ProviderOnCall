/* 
Copyright (c) 2020 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

import Foundation
 
/* For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar */

public class ShiftSchedule {
	public var shiftMasterId : Int?
	public var shiftName : String?
	public var locationId : Int?
	public var weekKey : Int?
	public var days : Array<Days>?
	public var staffID : Int?

/**
    Returns an array of models based on given dictionary.
    
    Sample usage:
    let json4Swift_Base_list = Json4Swift_Base.modelsFromDictionaryArray(someDictionaryArrayFromJSON)

    - parameter array:  NSArray from JSON dictionary.

    - returns: Array of Json4Swift_Base Instances.
*/
    public class func modelsFromDictionaryArray(array:NSArray) -> [ShiftSchedule]
    {
        var models:[ShiftSchedule] = []
        for item in array
        {
            models.append(ShiftSchedule(dictionary: item as! NSDictionary)!)
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

		shiftMasterId = dictionary["shiftMasterId"] as? Int
		shiftName = dictionary["shiftName"] as? String
		locationId = dictionary["locationId"] as? Int
		weekKey = dictionary["weekKey"] as? Int
        if (dictionary["days"] != nil) { days = Days.modelsFromDictionaryArray(array: dictionary["days"] as! NSArray) }
		staffID = dictionary["staffID"] as? Int
	}

		
/**
    Returns the dictionary representation for the current instance.
    
    - returns: NSDictionary.
*/
	public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()

		dictionary.setValue(self.shiftMasterId, forKey: "shiftMasterId")
		dictionary.setValue(self.shiftName, forKey: "shiftName")
		dictionary.setValue(self.locationId, forKey: "locationId")
		dictionary.setValue(self.weekKey, forKey: "weekKey")
		dictionary.setValue(self.staffID, forKey: "staffID")

		return dictionary
	}

}
