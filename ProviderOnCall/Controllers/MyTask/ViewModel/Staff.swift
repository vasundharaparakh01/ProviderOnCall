/* 
Copyright (c) 2020 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

import Foundation
 
/* For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar */

public class Staff {
	public var id : Int?
	public var firstName : String?
	public var lastName : String?
	public var email : String?
	public var phoneNumber : String?
	public var value : String?
	public var userId : Int?

/**
    Returns an array of models based on given dictionary.
    
    Sample usage:
    let staff_list = Staff.modelsFromDictionaryArray(someDictionaryArrayFromJSON)

    - parameter array:  NSArray from JSON dictionary.

    - returns: Array of Staff Instances.
*/
    public class func modelsFromDictionaryArray(array:NSArray) -> [Staff]
    {
        var models:[Staff] = []
        for item in array
        {
            models.append(Staff(dictionary: item as! NSDictionary)!)
        }
        return models
    }

/**
    Constructs the object based on the given dictionary.
    
    Sample usage:
    let staff = Staff(someDictionaryFromJSON)

    - parameter dictionary:  NSDictionary from JSON.

    - returns: Staff Instance.
*/
	required public init?(dictionary: NSDictionary) {

		id = dictionary["id"] as? Int
		firstName = dictionary["firstName"] as? String
		lastName = dictionary["lastName"] as? String
		email = dictionary["email"] as? String
		phoneNumber = dictionary["phoneNumber"] as? String
		value = dictionary["value"] as? String
		userId = dictionary["userId"] as? Int
	}

		
/**
    Returns the dictionary representation for the current instance.
    
    - returns: NSDictionary.
*/
	public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()

		dictionary.setValue(self.id, forKey: "id")
		dictionary.setValue(self.firstName, forKey: "firstName")
		dictionary.setValue(self.lastName, forKey: "lastName")
		dictionary.setValue(self.email, forKey: "email")
		dictionary.setValue(self.phoneNumber, forKey: "phoneNumber")
		dictionary.setValue(self.value, forKey: "value")
		dictionary.setValue(self.userId, forKey: "userId")

		return dictionary
	}

}