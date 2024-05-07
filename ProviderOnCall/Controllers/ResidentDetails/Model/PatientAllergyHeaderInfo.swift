/* 
Copyright (c) 2020 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

import Foundation
 
/* For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar */

public class PatientAllergyHeaderInfo {
	public var allergen : String?
	public var allergyType : String?
	public var reaction : String?
	public var note : String?

/**
    Returns an array of models based on given dictionary.
    
    Sample usage:
    let patientAllergyHeaderInfo_list = PatientAllergyHeaderInfo.modelsFromDictionaryArray(someDictionaryArrayFromJSON)

    - parameter array:  NSArray from JSON dictionary.

    - returns: Array of PatientAllergyHeaderInfo Instances.
*/
    public class func modelsFromDictionaryArray(array:NSArray) -> [PatientAllergyHeaderInfo]
    {
        var models:[PatientAllergyHeaderInfo] = []
        for item in array
        {
            models.append(PatientAllergyHeaderInfo(dictionary: item as! NSDictionary)!)
        }
        return models
    }

/**
    Constructs the object based on the given dictionary.
    
    Sample usage:
    let patientAllergyHeaderInfo = PatientAllergyHeaderInfo(someDictionaryFromJSON)

    - parameter dictionary:  NSDictionary from JSON.

    - returns: PatientAllergyHeaderInfo Instance.
*/
	required public init?(dictionary: NSDictionary) {

		allergen = dictionary["allergen"] as? String
		allergyType = dictionary["allergyType"] as? String
		reaction = dictionary["reaction"] as? String
		note = dictionary["note"] as? String
	}

		
/**
    Returns the dictionary representation for the current instance.
    
    - returns: NSDictionary.
*/
	public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()

		dictionary.setValue(self.allergen, forKey: "allergen")
		dictionary.setValue(self.allergyType, forKey: "allergyType")
		dictionary.setValue(self.reaction, forKey: "reaction")
		dictionary.setValue(self.note, forKey: "note")

		return dictionary
	}

}