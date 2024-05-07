//
//  Skin.swift
//  AccessEMR
//
//  Created by Vasundhara Parakh on 3/11/20.
//  Copyright © 2020 smartData Enterprises (I) Ltd. All rights reserved.
//

import UIKit

public class Skin{
    public var id : Int?
    public var patientID : Int?
    public var skinNotes : String?
    public var skinCaresId : Int?
    public var skinCares : String?
    public var skinConcernsId : Int?
    public var skinConcerns : String?
    public var createdDate : String?
    public var addedByName : String?

/**
    Returns an array of models based on given dictionary.
    
    Sample usage:
    let json4Swift_Base_list = Json4Swift_Base.modelsFromDictionaryArray(someDictionaryArrayFromJSON)

    - parameter array:  NSArray from JSON dictionary.

    - returns: Array of Json4Swift_Base Instances.
*/
    public class func modelsFromDictionaryArray(array:NSArray) -> [Skin]
    {
        var models:[Skin] = []
        for item in array
        {
            models.append(Skin(dictionary: item as! NSDictionary)!)
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
        skinNotes = dictionary["skinNotes"] as? String
        skinCaresId = dictionary["skinCaresId"] as? Int
        skinCares = dictionary["skinCares"] as? String
        skinConcernsId = dictionary["skinConcernsId"] as? Int
        skinConcerns = dictionary["skinConcerns"] as? String
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
        dictionary.setValue(self.patientID, forKey: "patientID")
        dictionary.setValue(self.skinNotes, forKey: "skinNotes")
        dictionary.setValue(self.skinCaresId, forKey: "skinCaresId")
        dictionary.setValue(self.skinCares, forKey: "skinCares")
        dictionary.setValue(self.skinConcernsId, forKey: "skinConcernsId")
        dictionary.setValue(self.skinConcerns, forKey: "skinConcerns")
        dictionary.setValue(self.createdDate, forKey: "createdDate")
        dictionary.setValue(self.addedByName, forKey: "addedByName")

        return dictionary
    }

}
