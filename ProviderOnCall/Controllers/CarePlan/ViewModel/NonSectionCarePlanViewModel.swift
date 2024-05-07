//
//  NonSectionCarePlanViewModel.swift
//  AccessEMR
//
//  Created by Vasundhara Parakh on 3/11/20.
//  Copyright © 2020 smartData Enterprises (I) Ltd. All rights reserved.
//

import UIKit

class NonSectionCarePlanViewModel: BaseViewModel{
    // MARK: - Parameters
    private(set) var service:CarePlanService
    
    // MARK: - Constructor
    init(with service:CarePlanService) {
        self.service = service
    }
    
    var arrData = [ListModel]()
    var dateOfPlan = ""
    var planAddedBy = ""
    
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

//MARK: CarePlan Details
extension NonSectionCarePlanViewModel{
    
    // MARK: - Network calls
    
    func getCarePlanDetails(carePlanItem : Int,patientId: Int){
        self.isLoading = true
        
        var apiPath = ""
        switch carePlanItem {
        case CarePlanItems.ConginitiveStatusItem.rawValue:
            apiPath = APITargetPoint.getConginitiveStatusPlan
        case CarePlanItems.BehavioursItem.rawValue:
            apiPath = APITargetPoint.getBehaviour
        case CarePlanItems.SafetyItem.rawValue:
            apiPath = APITargetPoint.getSafety
        case CarePlanItems.NutritionItem.rawValue:
            apiPath = APITargetPoint.getNutrition
        case CarePlanItems.BathingItem.rawValue:
            apiPath = APITargetPoint.getBathing
        case CarePlanItems.DressingItem.rawValue:
            apiPath = APITargetPoint.getDressing
        case CarePlanItems.HygieneItem.rawValue:
            apiPath = APITargetPoint.getHygiene
        case CarePlanItems.SkinItem.rawValue:
            apiPath = APITargetPoint.getSkin
        case CarePlanItems.MobilityItem.rawValue:
            apiPath = APITargetPoint.getMobility
        case CarePlanItems.TransferItem.rawValue:
            apiPath = APITargetPoint.getTransfer
        case CarePlanItems.ToiletingItem.rawValue:
            apiPath = APITargetPoint.getToileting
        case CarePlanItems.BladderContineneceItem.rawValue:
            apiPath = APITargetPoint.getBladderContinenece
        case CarePlanItems.BowelContineneceItem.rawValue:
            apiPath = APITargetPoint.getBowelContinenece
        default:
            apiPath = ""
        }
        service.getCarePlanDetails(carePlanItem: carePlanItem, apiPath: apiPath, patientId: patientId, target: self) { (result) in
            self.isLoading = false
            
            if let status = result as? ConginitiveStatus{
                self.dateOfPlan = status.createdDate ?? ""
                self.planAddedBy = status.addedByName ?? ""
                self.arrData = self.setConginitiveStatusData(data: status)
            }
            
            if let status = result as? Behaviour{
                self.dateOfPlan = status.createdDate ?? ""
                self.planAddedBy = status.addedByName ?? ""
                self.arrData = self.setBehaviourData(data: status)
            }
            
            if let safety = result as? Safety{
                self.dateOfPlan = safety.createdDate ?? ""
                self.planAddedBy = safety.addedByName ?? ""
                self.arrData = self.setSafetyData(data: safety)
            }
            if let status = result as? Nutrition{
                self.dateOfPlan = status.createdDate ?? ""
                self.planAddedBy = status.addedByName ?? ""
                self.arrData = self.setNutritionData(data: status)
            }
            
            if let res = result as? Bathing{
                self.dateOfPlan = res.createdDate ?? ""
                self.planAddedBy = res.addedByName ?? ""
                self.arrData = self.setBathingData(data: res)
            }

            if let res = result as? Dressing{
                self.dateOfPlan = res.createdDate ?? ""
                self.planAddedBy = res.addedByName ?? ""
                self.arrData = self.setDressingData(data: res)
            }
            
            if let res = result as? Hygiene{
                self.dateOfPlan = res.createdDate ?? ""
                self.planAddedBy = res.addedByName ?? ""
                self.arrData = self.setHygieneData(data: res)
            }
            
            if let res = result as? Skin{
                self.dateOfPlan = res.createdDate ?? ""
                self.planAddedBy = res.addedByName ?? ""
                self.arrData = self.setSkinData(data: res)
            }
            
            if let res = result as? Mobility{
                self.dateOfPlan = res.createdDate ?? ""
                self.planAddedBy = res.addedByName ?? ""
                self.arrData = self.setMobilityData(data: res)
            }
            
            if let res = result as? Transfer{
                self.dateOfPlan = res.createdDate ?? ""
                self.planAddedBy = res.addedByName ?? ""
                self.arrData = self.setTransferData(data: res)
            }

            if let res = result as? Toileting{
                self.dateOfPlan = res.createdDate ?? ""
                self.planAddedBy = res.addedByName ?? ""
                self.arrData = self.setToiletingData(data: res)
            }

            if let res = result as? BladderContinence{
                self.dateOfPlan = res.createdDate ?? ""
                self.planAddedBy = res.addedByName ?? ""
                self.arrData = self.setBladderContineneceData(data: res)
            }

            if let res = result as? BowelContinenece{
                self.dateOfPlan = res.createdDate ?? ""
                self.planAddedBy = res.addedByName ?? ""
                self.arrData = self.setBowelContineneceData(data: res)
            }
            
            self.isListLoaded = true
        }
    }
    
    func setConginitiveStatusData(data:ConginitiveStatus) -> [ListModel]{
        return [ListModel(title: "Orientation", value: data.orientation ?? ConstantStrings.NA),
                ListModel(title: "Oriented To", value: ""),
                ListModel(title: "Time", value: (data.isOrientedToTime ?? false) ? "Yes" : "No"),
                ListModel(title: "Person", value: (data.isOrientedToPerson ?? false) ? "Yes" : "No"),
                ListModel(title: "Place", value: (data.isOrientedToPlace ?? false) ? "Yes" : "No"),
                ListModel(title: "Cognitive Issues", value: ""),
                ListModel(title: "Memory impaired", value: (data.isMemoryImpairedIssue ?? false) ? "Yes" : "No"),
                ListModel(title: "Poor Judgement", value: (data.isPoorJudgementIssue ?? false) ? "Yes" : "No"),
                ListModel(title: "Unable to follow simple direction", value: (data.isUnableToFollowSimpleDirectionIssue ?? false) ? "Yes" : "No"),
                ListModel(title: "Brain injured(Traumatic)", value: (data.isBrainInjuredIssue ?? false) ? "Yes" : "No"),
                ListModel(title: "Notes", value: data.cognitiveStatusNotes ?? ConstantStrings.NA)
        ]
    }
    
    func setBehaviourData(data:Behaviour) -> [ListModel]{
        return [ ListModel(title: "Behaviour", value: data.behaviours ?? ConstantStrings.NA),
                 ListModel(title: "Notes", value: data.behaviourNotes ?? ConstantStrings.NA)
        ]
    }
    
    func setSafetyData(data:Safety) -> [ListModel]{
        return [ ListModel(title: "Allergies", value: data.allergies ?? ConstantStrings.NA),
                 ListModel(title: "Safety Risks", value: data.safetyRisks ?? ConstantStrings.NA),
                 ListModel(title: "Notes", value: data.safetyRisksNotes ?? ConstantStrings.NA),
                 ListModel(title: "Safety Measures", value: data.safetyPlans ?? ConstantStrings.NA),
                 ListModel(title: "Notes", value: data.safetyPlanNotes ?? ConstantStrings.NA)
        ]
    }
    
    func setNutritionData(data:Nutrition) -> [ListModel]{
        let dentalDate = Utility.convertServerDateToRequiredDate(dateStr: data.lastDentalDate ?? ConstantStrings.NA, requiredDateformat: DateFormats.mm_dd_yyyy)

        return [ ListModel(title: "Diet Type", value: data.dietType ?? ConstantStrings.NA),
                 ListModel(title: "Food Texture", value: data.foodTexture ?? ConstantStrings.NA),
                 ListModel(title: "Fluid Consistency", value: data.fluidConsistency ?? ConstantStrings.NA),
                 ListModel(title: "Tube Feed Formula", value: data.tubeFeedFormula ?? ConstantStrings.NA),
                 ListModel(title: "Rate", value: data.tubeFeedRate ?? ConstantStrings.NA),
                 ListModel(title: "Care Requirement", value: data.careRequirement ?? ConstantStrings.NA),
                 ListModel(title: "Notes", value: data.careRequirementNotes ?? ConstantStrings.NA),
                 ListModel(title: "Food Safety", value: data.foodSafety ?? ConstantStrings.NA),
                 ListModel(title: "Mouth Care", value: data.mouthCare ?? ConstantStrings.NA),
                 ListModel(title: "Teeth", value: data.teeth ?? ConstantStrings.NA),
                 ListModel(title: "Dentures", value: data.dentures ?? ConstantStrings.NA),
                 ListModel(title: "Name of Dentist/Denturist", value: data.dentistName ?? ConstantStrings.NA),
                 ListModel(title: "Last Date of Dental", value: dentalDate),
                 ListModel(title: "Notes", value: data.dentalNotes ?? ConstantStrings.NA)
        ]
    }
    
    func setBathingData(data:Bathing) -> [ListModel]{
        return [ ListModel(title: "Care Requirement", value: data.careRequirement ?? ConstantStrings.NA),
                 ListModel(title: "Bath Type", value: data.bathTypes ?? ConstantStrings.NA),
                 ListModel(title: "Bath Days", value: data.bathDays ?? ConstantStrings.NA),
                 ListModel(title: "Preferences", value: data.preferences ?? ConstantStrings.NA),
                 ListModel(title: "Hair Care", value: data.hairCares ?? ConstantStrings.NA),
                 ListModel(title: "Nail care done by", value: data.nailCareDoneBy ?? ConstantStrings.NA),
                 ListModel(title: "Foot care done by", value: data.footCareDoneBy ?? ConstantStrings.NA),
                 ListModel(title: "Notes", value: data.bathingNotes ?? ConstantStrings.NA)
        ]
    }
    
    func setDressingData(data:Dressing) -> [ListModel]{
        return [ ListModel(title: "Care Requirement", value: data.careRequirement ?? ConstantStrings.NA),
                 ListModel(title: "Notes", value: data.dressingNotes ?? ConstantStrings.NA)
        ]
    }
    
    func setHygieneData(data:Hygiene) -> [ListModel]{
        return [ ListModel(title: "Care Requirement", value: data.careRequirement ?? ConstantStrings.NA),
                 ListModel(title: "Notes", value: data.hygieneNotes ?? ConstantStrings.NA)
        ]
    }
    
    func setSkinData(data:Skin) -> [ListModel]{
        return [ ListModel(title: "Skin Concerns", value: data.skinConcerns ?? ConstantStrings.NA),
                 ListModel(title: "Notes", value: data.skinNotes ?? ConstantStrings.NA),
                 ListModel(title: "Skin Care", value: data.skinCares ?? ConstantStrings.NA),
        ]
    }
    
    func setMobilityData(data:Mobility) -> [ListModel]{
        return [ ListModel(title: "Care Requirement", value: data.careRequirement ?? ConstantStrings.NA),
                 ListModel(title: "Mobility Aids", value: data.mobilityAids ?? ConstantStrings.NA),
                 ListModel(title: "Notes", value: data.mobilityNotes ?? ConstantStrings.NA)
        ]
    }
    
    func setTransferData(data:Transfer) -> [ListModel]{
        return [ListModel(title: "Weight Bearing", value: data.weightBearing ?? ConstantStrings.NA),
                 ListModel(title: "Care Requirement", value: data.careRequirement ?? ConstantStrings.NA)
        ]
    }
    
    func setToiletingData(data:Toileting) -> [ListModel]{
        return [ ListModel(title: "Care Requirement", value: data.careRequirement ?? ConstantStrings.NA),
                 ListModel(title: "Notes", value: data.toiletingNotes ?? ConstantStrings.NA)
        ]
    }
    
    func setBladderContineneceData(data:BladderContinence) -> [ListModel]{
        return [ ListModel(title: "Bladder Continence", value: data.bladderContinence ?? ConstantStrings.NA),
                 ListModel(title: "Equipment", value: data.equipments ?? ConstantStrings.NA),
                 ListModel(title: "Products", value: data.isProduct ?? false ? ConstantStrings.yes : ConstantStrings.no),
                 ListModel(title: "Product Name", value: data.product ?? ConstantStrings.NA),
                 ListModel(title: "Product Size", value: data.size ?? ConstantStrings.NA),
                 ListModel(title: "Use in the", value: data.productUseinthe ?? ConstantStrings.NA),
                 ListModel(title: "Managed by", value: data.managedBy ?? ConstantStrings.NA),
                 ListModel(title: "Notes", value: data.bladderNotes ?? ConstantStrings.NA)
        ]
    }
    
    func setBowelContineneceData(data:BowelContinenece) -> [ListModel]{
        return [ ListModel(title: "Bowel Continence", value: data.bladderContinence ?? ConstantStrings.NA),
                 ListModel(title: "Bowel Incontinent", value: data.bladderIncontinent ?? ConstantStrings.NA),
                 ListModel(title: "Equipment", value: data.equipments ?? ConstantStrings.NA),
                 ListModel(title: "Product", value: data.isProduct ?? false ? ConstantStrings.yes : ConstantStrings.no),
                 ListModel(title: "Products - ", value: data.products ?? ConstantStrings.NA),
                 ListModel(title: "Product Name", value: data.product ?? ConstantStrings.NA),
                 ListModel(title: "Product Size", value: data.size ?? ConstantStrings.NA),
                 ListModel(title: "Use in the", value: data.productUseinthe ?? ConstantStrings.NA),
                 ListModel(title: "Managed by", value: data.managedBy ?? ConstantStrings.NA),
                 ListModel(title: "Notes", value: data.bowelNotes ?? ConstantStrings.NA)
        ]
    }
}

//MARK: PointOfCare Details
extension NonSectionCarePlanViewModel{
    func getPointOfCareDetails(nursingItem : Int,patientId: Int){
        switch nursingItem {
        case NursingCareFlowItems.SafetyItem.rawValue:
            self.arrData = self.setSafety()
        case NursingCareFlowItems.PersonalHygeieneItem.rawValue:
            self.arrData = self.setPersonalHygiene()
        case NursingCareFlowItems.SleepItem.rawValue:
            self.arrData = self.setSleepRest()
        default:
            print("Do nothing")
        }
    }
    
    func setSafety() -> [ListModel]{
       return [ ListModel(title: "\(UserDefaults.getOrganisationTypeName()) Status", value:  ConstantStrings.NA),
                 ListModel(title: "Care Done According To Care Plan", value:  ConstantStrings.NA),
                 ListModel(title: "One On One Companionship", value: ConstantStrings.NA),
                 ListModel(title: "Call Bell Within Reach", value: ConstantStrings.NA ),
                 ListModel(title: "Clutter Removed", value: ConstantStrings.NA),
                 ListModel(title: "Safety Rounds", value: ConstantStrings.NA),
                 ListModel(title: "Side Rails Up", value:  ConstantStrings.NA),
                 ListModel(title: "Notes", value:  ConstantStrings.NA),
        ]
    }
    
    func setPersonalHygiene() -> [ListModel]{
        return   [ ListModel(title: "Mouth Care", value:  ConstantStrings.NA),
                    ListModel(title: "Bath", value:  ConstantStrings.NA),
                    ListModel(title: "Bath Type", value: ConstantStrings.NA),
                    ListModel(title: "Water Temprature", value: ConstantStrings.NA ),
                    ListModel(title: "Skin Protocol", value: ConstantStrings.NA),
                    ListModel(title: "Nail Care", value: ConstantStrings.NA),
                    ListModel(title: "Notes", value:  ConstantStrings.NA),
           ]
       }
    
    func setSleepRest() -> [ListModel]{
       return [ ListModel(title: "Pain", value:  ConstantStrings.NA),
                 ListModel(title: "Usual As Per Self", value:  ConstantStrings.NA),
                 ListModel(title: "Abnormality Detected", value: ConstantStrings.NA),
                 ListModel(title: "Sleep At", value: ConstantStrings.NA ),
                 ListModel(title: "Awake At", value: ConstantStrings.NA),
                 ListModel(title: "Notes", value:  ConstantStrings.NA),
        ]
    }
}
