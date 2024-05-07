/* 
Copyright (c) 2020 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

import Foundation
 
/* For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar */

public class MasterLocation {
	public var id : Int?
	public var organizationID : Int?
	public var locationName : String?
	public var officeStartHour : String?
	public var officeEndHour : String?
	public var facilityCode : Int?
	public var facilityCodeName : String?
	public var facilityNPINumber : Int?
	public var facilityProviderNumber : Int?
	public var billingTaxId : Int?
	public var billingNPINumber : Int?
	public var mileageRate : Int?
	public var locationDescription : String?
	public var address : String?
	public var city : String?
	public var stateID : Int?
	public var stateName : String?
	public var zip : String?
	public var phone : String?
	public var countryID : Int?
	public var countryName : String?
	public var latitude : Double?
	public var longitude : Double?
	public var apartmentNumber : String?
	public var billingProviderInfo : String?
	public var standardTime : Int?
	public var daylightSavingTime : Int?
	public var isActive : Bool?
	public var isDeleted : Bool?
	public var createdBy : Int?
	public var createdDate : String?
	public var updatedDate : String?
	public var updatedBy : Int?

/**
    Returns an array of models based on given dictionary.
    
    Sample usage:
    let masterLocation_list = MasterLocation.modelsFromDictionaryArray(someDictionaryArrayFromJSON)

    - parameter array:  NSArray from JSON dictionary.

    - returns: Array of MasterLocation Instances.
*/
    public class func modelsFromDictionaryArray(array:NSArray) -> [MasterLocation]
    {
        var models:[MasterLocation] = []
        for item in array
        {
            models.append(MasterLocation(dictionary: item as! NSDictionary)!)
        }
        return models
    }

/**
    Constructs the object based on the given dictionary.
    
    Sample usage:
    let masterLocation = MasterLocation(someDictionaryFromJSON)

    - parameter dictionary:  NSDictionary from JSON.

    - returns: MasterLocation Instance.
*/
	required public init?(dictionary: NSDictionary) {

		id = dictionary["id"] as? Int
		organizationID = dictionary["organizationID"] as? Int
		locationName = dictionary["locationName"] as? String
		officeStartHour = dictionary["officeStartHour"] as? String
		officeEndHour = dictionary["officeEndHour"] as? String
		facilityCode = dictionary["facilityCode"] as? Int
		facilityCodeName = dictionary["facilityCodeName"] as? String
		facilityNPINumber = dictionary["facilityNPINumber"] as? Int
		facilityProviderNumber = dictionary["facilityProviderNumber"] as? Int
		billingTaxId = dictionary["billingTaxId"] as? Int
		billingNPINumber = dictionary["billingNPINumber"] as? Int
		mileageRate = dictionary["mileageRate"] as? Int
		locationDescription = dictionary["locationDescription"] as? String
		address = dictionary["address"] as? String
		city = dictionary["city"] as? String
		stateID = dictionary["stateID"] as? Int
		stateName = dictionary["stateName"] as? String
		zip = dictionary["zip"] as? String
		phone = dictionary["phone"] as? String
		countryID = dictionary["countryID"] as? Int
		countryName = dictionary["countryName"] as? String
		latitude = dictionary["latitude"] as? Double
		longitude = dictionary["longitude"] as? Double
		apartmentNumber = dictionary["apartmentNumber"] as? String
		billingProviderInfo = dictionary["billingProviderInfo"] as? String
		standardTime = dictionary["standardTime"] as? Int
		daylightSavingTime = dictionary["daylightSavingTime"] as? Int
		isActive = dictionary["isActive"] as? Bool
		isDeleted = dictionary["isDeleted"] as? Bool
		createdBy = dictionary["createdBy"] as? Int
		createdDate = dictionary["createdDate"] as? String
		updatedDate = dictionary["updatedDate"] as? String
		updatedBy = dictionary["updatedBy"] as? Int
	}

		
/**
    Returns the dictionary representation for the current instance.
    
    - returns: NSDictionary.
*/
	public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()

		dictionary.setValue(self.id, forKey: "id")
		dictionary.setValue(self.organizationID, forKey: "organizationID")
		dictionary.setValue(self.locationName, forKey: "locationName")
		dictionary.setValue(self.officeStartHour, forKey: "officeStartHour")
		dictionary.setValue(self.officeEndHour, forKey: "officeEndHour")
		dictionary.setValue(self.facilityCode, forKey: "facilityCode")
		dictionary.setValue(self.facilityCodeName, forKey: "facilityCodeName")
		dictionary.setValue(self.facilityNPINumber, forKey: "facilityNPINumber")
		dictionary.setValue(self.facilityProviderNumber, forKey: "facilityProviderNumber")
		dictionary.setValue(self.billingTaxId, forKey: "billingTaxId")
		dictionary.setValue(self.billingNPINumber, forKey: "billingNPINumber")
		dictionary.setValue(self.mileageRate, forKey: "mileageRate")
		dictionary.setValue(self.locationDescription, forKey: "locationDescription")
		dictionary.setValue(self.address, forKey: "address")
		dictionary.setValue(self.city, forKey: "city")
		dictionary.setValue(self.stateID, forKey: "stateID")
		dictionary.setValue(self.stateName, forKey: "stateName")
		dictionary.setValue(self.zip, forKey: "zip")
		dictionary.setValue(self.phone, forKey: "phone")
		dictionary.setValue(self.countryID, forKey: "countryID")
		dictionary.setValue(self.countryName, forKey: "countryName")
		dictionary.setValue(self.latitude, forKey: "latitude")
		dictionary.setValue(self.longitude, forKey: "longitude")
		dictionary.setValue(self.apartmentNumber, forKey: "apartmentNumber")
		dictionary.setValue(self.billingProviderInfo, forKey: "billingProviderInfo")
		dictionary.setValue(self.standardTime, forKey: "standardTime")
		dictionary.setValue(self.daylightSavingTime, forKey: "daylightSavingTime")
		dictionary.setValue(self.isActive, forKey: "isActive")
		dictionary.setValue(self.isDeleted, forKey: "isDeleted")
		dictionary.setValue(self.createdBy, forKey: "createdBy")
		dictionary.setValue(self.createdDate, forKey: "createdDate")
		dictionary.setValue(self.updatedDate, forKey: "updatedDate")
		dictionary.setValue(self.updatedBy, forKey: "updatedBy")

		return dictionary
	}

}