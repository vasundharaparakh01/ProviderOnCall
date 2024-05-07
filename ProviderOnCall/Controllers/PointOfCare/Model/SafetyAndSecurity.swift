/* 
Copyright (c) 2020 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

import Foundation
 
/* For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar */

public class SafetyAndSecurity {
	public var id : Int?
	public var patientID : Int?
	public var transfer : Int?
	public var oneOnOneCompanionshipId : Int?
	public var callBellWithInReachId : Int?
	public var cluttersRemovedId : Int?
	public var safetyRoundsId : Int?
	public var sideRailsUpId : Int?
	public var pressureUlcer : Int?
	public var fallId : Int?
	public var isDraft : Bool?
	public var notes : String?
	public var careDoneAccordingToCarePlanId : Int?
	public var fallTime : String?
	public var fallPatternId : Int?
	public var behaviourId : Int?
	public var behaviourTime : String?
	public var isActive : Bool?
	public var isDeleted : Bool?
	public var createdBy : Int?
	public var createdDate : String?

/**
    Returns an array of models based on given dictionary.
    
    Sample usage:
    let safetyAndSecurity_list = SafetyAndSecurity.modelsFromDictionaryArray(someDictionaryArrayFromJSON)

    - parameter array:  NSArray from JSON dictionary.

    - returns: Array of SafetyAndSecurity Instances.
*/
    public class func modelsFromDictionaryArray(array:NSArray) -> [SafetyAndSecurity]
    {
        var models:[SafetyAndSecurity] = []
        for item in array
        {
            models.append(SafetyAndSecurity(dictionary: item as! NSDictionary)!)
        }
        return models
    }

/**
    Constructs the object based on the given dictionary.
    
    Sample usage:
    let safetyAndSecurity = SafetyAndSecurity(someDictionaryFromJSON)

    - parameter dictionary:  NSDictionary from JSON.

    - returns: SafetyAndSecurity Instance.
*/
	required public init?(dictionary: NSDictionary) {

		id = dictionary["id"] as? Int
		patientID = dictionary["patientID"] as? Int
		transfer = dictionary["transfer"] as? Int
		oneOnOneCompanionshipId = dictionary["oneOnOneCompanionshipId"] as? Int
		callBellWithInReachId = dictionary["callBellWithInReachId"] as? Int
		cluttersRemovedId = dictionary["cluttersRemovedId"] as? Int
		safetyRoundsId = dictionary["safetyRoundsId"] as? Int
		sideRailsUpId = dictionary["sideRailsUpId"] as? Int
		pressureUlcer = dictionary["pressureUlcer"] as? Int
		fallId = dictionary["fallId"] as? Int
		isDraft = dictionary["isDraft"] as? Bool
		notes = dictionary["notes"] as? String
		careDoneAccordingToCarePlanId = dictionary["careDoneAccordingToCarePlanId"] as? Int
		fallTime = dictionary["fallTime"] as? String
		fallPatternId = dictionary["fallPatternId"] as? Int
		behaviourId = dictionary["behaviourId"] as? Int
		behaviourTime = dictionary["behaviourTime"] as? String
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
		dictionary.setValue(self.transfer, forKey: "transfer")
		dictionary.setValue(self.oneOnOneCompanionshipId, forKey: "oneOnOneCompanionshipId")
		dictionary.setValue(self.callBellWithInReachId, forKey: "callBellWithInReachId")
		dictionary.setValue(self.cluttersRemovedId, forKey: "cluttersRemovedId")
		dictionary.setValue(self.safetyRoundsId, forKey: "safetyRoundsId")
		dictionary.setValue(self.sideRailsUpId, forKey: "sideRailsUpId")
		dictionary.setValue(self.pressureUlcer, forKey: "pressureUlcer")
		dictionary.setValue(self.fallId, forKey: "fallId")
		dictionary.setValue(self.isDraft, forKey: "isDraft")
		dictionary.setValue(self.notes, forKey: "notes")
		dictionary.setValue(self.careDoneAccordingToCarePlanId, forKey: "careDoneAccordingToCarePlanId")
		dictionary.setValue(self.fallTime, forKey: "fallTime")
		dictionary.setValue(self.fallPatternId, forKey: "fallPatternId")
		dictionary.setValue(self.behaviourId, forKey: "behaviourId")
		dictionary.setValue(self.behaviourTime, forKey: "behaviourTime")
		dictionary.setValue(self.isActive, forKey: "isActive")
		dictionary.setValue(self.isDeleted, forKey: "isDeleted")
		dictionary.setValue(self.createdBy, forKey: "createdBy")
		dictionary.setValue(self.createdDate, forKey: "createdDate")

		return dictionary
	}

}