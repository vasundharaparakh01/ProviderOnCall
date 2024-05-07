/* 
Copyright (c) 2020 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

import Foundation
 
/* For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar */

public class Routes {
	public var bounds : Bounds?
	public var summary : String?
	public var waypoint_order : Array<String>?
	public var legs : Array<Legs>?
	public var warnings : Array<String>?
	public var copyrights : String?
	public var overview_polyline : Overview_polyline?

/**
    Returns an array of models based on given dictionary.
    
    Sample usage:
    let routes_list = Routes.modelsFromDictionaryArray(someDictionaryArrayFromJSON)

    - parameter array:  NSArray from JSON dictionary.

    - returns: Array of Routes Instances.
*/
    public class func modelsFromDictionaryArray(array:NSArray) -> [Routes]
    {
        var models:[Routes] = []
        for item in array
        {
            models.append(Routes(dictionary: item as! NSDictionary)!)
        }
        return models
    }

/**
    Constructs the object based on the given dictionary.
    
    Sample usage:
    let routes = Routes(someDictionaryFromJSON)

    - parameter dictionary:  NSDictionary from JSON.

    - returns: Routes Instance.
*/
	required public init?(dictionary: NSDictionary) {

		if (dictionary["bounds"] != nil) { bounds = Bounds(dictionary: dictionary["bounds"] as! NSDictionary) }
		summary = dictionary["summary"] as? String
		//if (dictionary["waypoint_order"] != nil) { waypoint_order = Waypoint_order.modelsFromDictionaryArray(dictionary["waypoint_order"] as! NSArray) }
        if (dictionary["legs"] != nil) { legs = Legs.modelsFromDictionaryArray(array: dictionary["legs"] as! NSArray) }
		//if (dictionary["warnings"] != nil) { warnings = Warnings.modelsFromDictionaryArray(dictionary["warnings"] as! NSArray) }
		copyrights = dictionary["copyrights"] as? String
		if (dictionary["overview_polyline"] != nil) { overview_polyline = Overview_polyline(dictionary: dictionary["overview_polyline"] as! NSDictionary) }
	}

		
/**
    Returns the dictionary representation for the current instance.
    
    - returns: NSDictionary.
*/
	public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()

		dictionary.setValue(self.bounds?.dictionaryRepresentation(), forKey: "bounds")
		dictionary.setValue(self.summary, forKey: "summary")
		dictionary.setValue(self.copyrights, forKey: "copyrights")
		dictionary.setValue(self.overview_polyline?.dictionaryRepresentation(), forKey: "overview_polyline")

		return dictionary
	}

}
