//
//  MoodTrackingViewModel.swift
//  appName
//
//  Created by Vasundhara Parakh on 3/12/20.
//  Copyright © 2020 smartData Enterprises (I) Ltd. All rights reserved.
//

import UIKit
enum MoodType{
   static let MBTT_Makes_Negative_Statement = "MBTT_Makes_Negative_Statement"
   static let  MBTT_Repetitive_Questions = "MBTT_Repetitive_Questions "
   static let  MBTT_Repetitive_Verbalizations = "MBTT_Repetitive_Verbalizations"
   static let  MBTT_Persistent_Anger_With_Self_Or_Others = "MBTT_Persistent_Anger_With_Self_Or_Others"
   static let  MBTT_Runs_Self_Down = "MBTT_Runs_Self_Down"
   static let  MBTT_Expresses_Unrealistic_Fears = "MBTT_Expresses_Unrealistic_Fears"
   static let  MBTT_Makes_Recurrent_Statement = "MBTT_Makes_Recurrent_Statement"
   static let  MBTT_Frequently_Complain_About_Health = "MBTT_Frequently_Complain_About_Health"
   static let  MBTT_Anxious_Complaints = "MBTT_Anxious_Complaints"
   static let  MBTT_Sad_Pained_Worried_Facial_Expressions = "MBTT_Sad_Pained_Worried_Facial_Expressions"
   static let  MBTT_Crying_Tearfulness = "MBTT_Crying_Tearfulness"
   static let  MBTT_Repetitive_Physical_Movement = "MBTT_Repetitive_Physical_Movement"
   static let  MBTT_Withdrawn_Disinterested_In_Surroundings = "MBTT_Withdrawn_Disinterested_In_Surroundings"
   static let  MBTT_Decreased_Social_Interaction = "MBTT_Decreased_Social_Interaction"
   static let  MBTT_Wanders_With_No_Rational_Purpose_And_No_Regard_To_Self_Or_Others_Safety = "MBTT_Wanders_With_No_Rational_Purpose_And_No_Regard_To_Self_Or_Others_Safety"
   static let  MBTT_Screams_Threatens_Curses = "MBTT_Screams_Threatens_Curses"
   static let  MBTT_Socially_Inappropriate_Or_Disruptive_Behaviors = "MBTT_Socially_Inappropriate_Or_Disruptive_Behaviors"
   static let  MBTT_Rating_Of_Pain_Itching_Discomfort_Using = "MBTT_Rating"//"MBTT_Rating_Of_Pain_Itching_Discomfort_Using"
   static let  MBTT_Slept_Or_Dozed_More_Than_One_Hour_This_Shift = "MBTT_Slept_Or_Dozed_More_Than_One_Hour_This_Shift"
   static let  MBTT_Spent_Time_In_Leisure_Activities_Pursuit_Own_Interest = "MBTT_Spent_Time_In_Leisure_Activities_Pursuit_Own_Interest"
   static let  MBTT_Hits_Shoves_Scratches = "MBTT_Hits_Shoves_Scratches"
    static let MBTT_Resist_Care = "MBTT_Resist_Care"
}

class MoodTrackingViewModel: BaseViewModel{
    // MARK: - Parameters
    var service:PointOfCareService
    var serviceMaster : MasterService
    var moodBeahviour : MoodTrackingTool?

    // MARK: - Constructor
    init(with service:PointOfCareService) {
        self.service = service
        self.serviceMaster = MasterService()
    }
    
    var arrData = [ListModel]()
    var dateOfPlan = ""
    var planAddedBy = ""
    var dropdownMood : [PointOfCareMasterDropdown]?
    //MARK: -Table view methods
    //MARK: -Table view methods
    func numberOfSection()-> Int{
        return arrData.count
    }
    func numberOfRows(section : Int)-> Int{
        return arrData.count
    }
    func roomForIndexPath(_ indexPath: IndexPath) -> ListModel? {
        return arrData[indexPath.row]
    }

}
//MARK:- ADLTracking
extension MoodTrackingViewModel{
    // MARK: - Network calls
    
    func getMoodAndBehaviourDetail(patientId : Int,completion:@escaping (Any?) -> Void){
        self.isLoading = true
        service.getMoodAndBehaviour(with: patientId) { (result) in
            self.isLoading = false
            if let res = result as? MoodTrackingTool{
                self.moodBeahviour = res
                //self.arrData.append(contentsOf: self.getMoodDetail(data: res))
                self.isListLoaded = true
                completion(res)
            }
            completion(nil)
        }
        
    }
    
    
    /*
    func getMoodDetail(data : MoodTrackingTool) -> [ListModel]{
      return [ListModel(title: "Makes negative statement e.g. Nothing matters", value: data.makeNegativeStatementValue ?? ConstantStrings.NA),
              ListModel(title: "Repetitive questions e.g. Where do I go?", value: data.repetativeQuestionValue ?? ConstantStrings.NA),
              ListModel(title: "Repetitive verbalization e.g. calling out for help", value: data.repetativeVerbilizationValue ?? ConstantStrings.NA),
              ListModel(title: "Persistent anger with self or others", value: data.persistentAngerValue ?? ConstantStrings.NA),
              ListModel(title: "Runs self down (Self depreciation)", value: data.runSelfDownValue ?? ConstantStrings.NA),
              ListModel(title: "Expresses unrealistic fears e.g. fear of being alone", value: data.expressUnrealisticFearValue ?? ConstantStrings.NA),
              ListModel(title: "Makes recurrent statement that something terrible is going to happen e.g. about to die", value: data.makeRecurrentStatementValue ?? ConstantStrings.NA),
              ListModel(title: "Frequently complain about health", value: data.frequentlyComplainAboutHealthValue ?? ConstantStrings.NA),
              ListModel(title: "Anxious complaints/concerns other than health", value: data.anxiousComplaintsValue ?? ConstantStrings.NA),
              ListModel(title: "Sad, pained, worried facial expressions", value: data.facialExpressionValue ?? ConstantStrings.NA),
              ListModel(title: "Crying, tearfulness", value: data.cryingOrTearfulnessValue ?? ConstantStrings.NA),
              ListModel(title: "Repetitive physical movement e.g. pacing, hand wringing", value: data.repetitivePhysicalMovementValue ?? ConstantStrings.NA),
              ListModel(title: "Withdrawn, disinterested in surroundings", value: data.withdrawnOrdisinterestedInSurroundingsValue ?? ConstantStrings.NA),
              ListModel(title: "Decreased social interaction", value: data.decreasedSocialInteractionValue ?? ConstantStrings.NA),
              ListModel(title: "Wanders with no rational purpose and no regard to self or others safety", value: data.wandersWithNoRationalPurposeValue ?? ConstantStrings.NA),
              ListModel(title: "Screams, threatens curses", value: data.screamsOrThreatensCursesValue ?? ConstantStrings.NA),
              ListModel(title: "Hits, shoves, scratches", value: data.hitsOrShovesOrScratchesValue ?? ConstantStrings.NA),
              ListModel(title: "Socially inappropriate or disruptive behaviours", value: data.sociallyInappropriateValue ?? ConstantStrings.NA),
              ListModel(title: "Resist care", value: data.resistCareValue ?? ConstantStrings.NA),
              ListModel(title: "Rating of pain, itching, discomfort using 0 -10 scale (If resident is non verbal use ……….)", value: data.ratingOfPainValue ?? ConstantStrings.NA),
              ListModel(title: "Slept or dozed more than one hour this shift", value: data.sleptOrDozedMoreThanOneHourThisShiftValue ?? ConstantStrings.NA),
              ListModel(title: "Spent time in leisure activities, pursuit own interest", value: data.spentTimeInLeisureActivitiesPursuitOwnInterestValue ?? ConstantStrings.NA),

        ]
    }
    */
    func getMoodMasterData(){
        self.isLoading = true
        serviceMaster.getPointOfCareMasters { (result) in
                        self.isLoading = false
            if let res = result as? [PointOfCareMasterDropdown]
            {
                self.dropdownMood = res
                self.shouldUpdateView = true
            }else{
                self.errorMessage = Alert.ErrorMessages.invalid_response
            }
        }
    }
    
    func dropDownforFieldType(type: String) -> [PointOfCareMasterDropdown]?{
        if let dropdownArr = self.dropdownMood{
            let dropDownArray = dropdownArr.compactMap { (entity) -> PointOfCareMasterDropdown? in
                if entity.type == type{
                    return entity
                }
                return nil
            }
            return dropDownArray
        }
        return nil
    }
    func getDropdownName(id: Int,dropdown:Any? ) -> String{
        var dropdownName = ""
        
        if let dropdownArr = dropdown as? [PointOfCareMasterDropdown]{
            let dropdownList = dropdownArr.compactMap { (entity) -> PointOfCareMasterDropdown? in
                return ((entity.id ?? 0) == id) ? entity : nil
            }
            dropdownName = dropdownList.isEmpty ? "" : dropdownList.first?.value ?? ""
        }
        
        return  dropdownName
    }
    func saveMoodAndBehavior(params : [String: Any]){
        self.isLoading = true
        service.saveMoodAndBehaviour(params: params) { (result) in
            self.isLoading = false
            if let res = result as? String{
                self.errorMessage = res
            }else{
                self.isSuccess = true
                self.alertMessage = Alert.Message.formSavedSuccessfully
            }
            
        }
    }
    func deleteMood(apiName:String, params : [String: Any]){
        self.isLoading = true
        service.discardNursingCareFlow(apiName: apiName, params: params)  { (result) in
            self.isLoading = false
            if let res = result as? String{
                self.errorMessage = res
            }else{
                self.isSuccess = true
                self.alertMessage = Alert.Message.formResetSuccessfully
            }
        }
    }
}
