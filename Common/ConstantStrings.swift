//
//  ConstantStrings.swift
//  appName
//
//  Created by Vasundhara Parakh on 2/25/20.
//  Copyright © 2020 smartData Enterprises (I) Ltd. All rights reserved.
//

import Foundation
//MARK:- Alert
struct Alert {
    struct Title {
        static let appName = NSLocalizedString("appName", comment: "")
        static let error = NSLocalizedString("Error", comment: "")
        static let logout = NSLocalizedString("Log Out?", comment: "")
        static let tnc = NSLocalizedString("Terms And Conditions", comment: "")

    }
    
    struct ButtonTitle {
        static let ok  =  NSLocalizedString("OK", comment: "")
        static let yes = NSLocalizedString("YES", comment: "")
        static let no = NSLocalizedString("NO", comment: "")
        static let logout = NSLocalizedString("LOG OUT", comment: "")
        static let cancel = NSLocalizedString("CANCEL", comment: "")
        static let saveForLater = NSLocalizedString("Save", comment: "")
        static let discardChanges = NSLocalizedString("Discard", comment: "")
        static let accept = NSLocalizedString("ACCEPT", comment: "")
        static let decline = NSLocalizedString("DECLINE", comment: "")

        static let completed = NSLocalizedString("COMPLETE", comment: "")
        static let fillForm = NSLocalizedString("FILL FORM", comment: "")

        static let exit = NSLocalizedString("Exit", comment: "")
        static let continueStr = NSLocalizedString("Continue", comment: "")


    }
    
    struct Message {
        static let serverError = NSLocalizedString("Server eror", comment: "")
        static let logout = NSLocalizedString("Are you sure you want to logout?", comment: "")
        static let tnc = NSLocalizedString("By continuing you agree to the terms & conditions of confitendtiality & information access agreement. ", comment: "")

        static let noRecords = NSLocalizedString("No records found.", comment: "")
        static let reset = NSLocalizedString("All the values will be lost. Are you sure you want to reset?", comment: "")
        static let maxAttachmentLimitReached = NSLocalizedString("You cannot select more images.", comment: "")
        static let formSavedSuccessfully = NSLocalizedString("Details have been saved successfully", comment: "")
        static let formResetSuccessfully = NSLocalizedString("Details have been Reset successfully", comment: "")
        static let startTask = NSLocalizedString("Please accept task to begin", comment: "")
        static let completeTask = NSLocalizedString("Please fill form to complete task or mark it complete if already done.", comment: "")
        static let deletedSuccessfully = NSLocalizedString("Deleted successfully", comment: "")
        static let cancelledSuccessfully = NSLocalizedString("Cancelled successfully", comment: "")
        static let discard = NSLocalizedString("Click back button to save entries.", comment: "")
        static let discardFullNCFForm = NSLocalizedString("All your changes will be lost. \n Are you sure you want to discard changes?", comment: "")



    }
    
    struct ErrorMessages {
        static let invalid_response = NSLocalizedString("Please try again later", comment: "")
        static let lost_internet            = NSLocalizedString("It seems you are offline, Please check your Internet connection.", comment: "")
        static let invalid_URL              = NSLocalizedString("Invalid server url", comment: "")

    }
}

//MARK:- InputTextfieldMessage
struct InputTextfieldMessage {
    
    struct ErrorMessages {
        static let emailMissing             = NSLocalizedString("Please enter email", comment: "")
        static let emailInvalid             = NSLocalizedString("Please enter a valid email", comment: "")
        static let passwordMissing          = NSLocalizedString("Please enter password", comment: "")
        static let passwordInvalid          = NSLocalizedString("Password must contain minimum 6 characters.", comment: "") //TODO: Change this
        
        
        //Vitals
        

    }
    
}

//MARK:- InputTextfieldMessage
struct ButtonTitles {
    static let done          = NSLocalizedString("Done", comment: "")
    static let next          = NSLocalizedString("Next", comment: "")
}

struct ConstantStrings {
    static let NA = NSLocalizedString("NA", comment: "")
    static let GoalOfCare_NA = NSLocalizedString("No Goal Of Care Specified.", comment: "")
    static let yes = NSLocalizedString("Yes", comment: "")
    static let no = NSLocalizedString("No", comment: "")
    static let searchHelp = NSLocalizedString("Search by :  \n Name, Room no., PHC No., DOB (eg : MM/dd/YYYY)", comment: "")
    static let searchHelpTask = NSLocalizedString("Search by :  \n Name, Room no., Assigned to", comment: "")
    static let searchHelpInventory = NSLocalizedString("Search by :  \n Inventory item", comment: "")

    static let roomNoPrefix = NSLocalizedString("Room no : ", comment: "")
    static let phcNoPrefix = NSLocalizedString("PHC no : ", comment: "")
    static let diagnosisPrefix = NSLocalizedString("Diagnosis : ", comment: "")
    static let allergiesPrefix = NSLocalizedString("Allergies : ", comment: "")
    static let goalOfCarePrefix = NSLocalizedString("Goal of Care : ", comment: "")
    static let allergenPrefix = NSLocalizedString("Allergen : ", comment: "")
    static let reactionPrefix = NSLocalizedString("Reaction : ", comment: "")
    static let notesPrefix = NSLocalizedString("Notes : ", comment: "")
    static let severityPrefix = NSLocalizedString("Severity : ", comment: "")
    static let taskDescriptionPrefix = NSLocalizedString("Task Description : ", comment: "")
    static let description = NSLocalizedString("Description : ", comment: "")
    static let type = NSLocalizedString("Type : ", comment: "")
    static let MinQty = NSLocalizedString("Min QTY : ", comment: "")
    static let stock = NSLocalizedString("Stock : ", comment: "")
    static let Price = NSLocalizedString("Price per unit ($) : ", comment: "")
    static let location = NSLocalizedString("Location : ", comment: "")
    static let mandatory = NSLocalizedString("Mandatory", comment: "")
}
