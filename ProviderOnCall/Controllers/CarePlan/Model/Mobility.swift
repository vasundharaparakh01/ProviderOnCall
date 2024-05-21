//
//  Mobility.swift

//
//  Created by Vasundhara Parakh on 3/11/20.
//  Copyright © 2020 smartData Enterprises (I) Ltd. All rights reserved.
//

import UIKit

public class Mobility{
    public var id : Int?
    public var patientId : Int?
    public var createdDate : String?
    public var mobilityNotes : String?
    public var careRequirement : String?
    public var mobilityAidsId : Int?
    public var mobilityAids : String?
    public var addedByName : String?

/**
    Returns an array of models based on given dictionary.
    
    Sample usage:
    let json4Swift_Base_list = Json4Swift_Base.modelsFromDictionaryArray(someDictionaryArrayFromJSON)

    - parameter array:  NSArray from JSON dictionary.

    - returns: Array of Json4Swift_Base Instances.
*/
    public class func modelsFromDictionaryArray(array:NSArray) -> [Mobility]
    {
        var models:[Mobility] = []
        for item in array
        {
            models.append(Mobility(dictionary: item as! NSDictionary)!)
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
        mobilityNotes = dictionary["mobilityNotes"] as? String
        careRequirement = dictionary["careRequirement"] as? String
        mobilityAidsId = dictionary["mobilityAidsId"] as? Int
        mobilityAids = dictionary["mobilityAids"] as? String
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
        dictionary.setValue(self.mobilityNotes, forKey: "mobilityNotes")
        dictionary.setValue(self.careRequirement, forKey: "careRequirement")
        dictionary.setValue(self.mobilityAidsId, forKey: "mobilityAidsId")
        dictionary.setValue(self.mobilityAids, forKey: "mobilityAids")
        dictionary.setValue(self.addedByName, forKey: "addedByName")

        return dictionary
    }

}
