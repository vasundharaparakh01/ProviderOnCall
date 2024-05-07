/*
Copyright (c) 2020 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

import Foundation
 
/* For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar */

public class FoodDiary {
    public var id : Int?
    public var patientId : Int?
    public var firstName : String?
    public var lastName : String?
    public var roomName : String?
    public var mealCategoryName : String?
    public var mealItemName : String?
    public var servingSize : String?
    public var servingSizePortion : String?
    public var servingHall : String?
    public var typeOfFoodName : String?
    public var foodAllergy : String?
    public var fluidConsistencyName : String?
    public var notes : String?
    public var startDate : String?
    public var stopDate : String?
    public var cssClass : String?
    public var mealTime : String?
    public var patientFoodDiaryDetails : Array<PatientFoodDiaryDetails>?

/**
    Returns an array of models based on given dictionary.
    
    Sample usage:
    let json4Swift_Base_list = Json4Swift_Base.modelsFromDictionaryArray(someDictionaryArrayFromJSON)

    - parameter array:  NSArray from JSON dictionary.

    - returns: Array of Json4Swift_Base Instances.
*/
    public class func modelsFromDictionaryArray(array:NSArray) -> [FoodDiary]
    {
        var models:[FoodDiary] = []
        for item in array
        {
            models.append(FoodDiary(dictionary: item as! NSDictionary)!)
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
        firstName = dictionary["firstName"] as? String
        lastName = dictionary["lastName"] as? String
        roomName = dictionary["roomName"] as? String
        mealCategoryName = dictionary["mealCategoryName"] as? String
        mealItemName = dictionary["mealItemName"] as? String
        servingSize = dictionary["servingSize"] as? String
        servingSizePortion = dictionary["servingSizePortion"] as? String
        servingHall = dictionary["servingHall"] as? String
        typeOfFoodName = dictionary["typeOfFoodName"] as? String
        foodAllergy = dictionary["foodAllergy"] as? String
        fluidConsistencyName = dictionary["fluidConsistencyName"] as? String
        notes = dictionary["notes"] as? String
        startDate = dictionary["startDate"] as? String
        stopDate = dictionary["stopDate"] as? String
        cssClass = dictionary["cssClass"] as? String
        mealTime = dictionary["mealTime"] as? String

        if (dictionary["patientFoodDiaryDetails"] != nil) { patientFoodDiaryDetails = PatientFoodDiaryDetails.modelsFromDictionaryArray(array: dictionary["patientFoodDiaryDetails"] as! NSArray) }
    }

        
/**
    Returns the dictionary representation for the current instance.
    
    - returns: NSDictionary.
*/
    public func dictionaryRepresentation() -> NSDictionary {

        let dictionary = NSMutableDictionary()

        dictionary.setValue(self.id, forKey: "id")
        dictionary.setValue(self.patientId, forKey: "patientId")
        dictionary.setValue(self.firstName, forKey: "firstName")
        dictionary.setValue(self.lastName, forKey: "lastName")
        dictionary.setValue(self.roomName, forKey: "roomName")
        dictionary.setValue(self.mealCategoryName, forKey: "mealCategoryName")
        dictionary.setValue(self.mealItemName, forKey: "mealItemName")
        dictionary.setValue(self.servingSize, forKey: "servingSize")
        dictionary.setValue(self.servingSizePortion, forKey: "servingSizePortion")
        dictionary.setValue(self.servingHall, forKey: "servingHall")
        dictionary.setValue(self.typeOfFoodName, forKey: "typeOfFoodName")
        dictionary.setValue(self.foodAllergy, forKey: "foodAllergy")
        dictionary.setValue(self.fluidConsistencyName, forKey: "fluidConsistencyName")
        dictionary.setValue(self.notes, forKey: "notes")
        dictionary.setValue(self.startDate, forKey: "startDate")
        dictionary.setValue(self.stopDate, forKey: "stopDate")
        dictionary.setValue(self.cssClass, forKey: "cssClass")
        dictionary.setValue(self.mealTime, forKey: "mealTime")
        return dictionary
    }

}

