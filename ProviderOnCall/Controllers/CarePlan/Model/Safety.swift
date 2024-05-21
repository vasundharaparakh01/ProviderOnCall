//
//  Safety.swift

//
//  Created by Vasundhara Parakh on 3/11/20.
//  Copyright © 2020 smartData Enterprises (I) Ltd. All rights reserved.
//

import UIKit

public class Safety {
    public var id : Int?
    public var patientID : Int?
    public var allergies : String?
    public var safetyRisksNotes : String?
    public var safetyPlanNotes : String?
    public var createdDate : String?
    public var safetyPlansID : Int?
    public var safetyPlans : String?
    public var safetyRisksID : Int?
    public var safetyRisks : String?
    public var addedByName : String?

/**
    Returns an array of models based on given dictionary.
    
    Sample usage:
    let json4Swift_Base_list = Json4Swift_Base.modelsFromDictionaryArray(someDictionaryArrayFromJSON)

    - parameter array:  NSArray from JSON dictionary.

    - returns: Array of Json4Swift_Base Instances.
*/
    public class func modelsFromDictionaryArray(array:NSArray) -> [Safety]
    {
        var models:[Safety] = []
        for item in array
        {
            models.append(Safety(dictionary: item as! NSDictionary)!)
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
        allergies = dictionary["allergies"] as? String
        safetyRisksNotes = dictionary["safetyRisksNotes"] as? String
        safetyPlanNotes = dictionary["safetyPlanNotes"] as? String
        createdDate = dictionary["createdDate"] as? String
        safetyPlansID = dictionary["safetyPlansID"] as? Int
        safetyPlans = dictionary["safetyPlans"] as? String
        safetyRisksID = dictionary["safetyRisksID"] as? Int
        safetyRisks = dictionary["safetyRisks"] as? String
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
        dictionary.setValue(self.allergies, forKey: "allergies")
        dictionary.setValue(self.safetyRisksNotes, forKey: "safetyRisksNotes")
        dictionary.setValue(self.safetyPlanNotes, forKey: "safetyPlanNotes")
        dictionary.setValue(self.createdDate, forKey: "createdDate")
        dictionary.setValue(self.safetyPlansID, forKey: "safetyPlansID")
        dictionary.setValue(self.safetyPlans, forKey: "safetyPlans")
        dictionary.setValue(self.safetyRisksID, forKey: "safetyRisksID")
        dictionary.setValue(self.safetyRisks, forKey: "safetyRisks")
        dictionary.setValue(self.addedByName, forKey: "addedByName")

        return dictionary
    }

}
