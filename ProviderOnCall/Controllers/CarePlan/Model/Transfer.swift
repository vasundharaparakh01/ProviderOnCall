//
//  Transfer.swift
//  AccessEMR
//
//  Created by Vasundhara Parakh on 3/11/20.
//  Copyright © 2020 smartData Enterprises (I) Ltd. All rights reserved.
//

import UIKit

public class Transfer {
    public var id : Int?
    public var patientId : Int?
    public var createdDate : String?
    public var weightBearingId : Int?
    public var weightBearing : String?
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
    public class func modelsFromDictionaryArray(array:NSArray) -> [Transfer]
    {
        var models:[Transfer] = []
        for item in array
        {
            models.append(Transfer(dictionary: item as! NSDictionary)!)
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
        createdDate = dictionary["createdDate"] as? String
        weightBearingId = dictionary["weightBearingId"] as? Int
        weightBearing = dictionary["weightBearing"] as? String
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
        dictionary.setValue(self.patientId, forKey: "patientId")
        dictionary.setValue(self.createdDate, forKey: "createdDate")
        dictionary.setValue(self.weightBearingId, forKey: "weightBearingId")
        dictionary.setValue(self.weightBearing, forKey: "weightBearing")
        dictionary.setValue(self.careRequirementId, forKey: "careRequirementId")
        dictionary.setValue(self.careRequirement, forKey: "careRequirement")
        dictionary.setValue(self.addedByName, forKey: "addedByName")

        return dictionary
    }

}
