//
//  ADLTrackingTool.swift
//  AccessEMR
//
//  Created by Vasundhara Parakh on 3/12/20.
//  Copyright © 2020 smartData Enterprises (I) Ltd. All rights reserved.
//

import UIKit

public class ADLTrackingTool {
    public var id : Int?
    public var movesInBedSelfPerformanceId : Int?
    public var movesInBedSupportProvidedId : Int?
    public var walksInRoomSelfPerformanceId : Int?
    public var walksInRoomSupportProvidedId : Int?
    public var walksInHallSelfPerformanceId : Int?
    public var walksInHallSupportProvidedId : Int?
    public var movesOnUnitSelfPerformanceId : Int?
    public var movesOnUnitSupportProvidedId : Int?
    public var movesOffUnitSelfPerformanceId : Int?
    public var movesOffUnitSupportProvidedId : Int?
    public var transferSelfPerformanceId : Int?
    public var transferSupportProvidedId : Int?
    public var dresesSelfPerformanceId : Int?
    public var dresesSupportProvidedId : Int?
    public var unDresesSelfPerformanceId : Int?
    public var unDresesSupportProvidedId : Int?
    public var eatAndDrinkSelfPerformanceId : Int?
    public var eatAndDrinkSupportProvidedId : Int?
    public var usesToiletSupportProvidedId : Int?
    public var usesToiletSelfPerformanceId : Int?
    public var personalHygieneSelfPerformanceId : Int?
    public var personalHygieneSupportProvidedId : Int?
    public var bathingSupportProvidedId : Int?
    public var bathingSelfPerformanceId : Int?
    public var bladderId : Int?
    public var bowelId : Int?
    public var notes : String?
    public var patientID : Int?
    public var isDraft : Bool?
    public var isActive : Bool?
    public var isDeleted : Bool?
    public var createdBy : Int?
    public var createdDate : String?

/**
    Returns an array of models based on given dictionary.
    
    Sample usage:
    let json4Swift_Base_list = Json4Swift_Base.modelsFromDictionaryArray(someDictionaryArrayFromJSON)

    - parameter array:  NSArray from JSON dictionary.

    - returns: Array of Json4Swift_Base Instances.
*/
    public class func modelsFromDictionaryArray(array:NSArray) -> [ADLTrackingTool]
    {
        var models:[ADLTrackingTool] = []
        for item in array
        {
            models.append(ADLTrackingTool(dictionary: item as! NSDictionary)!)
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
        movesInBedSelfPerformanceId = dictionary["movesInBedSelfPerformanceId"] as? Int
        movesInBedSupportProvidedId = dictionary["movesInBedSupportProvidedId"] as? Int
        walksInRoomSelfPerformanceId = dictionary["walksInRoomSelfPerformanceId"] as? Int
        walksInRoomSupportProvidedId = dictionary["walksInRoomSupportProvidedId"] as? Int
        walksInHallSelfPerformanceId = dictionary["walksInHallSelfPerformanceId"] as? Int
        walksInHallSupportProvidedId = dictionary["walksInHallSupportProvidedId"] as? Int
        movesOnUnitSelfPerformanceId = dictionary["movesOnUnitSelfPerformanceId"] as? Int
        movesOnUnitSupportProvidedId = dictionary["movesOnUnitSupportProvidedId"] as? Int
        movesOffUnitSelfPerformanceId = dictionary["movesOffUnitSelfPerformanceId"] as? Int
        movesOffUnitSupportProvidedId = dictionary["movesOffUnitSupportProvidedId"] as? Int
        transferSelfPerformanceId = dictionary["transferSelfPerformanceId"] as? Int
        transferSupportProvidedId = dictionary["transferSupportProvidedId"] as? Int
        dresesSelfPerformanceId = dictionary["dresesSelfPerformanceId"] as? Int
        dresesSupportProvidedId = dictionary["dresesSupportProvidedId"] as? Int
        unDresesSelfPerformanceId = dictionary["unDresesSelfPerformanceId"] as? Int
        unDresesSupportProvidedId = dictionary["unDresesSupportProvidedId"] as? Int
        eatAndDrinkSelfPerformanceId = dictionary["eatAndDrinkSelfPerformanceId"] as? Int
        eatAndDrinkSupportProvidedId = dictionary["eatAndDrinkSupportProvidedId"] as? Int
        usesToiletSupportProvidedId = dictionary["usesToiletSupportProvidedId"] as? Int
        usesToiletSelfPerformanceId = dictionary["usesToiletSelfPerformanceId"] as? Int
        personalHygieneSelfPerformanceId = dictionary["personalHygieneSelfPerformanceId"] as? Int
        personalHygieneSupportProvidedId = dictionary["personalHygieneSupportProvidedId"] as? Int
        bathingSupportProvidedId = dictionary["bathingSupportProvidedId"] as? Int
        bathingSelfPerformanceId = dictionary["bathingSelfPerformanceId"] as? Int
        bladderId = dictionary["bladderId"] as? Int
        bowelId = dictionary["bowelId"] as? Int
        notes = dictionary["notes"] as? String
        patientID = dictionary["patientID"] as? Int
        isDraft = dictionary["isDraft"] as? Bool
        isActive = dictionary["isActive"] as? Bool
        isDeleted = dictionary["isDeleted"] as? Bool
        createdBy = dictionary["createdBy"] as? Int
        createdDate = dictionary["createdDate"] as? String
    }

        
/**
    Returns the dictionary representation for the current instance.
    
    - returns: NSDictionary.
*/
    public func dictionaryRepresentation() -> NSDictionary {

        let dictionary = NSMutableDictionary()

        dictionary.setValue(self.id, forKey: "id")
        dictionary.setValue(self.movesInBedSelfPerformanceId, forKey: "movesInBedSelfPerformanceId")
        dictionary.setValue(self.movesInBedSupportProvidedId, forKey: "movesInBedSupportProvidedId")
        dictionary.setValue(self.walksInRoomSelfPerformanceId, forKey: "walksInRoomSelfPerformanceId")
        dictionary.setValue(self.walksInRoomSupportProvidedId, forKey: "walksInRoomSupportProvidedId")
        dictionary.setValue(self.walksInHallSelfPerformanceId, forKey: "walksInHallSelfPerformanceId")
        dictionary.setValue(self.walksInHallSupportProvidedId, forKey: "walksInHallSupportProvidedId")
        dictionary.setValue(self.movesOnUnitSelfPerformanceId, forKey: "movesOnUnitSelfPerformanceId")
        dictionary.setValue(self.movesOnUnitSupportProvidedId, forKey: "movesOnUnitSupportProvidedId")
        dictionary.setValue(self.movesOffUnitSelfPerformanceId, forKey: "movesOffUnitSelfPerformanceId")
        dictionary.setValue(self.movesOffUnitSupportProvidedId, forKey: "movesOffUnitSupportProvidedId")
        dictionary.setValue(self.transferSelfPerformanceId, forKey: "transferSelfPerformanceId")
        dictionary.setValue(self.transferSupportProvidedId, forKey: "transferSupportProvidedId")
        dictionary.setValue(self.dresesSelfPerformanceId, forKey: "dresesSelfPerformanceId")
        dictionary.setValue(self.dresesSupportProvidedId, forKey: "dresesSupportProvidedId")
        dictionary.setValue(self.unDresesSelfPerformanceId, forKey: "unDresesSelfPerformanceId")
        dictionary.setValue(self.unDresesSupportProvidedId, forKey: "unDresesSupportProvidedId")
        dictionary.setValue(self.eatAndDrinkSelfPerformanceId, forKey: "eatAndDrinkSelfPerformanceId")
        dictionary.setValue(self.eatAndDrinkSupportProvidedId, forKey: "eatAndDrinkSupportProvidedId")
        dictionary.setValue(self.usesToiletSupportProvidedId, forKey: "usesToiletSupportProvidedId")
        dictionary.setValue(self.usesToiletSelfPerformanceId, forKey: "usesToiletSelfPerformanceId")
        dictionary.setValue(self.personalHygieneSelfPerformanceId, forKey: "personalHygieneSelfPerformanceId")
        dictionary.setValue(self.personalHygieneSupportProvidedId, forKey: "personalHygieneSupportProvidedId")
        dictionary.setValue(self.bathingSupportProvidedId, forKey: "bathingSupportProvidedId")
        dictionary.setValue(self.bathingSelfPerformanceId, forKey: "bathingSelfPerformanceId")
        dictionary.setValue(self.bladderId, forKey: "bladderId")
        dictionary.setValue(self.bowelId, forKey: "bowelId")
        dictionary.setValue(self.notes, forKey: "notes")
        dictionary.setValue(self.patientID, forKey: "patientID")
        dictionary.setValue(self.isDraft, forKey: "isDraft")
        dictionary.setValue(self.isActive, forKey: "isActive")
        dictionary.setValue(self.isDeleted, forKey: "isDeleted")
        dictionary.setValue(self.createdBy, forKey: "createdBy")
        dictionary.setValue(self.createdDate, forKey: "createdDate")

        return dictionary
    }

}
/*{
    public var id : Int?
    public var bathingId : Int?
    public var bathingSelfValue : String?
    public var bathingSupportValue : String?
    public var movesInBedSelfValue : String?
    public var movesInBedSupportValue : String?
    public var movesInBedId : Int?
    public var walksInRoomSelfValue : String?
    public var walksInRoomSupportValue : String?
    public var walksInHallSelfValue : String?
    public var walksInHallSupportValue : String?
    public var movesOnUnitSelfValue : String?
    public var movesOnUnitSupportValue : String?
    public var movesOffUnitSelfValue : String?
    public var movesOffUnitSupportValue : String?
    public var dresesSelfValue : String?
    public var dresesSupportValue : String?
    public var unDresesSelfValue : String?
    public var unDresesSupportValue : String?
    public var eatAndDrinkValue : String?
    public var eatAndDrinkSuportValue : String?
    public var usesToiletSelfValue : String?
    public var usesToiletSupportValue : String?
    public var personalHygieneSelfValue : String?
    public var personalHygieneSupportValue : String?
    public var transferSupportValue : String?
    public var transferSelfValue : String?
    public var bladderValue : String?
    public var bowelValue : String?
    public var walksInRoomId : Int?
    public var walksInHallId : Int?
    public var movesOnUnitId : Int?
    public var movesOffUnitId : Int?
    public var dresesId : Int?
    public var unDresesId : Int?
    public var eatAndDrinkId : Int?
    public var usesToiletId : Int?
    public var personalHygieneId : Int?
    public var breakfastId : Int?
    public var afterBreakfastSnackId : Int?
    public var lunchId : Int?
    public var afterLunchSnackId : Int?
    public var supperId : Int?
    public var supperSnackId : Int?
    public var bladderId : Int?
    public var bladder : String?
    public var bowelId : Int?
    public var bowel : String?
    public var createdDate : String?

/**
    Returns an array of models based on given dictionary.
    
    Sample usage:
    let json4Swift_Base_list = Json4Swift_Base.modelsFromDictionaryArray(someDictionaryArrayFromJSON)

    - parameter array:  NSArray from JSON dictionary.

    - returns: Array of Json4Swift_Base Instances.
*/
    public class func modelsFromDictionaryArray(array:NSArray) -> [ADLTrackingTool]
    {
        var models:[ADLTrackingTool] = []
        for item in array
        {
            models.append(ADLTrackingTool(dictionary: item as! NSDictionary)!)
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
        bathingId = dictionary["bathingId"] as? Int
        bathingSelfValue = dictionary["bathingSelfValue"] as? String
        bathingSupportValue = dictionary["bathingSupportValue"] as? String
        movesInBedSelfValue = dictionary["movesInBedSelfValue"] as? String
        movesInBedSupportValue = dictionary["movesInBedSupportValue"] as? String
        movesInBedId = dictionary["movesInBedId"] as? Int
        walksInRoomSelfValue = dictionary["walksInRoomSelfValue"] as? String
        walksInRoomSupportValue = dictionary["walksInRoomSupportValue"] as? String
        walksInHallSelfValue = dictionary["walksInHallSelfValue"] as? String
        walksInHallSupportValue = dictionary["walksInHallSupportValue"] as? String
        movesOnUnitSelfValue = dictionary["movesOnUnitSelfValue"] as? String
        movesOnUnitSupportValue = dictionary["movesOnUnitSupportValue"] as? String
        movesOffUnitSelfValue = dictionary["movesOffUnitSelfValue"] as? String
        movesOffUnitSupportValue = dictionary["movesOffUnitSupportValue"] as? String
        dresesSelfValue = dictionary["dresesSelfValue"] as? String
        dresesSupportValue = dictionary["dresesSupportValue"] as? String
        unDresesSelfValue = dictionary["unDresesSelfValue"] as? String
        unDresesSupportValue = dictionary["unDresesSupportValue"] as? String
        eatAndDrinkValue = dictionary["eatAndDrinkValue"] as? String
        eatAndDrinkSuportValue = dictionary["eatAndDrinkSuportValue"] as? String
        usesToiletSelfValue = dictionary["usesToiletSelfValue"] as? String
        usesToiletSupportValue = dictionary["usesToiletSupportValue"] as? String
        personalHygieneSelfValue = dictionary["personalHygieneSelfValue"] as? String
        personalHygieneSupportValue = dictionary["personalHygieneSupportValue"] as? String
        transferSupportValue = dictionary["transferSupportValue"] as? String
        transferSelfValue = dictionary["transferSelfValue"] as? String
        bladderValue = dictionary["bladderValue"] as? String
        bowelValue = dictionary["bowelValue"] as? String
        walksInRoomId = dictionary["walksInRoomId"] as? Int
        walksInHallId = dictionary["walksInHallId"] as? Int
        movesOnUnitId = dictionary["movesOnUnitId"] as? Int
        movesOffUnitId = dictionary["movesOffUnitId"] as? Int
        dresesId = dictionary["dresesId"] as? Int
        unDresesId = dictionary["unDresesId"] as? Int
        eatAndDrinkId = dictionary["eatAndDrinkId"] as? Int
        usesToiletId = dictionary["usesToiletId"] as? Int
        personalHygieneId = dictionary["personalHygieneId"] as? Int
        breakfastId = dictionary["breakfastId"] as? Int
        afterBreakfastSnackId = dictionary["afterBreakfastSnackId"] as? Int
        lunchId = dictionary["lunchId"] as? Int
        afterLunchSnackId = dictionary["afterLunchSnackId"] as? Int
        supperId = dictionary["supperId"] as? Int
        supperSnackId = dictionary["supperSnackId"] as? Int
        bladderId = dictionary["bladderId"] as? Int
        bladder = dictionary["bladder"] as? String
        bowelId = dictionary["bowelId"] as? Int
        bowel = dictionary["bowel"] as? String
        createdDate = dictionary["createdDate"] as? String
    }

        
/**
    Returns the dictionary representation for the current instance.
    
    - returns: NSDictionary.
*/
    public func dictionaryRepresentation() -> NSDictionary {

        let dictionary = NSMutableDictionary()

        dictionary.setValue(self.id, forKey: "id")
        dictionary.setValue(self.bathingId, forKey: "bathingId")
        dictionary.setValue(self.bathingSelfValue, forKey: "bathingSelfValue")
        dictionary.setValue(self.bathingSupportValue, forKey: "bathingSupportValue")
        dictionary.setValue(self.movesInBedSelfValue, forKey: "movesInBedSelfValue")
        dictionary.setValue(self.movesInBedSupportValue, forKey: "movesInBedSupportValue")
        dictionary.setValue(self.movesInBedId, forKey: "movesInBedId")
        dictionary.setValue(self.walksInRoomSelfValue, forKey: "walksInRoomSelfValue")
        dictionary.setValue(self.walksInRoomSupportValue, forKey: "walksInRoomSupportValue")
        dictionary.setValue(self.walksInHallSelfValue, forKey: "walksInHallSelfValue")
        dictionary.setValue(self.walksInHallSupportValue, forKey: "walksInHallSupportValue")
        dictionary.setValue(self.movesOnUnitSelfValue, forKey: "movesOnUnitSelfValue")
        dictionary.setValue(self.movesOnUnitSupportValue, forKey: "movesOnUnitSupportValue")
        dictionary.setValue(self.movesOffUnitSelfValue, forKey: "movesOffUnitSelfValue")
        dictionary.setValue(self.movesOffUnitSupportValue, forKey: "movesOffUnitSupportValue")
        dictionary.setValue(self.dresesSelfValue, forKey: "dresesSelfValue")
        dictionary.setValue(self.dresesSupportValue, forKey: "dresesSupportValue")
        dictionary.setValue(self.unDresesSelfValue, forKey: "unDresesSelfValue")
        dictionary.setValue(self.unDresesSupportValue, forKey: "unDresesSupportValue")
        dictionary.setValue(self.eatAndDrinkValue, forKey: "eatAndDrinkValue")
        dictionary.setValue(self.eatAndDrinkSuportValue, forKey: "eatAndDrinkSuportValue")
        dictionary.setValue(self.usesToiletSelfValue, forKey: "usesToiletSelfValue")
        dictionary.setValue(self.usesToiletSupportValue, forKey: "usesToiletSupportValue")
        dictionary.setValue(self.personalHygieneSelfValue, forKey: "personalHygieneSelfValue")
        dictionary.setValue(self.personalHygieneSupportValue, forKey: "personalHygieneSupportValue")
        dictionary.setValue(self.transferSupportValue, forKey: "transferSupportValue")
        dictionary.setValue(self.transferSelfValue, forKey: "transferSelfValue")
        dictionary.setValue(self.bladderValue, forKey: "bladderValue")
        dictionary.setValue(self.bowelValue, forKey: "bowelValue")
        dictionary.setValue(self.walksInRoomId, forKey: "walksInRoomId")
        dictionary.setValue(self.walksInHallId, forKey: "walksInHallId")
        dictionary.setValue(self.movesOnUnitId, forKey: "movesOnUnitId")
        dictionary.setValue(self.movesOffUnitId, forKey: "movesOffUnitId")
        dictionary.setValue(self.dresesId, forKey: "dresesId")
        dictionary.setValue(self.unDresesId, forKey: "unDresesId")
        dictionary.setValue(self.eatAndDrinkId, forKey: "eatAndDrinkId")
        dictionary.setValue(self.usesToiletId, forKey: "usesToiletId")
        dictionary.setValue(self.personalHygieneId, forKey: "personalHygieneId")
        dictionary.setValue(self.breakfastId, forKey: "breakfastId")
        dictionary.setValue(self.afterBreakfastSnackId, forKey: "afterBreakfastSnackId")
        dictionary.setValue(self.lunchId, forKey: "lunchId")
        dictionary.setValue(self.afterLunchSnackId, forKey: "afterLunchSnackId")
        dictionary.setValue(self.supperId, forKey: "supperId")
        dictionary.setValue(self.supperSnackId, forKey: "supperSnackId")
        dictionary.setValue(self.bladderId, forKey: "bladderId")
        dictionary.setValue(self.bladder, forKey: "bladder")
        dictionary.setValue(self.bowelId, forKey: "bowelId")
        dictionary.setValue(self.bowel, forKey: "bowel")
        dictionary.setValue(self.createdDate, forKey: "createdDate")

        return dictionary
    }

}
*/
