/* 
Copyright (c) 2020 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

import Foundation
 
/* For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar */

public class DynamicBloodLoss {
	public var id : Int?
	public var nutritionAndHydrationId : Int?
	public var bloodLossAmount : String?
	public var bloodLossTime : String?
	public var isActive : Bool?
	public var isDeleted : Bool?
	public var createdBy : Int?
	public var createdDate : String?

/**
    Returns an array of models based on given dictionary.
    
    Sample usage:
    let dynamicBloodLoss_list = DynamicBloodLoss.modelsFromDictionaryArray(someDictionaryArrayFromJSON)

    - parameter array:  NSArray from JSON dictionary.

    - returns: Array of DynamicBloodLoss Instances.
*/
    public class func modelsFromDictionaryArray(array:NSArray) -> [DynamicBloodLoss]
    {
        var models:[DynamicBloodLoss] = []
        for item in array
        {
            models.append(DynamicBloodLoss(dictionary: item as! NSDictionary)!)
        }
        return models
    }

/**
    Constructs the object based on the given dictionary.
    
    Sample usage:
    let dynamicBloodLoss = DynamicBloodLoss(someDictionaryFromJSON)

    - parameter dictionary:  NSDictionary from JSON.

    - returns: DynamicBloodLoss Instance.
*/
	required public init?(dictionary: NSDictionary) {

		id = dictionary["id"] as? Int
		nutritionAndHydrationId = dictionary["nutritionAndHydrationId"] as? Int
		bloodLossAmount = dictionary["bloodLossAmount"] as? String
		bloodLossTime = dictionary["bloodLossTime"] as? String
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
		dictionary.setValue(self.nutritionAndHydrationId, forKey: "nutritionAndHydrationId")
		dictionary.setValue(self.bloodLossAmount, forKey: "bloodLossAmount")
		dictionary.setValue(self.bloodLossTime, forKey: "bloodLossTime")
		dictionary.setValue(self.isActive, forKey: "isActive")
		dictionary.setValue(self.isDeleted, forKey: "isDeleted")
		dictionary.setValue(self.createdBy, forKey: "createdBy")
		dictionary.setValue(self.createdDate, forKey: "createdDate")

		return dictionary
	}

}