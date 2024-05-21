//
//  NursingCareViewModel.swift
//  appName
//
//  Created by Vasundhara Parakh on 3/16/20.
//  Copyright © 2020 smartData Enterprises (I) Ltd. All rights reserved.
//

import UIKit
enum NursingHeadingTitles{
    static let Safety = "Safety & Security"
    static let PersonalHygiene = "Personal Hygiene"
    static let Activity = "Activity & Exercise"
    static let Sleep = "Sleep, Rest & Comfort"
    static let Nutrition = "Nutrition, Hydration & Elimination"
}

enum NursingSections : Int{
    case Safety = 0
    case PersonalHygiene
    case Activity
    case Sleep
    case Nutrition
}

enum NursingDropDownType{
    static let NCFS_SAFETY_SECURITY_DROPDOWN = "NCFS_SAFETY_SECURITY_DROPDOWN"
    static let NCFS_SAFETY_ROUNDS = "NCFS_SAFETY_ROUNDS"
    static let NCFS_SIDE_RAILS_UP = "NCFS_SIDE_RAILS_UP"
    static let NCFS_NURSING_CARE_FLOW_YN = "NCFS_NURSING_CARE_FLOW_YN"
    static let NCFS_PERSONAL_HYGIENE_BATH_TYPE = "NCFS_PERSONAL_HYGIENE_BATH_TYPE"
    static let NCFS_PAIN = "NCFS_PAIN"
    static let NCFS_WELL_TOLLERATED = "NCFS_WELL_TOLLERATED"
    static let NCFS_REPOSITION = "NCFS_REPOSITION"
    static let NCFS_Appetite = "NCFS_Appetite"
    static let NCFS_BOWEL_AMOUNT_TYPE = "NCFS_BOWEL_AMOUNT_TYPE"
    static let DietType = "DietType"
    static let BowelCare = "Bowel Care"
    static let VOIDING_TYPE = "VOIDING_TYPE"
    static let BOWEL_CONSISTENCY = "BOWEL_CONSISTENCY"
    static let NCFS_SAFETY_SECURITY_PRESSURE_ULCER = "NCFS_SAFETY_SECURITY_PRESSURE_ULCER"
    static let NCFS_SAFETY_SECURITY_FALL = "NCFS_SAFETY_SECURITY_FALL"
    static let NCFS_SAFETY_SECURITY_BEHAVIOR_TYPE = "NCFS_SAFETY_SECURITY_BEHAVIOR_TYPE"
    static let NCFS_NURSING_CARE_FLOW_ABNORMAL = "NCFS_NURSING_CARE_FLOW_ABNORMAL"
}
enum ProgressNotsType{
    static let Consistency_Stool = "Consistency Stool"
    static let Voiding_pattern_GU = "Voiding pattern GU"
    
}


enum NursingTitles{
    enum Safety{
        static let ResidentStatus = "\(UserDefaults.getOrganisationTypeName()) Status"
        static let CareDone = "Care Done According To Care Plan"
        static let OneOnOneCompanionship = "One On One Companionship"
        static let CallBellWithinReach = "Call Bell Within Reach"
        static let ClutterRemoved = "Clutter Removed"
        static let SafetyRounds = "Safety Rounds"
        static let SideRailsUp = "Side Rails Up"
        static let Notes = "Notes"
        static let Fall = "Fall"
        static let TimeOfFall = "Time of Fall"
        static let FallType = "Fall Type"
        static let PressureUlcer = "Pressure Ulcer"
        static let BodySite = "Body Site"
        static let Behaviour = "Behaviour"
        static let BehaviourType = "Behaviour Type"
        static let BehaviourTime = "Behaviour Time"
    }
    
    enum PersonalHygiene{
        static let MouthCare = "Mouth Care"
        static let Bath = "Bath"
        static let BathType = "Bath Type"
        static let WaterTemperature = "Water Temperature"
        static let WaterTemperatureUnit = "Unit"
        static let SkinProtocol = "Skin Protocol"
        static let NailCare = "Nail Care"
        static let Notes = "Notes"
    }
    
    enum Activity{
        static let UsualAsPerSelf = "Usual As Per Self"
        static let ParticipatedInActivity = "Participated In Activity"
        static let WeightBearing = "Weight Bearing"
        static let RangeOfMotion = "Range Of Motion"
        static let WellTolerated = "Well Tolerated"
        static let AbnormalityDetected = "Abnormality Detected"
        static let NailCare = "Nail Care"
        static let SelfPerformance = "Self Performance"
        static let SupportProvided = "Support Provided"
        static let Repositioning = "Repositioning"
        static let Notes = "Notes"
    }
    
    enum Sleep{
        static let Pain = "Pain"
        static let UsualAsPerSelf = "Usual As Per Self"
        static let AbnormalityDetected = "Abnormality Detected"
        static let SleepAt = "Sleep At"
        static let AwakeAt = "Awake At"
        static let Notes = "Notes"
    }
    
    enum Nutrition{
        static let Appetite = "Appetite"
        static let TypeOfDiet = "Type Of Diet"
        static let MealEaten = "Meal Eaten"
        static let MealTime = "Meal Time"
        static let MealEatenPercentage = "% of Meal Eaten"
        static let Snack = "Snack"
        enum FluidIntake {
            static let FluidIntake = "Fluid Intake"
            static let FluidIntakeTime = "Fluid Intake Time"
            static let Amount = "Amount(ml)"
            static let TotalAmount = "Total Amount of fluid intake"
            
        }
        
        enum Bowel {
            static let Bowel = "Bowel"
            static let Consistency = "Consistency"
            static let BowelTime = "Bowel Time"
            static let Amount = "Amount"
            static let TotalBowelMovement = "Total Number of Bowel Movement"
        }
        
        enum UrinaryVoids {
            static let UrinaryVoids = "Urinary Voids"
            static let UrineColor = "Urine Color"
            static let UrineTime = "Urine Time"
            static let Amount = "Amount (ml)"
            static let TotalUrinaryVoids = "Total Number of Urinary Voids"
        }
        
        enum Emesis {
            static let Emesis = "Emesis"
            static let Amount = "Amount (ml)"
            static let EmesisTotal = "Emesis Total"
            static let EmesisTime = "Emesis Time"

        }
        
        enum BloodLoss {
            static let BloodLoss = "Blood Loss"
            static let BleedingTime = "Bleeding Time"
            static let Amount = "Amount (ml)"
            static let BloodLossTotal = "Blood Loss Total"
        }
        
        static let TotalFluidOutput = "Total Fluid Output"
        static let IncontinentUrinary = "Incontinent, Urinary *"
        static let IncontinentBowel = "Incontinent, Bowel *"
        static let BriefCount = "Brief/Pull Up Count"
        static let PerinealPadsCount = "Perineal Pads Count"
        static let VoidingPatternGU = "Voiding pattern GU"
        static let RectalCheckPerformed = "Rectal Check Performed"
        static let BowelCare = "Bowel Care"
        static let Notes = "Notes"
    }
}


class NursingCareViewModel: BaseViewModel{
    // MARK: - Parameters
    var service:PointOfCareService
    var serviceMaster : MasterService
    var selectedSection = 0
    var vitalsMasterData : MasterData?
    // MARK: - Constructor
    init(with service:PointOfCareService, section : Int) {
        self.service = service
        self.serviceMaster = MasterService()
        self.selectedSection = section
    }
    
    var arrData = [ListingSectionModel]()
    var dateOfPlan = ""
    var planAddedBy = ""
    let headerArray = [NursingHeadingTitles.Safety,NursingHeadingTitles.PersonalHygiene,NursingHeadingTitles.Activity,NursingHeadingTitles.Sleep,NursingHeadingTitles.Nutrition]
    var dropdownMood : [PointOfCareMasterDropdown]?
    var dropdownWoundAssessment : [AllAssessmentMasters]?
    var personalHygieneDetail : PersonalHygiene?
    var safetySecurityDetail : SafetySecurityDetail?
    var sleepRestDetail : SleepRest?
    var activityDetail : ActivityDetail?

    //MARK: -Table view methods
    func numberOfSection()-> Int{
        return arrData.count
    }
    func numberOfRows(section : Int)-> Int{
        let listModel = self.arrData[section]
        let listArray = listModel.content
        return listArray?.count ?? 0
    }
    func roomForIndexPath(_ indexPath: IndexPath) -> ListModel? {
        let listModel = self.arrData[indexPath.section]
        let listArray = listModel.content
        return listArray?[indexPath.row] ?? ListModel(title: "", value: "")
    }
    
    func titleForSectionHeader(section : Int) -> String{
        let listModel = self.arrData[section]
        return listModel.headerTitle ?? ""
    }
    
    func titleForHeader(section: Int) -> String? {

        return self.headerArray[section]
    }
    
}
//MARK:- NursingCareViewModel
extension NursingCareViewModel{
    // MARK: - Network calls
    func getWoundAssessmentMasters(completion:@escaping (Any?) -> Void){
        self.isLoading = true
        serviceMaster.getAssessmentMasters(completion:{ (result) in
                        self.isLoading = false
            if let res = result as? [AllAssessmentMasters]
            {
                completion(res)
            }else{
                self.errorMessage = Alert.ErrorMessages.invalid_response
            }
        })
    }
    func dropDownforFieldTypeForAssessment(type: String) -> [AllAssessmentMasters]?{
        if let dropdownArr = self.dropdownWoundAssessment{
            let dropDownArray = dropdownArr.compactMap { (entity) -> AllAssessmentMasters? in
                if entity.type == type{
                    return entity
                }
                return nil
            }
            return dropDownArray
        }
        return nil
    }
    
    func getVitalsMasterData(completion:@escaping (Any?) -> Void){
        self.isLoading = true
        serviceMaster.getVitalMasters { (result) in
            self.isLoading = false
            if let res = result as? MasterData{
                completion(res)
            }else{
                self.errorMessage = Alert.ErrorMessages.invalid_response
                completion(nil)
            }
        }
    }
    func getNursingCareMasterData(){
        self.isLoading = true
        serviceMaster.getPointOfCareMasters { (result) in
            if let res = result as? [PointOfCareMasterDropdown]
            {
                self.getWoundAssessmentMasters { (assessment) in
                    if let assess = assessment as? [AllAssessmentMasters]{
                        self.dropdownWoundAssessment = assess
                        self.getVitalsMasterData { (result) in
                            self.isLoading = false
                            if let resVitals = result  as? MasterData{
                                self.vitalsMasterData = resVitals
                                self.dropdownMood = res
                                self.shouldUpdateView = true
                            }
                        }
                    }
                }
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
    
    func getSafetySecurityDetail(patientId : Int,completion:@escaping (Any?) -> Void){
        self.isLoading = true
        service.getSafetySecurityDetail(with: patientId) { (result) in
            self.isLoading = false
            if let res = result as? SafetySecurityDetail{
                self.safetySecurityDetail = res
                self.isListLoaded = true
                completion(res)
            }
            completion(nil)
        }
    }

    func getPersonalHygieneDetail(patientId : Int,completion:@escaping (Any?) -> Void){
        self.isLoading = true
        service.getPersonalHygieneDetail(with: patientId) { (result) in
            self.isLoading = false
            if let res = result as? PersonalHygiene{
                self.personalHygieneDetail = res
                self.isListLoaded = true
                completion(res)
            }
            completion(nil)
        }
    }
    func getActivityDetail(patientId : Int,completion:@escaping (Any?) -> Void){
        self.isLoading = true
        service.getActivityDetail(with: patientId) { (result) in
            self.isLoading = false
            if let res = result as? ActivityDetail{
                self.activityDetail = res
                self.isListLoaded = true
                completion(res)
            }
            completion(nil)
        }
    }
    func getSleepRestDetail(patientId : Int,completion:@escaping (Any?) -> Void){
        self.isLoading = true
        service.getSleepRestDetail(with: patientId) { (result) in
            self.isLoading = false
            if let res = result as? SleepRest{
                self.sleepRestDetail = res
                self.isListLoaded = true
                completion(res)
            }
            completion(nil)
        }
    }
    func getDropdownName(id: Int,dropdown:Any? ) -> String{
        var dropdownName = ""
        
        if let dropdownArr = dropdown as? [PointOfCareMasterDropdown]{
            let dropdownList = dropdownArr.compactMap { (entity) -> PointOfCareMasterDropdown? in
                return ((entity.id ?? 0) == id) ? entity : nil
            }
            dropdownName = dropdownList.isEmpty ? "" : dropdownList.first?.value ?? ""
        }
        
        if let dropdownArr = dropdown as? [AllAssessmentMasters]{
            let dropdownList = dropdownArr.compactMap { (entity) -> AllAssessmentMasters? in
                return ((entity.id ?? 0) == id) ? entity : nil
            }
            dropdownName = dropdownList.isEmpty ? "" : dropdownList.first?.value ?? ""
        }

        
        if let dropdownArr = dropdown as? [MasterVitalBodyTempUnit]{
            let dropdownList = dropdownArr.compactMap { (entity) -> MasterVitalBodyTempUnit? in
                return ((entity.id ?? 0) == id) ? entity : nil
            }
            dropdownName = dropdownList.isEmpty ? "" : dropdownList.first?.bodyTempUnit ?? ""
        }
        
        return  dropdownName
    }
    func saveNursingCare(apiName:String, params : [String: Any]){
        self.isLoading = true
        service.saveNursingCareFlow(apiName: apiName, params: params)  { (result) in
            self.isLoading = false
            if let res = result as? String{
                self.errorMessage = res
            }else{
                self.isSuccess = true
                self.alertMessage = Alert.Message.formSavedSuccessfully
            }
        }
    }
    func deleteNursingCare(apiName:String, params : [String: Any]){
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
    
    func getInputArray() -> [Any]{
        var finalArray = [Any]()
        switch selectedSection {
        case NursingSections.Safety.rawValue:
            finalArray.append(self.getSafetyInput())
        case NursingSections.PersonalHygiene.rawValue:
            finalArray.append(self.getPersonalHygiene())
        case NursingSections.Activity.rawValue:
            finalArray.append(self.getActivityInput())
        case NursingSections.Sleep.rawValue:
            finalArray.append(self.getSleepInput())
        default:
            print("Do nothing")
        }
        //ALL SECTIONS TOGETHER
        /*
         finalArray.append(self.getSafetyInput())
         finalArray.append(self.getPersonalHygiene())
         finalArray.append(self.getActivityInput())
         finalArray.append(self.getSleepInput())
         */
        return finalArray
    }
    
    
    func getSafetyInput() -> [Any]{
        let residentStatus = self.getDropdownName(id: self.safetySecurityDetail?.transfer ?? 0, dropdown: self.dropDownforFieldType(type: NursingDropDownType.NCFS_SAFETY_SECURITY_DROPDOWN))
//        SharedappName.sharedInstance.patientActiveStatus = residentStatus
        UserDefaults.setPatientStatus(token: residentStatus)
        let careDone = self.getDropdownName(id: self.safetySecurityDetail?.careDoneAccordingToCarePlanId ?? 0, dropdown: self.dropDownforFieldType(type: NursingDropDownType.NCFS_NURSING_CARE_FLOW_YN))

        let oneToOne = self.getDropdownName(id: self.safetySecurityDetail?.oneOnOneCompanionshipId ?? 0, dropdown: self.dropDownforFieldType(type: NursingDropDownType.NCFS_NURSING_CARE_FLOW_YN))

        let callBell = self.getDropdownName(id: self.safetySecurityDetail?.callBellWithInReachId ?? 0, dropdown: self.dropDownforFieldType(type: NursingDropDownType.NCFS_NURSING_CARE_FLOW_YN))
        
        let clutterRemoved = self.getDropdownName(id: self.safetySecurityDetail?.cluttersRemovedId ?? 0, dropdown: self.dropDownforFieldType(type: NursingDropDownType.NCFS_NURSING_CARE_FLOW_YN))

        let safetyRounds = self.getDropdownName(id: self.safetySecurityDetail?.safetyRoundsId ?? 0, dropdown: self.dropDownforFieldType(type: NursingDropDownType.NCFS_SAFETY_ROUNDS))
        
        let sideRails = self.getDropdownName(id: self.safetySecurityDetail?.sideRailsUpId ?? 0, dropdown: self.dropDownforFieldType(type: NursingDropDownType.NCFS_SIDE_RAILS_UP))

        let fall = self.getDropdownName(id: self.safetySecurityDetail?.fallId ?? 0, dropdown: self.dropDownforFieldType(type: NursingDropDownType.NCFS_NURSING_CARE_FLOW_YN))

        let pressureUlcer = self.getDropdownName(id: self.safetySecurityDetail?.pressureUlcer ?? 0, dropdown: self.dropDownforFieldType(type: NursingDropDownType.NCFS_SAFETY_SECURITY_PRESSURE_ULCER))

        let behaviour = self.getDropdownName(id: self.safetySecurityDetail?.behaviourId ?? 0, dropdown: self.dropDownforFieldType(type: NursingDropDownType.NCFS_NURSING_CARE_FLOW_YN))

        let notes = self.safetySecurityDetail?.notes ?? ""

        
        return [InputTextfieldModel(value: residentStatus, placeholder: NursingTitles.Safety.ResidentStatus, apiKey: Key.Params.NursingCareFlow.Safety.transfer, valueId: self.safetySecurityDetail?.transfer ?? nil, inputType: InputType.Dropdown, dropdownArr: self.dropDownforFieldType(type: NursingDropDownType.NCFS_SAFETY_SECURITY_DROPDOWN),isValid: residentStatus.count != 0, errorMessage: ConstantStrings.mandatory),
                
                InputTextfieldModel(value: careDone, placeholder: NursingTitles.Safety.CareDone, apiKey: Key.Params.NursingCareFlow.Safety.careDoneAccordingToCarePlanId, valueId: self.safetySecurityDetail?.careDoneAccordingToCarePlanId ?? nil, inputType: InputType.Dropdown, dropdownArr: self.dropDownforFieldType(type: NursingDropDownType.NCFS_NURSING_CARE_FLOW_YN),isValid: careDone.count != 0, errorMessage: ConstantStrings.mandatory),
                
                InputTextfieldModel(value: oneToOne, placeholder: NursingTitles.Safety.OneOnOneCompanionship, apiKey: Key.Params.NursingCareFlow.Safety.oneOnOneCompanionshipId, valueId: self.safetySecurityDetail?.oneOnOneCompanionshipId ?? nil, inputType: InputType.Dropdown, dropdownArr: self.dropDownforFieldType(type: NursingDropDownType.NCFS_NURSING_CARE_FLOW_YN),isValid: oneToOne.count != 0, errorMessage: ConstantStrings.mandatory),
                
                InputTextfieldModel(value: callBell, placeholder: NursingTitles.Safety.CallBellWithinReach, apiKey: Key.Params.NursingCareFlow.Safety.callBellWithInReachId, valueId: self.safetySecurityDetail?.callBellWithInReachId ?? nil, inputType: InputType.Dropdown, dropdownArr: self.dropDownforFieldType(type: NursingDropDownType.NCFS_NURSING_CARE_FLOW_YN),isValid: callBell.count != 0, errorMessage: ConstantStrings.mandatory),
                
                InputTextfieldModel(value: clutterRemoved, placeholder: NursingTitles.Safety.ClutterRemoved, apiKey: Key.Params.NursingCareFlow.Safety.cluttersRemovedId, valueId: self.safetySecurityDetail?.cluttersRemovedId ?? nil, inputType: InputType.Dropdown, dropdownArr: self.dropDownforFieldType(type: NursingDropDownType.NCFS_NURSING_CARE_FLOW_YN),isValid: clutterRemoved.count != 0, errorMessage: ConstantStrings.mandatory),
                
                InputTextfieldModel(value: safetyRounds, placeholder: NursingTitles.Safety.SafetyRounds, apiKey: Key.Params.NursingCareFlow.Safety.safetyRoundsId, valueId: self.safetySecurityDetail?.safetyRoundsId ?? nil, inputType: InputType.Dropdown, dropdownArr: self.dropDownforFieldType(type: NursingDropDownType.NCFS_SAFETY_ROUNDS),isValid: safetyRounds.count != 0, errorMessage: ConstantStrings.mandatory),
                
                InputTextfieldModel(value: sideRails, placeholder: NursingTitles.Safety.SideRailsUp, apiKey: Key.Params.NursingCareFlow.Safety.sideRailsUpId, valueId: self.safetySecurityDetail?.sideRailsUpId ?? nil, inputType: InputType.Dropdown, dropdownArr: self.dropDownforFieldType(type: NursingDropDownType.NCFS_SIDE_RAILS_UP),isValid: sideRails.count != 0, errorMessage: ConstantStrings.mandatory),
                
                InputTextfieldModel(value: fall, placeholder: NursingTitles.Safety.Fall, apiKey: Key.Params.NursingCareFlow.Safety.fallId, valueId: self.safetySecurityDetail?.fallId ?? nil, inputType: InputType.Dropdown, dropdownArr: self.dropDownforFieldType(type: NursingDropDownType.NCFS_NURSING_CARE_FLOW_YN),isValid: fall.count != 0, errorMessage: ConstantStrings.mandatory),

                InputTextfieldModel(value: pressureUlcer, placeholder: NursingTitles.Safety.PressureUlcer, apiKey: Key.Params.NursingCareFlow.Safety.pressureUlcer, valueId: self.safetySecurityDetail?.pressureUlcer ?? nil, inputType: InputType.Dropdown, dropdownArr: self.dropDownforFieldType(type: NursingDropDownType.NCFS_SAFETY_SECURITY_PRESSURE_ULCER),isValid: pressureUlcer.count != 0, errorMessage: ConstantStrings.mandatory),

                InputTextfieldModel(value: behaviour, placeholder: NursingTitles.Safety.Behaviour, apiKey: Key.Params.NursingCareFlow.Safety.behaviourId, valueId: self.safetySecurityDetail?.behaviourId ?? nil, inputType: InputType.Dropdown, dropdownArr: self.dropDownforFieldType(type: NursingDropDownType.NCFS_NURSING_CARE_FLOW_YN),isValid: behaviour.count != 0, errorMessage: ConstantStrings.mandatory),

                //InputTextfieldModel(value: notes, placeholder: NursingTitles.Safety.Notes, apiKey: Key.Params.NursingCareFlow.Safety.notes, valueId: notes.count != 0 ? notes : nil, inputType: InputType.Text, dropdownArr: nil,isValid: true, errorMessage: ConstantStrings.mandatory)
            
        ]
    }
    
    func getFallTimeInput() -> InputTextfieldModel{
        let fallTime = (self.safetySecurityDetail?.fallTime ?? "").count != 0 ? Utility.convertServerDateToRequiredDate(dateStr: self.safetySecurityDetail?.fallTime ?? "", requiredDateformat: DateFormats.hh_mm_a) : ""
        return InputTextfieldModel(value: fallTime, placeholder: NursingTitles.Safety.TimeOfFall, apiKey: Key.Params.NursingCareFlow.Safety.fallTime, valueId: fallTime.count != 0 ? self.safetySecurityDetail?.fallTime : nil, inputType: InputType.Time, dropdownArr: nil,isValid: fallTime.count != 0, errorMessage: ConstantStrings.mandatory)
    }
    func getFallTypeInput() -> InputTextfieldModel{
        let fallType = self.getDropdownName(id: self.safetySecurityDetail?.fallPatternId ?? 0, dropdown: self.dropDownforFieldType(type: NursingDropDownType.NCFS_SAFETY_SECURITY_FALL))
        
        return InputTextfieldModel(value: fallType, placeholder: NursingTitles.Safety.FallType, apiKey: Key.Params.NursingCareFlow.Safety.fallPatternId, valueId: self.safetySecurityDetail?.fallPatternId ?? nil, inputType: InputType.Dropdown, dropdownArr: self.dropDownforFieldType(type: NursingDropDownType.NCFS_SAFETY_SECURITY_FALL),isValid: fallType.count != 0, errorMessage: ConstantStrings.mandatory)
    }
    
    func getBehaviourTimeInput() -> InputTextfieldModel{
        let behaviourTime = (self.safetySecurityDetail?.behaviourTime ?? "").count != 0 ? Utility.convertServerDateToRequiredDate(dateStr: self.safetySecurityDetail?.behaviourTime ?? "", requiredDateformat: DateFormats.hh_mm_a) : ""

        return InputTextfieldModel(value: behaviourTime, placeholder: NursingTitles.Safety.BehaviourTime, apiKey: Key.Params.NursingCareFlow.Safety.behaviourTime, valueId: behaviourTime.count != 0 ? self.safetySecurityDetail?.behaviourTime : nil, inputType: InputType.Time, dropdownArr: nil,isValid: behaviourTime.count != 0, errorMessage: ConstantStrings.mandatory)
    }
    func getBeahviourTypeInput() -> InputTextfieldModel{
        let type = self.getDropdownName(id: self.safetySecurityDetail?.behaviorTypes?.first?.behaviorId ?? 0, dropdown: self.dropDownforFieldType(type: NursingDropDownType.NCFS_SAFETY_SECURITY_BEHAVIOR_TYPE))

        return InputTextfieldModel(value: type, placeholder: NursingTitles.Safety.BehaviourType, apiKey: Key.Params.NursingCareFlow.Safety.behaviourTypeId, valueId: self.safetySecurityDetail?.behaviorTypes?.first?.behaviorId ?? nil, inputType: InputType.Dropdown, dropdownArr: self.dropDownforFieldType(type: NursingDropDownType.NCFS_SAFETY_SECURITY_BEHAVIOR_TYPE),isValid: type.count != 0, errorMessage: ConstantStrings.mandatory)
    }
    func getBodySiteInput(bodySite : BodySiteGet?) -> InputTextfieldModel{
        if let body = bodySite{
            let site = self.getDropdownName(id: body.pressureUlcerBodySiteId ?? 0, dropdown: self.dropDownforFieldTypeForAssessment(type: WoundAssessmentTypes.bodysite))
            return InputTextfieldModel(value: site, placeholder: NursingTitles.Safety.BodySite, apiKey: Key.Params.NursingCareFlow.Safety.bodySiteId, valueId: body.pressureUlcerBodySiteId ?? nil, inputType: InputType.Dropdown, dropdownArr:  self.dropDownforFieldTypeForAssessment(type: WoundAssessmentTypes.bodysite),isValid: site.count != 0, errorMessage: ConstantStrings.mandatory)
        }
        return InputTextfieldModel(value: "", placeholder: NursingTitles.Safety.BodySite, apiKey: Key.Params.NursingCareFlow.Safety.bodySiteId, valueId: nil, inputType: InputType.Dropdown, dropdownArr:  self.dropDownforFieldTypeForAssessment(type: WoundAssessmentTypes.bodysite),isValid: false, errorMessage: ConstantStrings.mandatory)
    }

    
    func getPersonalHygiene() -> [Any] {
        let mouthCare = self.getDropdownName(id: self.personalHygieneDetail?.mouthCareId ?? 0, dropdown: self.dropDownforFieldType(type: NursingDropDownType.NCFS_NURSING_CARE_FLOW_YN))
        let bath = self.getDropdownName(id: self.personalHygieneDetail?.bathId ?? 0, dropdown: self.dropDownforFieldType(type: NursingDropDownType.NCFS_NURSING_CARE_FLOW_YN))
        let skinProtocol = self.getDropdownName(id: self.personalHygieneDetail?.skinProtocolId ?? 0, dropdown: self.dropDownforFieldType(type: NursingDropDownType.NCFS_NURSING_CARE_FLOW_YN))
        let nailCare = self.getDropdownName(id: self.personalHygieneDetail?.nailCareId ?? 0, dropdown: self.dropDownforFieldType(type: NursingDropDownType.NCFS_NURSING_CARE_FLOW_YN))
        let notes = self.personalHygieneDetail?.notes ?? ""

        return [InputTextfieldModel(value: mouthCare, placeholder: NursingTitles.PersonalHygiene.MouthCare, apiKey: Key.Params.NursingCareFlow.PersonalHygiene.mouthCareId, valueId: self.personalHygieneDetail?.mouthCareId ?? nil, inputType: InputType.Dropdown, dropdownArr: self.dropDownforFieldType(type: NursingDropDownType.NCFS_NURSING_CARE_FLOW_YN),isValid: mouthCare.count != 0, errorMessage: ConstantStrings.mandatory),
                
                InputTextfieldModel(value: bath, placeholder: NursingTitles.PersonalHygiene.Bath, apiKey: Key.Params.NursingCareFlow.PersonalHygiene.bathId, valueId:  self.personalHygieneDetail?.bathId ?? nil, inputType: InputType.Dropdown, dropdownArr: self.dropDownforFieldType(type: NursingDropDownType.NCFS_NURSING_CARE_FLOW_YN),isValid: bath.count != 0, errorMessage: ConstantStrings.mandatory),
                InputTextfieldModel(value: skinProtocol, placeholder: NursingTitles.PersonalHygiene.SkinProtocol, apiKey: Key.Params.NursingCareFlow.PersonalHygiene.skinProtocolId, valueId: self.personalHygieneDetail?.skinProtocolId ?? nil, inputType: InputType.Dropdown, dropdownArr: self.dropDownforFieldType(type: NursingDropDownType.NCFS_NURSING_CARE_FLOW_YN),isValid: skinProtocol.count != 0, errorMessage: ConstantStrings.mandatory),
                
                InputTextfieldModel(value: nailCare, placeholder: NursingTitles.PersonalHygiene.NailCare, apiKey: Key.Params.NursingCareFlow.PersonalHygiene.nailCareId, valueId: self.personalHygieneDetail?.nailCareId ?? nil, inputType: InputType.Dropdown, dropdownArr: self.dropDownforFieldType(type: NursingDropDownType.NCFS_NURSING_CARE_FLOW_YN),isValid: nailCare.count != 0, errorMessage: ConstantStrings.mandatory),
                
                //InputTextfieldModel(value: notes, placeholder: NursingTitles.PersonalHygiene.Notes, apiKey: Key.Params.NursingCareFlow.PersonalHygiene.notes, valueId: self.personalHygieneDetail?.notes ?? nil, inputType: InputType.Text, dropdownArr: nil,isValid: true, errorMessage: ConstantStrings.mandatory),
        ]
    }
    
    func getBathType() -> InputTextfieldModel{
        let bathType = self.getDropdownName(id: self.personalHygieneDetail?.bathTypeId ?? 0, dropdown: self.dropDownforFieldType(type: NursingDropDownType.NCFS_PERSONAL_HYGIENE_BATH_TYPE))

       return InputTextfieldModel(value: bathType, placeholder: NursingTitles.PersonalHygiene.BathType, apiKey: Key.Params.NursingCareFlow.PersonalHygiene.bathTypeId, valueId:  self.personalHygieneDetail?.bathTypeId ?? nil, inputType: InputType.Dropdown, dropdownArr: self.dropDownforFieldType(type: NursingDropDownType.NCFS_PERSONAL_HYGIENE_BATH_TYPE),isValid: bathType.count != 0, errorMessage: ConstantStrings.mandatory)
    }
    
    func getBathTemperature() -> Any{
        let waterTemp = self.personalHygieneDetail?.waterTemprature != nil ? "\(self.personalHygieneDetail!.waterTemprature!)" : ""
        let tempUnit = self.getDropdownName(id: self.personalHygieneDetail?.temperatureUnit ?? 0, dropdown: self.vitalsMasterData?.masterVitalBodyTempUnit ?? [""])
        
        return [InputTextfieldModel(value: waterTemp, placeholder: NursingTitles.PersonalHygiene.WaterTemperature, apiKey: Key.Params.NursingCareFlow.PersonalHygiene.waterTemprature, valueId: self.personalHygieneDetail?.waterTemprature ?? nil, inputType: InputType.Decimal, dropdownArr: nil,isValid: waterTemp.count != 0, errorMessage: ConstantStrings.mandatory),
                InputTextfieldModel(value: tempUnit, placeholder: NursingTitles.PersonalHygiene.WaterTemperatureUnit, apiKey: Key.Params.NursingCareFlow.PersonalHygiene.temperatureUnit, valueId: self.personalHygieneDetail?.temperatureUnit, inputType: InputType.Dropdown, dropdownArr: self.vitalsMasterData?.masterVitalBodyTempUnit ?? [""],isValid: tempUnit.count != 0, errorMessage: ConstantStrings.mandatory)]
        
    }
    
    func getActivityInput() -> [Any]{
        let usualasSelf = self.getDropdownName(id: self.activityDetail?.usualAsPerSelfId ?? 0, dropdown: self.dropDownforFieldType(type: NursingDropDownType.NCFS_NURSING_CARE_FLOW_YN))
        let participatedInActivity = self.getDropdownName(id: self.activityDetail?.participitedInActivityId ?? 0, dropdown: self.dropDownforFieldType(type: NursingDropDownType.NCFS_NURSING_CARE_FLOW_YN))
        let weightBearing = self.getDropdownName(id: self.activityDetail?.weightBearingId ?? 0, dropdown: self.dropDownforFieldType(type: NursingDropDownType.NCFS_NURSING_CARE_FLOW_YN))
        let rangeOfMotion = self.getDropdownName(id: self.activityDetail?.rangeOfMotionId ?? 0, dropdown: self.dropDownforFieldType(type: NursingDropDownType.NCFS_WELL_TOLLERATED))
        let wellTolerated = self.getDropdownName(id: self.activityDetail?.wellToleratedId ?? 0, dropdown: self.dropDownforFieldType(type: NursingDropDownType.NCFS_NURSING_CARE_FLOW_YN))
        let abnormality = self.getDropdownName(id: self.activityDetail?.abnormilityDetectedId ?? 0, dropdown: self.dropDownforFieldType(type: NursingDropDownType.NCFS_NURSING_CARE_FLOW_YN))
        let transferSelf = self.getDropdownName(id: self.activityDetail?.transferSelfPerformanceId ?? 0, dropdown: self.dropDownforFieldType(type: ADLType.ADL_SELF_PERFORMANCE_OPTIONS))
        let transferSupport = self.getDropdownName(id: self.activityDetail?.transferSupportProvidedId ?? 0, dropdown: self.dropDownforFieldType(type: ADLType.ADL_SUPPORT_PROVIDED_OPTIONS))
        let reposition = self.getDropdownName(id: self.activityDetail?.repositioningId ?? 0, dropdown: self.dropDownforFieldType(type: NursingDropDownType.NCFS_REPOSITION))
        let notes =  self.activityDetail?.notes ?? ""
      
        /* Array Added for not Applicable for :-
            • Usual As per Self
            • Participated in Activity
            • Weight Bearing
            • Range of Motion
            • Abnormality Detected*/
        let notAplicable = self.dropDownforFieldType(type: NursingDropDownType.NCFS_NURSING_CARE_FLOW_ABNORMAL)
        var arrayWithNotApplicable  = self.dropDownforFieldType(type: NursingDropDownType.NCFS_NURSING_CARE_FLOW_YN)
        if let datahave = notAplicable{
            for dict in datahave {
                arrayWithNotApplicable?.append(dict)
            }
        }
        
 
        
        return [InputTextfieldModel(value: usualasSelf, placeholder: NursingTitles.Activity.UsualAsPerSelf, apiKey: Key.Params.NursingCareFlow.Activity.usualAsPerSelfId, valueId: self.activityDetail?.usualAsPerSelfId ?? nil, inputType: InputType.Dropdown, dropdownArr: arrayWithNotApplicable,isValid: usualasSelf.count != 0, errorMessage: ConstantStrings.mandatory),
                
                InputTextfieldModel(value: participatedInActivity, placeholder: NursingTitles.Activity.ParticipatedInActivity, apiKey: Key.Params.NursingCareFlow.Activity.participitedInActivityId, valueId: self.activityDetail?.participitedInActivityId ?? nil, inputType: InputType.Dropdown, dropdownArr: arrayWithNotApplicable,isValid: participatedInActivity.count != 0, errorMessage: ConstantStrings.mandatory),
                
                InputTextfieldModel(value: weightBearing, placeholder: NursingTitles.Activity.WeightBearing, apiKey: Key.Params.NursingCareFlow.Activity.weightBearingId, valueId: self.activityDetail?.weightBearingId ?? nil, inputType: InputType.Dropdown, dropdownArr: arrayWithNotApplicable,isValid: weightBearing.count != 0, errorMessage: ConstantStrings.mandatory),
                
                InputTextfieldModel(value: rangeOfMotion, placeholder: NursingTitles.Activity.RangeOfMotion, apiKey: Key.Params.NursingCareFlow.Activity.rangeOfMotionId, valueId: self.activityDetail?.rangeOfMotionId ?? nil, inputType: InputType.Dropdown, dropdownArr: self.dropDownforFieldType(type: NursingDropDownType.NCFS_WELL_TOLLERATED),isValid: rangeOfMotion.count != 0, errorMessage: ConstantStrings.mandatory),
                
                InputTextfieldModel(value: wellTolerated, placeholder: NursingTitles.Activity.WellTolerated, apiKey: Key.Params.NursingCareFlow.Activity.wellToleratedId, valueId: self.activityDetail?.wellToleratedId ?? nil, inputType: InputType.Dropdown,
                    dropdownArr: arrayWithNotApplicable,
                    isValid: wellTolerated.count != 0,
                    errorMessage: ConstantStrings.mandatory),
                
                InputTextfieldModel(value: abnormality, placeholder: NursingTitles.Activity.AbnormalityDetected, apiKey: Key.Params.NursingCareFlow.Activity.abnormilityDetectedId, valueId: self.activityDetail?.abnormilityDetectedId ?? nil, inputType: InputType.Dropdown, dropdownArr: arrayWithNotApplicable,isValid: abnormality.count != 0, errorMessage: ConstantStrings.mandatory),
                
                InputTextfieldModel(value: "", placeholder: "Transfer", apiKey: "", valueId: nil, inputType: InputType.Title, dropdownArr: nil, isValid: true, errorMessage: ""),
                
                [  InputTextfieldModel(value: transferSelf, placeholder: NursingTitles.Activity.SelfPerformance, apiKey: Key.Params.NursingCareFlow.Activity.transferSelfPerformanceId, valueId: self.activityDetail?.transferSelfPerformanceId ?? nil, inputType: InputType.Dropdown, dropdownArr: self.dropDownforFieldType(type: ADLType.ADL_SELF_PERFORMANCE_OPTIONS),isValid: transferSelf.count != 0, errorMessage: ConstantStrings.mandatory),
                   InputTextfieldModel(value: transferSupport, placeholder: NursingTitles.Activity.SupportProvided, apiKey: Key.Params.NursingCareFlow.Activity.transferSupportProvidedId, valueId: self.activityDetail?.transferSupportProvidedId ?? nil, inputType: InputType.Dropdown, dropdownArr: self.dropDownforFieldType(type: ADLType.ADL_SUPPORT_PROVIDED_OPTIONS),isValid: transferSupport.count != 0, errorMessage: ConstantStrings.mandatory)],
                
                InputTextfieldModel(value: reposition, placeholder: NursingTitles.Activity.Repositioning, apiKey: Key.Params.NursingCareFlow.Activity.repositioningId, valueId: self.activityDetail?.repositioningId ?? nil, inputType: InputType.Dropdown, dropdownArr: self.dropDownforFieldType(type: NursingDropDownType.NCFS_REPOSITION),isValid: reposition.count != 0, errorMessage: ConstantStrings.mandatory),
                
                //InputTextfieldModel(value: notes, placeholder: NursingTitles.Activity.Notes, apiKey: Key.Params.NursingCareFlow.Activity.notes, valueId: notes.count != 0 ? notes : nil, inputType: InputType.Text, dropdownArr: nil,isValid: true, errorMessage: ConstantStrings.mandatory)
            
        ]
    }
    func getSleepInput() -> [Any]{
        let pain = self.getDropdownName(id: self.sleepRestDetail?.painId ?? 0, dropdown: self.dropDownforFieldType(type: NursingDropDownType.NCFS_PAIN))
        let abnormality = self.getDropdownName(id: self.sleepRestDetail?.noAbnormilityDetectedId ?? 0, dropdown: self.dropDownforFieldType(type: NursingDropDownType.NCFS_NURSING_CARE_FLOW_YN))
        let usualAsPerSelf = self.getDropdownName(id: self.sleepRestDetail?.usualAsPerSelfId ?? 0, dropdown: self.dropDownforFieldType(type: NursingDropDownType.NCFS_NURSING_CARE_FLOW_YN))
        let notes = self.sleepRestDetail?.notes ?? ""
        var dateStr = ""//Utility.getStringFromDate(date: Date(), dateFormat: DateFormats.hh_mm_a)
        let sleepTime = ((self.sleepRestDetail?.sleepAtTime ?? "").count != 0) ? Utility.convertServerDateToRequiredDate(dateStr: self.sleepRestDetail?.sleepAtTime ?? "", requiredDateformat: DateFormats.hh_mm_a) : dateStr
        let awakeTime = ((self.sleepRestDetail?.awakeAtTime ?? "").count != 0) ? Utility.convertServerDateToRequiredDate(dateStr: self.sleepRestDetail?.awakeAtTime ?? "", requiredDateformat: DateFormats.hh_mm_a) : dateStr

        
        return [InputTextfieldModel(value: pain, placeholder: NursingTitles.Sleep.Pain, apiKey: Key.Params.NursingCareFlow.Sleep.painId, valueId: self.sleepRestDetail?.painId ?? nil, inputType: InputType.Dropdown, dropdownArr: self.dropDownforFieldType(type: NursingDropDownType.NCFS_PAIN),isValid: pain.count != 0, errorMessage: ConstantStrings.mandatory),
                
                InputTextfieldModel(value: usualAsPerSelf, placeholder: NursingTitles.Sleep.UsualAsPerSelf, apiKey: Key.Params.NursingCareFlow.Sleep.usualAsPerSelfId, valueId: self.sleepRestDetail?.usualAsPerSelfId ?? nil, inputType: InputType.Dropdown, dropdownArr: self.dropDownforFieldType(type: NursingDropDownType.NCFS_NURSING_CARE_FLOW_YN),isValid: usualAsPerSelf.count != 0, errorMessage: ConstantStrings.mandatory),
                
                InputTextfieldModel(value: abnormality, placeholder: NursingTitles.Sleep.AbnormalityDetected, apiKey: Key.Params.NursingCareFlow.Sleep.noAbnormilityDetectedId, valueId:  self.sleepRestDetail?.noAbnormilityDetectedId ?? nil, inputType: InputType.Dropdown, dropdownArr: self.dropDownforFieldType(type: NursingDropDownType.NCFS_NURSING_CARE_FLOW_YN),isValid: abnormality.count != 0, errorMessage: ConstantStrings.mandatory),
                
                InputTextfieldModel(value: ((self.sleepRestDetail?.sleepAtTime ?? "").count != 0) ? sleepTime : "", placeholder: NursingTitles.Sleep.SleepAt, apiKey: Key.Params.NursingCareFlow.Sleep.sleepAtTime, valueId: sleepTime, inputType: InputType.Time, dropdownArr: nil,isValid: true , errorMessage: ConstantStrings.mandatory),
                
                InputTextfieldModel(value: ((self.sleepRestDetail?.awakeAtTime ?? "").count != 0) ? awakeTime : "", placeholder: NursingTitles.Sleep.AwakeAt, apiKey: Key.Params.NursingCareFlow.Sleep.awakeAtTime, valueId: awakeTime, inputType: InputType.Time, dropdownArr: nil,isValid: true , errorMessage: ConstantStrings.mandatory),
                
                //InputTextfieldModel(value: notes, placeholder: NursingTitles.Sleep.Notes, apiKey: Key.Params.NursingCareFlow.Sleep.notes, valueId: notes.count != 0 ? notes : nil, inputType: InputType.Text, dropdownArr: nil,isValid: true , errorMessage: ConstantStrings.mandatory),
        ]
    }
    
}
