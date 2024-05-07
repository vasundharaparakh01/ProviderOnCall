//
//  Behaviour.swift
//  AccessEMR
//
//  Created by Vasundhara Parakh on 3/11/20.
//  Copyright © 2020 smartData Enterprises (I) Ltd. All rights reserved.
//

import UIKit

public class Behaviour {
    public var id : Int?
    public var patientId : Int?
    public var behavioursID : Int?
    public var behaviours : String?
    public var behaviourNotes : String?
    public var createdDate : String?
    public var addedByName : String?

/**
    Returns an array of models based on given dictionary.
    
    Sample usage:
    let json4Swift_Base_list = Json4Swift_Base.modelsFromDictionaryArray(someDictionaryArrayFromJSON)

    - parameter array:  NSArray from JSON dictionary.

    - returns: Array of Json4Swift_Base Instances.
*/
    public class func modelsFromDictionaryArray(array:NSArray) -> [Behaviour]
    {
        var models:[Behaviour] = []
        for item in array
        {
            models.append(Behaviour(dictionary: item as! NSDictionary)!)
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
        behavioursID = dictionary["behavioursID"] as? Int
        behaviours = dictionary["behaviours"] as? String
        behaviourNotes = dictionary["behaviourNotes"] as? String
        createdDate = dictionary["createdDate"] as? String
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
        dictionary.setValue(self.behavioursID, forKey: "behavioursID")
        dictionary.setValue(self.behaviours, forKey: "behaviours")
        dictionary.setValue(self.behaviourNotes, forKey: "behaviourNotes")
        dictionary.setValue(self.createdDate, forKey: "createdDate")
        dictionary.setValue(self.addedByName, forKey: "addedByName")

        return dictionary
    }

}
