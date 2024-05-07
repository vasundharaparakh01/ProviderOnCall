//
//  Routine.swift
//  AccessEMR
//
//  Created by Vasundhara Parakh on 3/6/20.
//  Copyright © 2020 smartData Enterprises (I) Ltd. All rights reserved.
//

import UIKit

public class Routine {
    public var id : Int?
    public var patientID : Int?
    public var carePlanMasterId : Int?
    public var oxygenTherapyId : Bool?
    public var amountLMin : String?
    public var deliveryId : Int?
    public var delivaryName : String?
    public var oxygenSaturation : String?
    public var isGlucosemonitoring : Bool?
    public var isFastingBloodSugarTest : Bool?
    public var randomBloodSugarTest : Bool?
    public var glucoseNotes : String?
    public var bedTime : String?
    public var wakesUpAt : String?
    public var restTime : String?
    public var sleepNotes : String?
    public var laundryDoneById : Int?
    public var loundryDoneBy : String?
    public var laundryNotes : String?
    public var loundryDays : String?
    public var addedByName : String?
    public var createdDate : String?

/**
    Returns an array of models based on given dictionary.
    
    Sample usage:
    let json4Swift_Base_list = Json4Swift_Base.modelsFromDictionaryArray(someDictionaryArrayFromJSON)

    - parameter array:  NSArray from JSON dictionary.

    - returns: Array of Json4Swift_Base Instances.
*/
    public class func modelsFromDictionaryArray(array:NSArray) -> [Routine]
    {
        var models:[Routine] = []
        for item in array
        {
            models.append(Routine(dictionary: item as! NSDictionary)!)
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
        carePlanMasterId = dictionary["carePlanMasterId"] as? Int
        oxygenTherapyId = dictionary["oxygenTherapyId"] as? Bool
        amountLMin = dictionary["amountLMin"] as? String
        deliveryId = dictionary["deliveryId"] as? Int
        delivaryName = dictionary["delivaryName"] as? String
        oxygenSaturation = dictionary["oxygenSaturation"] as? String
        isGlucosemonitoring = dictionary["isGlucosemonitoring"] as? Bool
        isFastingBloodSugarTest = dictionary["isFastingBloodSugarTest"] as? Bool
        randomBloodSugarTest = dictionary["randomBloodSugarTest"] as? Bool
        glucoseNotes = dictionary["glucoseNotes"] as? String
        bedTime = dictionary["bedTime"] as? String
        wakesUpAt = dictionary["wakesUpAt"] as? String
        restTime = dictionary["restTime"] as? String
        sleepNotes = dictionary["sleepNotes"] as? String
        laundryDoneById = dictionary["laundryDoneById"] as? Int
        loundryDoneBy = dictionary["loundryDoneBy"] as? String
        laundryNotes = dictionary["laundryNotes"] as? String
        loundryDays = dictionary["loundryDays"] as? String
        addedByName = dictionary["addedByName"] as? String
        createdDate = dictionary["createdDate"] as? String
    }

        
/**
    Returns the dictionary representation for the current instance.
    
    - returns: NSDictionary.
*/
    public func dictionaryRepresentation() -> NSDictionary {

        let dictionary = NSMutableDictionary()

        dictionary.setValue(self.id, forKey: "id")
        dictionary.setValue(self.patientID, forKey: "patientID")
        dictionary.setValue(self.carePlanMasterId, forKey: "carePlanMasterId")
        dictionary.setValue(self.oxygenTherapyId, forKey: "oxygenTherapyId")
        dictionary.setValue(self.amountLMin, forKey: "amountLMin")
        dictionary.setValue(self.deliveryId, forKey: "deliveryId")
        dictionary.setValue(self.delivaryName, forKey: "delivaryName")
        dictionary.setValue(self.oxygenSaturation, forKey: "oxygenSaturation")
        dictionary.setValue(self.isGlucosemonitoring, forKey: "isGlucosemonitoring")
        dictionary.setValue(self.isFastingBloodSugarTest, forKey: "isFastingBloodSugarTest")
        dictionary.setValue(self.randomBloodSugarTest, forKey: "randomBloodSugarTest")
        dictionary.setValue(self.glucoseNotes, forKey: "glucoseNotes")
        dictionary.setValue(self.bedTime, forKey: "bedTime")
        dictionary.setValue(self.wakesUpAt, forKey: "wakesUpAt")
        dictionary.setValue(self.restTime, forKey: "restTime")
        dictionary.setValue(self.sleepNotes, forKey: "sleepNotes")
        dictionary.setValue(self.laundryDoneById, forKey: "laundryDoneById")
        dictionary.setValue(self.loundryDoneBy, forKey: "loundryDoneBy")
        dictionary.setValue(self.laundryNotes, forKey: "laundryNotes")
        dictionary.setValue(self.loundryDays, forKey: "loundryDays")
        dictionary.setValue(self.addedByName, forKey: "addedByName")
        dictionary.setValue(self.createdDate, forKey: "createdDate")

        return dictionary
    }

}
