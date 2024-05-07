/* 
Copyright (c) 2020 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

import Foundation
 
/* For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar */

public class Resident {
	public var patientId : Int?
	public var firstName : String?
	public var lastName : String?
	public var gender : String?
	public var photoThumbnailPath : String?
	public var isActive : Bool?
	public var dob : String?
	public var isBlock : Bool?
	public var totalRecords : Int?
	public var goalOfCare : String?
	public var phcNo : String?
	public var goalOfCareId : Int?
	public var status : Int?
	public var room : String?
    public var patientAllergy : String?
    public var patientDiagnosis : String?
    public var isAllergy : Bool?
    public var address : String?
    public var latitude : String?
    public var longitude : String?
    public var visitStatus : Bool?
    public var visitTime : String?


/**
    Returns an array of models based on given dictionary.
    
    Sample usage:
    let json4Swift_Base_list = Json4Swift_Base.modelsFromDictionaryArray(someDictionaryArrayFromJSON)

    - parameter array:  NSArray from JSON dictionary.

    - returns: Array of Json4Swift_Base Instances.
*/
    public class func modelsFromDictionaryArray(array:NSArray) -> [Resident]
    {
        var models:[Resident] = []
        for item in array
        {
            models.append(Resident(dictionary: item as! NSDictionary)!)
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

		patientId = dictionary["patientId"] as? Int
		firstName = dictionary["firstName"] as? String
		lastName = dictionary["lastName"] as? String
		gender = dictionary["gender"] as? String
		photoThumbnailPath = dictionary["photoThumbnailPath"] as? String
		isActive = dictionary["isActive"] as? Bool
		dob = dictionary["dob"] as? String
		isBlock = dictionary["isBlock"] as? Bool
		totalRecords = dictionary["totalRecords"] as? Int
		goalOfCare = dictionary["goalOfCare"] as? String
		phcNo = dictionary["phcNo"] as? String
		goalOfCareId = dictionary["goalOfCareId"] as? Int
		status = dictionary["status"] as? Int
		room = dictionary["room"] as? String
        patientAllergy = (dictionary["patientAllergy"] as? String)?.trimmingCharacters(in: .whitespacesAndNewlines)
        patientDiagnosis = (dictionary["patientDiagnosis"] as? String)?.trimmingCharacters(in: .whitespacesAndNewlines)
        isAllergy = dictionary["isAllergy"] as? Bool
        address = dictionary["address"] as? String
        latitude = dictionary["latitude"] as? String
        longitude = dictionary["longitude"] as? String
        visitStatus = dictionary["visitStatus"] as? Bool
        visitTime = dictionary["visitTime"] as? String


	}

		
/**
    Returns the dictionary representation for the current instance.
    
    - returns: NSDictionary.
*/
	public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()

		dictionary.setValue(self.patientId, forKey: "patientId")
		dictionary.setValue(self.firstName, forKey: "firstName")
		dictionary.setValue(self.lastName, forKey: "lastName")
		dictionary.setValue(self.gender, forKey: "gender")
		dictionary.setValue(self.photoThumbnailPath, forKey: "photoThumbnailPath")
		dictionary.setValue(self.isActive, forKey: "isActive")
		dictionary.setValue(self.dob, forKey: "dob")
		dictionary.setValue(self.isBlock, forKey: "isBlock")
		dictionary.setValue(self.totalRecords, forKey: "totalRecords")
		dictionary.setValue(self.goalOfCare, forKey: "goalOfCare")
		dictionary.setValue(self.phcNo, forKey: "phcNo")
		dictionary.setValue(self.goalOfCareId, forKey: "goalOfCareId")
		dictionary.setValue(self.status, forKey: "status")
		dictionary.setValue(self.room, forKey: "room")
        dictionary.setValue(self.patientAllergy, forKey: "patientAllergy")
        dictionary.setValue(self.patientDiagnosis, forKey: "patientDiagnosis")
        dictionary.setValue(self.isAllergy, forKey: "isAllergy")
        dictionary.setValue(self.address, forKey: "address")
        dictionary.setValue(self.latitude, forKey: "latitude")
        dictionary.setValue(self.longitude, forKey: "longitude")
        dictionary.setValue(self.visitStatus, forKey: "visitStatus")
        dictionary.setValue(self.visitTime, forKey: "visitTime")

		return dictionary
	}

}
