//
//  Nutrition.swift

//
//  Created by Vasundhara Parakh on 3/11/20.
//  Copyright © 2020 smartData Enterprises (I) Ltd. All rights reserved.
//

import UIKit

public class Nutrition{
    public var id : Int?
    public var patientID : Int?
    public var dietTypeId : Int?
    public var dietType : String?
    public var tubeFeedFormula : String?
    public var tubeFeedRate : String?
    public var foodTextureId : Int?
    public var foodTexture : String?
    public var fluidConsistencyId : Int?
    public var fluidConsistency : String?
    public var mouthCareId : Int?
    public var mouthCare : String?
    public var createdDate : String?
    public var dentistName : String?
    public var lastDentalDate : String?
    public var dentalNotes : String?
    public var careRequirement : String?
    public var careRequirementNotes : String?
    public var foodSafety : String?
    public var teeth : String?
    public var dentures : String?
    public var addedByName : String?

/**
    Returns an array of models based on given dictionary.
    
    Sample usage:
    let json4Swift_Base_list = Json4Swift_Base.modelsFromDictionaryArray(someDictionaryArrayFromJSON)

    - parameter array:  NSArray from JSON dictionary.

    - returns: Array of Json4Swift_Base Instances.
*/
    public class func modelsFromDictionaryArray(array:NSArray) -> [Nutrition]
    {
        var models:[Nutrition] = []
        for item in array
        {
            models.append(Nutrition(dictionary: item as! NSDictionary)!)
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
        patientID = dictionary["patientID"] as? Int
        dietTypeId = dictionary["dietTypeId"] as? Int
        dietType = dictionary["dietType"] as? String
        tubeFeedFormula = dictionary["tubeFeedFormula"] as? String
        tubeFeedRate = dictionary["tubeFeedRate"] as? String
        foodTextureId = dictionary["foodTextureId"] as? Int
        foodTexture = dictionary["foodTexture"] as? String
        fluidConsistencyId = dictionary["fluidConsistencyId"] as? Int
        fluidConsistency = dictionary["fluidConsistency"] as? String
        mouthCareId = dictionary["mouthCareId"] as? Int
        mouthCare = dictionary["mouthCare"] as? String
        createdDate = dictionary["createdDate"] as? String
        dentistName = dictionary["dentistName"] as? String
        lastDentalDate = dictionary["lastDentalDate"] as? String
        dentalNotes = dictionary["dentalNotes"] as? String
        careRequirement = dictionary["careRequirement"] as? String
        careRequirementNotes = dictionary["careRequirementNotes"] as? String
        foodSafety = dictionary["foodSafety"] as? String
        teeth = dictionary["teeth"] as? String
        dentures = dictionary["dentures"] as? String
        addedByName = dictionary["addedByName"] as? String
    }

        
/**
    Returns the dictionary representation for the current instance.
    
    - returns: NSDictionary.
*/
    public func dictionaryRepresentation() -> NSDictionary {

        let dictionary = NSMutableDictionary()

        dictionary.setValue(self.id, forKey: "id")
        dictionary.setValue(self.patientID, forKey: "patientID")
        dictionary.setValue(self.dietTypeId, forKey: "dietTypeId")
        dictionary.setValue(self.dietType, forKey: "dietType")
        dictionary.setValue(self.tubeFeedFormula, forKey: "tubeFeedFormula")
        dictionary.setValue(self.tubeFeedRate, forKey: "tubeFeedRate")
        dictionary.setValue(self.foodTextureId, forKey: "foodTextureId")
        dictionary.setValue(self.foodTexture, forKey: "foodTexture")
        dictionary.setValue(self.fluidConsistencyId, forKey: "fluidConsistencyId")
        dictionary.setValue(self.fluidConsistency, forKey: "fluidConsistency")
        dictionary.setValue(self.mouthCareId, forKey: "mouthCareId")
        dictionary.setValue(self.mouthCare, forKey: "mouthCare")
        dictionary.setValue(self.createdDate, forKey: "createdDate")
        dictionary.setValue(self.dentistName, forKey: "dentistName")
        dictionary.setValue(self.lastDentalDate, forKey: "lastDentalDate")
        dictionary.setValue(self.dentalNotes, forKey: "dentalNotes")
        dictionary.setValue(self.careRequirement, forKey: "careRequirement")
        dictionary.setValue(self.careRequirementNotes, forKey: "careRequirementNotes")
        dictionary.setValue(self.foodSafety, forKey: "foodSafety")
        dictionary.setValue(self.teeth, forKey: "teeth")
        dictionary.setValue(self.dentures, forKey: "dentures")
        dictionary.setValue(self.addedByName, forKey: "addedByName")

        return dictionary
    }

}
