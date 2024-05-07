/* 
Copyright (c) 2020 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

import Foundation
 
/* For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar */

public class ActivityDetail {
	public var id : Int?
	public var patientID : Int?
	public var usualAsPerSelfId : Int?
	public var participitedInActivityId : Int?
	public var weightBearingId : Int?
	public var abnormilityDetectedId : Int?
	public var wellToleratedId : Int?
	public var transferSelfPerformanceId : Int?
	public var transferSupportProvidedId : Int?
	public var repositioningId : Int?
	public var rangeOfMotionId : Int?
	public var isDraft : Bool?
	public var notes : String?
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
    public class func modelsFromDictionaryArray(array:NSArray) -> [ActivityDetail]
    {
        var models:[ActivityDetail] = []
        for item in array
        {
            models.append(ActivityDetail(dictionary: item as! NSDictionary)!)
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
		usualAsPerSelfId = dictionary["usualAsPerSelfId"] as? Int
		participitedInActivityId = dictionary["participitedInActivityId"] as? Int
		weightBearingId = dictionary["weightBearingId"] as? Int
		abnormilityDetectedId = dictionary["abnormilityDetectedId"] as? Int
		wellToleratedId = dictionary["wellToleratedId"] as? Int
		transferSelfPerformanceId = dictionary["transferSelfPerformanceId"] as? Int
		transferSupportProvidedId = dictionary["transferSupportProvidedId"] as? Int
		repositioningId = dictionary["repositioningId"] as? Int
		rangeOfMotionId = dictionary["rangeOfMotionId"] as? Int
		isDraft = dictionary["isDraft"] as? Bool
		notes = dictionary["notes"] as? String
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
		dictionary.setValue(self.usualAsPerSelfId, forKey: "usualAsPerSelfId")
		dictionary.setValue(self.participitedInActivityId, forKey: "participitedInActivityId")
		dictionary.setValue(self.weightBearingId, forKey: "weightBearingId")
		dictionary.setValue(self.abnormilityDetectedId, forKey: "abnormilityDetectedId")
		dictionary.setValue(self.wellToleratedId, forKey: "wellToleratedId")
		dictionary.setValue(self.transferSelfPerformanceId, forKey: "transferSelfPerformanceId")
		dictionary.setValue(self.transferSupportProvidedId, forKey: "transferSupportProvidedId")
		dictionary.setValue(self.repositioningId, forKey: "repositioningId")
		dictionary.setValue(self.rangeOfMotionId, forKey: "rangeOfMotionId")
		dictionary.setValue(self.isDraft, forKey: "isDraft")
		dictionary.setValue(self.notes, forKey: "notes")
		dictionary.setValue(self.isActive, forKey: "isActive")
		dictionary.setValue(self.isDeleted, forKey: "isDeleted")
		dictionary.setValue(self.createdBy, forKey: "createdBy")
		dictionary.setValue(self.createdDate, forKey: "createdDate")

		return dictionary
	}

}
