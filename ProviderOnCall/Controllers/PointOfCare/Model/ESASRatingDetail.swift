/* 
Copyright (c) 2020 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

import Foundation
 
/* For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar */

public class ESASRatingDetail {
	public var id : Int?
	public var patientID : Int?
	public var esasRatingsId : Int?
	public var pain : Int?
	public var tired : Int?
	public var nauseated : Int?
	public var depressed : Int?
	public var anxious : Int?
	public var drowsy : Int?
	public var appetite : Int?
	public var wellbeing : Int?
	public var shortnessOfBreath : Int?
	public var otherProblem : Int?
	public var isDraft : Bool?
	public var isActive : Bool?
	public var isDeleted : Bool?
	public var createdBy : Int?
	public var otherTypeModel : Array<OtherTypeModel>?
	public var value : Int?
	public var createdDate : String?
	public var orderById : Int?
	public var locationId : Int?
	public var unitId : Int?
	public var shiftId : Int?
    public var shiftName : String?

/**
    Returns an array of models based on given dictionary.
    
    Sample usage:
    let json4Swift_Base_list = Json4Swift_Base.modelsFromDictionaryArray(someDictionaryArrayFromJSON)

    - parameter array:  NSArray from JSON dictionary.

    - returns: Array of Json4Swift_Base Instances.
*/
    public class func modelsFromDictionaryArray(array:NSArray) -> [ESASRatingDetail]
    {
        var models:[ESASRatingDetail] = []
        for item in array
        {
            models.append(ESASRatingDetail(dictionary: item as! NSDictionary)!)
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
		esasRatingsId = dictionary["esasRatingsId"] as? Int
		pain = dictionary["pain"] as? Int
		tired = dictionary["tired"] as? Int
		nauseated = dictionary["nauseated"] as? Int
		depressed = dictionary["depressed"] as? Int
		anxious = dictionary["anxious"] as? Int
		drowsy = dictionary["drowsy"] as? Int
		appetite = dictionary["appetite"] as? Int
		wellbeing = dictionary["wellbeing"] as? Int
		shortnessOfBreath = dictionary["shortnessOfBreath"] as? Int
		otherProblem = dictionary["otherProblem"] as? Int
		isDraft = dictionary["isDraft"] as? Bool
		isActive = dictionary["isActive"] as? Bool
		isDeleted = dictionary["isDeleted"] as? Bool
		createdBy = dictionary["createdBy"] as? Int
        if (dictionary["otherTypeModel"] != nil) { otherTypeModel = OtherTypeModel.modelsFromDictionaryArray(array: dictionary["otherTypeModel"] as! NSArray) }
		value = dictionary["value"] as? Int
		createdDate = dictionary["createdDate"] as? String
		orderById = dictionary["orderById"] as? Int
		locationId = dictionary["locationId"] as? Int
		unitId = dictionary["unitId"] as? Int
		shiftId = dictionary["shiftId"] as? Int
        shiftName = dictionary["shiftName"] as? String

	}

		
/**
    Returns the dictionary representation for the current instance.
    
    - returns: NSDictionary.
*/
	public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()

		dictionary.setValue(self.id, forKey: "id")
		dictionary.setValue(self.patientID, forKey: "patientID")
		dictionary.setValue(self.esasRatingsId, forKey: "esasRatingsId")
		dictionary.setValue(self.pain, forKey: "pain")
		dictionary.setValue(self.tired, forKey: "tired")
		dictionary.setValue(self.nauseated, forKey: "nauseated")
		dictionary.setValue(self.depressed, forKey: "depressed")
		dictionary.setValue(self.anxious, forKey: "anxious")
		dictionary.setValue(self.drowsy, forKey: "drowsy")
		dictionary.setValue(self.appetite, forKey: "appetite")
		dictionary.setValue(self.wellbeing, forKey: "wellbeing")
		dictionary.setValue(self.shortnessOfBreath, forKey: "shortnessOfBreath")
		dictionary.setValue(self.otherProblem, forKey: "otherProblem")
		dictionary.setValue(self.isDraft, forKey: "isDraft")
		dictionary.setValue(self.isActive, forKey: "isActive")
		dictionary.setValue(self.isDeleted, forKey: "isDeleted")
		dictionary.setValue(self.createdBy, forKey: "createdBy")
		dictionary.setValue(self.value, forKey: "value")
		dictionary.setValue(self.createdDate, forKey: "createdDate")
		dictionary.setValue(self.orderById, forKey: "orderById")
		dictionary.setValue(self.locationId, forKey: "locationId")
		dictionary.setValue(self.unitId, forKey: "unitId")
		dictionary.setValue(self.shiftId, forKey: "shiftId")
        dictionary.setValue(self.shiftName, forKey: "shiftName")
		return dictionary
	}

}
