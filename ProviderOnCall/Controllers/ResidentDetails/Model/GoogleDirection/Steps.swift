/* 
Copyright (c) 2020 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

import Foundation
 
/* For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar */

public class Steps {
	public var html_instructions : String?
	public var start_location : Start_location?
	public var distance : Distance?
	public var travel_mode : String?
	public var duration : Duration?
	public var polyline : Polyline?
	public var end_location : End_location?
    public var maneuver : String?


/**
    Returns an array of models based on given dictionary.
    
    Sample usage:
    let steps_list = Steps.modelsFromDictionaryArray(someDictionaryArrayFromJSON)

    - parameter array:  NSArray from JSON dictionary.

    - returns: Array of Steps Instances.
*/
    public class func modelsFromDictionaryArray(array:NSArray) -> [Steps]
    {
        var models:[Steps] = []
        for item in array
        {
            models.append(Steps(dictionary: item as! NSDictionary)!)
        }
        return models
    }

/**
    Constructs the object based on the given dictionary.
    
    Sample usage:
    let steps = Steps(someDictionaryFromJSON)

    - parameter dictionary:  NSDictionary from JSON.

    - returns: Steps Instance.
*/
	required public init?(dictionary: NSDictionary) {
        maneuver = dictionary["maneuver"] as? String
		html_instructions = dictionary["html_instructions"] as? String
		if (dictionary["start_location"] != nil) { start_location = Start_location(dictionary: dictionary["start_location"] as! NSDictionary) }
		if (dictionary["distance"] != nil) { distance = Distance(dictionary: dictionary["distance"] as! NSDictionary) }
		travel_mode = dictionary["travel_mode"] as? String
		if (dictionary["duration"] != nil) { duration = Duration(dictionary: dictionary["duration"] as! NSDictionary) }
		if (dictionary["polyline"] != nil) { polyline = Polyline(dictionary: dictionary["polyline"] as! NSDictionary) }
		if (dictionary["end_location"] != nil) { end_location = End_location(dictionary: dictionary["end_location"] as! NSDictionary) }
	}

		
/**
    Returns the dictionary representation for the current instance.
    
    - returns: NSDictionary.
*/
	public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()

		dictionary.setValue(self.html_instructions, forKey: "html_instructions")
		dictionary.setValue(self.start_location?.dictionaryRepresentation(), forKey: "start_location")
		dictionary.setValue(self.distance?.dictionaryRepresentation(), forKey: "distance")
		dictionary.setValue(self.travel_mode, forKey: "travel_mode")
		dictionary.setValue(self.duration?.dictionaryRepresentation(), forKey: "duration")
		dictionary.setValue(self.polyline?.dictionaryRepresentation(), forKey: "polyline")
		dictionary.setValue(self.end_location?.dictionaryRepresentation(), forKey: "end_location")
        dictionary.setValue(self.maneuver, forKey: "maneuver")

		return dictionary
	}

}
