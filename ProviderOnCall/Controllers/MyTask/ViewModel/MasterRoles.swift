/* 
Copyright (c) 2020 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

import Foundation
 
/* For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar */

public class MasterRoles {
	public var id : Int?
	public var roleName : String?
	public var userType : String?
	public var value : String?
	public var isActive : Bool?
	public var isDeleted : Bool?
	public var organizationID : Int?

/**
    Returns an array of models based on given dictionary.
    
    Sample usage:
    let masterRoles_list = MasterRoles.modelsFromDictionaryArray(someDictionaryArrayFromJSON)

    - parameter array:  NSArray from JSON dictionary.

    - returns: Array of MasterRoles Instances.
*/
    public class func modelsFromDictionaryArray(array:NSArray) -> [MasterRoles]
    {
        var models:[MasterRoles] = []
        for item in array
        {
            models.append(MasterRoles(dictionary: item as! NSDictionary)!)
        }
        return models
    }

/**
    Constructs the object based on the given dictionary.
    
    Sample usage:
    let masterRoles = MasterRoles(someDictionaryFromJSON)

    - parameter dictionary:  NSDictionary from JSON.

    - returns: MasterRoles Instance.
*/
	required public init?(dictionary: NSDictionary) {

		id = dictionary["id"] as? Int
		roleName = dictionary["roleName"] as? String
		userType = dictionary["userType"] as? String
		value = dictionary["value"] as? String
		isActive = dictionary["isActive"] as? Bool
		isDeleted = dictionary["isDeleted"] as? Bool
		organizationID = dictionary["organizationID"] as? Int
	}

		
/**
    Returns the dictionary representation for the current instance.
    
    - returns: NSDictionary.
*/
	public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()

		dictionary.setValue(self.id, forKey: "id")
		dictionary.setValue(self.roleName, forKey: "roleName")
		dictionary.setValue(self.userType, forKey: "userType")
		dictionary.setValue(self.value, forKey: "value")
		dictionary.setValue(self.isActive, forKey: "isActive")
		dictionary.setValue(self.isDeleted, forKey: "isDeleted")
		dictionary.setValue(self.organizationID, forKey: "organizationID")

		return dictionary
	}

}