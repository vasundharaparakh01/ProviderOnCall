//
//  Communication.swift

//
//  Created by Vasundhara Parakh on 3/6/20.
//  Copyright © 2020 smartData Enterprises (I) Ltd. All rights reserved.
//

import UIKit

public class Communication {
    public var id : Int?
    public var patientId : Int?
    public var audiologist : String?
    public var hearingNotes : String?
    public var notesOnUnderstanding : String?
    public var rightHearingAid : Bool?
    public var rightAidSerialNumber : Int?
    public var leftHearingAid : Bool?
    public var leftAidSerialNumber : Int?
    public var usesAidsIndependently : Bool?
    public var isChangesBatteries : Bool?
    public var lastEarExamination : String?
    public var hearingAids : String?
    public var hearingType : String?
    public var hearingPerception : String?
    public var ableToUnderstandOthers : String?
    public var makesSelfUnderstood : String?
    public var visionNotes : String?
    public var isWearsContactLenses : Bool?
    public var isWearsGlasses : Bool?
    public var ophthalmologist : String?
    public var lastEyeExamination : String?
    public var createdDate : String?
    public var vision : String?
    public var eyeprosthesis : String?
    public var visualAcuity : String?
    public var isSpeaksEnglish : Bool?
    public var isUnderstandsEnglish : Bool?
    public var languageNotes : String?
    public var callBellNotes : String?
    public var isInterpreterNeeded : Bool?
    public var speechNotes : String?
    public var speech : String?
    public var callBellType : String?
    public var addedByName : String?
    public var languageName : String?

/**
    Returns an array of models based on given dictionary.
    
    Sample usage:
    let json4Swift_Base_list = Json4Swift_Base.modelsFromDictionaryArray(someDictionaryArrayFromJSON)

    - parameter array:  NSArray from JSON dictionary.

    - returns: Array of Json4Swift_Base Instances.
*/
    public class func modelsFromDictionaryArray(array:NSArray) -> [Communication]
    {
        var models:[Communication] = []
        for item in array
        {
            models.append(Communication(dictionary: item as! NSDictionary)!)
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
        audiologist = dictionary["audiologist"] as? String
        hearingNotes = dictionary["hearingNotes"] as? String
        notesOnUnderstanding = dictionary["notesOnUnderstanding"] as? String
        rightHearingAid = dictionary["rightHearingAid"] as? Bool
        rightAidSerialNumber = dictionary["rightAidSerialNumber"] as? Int
        leftHearingAid = dictionary["leftHearingAid"] as? Bool
        leftAidSerialNumber = dictionary["leftAidSerialNumber"] as? Int
        usesAidsIndependently = dictionary["usesAidsIndependently"] as? Bool
        isChangesBatteries = dictionary["isChangesBatteries"] as? Bool
        lastEarExamination = dictionary["lastEarExamination"] as? String
        hearingAids = dictionary["hearingAids"] as? String
        hearingType = dictionary["hearingType"] as? String
        hearingPerception = dictionary["hearingPerception"] as? String
        ableToUnderstandOthers = dictionary["ableToUnderstandOthers"] as? String
        makesSelfUnderstood = dictionary["makesSelfUnderstood"] as? String
        visionNotes = dictionary["visionNotes"] as? String
        isWearsContactLenses = dictionary["isWearsContactLenses"] as? Bool
        isWearsGlasses = dictionary["isWearsGlasses"] as? Bool
        ophthalmologist = dictionary["ophthalmologist"] as? String
        lastEyeExamination = dictionary["lastEyeExamination"] as? String
        createdDate = dictionary["createdDate"] as? String
        vision = dictionary["vision"] as? String
        eyeprosthesis = dictionary["eyeprosthesis"] as? String
        visualAcuity = dictionary["visualAcuity"] as? String
        isSpeaksEnglish = dictionary["isSpeaksEnglish"] as? Bool
        isUnderstandsEnglish = dictionary["isUnderstandsEnglish"] as? Bool
        languageNotes = dictionary["languageNotes"] as? String
        callBellNotes = dictionary["callBellNotes"] as? String
        isInterpreterNeeded = dictionary["isInterpreterNeeded"] as? Bool
        speechNotes = dictionary["speechNotes"] as? String
        speech = dictionary["speech"] as? String
        callBellType = dictionary["callBellType"] as? String
        addedByName = dictionary["addedByName"] as? String
        languageName = dictionary["languageName"] as? String
    }

        
/**
    Returns the dictionary representation for the current instance.
    
    - returns: NSDictionary.
*/
    public func dictionaryRepresentation() -> NSDictionary {

        let dictionary = NSMutableDictionary()

        dictionary.setValue(self.id, forKey: "id")
        dictionary.setValue(self.patientId, forKey: "patientId")
        dictionary.setValue(self.audiologist, forKey: "audiologist")
        dictionary.setValue(self.hearingNotes, forKey: "hearingNotes")
        dictionary.setValue(self.notesOnUnderstanding, forKey: "notesOnUnderstanding")
        dictionary.setValue(self.rightHearingAid, forKey: "rightHearingAid")
        dictionary.setValue(self.rightAidSerialNumber, forKey: "rightAidSerialNumber")
        dictionary.setValue(self.leftHearingAid, forKey: "leftHearingAid")
        dictionary.setValue(self.leftAidSerialNumber, forKey: "leftAidSerialNumber")
        dictionary.setValue(self.usesAidsIndependently, forKey: "usesAidsIndependently")
        dictionary.setValue(self.isChangesBatteries, forKey: "isChangesBatteries")
        dictionary.setValue(self.lastEarExamination, forKey: "lastEarExamination")
        dictionary.setValue(self.hearingAids, forKey: "hearingAids")
        dictionary.setValue(self.hearingType, forKey: "hearingType")
        dictionary.setValue(self.hearingPerception, forKey: "hearingPerception")
        dictionary.setValue(self.ableToUnderstandOthers, forKey: "ableToUnderstandOthers")
        dictionary.setValue(self.makesSelfUnderstood, forKey: "makesSelfUnderstood")
        dictionary.setValue(self.visionNotes, forKey: "visionNotes")
        dictionary.setValue(self.isWearsContactLenses, forKey: "isWearsContactLenses")
        dictionary.setValue(self.isWearsGlasses, forKey: "isWearsGlasses")
        dictionary.setValue(self.ophthalmologist, forKey: "ophthalmologist")
        dictionary.setValue(self.lastEyeExamination, forKey: "lastEyeExamination")
        dictionary.setValue(self.createdDate, forKey: "createdDate")
        dictionary.setValue(self.vision, forKey: "vision")
        dictionary.setValue(self.eyeprosthesis, forKey: "eyeprosthesis")
        dictionary.setValue(self.visualAcuity, forKey: "visualAcuity")
        dictionary.setValue(self.isSpeaksEnglish, forKey: "isSpeaksEnglish")
        dictionary.setValue(self.isUnderstandsEnglish, forKey: "isUnderstandsEnglish")
        dictionary.setValue(self.languageNotes, forKey: "languageNotes")
        dictionary.setValue(self.callBellNotes, forKey: "callBellNotes")
        dictionary.setValue(self.isInterpreterNeeded, forKey: "isInterpreterNeeded")
        dictionary.setValue(self.speechNotes, forKey: "speechNotes")
        dictionary.setValue(self.speech, forKey: "speech")
        dictionary.setValue(self.callBellType, forKey: "callBellType")
        dictionary.setValue(self.addedByName, forKey: "addedByName")
        dictionary.setValue(self.languageName, forKey: "languageName")

        return dictionary
    }

}
