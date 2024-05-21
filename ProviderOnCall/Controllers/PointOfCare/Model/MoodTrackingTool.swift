//
//  MoodTrackingTool.swift
//  appName
//
//  Created by Vasundhara Parakh on 3/12/20.
//  Copyright © 2020 smartData Enterprises (I) Ltd. All rights reserved.
//

import UIKit

public class MoodTrackingTool{
    public var id : Int?
    public var patientID : Int?
    public var makeNegativeStatementId : Int?
    public var repetativeQuestionId : Int?
    public var repetativeVerbilizationId : Int?
    public var persistAngerId : Int?
    public var runSelfDownId : Int?
    public var expressUnrealisticFearId : Int?
    public var makeRecurrentStatementId : Int?
    public var frequentlyComplainAboutHealthId : Int?
    public var anxiousComplaintsId : Int?
    public var facialExpressionsId : Int?
    public var cryingOrTearfulnessId : Int?
    public var repetitivePhysicalMovementId : Int?
    public var withdrawnOrdisinterestedInSurroundingsId : Int?
    public var decreasedSocialInteractionId : Int?
    public var wandersWithNoRationalPurposeId : Int?
    public var screamsOrThreatensCursesId : Int?
    public var hitsOrShovesOrScratchesId : Int?
    public var sociallyInappropriateId : Int?
    public var resistCareId : Int?
    public var ratingOfPainId : Int?
    public var ratingOfPainRating : Int?
    public var sleptOrDozedMoreThanOneHourThisShiftId : Int?
    public var spentTimeInLeisureActivitiesPursuitOwnInterestId : Int?
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
    public class func modelsFromDictionaryArray(array:NSArray) -> [MoodTrackingTool]
    {
        var models:[MoodTrackingTool] = []
        for item in array
        {
            models.append(MoodTrackingTool(dictionary: item as! NSDictionary)!)
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
        makeNegativeStatementId = dictionary["makeNegativeStatementId"] as? Int
        repetativeQuestionId = dictionary["repetativeQuestionId"] as? Int
        repetativeVerbilizationId = dictionary["repetativeVerbilizationId"] as? Int
        persistAngerId = dictionary["persistAngerId"] as? Int
        runSelfDownId = dictionary["runSelfDownId"] as? Int
        expressUnrealisticFearId = dictionary["expressUnrealisticFearId"] as? Int
        makeRecurrentStatementId = dictionary["makeRecurrentStatementId"] as? Int
        frequentlyComplainAboutHealthId = dictionary["frequentlyComplainAboutHealthId"] as? Int
        anxiousComplaintsId = dictionary["anxiousComplaintsId"] as? Int
        facialExpressionsId = dictionary["facialExpressionsId"] as? Int
        cryingOrTearfulnessId = dictionary["cryingOrTearfulnessId"] as? Int
        repetitivePhysicalMovementId = dictionary["repetitivePhysicalMovementId"] as? Int
        withdrawnOrdisinterestedInSurroundingsId = dictionary["withdrawnOrdisinterestedInSurroundingsId"] as? Int
        decreasedSocialInteractionId = dictionary["decreasedSocialInteractionId"] as? Int
        wandersWithNoRationalPurposeId = dictionary["wandersWithNoRationalPurposeId"] as? Int
        screamsOrThreatensCursesId = dictionary["screamsOrThreatensCursesId"] as? Int
        hitsOrShovesOrScratchesId = dictionary["hitsOrShovesOrScratchesId"] as? Int
        sociallyInappropriateId = dictionary["sociallyInappropriateId"] as? Int
        resistCareId = dictionary["resistCareId"] as? Int
        ratingOfPainId = dictionary["ratingOfPainId"] as? Int
        ratingOfPainRating = dictionary["ratingOfPainRating"] as? Int
        sleptOrDozedMoreThanOneHourThisShiftId = dictionary["sleptOrDozedMoreThanOneHourThisShiftId"] as? Int
        spentTimeInLeisureActivitiesPursuitOwnInterestId = dictionary["spentTimeInLeisureActivitiesPursuitOwnInterestId"] as? Int
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
        dictionary.setValue(self.patientID, forKey: "patientID")
        dictionary.setValue(self.makeNegativeStatementId, forKey: "makeNegativeStatementId")
        dictionary.setValue(self.repetativeQuestionId, forKey: "repetativeQuestionId")
        dictionary.setValue(self.repetativeVerbilizationId, forKey: "repetativeVerbilizationId")
        dictionary.setValue(self.persistAngerId, forKey: "persistAngerId")
        dictionary.setValue(self.runSelfDownId, forKey: "runSelfDownId")
        dictionary.setValue(self.expressUnrealisticFearId, forKey: "expressUnrealisticFearId")
        dictionary.setValue(self.makeRecurrentStatementId, forKey: "makeRecurrentStatementId")
        dictionary.setValue(self.frequentlyComplainAboutHealthId, forKey: "frequentlyComplainAboutHealthId")
        dictionary.setValue(self.anxiousComplaintsId, forKey: "anxiousComplaintsId")
        dictionary.setValue(self.facialExpressionsId, forKey: "facialExpressionsId")
        dictionary.setValue(self.cryingOrTearfulnessId, forKey: "cryingOrTearfulnessId")
        dictionary.setValue(self.repetitivePhysicalMovementId, forKey: "repetitivePhysicalMovementId")
        dictionary.setValue(self.withdrawnOrdisinterestedInSurroundingsId, forKey: "withdrawnOrdisinterestedInSurroundingsId")
        dictionary.setValue(self.decreasedSocialInteractionId, forKey: "decreasedSocialInteractionId")
        dictionary.setValue(self.wandersWithNoRationalPurposeId, forKey: "wandersWithNoRationalPurposeId")
        dictionary.setValue(self.screamsOrThreatensCursesId, forKey: "screamsOrThreatensCursesId")
        dictionary.setValue(self.hitsOrShovesOrScratchesId, forKey: "hitsOrShovesOrScratchesId")
        dictionary.setValue(self.sociallyInappropriateId, forKey: "sociallyInappropriateId")
        dictionary.setValue(self.resistCareId, forKey: "resistCareId")
        dictionary.setValue(self.ratingOfPainId, forKey: "ratingOfPainId")
        dictionary.setValue(self.ratingOfPainRating, forKey: "ratingOfPainRating")
        dictionary.setValue(self.sleptOrDozedMoreThanOneHourThisShiftId, forKey: "sleptOrDozedMoreThanOneHourThisShiftId")
        dictionary.setValue(self.spentTimeInLeisureActivitiesPursuitOwnInterestId, forKey: "spentTimeInLeisureActivitiesPursuitOwnInterestId")
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
    public var patientID : Int?
    public var anxiousComplaints : String?
    public var anxiousComplaintsValue : String?
    public var anxiousComplaintsId : Int?
    public var cryingOrTearfulness : String?
    public var persistentAngerValue : String?
    public var cryingOrTearfulnessValue : String?
    public var cryingOrTearfulnessId : Int?
    public var decreasedSocialInteraction : String?
    public var decreasedSocialInteractionValue : String?
    public var decreasedSocialInteractionId : Int?
    public var expressUnrealisticFear : String?
    public var expressUnrealisticFearValue : String?
    public var expressUnrealisticFearId : Int?
    public var facialExpression : String?
    public var facialExpressionValue : String?
    public var facialExpressionId : Int?
    public var frequentlyComplainAboutHealth : String?
    public var frequentlyComplainAboutHealthValue : String?
    public var frequentlyComplainAboutHealthId : Int?
    public var hitsOrShovesOrScratches : String?
    public var hitsOrShovesOrScratchesValue : String?
    public var hitsOrShovesOrScratchesId : Int?
    public var makeNegativeStatement : String?
    public var makeNegativeStatementValue : String?
    public var makeNegativeStatementId : Int?
    public var makeRecurrentStatement : String?
    public var makeRecurrentStatementValue : String?
    public var makeRecurrentStatementId : Int?
    public var ratingOfPain : String?
    public var ratingOfPainValue : String?
    public var ratingOfPainId : Int?
    public var repetativeQuestion : String?
    public var repetativeQuestionValue : String?
    public var repetativeQuestionId : Int?
    public var repetativeVerbilization : String?
    public var repetativeVerbilizationValue : String?
    public var repetativeVerbilizationId : Int?
    public var repetitivePhysicalMovement : String?
    public var repetitivePhysicalMovementValue : String?
    public var repetitivePhysicalMovementId : Int?
    public var resistCare : String?
    public var resistCareValue : String?
    public var resistCareId : Int?
    public var runSelfDown : String?
    public var runSelfDownValue : String?
    public var runSelfDownId : Int?
    public var screamsOrThreatensCurses : String?
    public var screamsOrThreatensCursesValue : String?
    public var screamsOrThreatensCursesId : Int?
    public var sleptOrDozedMoreThanOneHourThisShift : String?
    public var sleptOrDozedMoreThanOneHourThisShiftValue : String?
    public var sleptOrDozedMoreThanOneHourThisShiftId : Int?
    public var sociallyInappropriate : String?
    public var sociallyInappropriateValue : String?
    public var sociallyInappropriateId : Int?
    public var spentTimeInLeisureActivitiesPursuitOwnInterest : String?
    public var spentTimeInLeisureActivitiesPursuitOwnInterestValue : String?
    public var spentTimeInLeisureActivitiesPursuitOwnInterestId : Int?
    public var wandersWithNoRationalPurpose : String?
    public var wandersWithNoRationalPurposeValue : String?
    public var wandersWithNoRationalPurposeId : Int?
    public var withdrawnOrdisinterestedInSurroundings : String?
    public var withdrawnOrdisinterestedInSurroundingsValue : String?
    public var withdrawnOrdisinterestedInSurroundingsId : Int?

/**
    Returns an array of models based on given dictionary.
    
    Sample usage:
    let json4Swift_Base_list = Json4Swift_Base.modelsFromDictionaryArray(someDictionaryArrayFromJSON)

    - parameter array:  NSArray from JSON dictionary.

    - returns: Array of Json4Swift_Base Instances.
*/
    public class func modelsFromDictionaryArray(array:NSArray) -> [MoodTrackingTool]
    {
        var models:[MoodTrackingTool] = []
        for item in array
        {
            models.append(MoodTrackingTool(dictionary: item as! NSDictionary)!)
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
        anxiousComplaints = dictionary["anxiousComplaints"] as? String
        anxiousComplaintsValue = dictionary["anxiousComplaintsValue"] as? String
        anxiousComplaintsId = dictionary["anxiousComplaintsId"] as? Int
        cryingOrTearfulness = dictionary["cryingOrTearfulness"] as? String
        cryingOrTearfulnessValue = dictionary["cryingOrTearfulnessValue"] as? String
        cryingOrTearfulnessId = dictionary["cryingOrTearfulnessId"] as? Int
        decreasedSocialInteraction = dictionary["decreasedSocialInteraction"] as? String
        decreasedSocialInteractionValue = dictionary["decreasedSocialInteractionValue"] as? String
        decreasedSocialInteractionId = dictionary["decreasedSocialInteractionId"] as? Int
        expressUnrealisticFear = dictionary["expressUnrealisticFear"] as? String
        expressUnrealisticFearValue = dictionary["expressUnrealisticFearValue"] as? String
        expressUnrealisticFearId = dictionary["expressUnrealisticFearId"] as? Int
        facialExpression = dictionary["facialExpression"] as? String
        facialExpressionValue = dictionary["facialExpressionValue"] as? String
        facialExpressionId = dictionary["facialExpressionId"] as? Int
        frequentlyComplainAboutHealth = dictionary["frequentlyComplainAboutHealth"] as? String
        frequentlyComplainAboutHealthValue = dictionary["frequentlyComplainAboutHealthValue"] as? String
        frequentlyComplainAboutHealthId = dictionary["frequentlyComplainAboutHealthId"] as? Int
        hitsOrShovesOrScratches = dictionary["hitsOrShovesOrScratches"] as? String
        hitsOrShovesOrScratchesValue = dictionary["hitsOrShovesOrScratchesValue"] as? String
        hitsOrShovesOrScratchesId = dictionary["hitsOrShovesOrScratchesId"] as? Int
        makeNegativeStatement = dictionary["makeNegativeStatement"] as? String
        makeNegativeStatementValue = dictionary["makeNegativeStatementValue"] as? String
        makeNegativeStatementId = dictionary["makeNegativeStatementId"] as? Int
        makeRecurrentStatement = dictionary["makeRecurrentStatement"] as? String
        makeRecurrentStatementValue = dictionary["makeRecurrentStatementValue"] as? String
        makeRecurrentStatementId = dictionary["makeRecurrentStatementId"] as? Int
        ratingOfPain = dictionary["ratingOfPain"] as? String
        ratingOfPainValue = dictionary["ratingOfPainValue"] as? String
        ratingOfPainId = dictionary["ratingOfPainId"] as? Int
        repetativeQuestion = dictionary["repetativeQuestion"] as? String
        repetativeQuestionValue = dictionary["repetativeQuestionValue"] as? String
        repetativeQuestionId = dictionary["repetativeQuestionId"] as? Int
        repetativeVerbilization = dictionary["repetativeVerbilization"] as? String
        repetativeVerbilizationValue = dictionary["repetativeVerbilizationValue"] as? String
        repetativeVerbilizationId = dictionary["repetativeVerbilizationId"] as? Int
        repetitivePhysicalMovement = dictionary["repetitivePhysicalMovement"] as? String
        repetitivePhysicalMovementValue = dictionary["repetitivePhysicalMovementValue"] as? String
        repetitivePhysicalMovementId = dictionary["repetitivePhysicalMovementId"] as? Int
        resistCare = dictionary["resistCare"] as? String
        resistCareValue = dictionary["resistCareValue"] as? String
        resistCareId = dictionary["resistCareId"] as? Int
        runSelfDown = dictionary["runSelfDown"] as? String
        runSelfDownValue = dictionary["runSelfDownValue"] as? String
        runSelfDownId = dictionary["runSelfDownId"] as? Int
        screamsOrThreatensCurses = dictionary["screamsOrThreatensCurses"] as? String
        screamsOrThreatensCursesValue = dictionary["screamsOrThreatensCursesValue"] as? String
        screamsOrThreatensCursesId = dictionary["screamsOrThreatensCursesId"] as? Int
        sleptOrDozedMoreThanOneHourThisShift = dictionary["sleptOrDozedMoreThanOneHourThisShift"] as? String
        sleptOrDozedMoreThanOneHourThisShiftValue = dictionary["sleptOrDozedMoreThanOneHourThisShiftValue"] as? String
        sleptOrDozedMoreThanOneHourThisShiftId = dictionary["sleptOrDozedMoreThanOneHourThisShiftId"] as? Int
        sociallyInappropriate = dictionary["sociallyInappropriate"] as? String
        sociallyInappropriateValue = dictionary["sociallyInappropriateValue"] as? String
        sociallyInappropriateId = dictionary["sociallyInappropriateId"] as? Int
        spentTimeInLeisureActivitiesPursuitOwnInterest = dictionary["spentTimeInLeisureActivitiesPursuitOwnInterest"] as? String
        spentTimeInLeisureActivitiesPursuitOwnInterestValue = dictionary["spentTimeInLeisureActivitiesPursuitOwnInterestValue"] as? String
        spentTimeInLeisureActivitiesPursuitOwnInterestId = dictionary["spentTimeInLeisureActivitiesPursuitOwnInterestId"] as? Int
        wandersWithNoRationalPurpose = dictionary["wandersWithNoRationalPurpose"] as? String
        wandersWithNoRationalPurposeValue = dictionary["wandersWithNoRationalPurposeValue"] as? String
        wandersWithNoRationalPurposeId = dictionary["wandersWithNoRationalPurposeId"] as? Int
        withdrawnOrdisinterestedInSurroundings = dictionary["withdrawnOrdisinterestedInSurroundings"] as? String
        withdrawnOrdisinterestedInSurroundingsValue = dictionary["withdrawnOrdisinterestedInSurroundingsValue"] as? String
        withdrawnOrdisinterestedInSurroundingsId = dictionary["withdrawnOrdisinterestedInSurroundingsId"] as? Int
        persistentAngerValue = dictionary["persistentAngerValue"] as? String
    }

        
/**
    Returns the dictionary representation for the current instance.
    
    - returns: NSDictionary.
*/
    public func dictionaryRepresentation() -> NSDictionary {

        let dictionary = NSMutableDictionary()

        dictionary.setValue(self.id, forKey: "id")
        dictionary.setValue(self.patientID, forKey: "patientID")
        dictionary.setValue(self.anxiousComplaints, forKey: "anxiousComplaints")
        dictionary.setValue(self.anxiousComplaintsValue, forKey: "anxiousComplaintsValue")
        dictionary.setValue(self.anxiousComplaintsId, forKey: "anxiousComplaintsId")
        dictionary.setValue(self.cryingOrTearfulness, forKey: "cryingOrTearfulness")
        dictionary.setValue(self.cryingOrTearfulnessValue, forKey: "cryingOrTearfulnessValue")
        dictionary.setValue(self.cryingOrTearfulnessId, forKey: "cryingOrTearfulnessId")
        dictionary.setValue(self.decreasedSocialInteraction, forKey: "decreasedSocialInteraction")
        dictionary.setValue(self.decreasedSocialInteractionValue, forKey: "decreasedSocialInteractionValue")
        dictionary.setValue(self.decreasedSocialInteractionId, forKey: "decreasedSocialInteractionId")
        dictionary.setValue(self.expressUnrealisticFear, forKey: "expressUnrealisticFear")
        dictionary.setValue(self.expressUnrealisticFearValue, forKey: "expressUnrealisticFearValue")
        dictionary.setValue(self.expressUnrealisticFearId, forKey: "expressUnrealisticFearId")
        dictionary.setValue(self.facialExpression, forKey: "facialExpression")
        dictionary.setValue(self.facialExpressionValue, forKey: "facialExpressionValue")
        dictionary.setValue(self.facialExpressionId, forKey: "facialExpressionId")
        dictionary.setValue(self.frequentlyComplainAboutHealth, forKey: "frequentlyComplainAboutHealth")
        dictionary.setValue(self.frequentlyComplainAboutHealthValue, forKey: "frequentlyComplainAboutHealthValue")
        dictionary.setValue(self.frequentlyComplainAboutHealthId, forKey: "frequentlyComplainAboutHealthId")
        dictionary.setValue(self.hitsOrShovesOrScratches, forKey: "hitsOrShovesOrScratches")
        dictionary.setValue(self.hitsOrShovesOrScratchesValue, forKey: "hitsOrShovesOrScratchesValue")
        dictionary.setValue(self.hitsOrShovesOrScratchesId, forKey: "hitsOrShovesOrScratchesId")
        dictionary.setValue(self.makeNegativeStatement, forKey: "makeNegativeStatement")
        dictionary.setValue(self.makeNegativeStatementValue, forKey: "makeNegativeStatementValue")
        dictionary.setValue(self.makeNegativeStatementId, forKey: "makeNegativeStatementId")
        dictionary.setValue(self.makeRecurrentStatement, forKey: "makeRecurrentStatement")
        dictionary.setValue(self.makeRecurrentStatementValue, forKey: "makeRecurrentStatementValue")
        dictionary.setValue(self.makeRecurrentStatementId, forKey: "makeRecurrentStatementId")
        dictionary.setValue(self.ratingOfPain, forKey: "ratingOfPain")
        dictionary.setValue(self.ratingOfPainValue, forKey: "ratingOfPainValue")
        dictionary.setValue(self.ratingOfPainId, forKey: "ratingOfPainId")
        dictionary.setValue(self.repetativeQuestion, forKey: "repetativeQuestion")
        dictionary.setValue(self.repetativeQuestionValue, forKey: "repetativeQuestionValue")
        dictionary.setValue(self.repetativeQuestionId, forKey: "repetativeQuestionId")
        dictionary.setValue(self.repetativeVerbilization, forKey: "repetativeVerbilization")
        dictionary.setValue(self.repetativeVerbilizationValue, forKey: "repetativeVerbilizationValue")
        dictionary.setValue(self.repetativeVerbilizationId, forKey: "repetativeVerbilizationId")
        dictionary.setValue(self.repetitivePhysicalMovement, forKey: "repetitivePhysicalMovement")
        dictionary.setValue(self.repetitivePhysicalMovementValue, forKey: "repetitivePhysicalMovementValue")
        dictionary.setValue(self.repetitivePhysicalMovementId, forKey: "repetitivePhysicalMovementId")
        dictionary.setValue(self.resistCare, forKey: "resistCare")
        dictionary.setValue(self.resistCareValue, forKey: "resistCareValue")
        dictionary.setValue(self.resistCareId, forKey: "resistCareId")
        dictionary.setValue(self.runSelfDown, forKey: "runSelfDown")
        dictionary.setValue(self.runSelfDownValue, forKey: "runSelfDownValue")
        dictionary.setValue(self.runSelfDownId, forKey: "runSelfDownId")
        dictionary.setValue(self.screamsOrThreatensCurses, forKey: "screamsOrThreatensCurses")
        dictionary.setValue(self.screamsOrThreatensCursesValue, forKey: "screamsOrThreatensCursesValue")
        dictionary.setValue(self.screamsOrThreatensCursesId, forKey: "screamsOrThreatensCursesId")
        dictionary.setValue(self.sleptOrDozedMoreThanOneHourThisShift, forKey: "sleptOrDozedMoreThanOneHourThisShift")
        dictionary.setValue(self.sleptOrDozedMoreThanOneHourThisShiftValue, forKey: "sleptOrDozedMoreThanOneHourThisShiftValue")
        dictionary.setValue(self.sleptOrDozedMoreThanOneHourThisShiftId, forKey: "sleptOrDozedMoreThanOneHourThisShiftId")
        dictionary.setValue(self.sociallyInappropriate, forKey: "sociallyInappropriate")
        dictionary.setValue(self.sociallyInappropriateValue, forKey: "sociallyInappropriateValue")
        dictionary.setValue(self.sociallyInappropriateId, forKey: "sociallyInappropriateId")
        dictionary.setValue(self.spentTimeInLeisureActivitiesPursuitOwnInterest, forKey: "spentTimeInLeisureActivitiesPursuitOwnInterest")
        dictionary.setValue(self.spentTimeInLeisureActivitiesPursuitOwnInterestValue, forKey: "spentTimeInLeisureActivitiesPursuitOwnInterestValue")
        dictionary.setValue(self.spentTimeInLeisureActivitiesPursuitOwnInterestId, forKey: "spentTimeInLeisureActivitiesPursuitOwnInterestId")
        dictionary.setValue(self.wandersWithNoRationalPurpose, forKey: "wandersWithNoRationalPurpose")
        dictionary.setValue(self.wandersWithNoRationalPurposeValue, forKey: "wandersWithNoRationalPurposeValue")
        dictionary.setValue(self.wandersWithNoRationalPurposeId, forKey: "wandersWithNoRationalPurposeId")
        dictionary.setValue(self.withdrawnOrdisinterestedInSurroundings, forKey: "withdrawnOrdisinterestedInSurroundings")
        dictionary.setValue(self.withdrawnOrdisinterestedInSurroundingsValue, forKey: "withdrawnOrdisinterestedInSurroundingsValue")
        dictionary.setValue(self.withdrawnOrdisinterestedInSurroundingsId, forKey: "withdrawnOrdisinterestedInSurroundingsId")
        dictionary.setValue(self.persistentAngerValue, forKey: "persistentAngerValue")
        return dictionary
    }

}
*/
