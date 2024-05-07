/* 
Copyright (c) 2020 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

import Foundation
 
/* For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar */

public class Days {
	public var id : Int?
	public var dayId : Int?
	public var startTime : String?
	public var endTime : String?
	public var shiftMasterId : Int?
	public var dayName : String?
	public var weekKey : Int?

/**
    Returns an array of models based on given dictionary.
    
    Sample usage:
    let days_list = Days.modelsFromDictionaryArray(someDictionaryArrayFromJSON)

    - parameter array:  NSArray from JSON dictionary.

    - returns: Array of Days Instances.
*/
    public class func modelsFromDictionaryArray(array:NSArray) -> [Days]
    {
        var models:[Days] = []
        for item in array
        {
            models.append(Days(dictionary: item as! NSDictionary)!)
        }
        return models
    }

/**
    Constructs the object based on the given dictionary.
    
    Sample usage:
    let days = Days(someDictionaryFromJSON)

    - parameter dictionary:  NSDictionary from JSON.

    - returns: Days Instance.
*/
	required public init?(dictionary: NSDictionary) {

		id = dictionary["id"] as? Int
		dayId = dictionary["dayId"] as? Int
		startTime = dictionary["startTime"] as? String
		endTime = dictionary["endTime"] as? String
		shiftMasterId = dictionary["shiftMasterId"] as? Int
		dayName = dictionary["dayName"] as? String
		weekKey = dictionary["weekKey"] as? Int
	}

		
/**
    Returns the dictionary representation for the current instance.
    
    - returns: NSDictionary.
*/
	public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()

		dictionary.setValue(self.id, forKey: "id")
		dictionary.setValue(self.dayId, forKey: "dayId")
		dictionary.setValue(self.startTime, forKey: "startTime")
		dictionary.setValue(self.endTime, forKey: "endTime")
		dictionary.setValue(self.shiftMasterId, forKey: "shiftMasterId")
		dictionary.setValue(self.dayName, forKey: "dayName")
		dictionary.setValue(self.weekKey, forKey: "weekKey")

		return dictionary
	}

}