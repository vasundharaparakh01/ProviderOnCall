//
//  Bathing.swift

//
//  Created by Vasundhara Parakh on 3/11/20.
//  Copyright © 2020 smartData Enterprises (I) Ltd. All rights reserved.
//

import UIKit

public class Bathing{
    public var id : Int?
    public var patientID : Int?
    public var nailCareDoneBy : String?
    public var footCareDoneBy : String?
    public var bathingNotes : String?
    public var createdDate : String?
    public var bathDaysID : Int?
    public var bathDays : String?
    public var bathTypesID : Int?
    public var bathTypes : String?
    public var hairCaresID : Int?
    public var hairCares : String?
    public var preferencesID : Int?
    public var preferences : String?
    public var careRequirementId : Int?
    public var careRequirement : String?
    public var addedByName : String?

/**
    Returns an array of models based on given dictionary.
    
    Sample usage:
    let json4Swift_Base_list = Json4Swift_Base.modelsFromDictionaryArray(someDictionaryArrayFromJSON)

    - parameter array:  NSArray from JSON dictionary.

    - returns: Array of Json4Swift_Base Instances.
*/
    public class func modelsFromDictionaryArray(array:NSArray) -> [Bathing]
    {
        var models:[Bathing] = []
        for item in array
        {
            models.append(Bathing(dictionary: item as! NSDictionary)!)
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
        nailCareDoneBy = dictionary["nailCareDoneBy"] as? String
        footCareDoneBy = dictionary["footCareDoneBy"] as? String
        bathingNotes = dictionary["bathingNotes"] as? String
        createdDate = dictionary["createdDate"] as? String
        bathDaysID = dictionary["bathDaysID"] as? Int
        bathDays = dictionary["bathDays"] as? String
        bathTypesID = dictionary["bathTypesID"] as? Int
        bathTypes = dictionary["bathTypes"] as? String
        hairCaresID = dictionary["hairCaresID"] as? Int
        hairCares = dictionary["hairCares"] as? String
        preferencesID = dictionary["preferencesID"] as? Int
        preferences = dictionary["preferences"] as? String
        careRequirementId = dictionary["careRequirementId"] as? Int
        careRequirement = dictionary["careRequirement"] as? String
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
        dictionary.setValue(self.nailCareDoneBy, forKey: "nailCareDoneBy")
        dictionary.setValue(self.footCareDoneBy, forKey: "footCareDoneBy")
        dictionary.setValue(self.bathingNotes, forKey: "bathingNotes")
        dictionary.setValue(self.createdDate, forKey: "createdDate")
        dictionary.setValue(self.bathDaysID, forKey: "bathDaysID")
        dictionary.setValue(self.bathDays, forKey: "bathDays")
        dictionary.setValue(self.bathTypesID, forKey: "bathTypesID")
        dictionary.setValue(self.bathTypes, forKey: "bathTypes")
        dictionary.setValue(self.hairCaresID, forKey: "hairCaresID")
        dictionary.setValue(self.hairCares, forKey: "hairCares")
        dictionary.setValue(self.preferencesID, forKey: "preferencesID")
        dictionary.setValue(self.preferences, forKey: "preferences")
        dictionary.setValue(self.careRequirementId, forKey: "careRequirementId")
        dictionary.setValue(self.careRequirement, forKey: "careRequirement")
        dictionary.setValue(self.addedByName, forKey: "addedByName")

        return dictionary
    }

}
