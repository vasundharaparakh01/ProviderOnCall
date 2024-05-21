//
//  Mdeciation.swift
//  appName
//
//  Created by Vasundhara Parakh on 2/28/20.
//  Copyright © 2020 smartData Enterprises (I) Ltd. All rights reserved.
//

import UIKit

public class Medication{
    public var id : Int?
    public var patientId : Int?
    public var medicationName : String?
    public var dose : String?
    public var route : String?
    public var frequency : String?
    public var startDate : String?
    public var endDate : String?
    public var isActive : Bool?
    public var duration : String?
    public var durationType : String?
    public var indicationForUseName : String?
    public var prescriptionTypeName : String?
    public var transcriberName : String?
    public var prescriptionDate : String?
    public var typeofOrderName : String?
    public var treatmentType : String?
    public var statusName : String?

/**
    Returns an array of models based on given dictionary.
    
    Sample usage:
    let json4Swift_Base_list = Json4Swift_Base.modelsFromDictionaryArray(someDictionaryArrayFromJSON)

    - parameter array:  NSArray from JSON dictionary.

    - returns: Array of Json4Swift_Base Instances.
*/
    public class func modelsFromDictionaryArray(array:NSArray) -> [Medication]
    {
        var models:[Medication] = []
        for item in array
        {
            models.append(Medication(dictionary: item as! NSDictionary)!)
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
        medicationName = dictionary["medicationName"] as? String
        dose = dictionary["dose"] as? String
        route = dictionary["route"] as? String
        frequency = dictionary["frequency"] as? String
        startDate = dictionary["startDate"] as? String
        endDate = dictionary["endDate"] as? String
        isActive = dictionary["isActive"] as? Bool
        duration = dictionary["duration"] as? String
        durationType = dictionary["durationType"] as? String
        indicationForUseName = dictionary["indicationForUseName"] as? String
        prescriptionTypeName = dictionary["prescriptionTypeName"] as? String
        transcriberName = dictionary["transcriberName"] as? String
        prescriptionDate = dictionary["prescriptionDate"] as? String
        typeofOrderName = dictionary["typeofOrderName"] as? String
        treatmentType = dictionary["treatmentType"] as? String
        statusName = dictionary["statusName"] as? String

    }

        
/**
    Returns the dictionary representation for the current instance.
    
    - returns: NSDictionary.
*/
    public func dictionaryRepresentation() -> NSDictionary {

        let dictionary = NSMutableDictionary()

        dictionary.setValue(self.id, forKey: "id")
        dictionary.setValue(self.patientId, forKey: "patientId")
        dictionary.setValue(self.medicationName, forKey: "medicationName")
        dictionary.setValue(self.dose, forKey: "dose")
        dictionary.setValue(self.route, forKey: "route")
        dictionary.setValue(self.frequency, forKey: "frequency")
        dictionary.setValue(self.startDate, forKey: "startDate")
        dictionary.setValue(self.endDate, forKey: "endDate")
        dictionary.setValue(self.isActive, forKey: "isActive")
        dictionary.setValue(self.duration, forKey: "duration")
        dictionary.setValue(self.durationType, forKey: "durationType")
        dictionary.setValue(self.indicationForUseName, forKey: "indicationForUseName")
        dictionary.setValue(self.prescriptionTypeName, forKey: "prescriptionTypeName")
        dictionary.setValue(self.transcriberName, forKey: "transcriberName")
        dictionary.setValue(self.prescriptionDate, forKey: "prescriptionDate")
        dictionary.setValue(self.typeofOrderName, forKey: "typeofOrderName")
        dictionary.setValue(self.treatmentType, forKey: "treatmentType")

        return dictionary
    }

}
