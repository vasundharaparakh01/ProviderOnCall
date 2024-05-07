//
//  Shift.swift
//  AccessEMR
//
//  Created by Vasundhara Parakh on 3/23/20.
//  Copyright © 2020 smartData Enterprises (I) Ltd. All rights reserved.
//

import UIKit

public class Shift {
    public var id : Int?
    public var organizationID : Int?
    public var locationId : Int?
    public var unitId : Int?
    public var shiftName : String?

/**
    Returns an array of models based on given dictionary.
    
    Sample usage:
    let json4Swift_Base_list = Json4Swift_Base.modelsFromDictionaryArray(someDictionaryArrayFromJSON)

    - parameter array:  NSArray from JSON dictionary.

    - returns: Array of Json4Swift_Base Instances.
*/
    public class func modelsFromDictionaryArray(array:NSArray) -> [Shift]
    {
        var models:[Shift] = []
        for item in array
        {
            models.append(Shift(dictionary: item as! NSDictionary)!)
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
        organizationID = dictionary["organizationID"] as? Int
        locationId = dictionary["locationId"] as? Int
        shiftName = dictionary["shiftName"] as? String
        unitId = dictionary["unitId"] as? Int

    }

        
/**
    Returns the dictionary representation for the current instance.
    
    - returns: NSDictionary.
*/
    public func dictionaryRepresentation() -> NSDictionary {

        let dictionary = NSMutableDictionary()

        dictionary.setValue(self.id, forKey: "id")
        dictionary.setValue(self.organizationID, forKey: "organizationID")
        dictionary.setValue(self.locationId, forKey: "locationId")
        dictionary.setValue(self.shiftName, forKey: "shiftName")
        dictionary.setValue(self.unitId, forKey: "unitId")
        return dictionary
    }

}
