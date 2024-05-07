//
//  ConginitiveStatus.swift
//  AccessEMR
//
//  Created by Vasundhara Parakh on 3/6/20.
//  Copyright © 2020 smartData Enterprises (I) Ltd. All rights reserved.
//

import UIKit

public class ConginitiveStatus{
    public var id : Int?
    public var patientId : Int?
    public var createdDate : String?
    public var orientationID : Int?
    public var orientation : String?
    public var isOrientedToTime : Bool?
    public var isOrientedToPerson : Bool?
    public var isOrientedToPlace : Bool?
    public var isMemoryImpairedIssue : Bool?
    public var isPoorJudgementIssue : Bool?
    public var isUnableToFollowSimpleDirectionIssue : Bool?
    public var isBrainInjuredIssue : Bool?
    public var cognitiveStatusNotes : String?
    public var addedByName : String?

/**
    Returns an array of models based on given dictionary.
    
    Sample usage:
    let json4Swift_Base_list = Json4Swift_Base.modelsFromDictionaryArray(someDictionaryArrayFromJSON)

    - parameter array:  NSArray from JSON dictionary.

    - returns: Array of Json4Swift_Base Instances.
*/
    public class func modelsFromDictionaryArray(array:NSArray) -> [ConginitiveStatus]
    {
        var models:[ConginitiveStatus] = []
        for item in array
        {
            models.append(ConginitiveStatus(dictionary: item as! NSDictionary)!)
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
        orientationID = dictionary["orientationID"] as? Int
        orientation = dictionary["orientation"] as? String
        isOrientedToTime = dictionary["isOrientedToTime"] as? Bool
        isOrientedToPerson = dictionary["isOrientedToPerson"] as? Bool
        isOrientedToPlace = dictionary["isOrientedToPlace"] as? Bool
        isMemoryImpairedIssue = dictionary["isMemoryImpairedIssue"] as? Bool
        isPoorJudgementIssue = dictionary["isPoorJudgementIssue"] as? Bool
        isUnableToFollowSimpleDirectionIssue = dictionary["isUnableToFollowSimpleDirectionIssue"] as? Bool
        isBrainInjuredIssue = dictionary["isBrainInjuredIssue"] as? Bool
        cognitiveStatusNotes = dictionary["cognitiveStatusNotes"] as? String
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
        dictionary.setValue(self.orientationID, forKey: "orientationID")
        dictionary.setValue(self.orientation, forKey: "orientation")
        dictionary.setValue(self.isOrientedToTime, forKey: "isOrientedToTime")
        dictionary.setValue(self.isOrientedToPerson, forKey: "isOrientedToPerson")
        dictionary.setValue(self.isOrientedToPlace, forKey: "isOrientedToPlace")
        dictionary.setValue(self.isMemoryImpairedIssue, forKey: "isMemoryImpairedIssue")
        dictionary.setValue(self.isPoorJudgementIssue, forKey: "isPoorJudgementIssue")
        dictionary.setValue(self.isUnableToFollowSimpleDirectionIssue, forKey: "isUnableToFollowSimpleDirectionIssue")
        dictionary.setValue(self.isBrainInjuredIssue, forKey: "isBrainInjuredIssue")
        dictionary.setValue(self.cognitiveStatusNotes, forKey: "cognitiveStatusNotes")
        dictionary.setValue(self.addedByName, forKey: "addedByName")

        return dictionary
    }

}
