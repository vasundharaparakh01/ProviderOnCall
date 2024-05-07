/* 
Copyright (c) 2020 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

import Foundation
 
/* For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar */

public class OtherMedicine {
	public var id : Int?
	public var patientId : Int?
	public var medicationName : String?
	public var dosage : String?
	public var note : String?
	public var pageNumber : Int?
	public var pageSize : Int?
	public var sortColumn : String?
	public var sortOrder : String?
	public var totalRecords : Int?
	public var searchKey : String?

/**
    Returns an array of models based on given dictionary.
    
    Sample usage:
    let json4Swift_Base_list = Json4Swift_Base.modelsFromDictionaryArray(someDictionaryArrayFromJSON)

    - parameter array:  NSArray from JSON dictionary.

    - returns: Array of Json4Swift_Base Instances.
*/
    public class func modelsFromDictionaryArray(array:NSArray) -> [OtherMedicine]
    {
        var models:[OtherMedicine] = []
        for item in array
        {
            models.append(OtherMedicine(dictionary: item as! NSDictionary)!)
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
		patientId = dictionary["patientId"] as? Int
		medicationName = dictionary["medicationName"] as? String
		dosage = dictionary["dosage"] as? String
		note = dictionary["note"] as? String
		pageNumber = dictionary["pageNumber"] as? Int
		pageSize = dictionary["pageSize"] as? Int
		sortColumn = dictionary["sortColumn"] as? String
		sortOrder = dictionary["sortOrder"] as? String
		totalRecords = dictionary["totalRecords"] as? Int
		searchKey = dictionary["searchKey"] as? String
	}

		
/**
    Returns the dictionary representation for the current instance.
    
    - returns: NSDictionary.
*/
	public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()

		dictionary.setValue(self.id, forKey: "id")
		dictionary.setValue(self.patientId, forKey: "patientId")
		dictionary.setValue(self.medicationName, forKey: "medicationName")
		dictionary.setValue(self.dosage, forKey: "dosage")
		dictionary.setValue(self.note, forKey: "note")
		dictionary.setValue(self.pageNumber, forKey: "pageNumber")
		dictionary.setValue(self.pageSize, forKey: "pageSize")
		dictionary.setValue(self.sortColumn, forKey: "sortColumn")
		dictionary.setValue(self.sortOrder, forKey: "sortOrder")
		dictionary.setValue(self.totalRecords, forKey: "totalRecords")
		dictionary.setValue(self.searchKey, forKey: "searchKey")

		return dictionary
	}

}
