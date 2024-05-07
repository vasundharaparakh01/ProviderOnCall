/* 
Copyright (c) 2020 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

import Foundation
 
/* For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar */

public class PersonalHygiene {
	public var id : Int?
	public var patientID : Int?
	public var mouthCareId : Int?
	public var waterTemprature : Int?
	public var bathId : Int?
    public var bathTypeId : Int?
	public var skinProtocolId : Int?
	public var temperatureUnit : Int?
	public var isDraft : Bool?
	public var notes : String?
	public var nailCareId : Int?
	public var isActive : Bool?
	public var isDeleted : Bool?
	public var createdBy : Int?
	public var createdDate : String?

/**
    Returns an array of models based on given dictionary.
    
    Sample usage:
    let json4Swift_Base_list = Json4Swift_Base.modelsFromDictionaryArray(someDictionaryArrayFromJSON)

    - parameter array:  NSArray from JSON dictionary.

    - returns: Array of Json4Swift_Base Instances.
*/
    public class func modelsFromDictionaryArray(array:NSArray) -> [PersonalHygiene]
    {
        var models:[PersonalHygiene] = []
        for item in array
        {
            models.append(PersonalHygiene(dictionary: item as! NSDictionary)!)
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

		id = dictionary["id"] as? Int
		patientID = dictionary["patientID"] as? Int
		mouthCareId = dictionary["mouthCareId"] as? Int
		waterTemprature = dictionary["waterTemprature"] as? Int
		bathId = dictionary["bathId"] as? Int
        bathTypeId = dictionary["bathTypeId"] as? Int
		skinProtocolId = dictionary["skinProtocolId"] as? Int
		temperatureUnit = dictionary["temperatureUnit"] as? Int
		isDraft = dictionary["isDraft"] as? Bool
		notes = dictionary["notes"] as? String
		nailCareId = dictionary["nailCareId"] as? Int
		isActive = dictionary["isActive"] as? Bool
		isDeleted = dictionary["isDeleted"] as? Bool
		createdBy = dictionary["createdBy"] as? Int
		createdDate = dictionary["createdDate"] as? String
	}

		
/**
    Returns the dictionary representation for the current instance.
    
    - returns: NSDictionary.
*/
	public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()

		dictionary.setValue(self.id, forKey: "id")
		dictionary.setValue(self.patientID, forKey: "patientID")
		dictionary.setValue(self.mouthCareId, forKey: "mouthCareId")
		dictionary.setValue(self.waterTemprature, forKey: "waterTemprature")
		dictionary.setValue(self.bathId, forKey: "bathId")
        dictionary.setValue(self.bathTypeId, forKey: "bathTypeId")
		dictionary.setValue(self.skinProtocolId, forKey: "skinProtocolId")
		dictionary.setValue(self.temperatureUnit, forKey: "temperatureUnit")
		dictionary.setValue(self.isDraft, forKey: "isDraft")
		dictionary.setValue(self.notes, forKey: "notes")
		dictionary.setValue(self.nailCareId, forKey: "nailCareId")
		dictionary.setValue(self.isActive, forKey: "isActive")
		dictionary.setValue(self.isDeleted, forKey: "isDeleted")
		dictionary.setValue(self.createdBy, forKey: "createdBy")
		dictionary.setValue(self.createdDate, forKey: "createdDate")

		return dictionary
	}

}
