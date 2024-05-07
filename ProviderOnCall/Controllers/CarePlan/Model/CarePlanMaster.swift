//
//  CarePlanMaster.swift
//  AccessEMR
//
//  Created by Vasundhara Parakh on 3/19/20.
//  Copyright © 2020 smartData Enterprises (I) Ltd. All rights reserved.
//

import UIKit

public class CarePlanMaster{
    public var id : Int?
    public var carePlanMasterId : Int?
    public var category : String?
    public var dropDownType : String?
    public var dropDownValue : String?
    public var isActive : Bool?
    public var isDeleted : Bool?

/**
    Returns an array of models based on given dictionary.
    
    Sample usage:
    let json4Swift_Base_list = Json4Swift_Base.modelsFromDictionaryArray(someDictionaryArrayFromJSON)

    - parameter array:  NSArray from JSON dictionary.

    - returns: Array of Json4Swift_Base Instances.
*/
    public class func modelsFromDictionaryArray(array:NSArray) -> [CarePlanMaster]
    {
        var models:[CarePlanMaster] = []
        for item in array
        {
            models.append(CarePlanMaster(dictionary: item as! NSDictionary)!)
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
        carePlanMasterId = dictionary["carePlanMasterId"] as? Int
        category = dictionary["category"] as? String
        dropDownType = dictionary["dropDownType"] as? String
        dropDownValue = dictionary["dropDownValue"] as? String
        isActive = dictionary["isActive"] as? Bool
        isDeleted = dictionary["isDeleted"] as? Bool
    }

        
/**
    Returns the dictionary representation for the current instance.
    
    - returns: NSDictionary.
*/
    public func dictionaryRepresentation() -> NSDictionary {

        let dictionary = NSMutableDictionary()

        dictionary.setValue(self.id, forKey: "id")
        dictionary.setValue(self.carePlanMasterId, forKey: "carePlanMasterId")
        dictionary.setValue(self.category, forKey: "category")
        dictionary.setValue(self.dropDownType, forKey: "dropDownType")
        dictionary.setValue(self.dropDownValue, forKey: "dropDownValue")
        dictionary.setValue(self.isActive, forKey: "isActive")
        dictionary.setValue(self.isDeleted, forKey: "isDeleted")

        return dictionary
    }

}
public class ProgressNotesMaster {
    public var id : Int?
    public var name : String?
    public var type : String?
    public var isDeleted : Int?

/**
    Returns an array of models based on given dictionary.
    
    Sample usage:
    let data_list = Data.modelsFromDictionaryArray(someDictionaryArrayFromJSON)

    - parameter array:  NSArray from JSON dictionary.

    - returns: Array of Data Instances.
*/
    public class func modelsFromDictionaryArray(array:NSArray) -> [ProgressNotesMaster]
    {
        var models:[ProgressNotesMaster] = []
        for item in array
        {
            models.append(ProgressNotesMaster(dictionary: item as! NSDictionary)!)
        }
        return models
    }

/**
    Constructs the object based on the given dictionary.
    
    Sample usage:
    let data = Data(someDictionaryFromJSON)

    - parameter dictionary:  NSDictionary from JSON.

    - returns: Data Instance.
*/
    required public init?(dictionary: NSDictionary) {

        id = dictionary["id"] as? Int
        name = dictionary["name"] as? String
        type = dictionary["type"] as? String
        isDeleted = dictionary["isDeleted"] as? Int
    }

        
/**
    Returns the dictionary representation for the current instance.
    
    - returns: NSDictionary.
*/
    public func dictionaryRepresentation() -> NSDictionary {

        let dictionary = NSMutableDictionary()

        dictionary.setValue(self.id, forKey: "id")
        dictionary.setValue(self.name, forKey: "name")
        dictionary.setValue(self.type, forKey: "type")
        dictionary.setValue(self.isDeleted, forKey: "isDeleted")

        return dictionary
    }

}
