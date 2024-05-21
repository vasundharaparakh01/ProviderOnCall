/* 
Copyright (c) 2020 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

import Foundation
 
/* For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar */

public class PatientBasicHeaderInfo {
	public var patientID : Int?
	public var name : String?
	public var dob : String?
	public var gender : String?
	public var status : String?
	public var address : String?
	public var photoPath : String?
	public var photoThumbnailPath : String?
	public var userId : Int?
	public var age : String?
	public var goalOfCareId : Int?
	public var phcNo : String?
	public var room : String?
	public var allergies : String?
    public var goalOfCare : String?
    public var goalOfCareInfo : String?
    public var isAllergy : Bool?
    public var latitude : String?
    public var longitude : String?
    public var visitStatus : Bool?
    public var visitTime : String?
    public var unitId : Int?

/**
    Returns an array of models based on given dictionary.
    
    Sample usage:
    let patientBasicHeaderInfo_list = PatientBasicHeaderInfo.modelsFromDictionaryArray(someDictionaryArrayFromJSON)

    - parameter array:  NSArray from JSON dictionary.

    - returns: Array of PatientBasicHeaderInfo Instances.
*/
    public class func modelsFromDictionaryArray(array:NSArray) -> [PatientBasicHeaderInfo]
    {
        var models:[PatientBasicHeaderInfo] = []
        for item in array
        {
            models.append(PatientBasicHeaderInfo(dictionary: item as! NSDictionary)!)
        }
        return models
    }

/**
    Constructs the object based on the given dictionary.
    
    Sample usage:
    let patientBasicHeaderInfo = PatientBasicHeaderInfo(someDictionaryFromJSON)

    - parameter dictionary:  NSDictionary from JSON.

    - returns: PatientBasicHeaderInfo Instance.
*/
	required public init?(dictionary: NSDictionary) {

		patientID = dictionary["patientID"] as? Int
		name = dictionary["name"] as? String
		dob = dictionary["dob"] as? String
		gender = dictionary["gender"] as? String
		status = dictionary["status"] as? String
		address = dictionary["address"] as? String
		photoPath = dictionary["photoPath"] as? String
		photoThumbnailPath = dictionary["photoThumbnailPath"] as? String
		userId = dictionary["userId"] as? Int
		age = dictionary["age"] as? String
		goalOfCareId = dictionary["goalOfCareId"] as? Int
		phcNo = dictionary["phcNo"] as? String
		room = dictionary["room"] as? String
        allergies = (dictionary["allergies"] as? String)?.trimmingCharacters(in: .whitespacesAndNewlines)
        goalOfCare = dictionary["goalOfCare"] as? String
        goalOfCareInfo = dictionary["goalOfCareInfo"] as? String
        isAllergy = dictionary["isAllergy"] as? Bool
        address = dictionary["address"] as? String
        latitude = dictionary["latitude"] as? String
        longitude = dictionary["longitude"] as? String
        visitStatus = dictionary["visitStatus"] as? Bool
        visitTime = dictionary["visitTime"] as? String
        unitId = dictionary["unitId"] as? Int
        SharedappName.sharedInstance.unitIDSymptomTracker = unitId

	}

		
/**
    Returns the dictionary representation for the current instance.
    
    - returns: NSDictionary.
*/
	public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()

		dictionary.setValue(self.patientID, forKey: "patientID")
		dictionary.setValue(self.name, forKey: "name")
		dictionary.setValue(self.dob, forKey: "dob")
		dictionary.setValue(self.gender, forKey: "gender")
		dictionary.setValue(self.status, forKey: "status")
		dictionary.setValue(self.address, forKey: "address")
		dictionary.setValue(self.photoPath, forKey: "photoPath")
		dictionary.setValue(self.photoThumbnailPath, forKey: "photoThumbnailPath")
		dictionary.setValue(self.userId, forKey: "userId")
		dictionary.setValue(self.age, forKey: "age")
		dictionary.setValue(self.goalOfCareId, forKey: "goalOfCareId")
		dictionary.setValue(self.phcNo, forKey: "phcNo")
		dictionary.setValue(self.room, forKey: "room")
		dictionary.setValue(self.allergies, forKey: "allergies")
        dictionary.setValue(self.goalOfCare, forKey: "goalOfCare")
        dictionary.setValue(self.goalOfCareInfo, forKey: "goalOfCareInfo")
        dictionary.setValue(self.isAllergy, forKey: "isAllergy")
        dictionary.setValue(self.latitude, forKey: "latitude")
        dictionary.setValue(self.longitude, forKey: "longitude")
        dictionary.setValue(self.visitStatus, forKey: "visitStatus")
        dictionary.setValue(self.visitTime, forKey: "visitTime")
        dictionary.setValue(self.unitId, forKey: "unitId")

		return dictionary
	}

}
