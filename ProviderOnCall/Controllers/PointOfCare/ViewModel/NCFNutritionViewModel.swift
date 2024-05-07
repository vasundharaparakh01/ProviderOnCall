//
//  NCFNutritionViewModel.swift
//  AccessEMR
//
//  Created by Vasundhara Parakh on 3/19/20.
//  Copyright © 2020 smartData Enterprises (I) Ltd. All rights reserved.
//

import UIKit
enum NCFNutritionHeaderTitle{
    static let Intake = "Intake"
    static let OutputCount = "Output Count"
}
class NCFNutritionViewModel: BaseViewModel{
    // MARK: - Parameters
    var service:PointOfCareService
    var serviceMaster : MasterService
    var selectedSection = 0
    var vitalsMasterData : MasterData?
    
    // MARK: - Constructor
    init(with service:PointOfCareService) {
        self.service = service
        self.serviceMaster = MasterService()
    }
    
    var arrData = [ListingSectionModel]()
    var dateOfPlan = ""
    var planAddedBy = ""
    let headerArray = [NCFNutritionHeaderTitle.Intake,NCFNutritionHeaderTitle.OutputCount]
    let recursiveTitleArray = [["","","","","",NursingTitles.Nutrition.FluidIntake.FluidIntake],[NursingTitles.Nutrition.Bowel.Bowel,"",NursingTitles.Nutrition.UrinaryVoids.UrinaryVoids,"",NursingTitles.Nutrition.Emesis.Emesis,"",NursingTitles.Nutrition.BloodLoss.BloodLoss,"","","","","","","","",""]]

    var dropdownMood : [PointOfCareMasterDropdown]?
    var dropdownCarePlan : [CarePlanMaster]?
    var nutritionDetail : NCFNutritionDetail?
    var progressNotesMaster : [ProgressNotesMaster]?
    
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
    
    func titleForRecursiveFields(indexPath : IndexPath) -> String? {
        return "Test"
        /*
        let arrSub = self.recursiveTitleArray[indexPath.section]
        let title = arrSub[indexPath.row]
        return title*/
    }
    
}
//MARK:- NursingCareViewModel
extension NCFNutritionViewModel{
    // MARK: - Network calls
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
    
    func getNCFNutritionDetail(patientId : Int,completion:@escaping (Any?) -> Void){
           self.isLoading = true
           service.getNCFNutritionDetail(with: patientId) { (result) in
               self.isLoading = false
               if let res = result as? NCFNutritionDetail{
                   self.nutritionDetail = res
                   self.isListLoaded = true
                   completion(res)
               }
               completion(nil)
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
    func getYesNO( boolvalue: Bool ) -> String{
        if boolvalue{
        return "Yes"
        }else{
         return "No"
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
           
           if let dropdownArr = dropdown as? [LocationMaster]{
               let dropdownList = dropdownArr.compactMap { (entity) -> LocationMaster? in
                   return ((entity.locationID ?? 0) == id) ? entity : nil
               }
               dropdownName = dropdownList.isEmpty ? "" : dropdownList.first?.locationName ?? ""
           }
           
           if let dropdownArr = dropdown as? [Shift]{
               let dropdownList = dropdownArr.compactMap { (entity) -> Shift? in
                   return ((entity.id ?? 0) == id) ? entity : nil
               }
               dropdownName = dropdownList.isEmpty ? "" : dropdownList.first?.shiftName ?? ""
           }
           
        if let dropdownArr = dropdown as? [CarePlanMaster]{
            let dropdownList = dropdownArr.compactMap { (entity) -> CarePlanMaster? in
                return ((entity.id ?? 0) == id) ? entity : nil
            }
            dropdownName = dropdownList.isEmpty ? "" : dropdownList.first?.dropDownValue ?? ""
        }
        
           return  dropdownName
       }
    func getNursingCareMasterData(){
        self.isLoading = true
        serviceMaster.getPointOfCareMasters { (result) in
            if let res = result as? [PointOfCareMasterDropdown]
            {
                self.getCarePlanMasters { (result) in
                    self.isLoading = false
                    if let resCareplan = result as? [CarePlanMaster]{
                        self.dropdownCarePlan = resCareplan
                        self.dropdownMood = res
                        self.shouldUpdateView = true
                    }
                }
                
                self.getgetPatientMasterProgressNotes { (result) in
                    self.isLoading = false
                    if let resProgressNotesMaster = result as? [ProgressNotesMaster]{
                        self.progressNotesMaster = resProgressNotesMaster
                        //self.dropdownMood = res
                        self.shouldUpdateView = true
                    }
                }
                
            }else{
                self.isLoading = false
                self.errorMessage = Alert.ErrorMessages.invalid_response
            }
        }
    }
    
    func getCarePlanMasters(completion:@escaping (Any?) -> Void){
        serviceMaster.getCarePlanMasters { (result) in
            if let res = result as? [CarePlanMaster]
            {
                completion(res)
            }else{
                self.isLoading = false
                self.errorMessage = Alert.ErrorMessages.invalid_response
            }
        }
    }
    func getgetPatientMasterProgressNotes(completion:@escaping (Any?) -> Void){
        serviceMaster.getPatientMasterProgressNotes { (result) in
            if let res = result as? [ProgressNotesMaster]
            {
                completion(res)
            }else{
                self.isLoading = false
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
    
    func dropDownforCarePlanType(type: String) -> [CarePlanMaster]?{
        if let dropdownArr = self.dropdownCarePlan{
            let dropDownArray = dropdownArr.compactMap { (entity) -> CarePlanMaster? in
                if entity.dropDownType == type{
                    return entity
                }
                return nil
            }
            return dropDownArray
        }
        return nil
    }
    func dropDownforProgressNotType(type: String) -> [ProgressNotesMaster]?{
           if let dropdownArr = self.progressNotesMaster{
               let dropDownArray = dropdownArr.compactMap { (entity) -> ProgressNotesMaster? in
                   if entity.type == type{
                       return entity
                   }
                   return nil
               }
               return dropDownArray
           }
           return nil
       }
    
    
    func getInputArray() -> [Any]{
        var finalArray = [Any]()
        finalArray.append(self.getIntakeInput())
        finalArray.append(self.getOutputCountInput())
        return finalArray
    }
    
    func getIntakeInput() -> [Any]{
        
        let foodIntakeStatus = self.getYesNO(boolvalue: self.nutritionDetail?.foodIntake ?? false)
        var time: String = ""
        if let mealTime = self.nutritionDetail?.mealTime{
            let startTime2 = Utility.getDateFromstring(dateStr: mealTime, dateFormat: DateFormats.server_format_MealTime)
            time = Utility.getStringFromDate(date: startTime2, dateFormat: DateFormats.hh_mm_a)
        }
        let appetite = self.getDropdownName(id: self.nutritionDetail?.appetiteId ?? 0, dropdown: self.dropDownforFieldType(type: NursingDropDownType.NCFS_Appetite))
        let mealEaten = self.nutritionDetail?.mealEaten ?? ""
        
        let typeDiet = self.getDropdownName(id: self.nutritionDetail?.typeOfDietId ?? 0, dropdown: self.dropDownforCarePlanType(type: NursingDropDownType.DietType))
        let percentageMeal =  self.nutritionDetail?.dietAmount  ?? ""
        let snack =  self.nutritionDetail?.snack ?? ""
        let fluidTotal = (self.nutritionDetail?.numberOfFluidIntake ?? 0) == 0 ? "" : "\((self.nutritionDetail?.numberOfFluidIntake ?? 0))"
        
        if self.nutritionDetail?.foodIntake == true{
            return
                          [ InputTextfieldModel(value: foodIntakeStatus, placeholder: YesNONutritionHydration.Food_Intake, apiKey: "", valueId: nil, inputType: InputType.Dropdown, dropdownArr: self.dropDownforFieldType(type: NursingDropDownType.NCFS_NURSING_CARE_FLOW_YN),isValid: true, errorMessage: nil),
                            
                            InputTextfieldModel(value:time, placeholder: NursingTitles.Nutrition.MealTime, apiKey: Key.Params.NursingCareFlow.Nutrition.mealTime, valueId: nil, inputType: InputType.Time, dropdownArr: nil,isValid: true , errorMessage: nil),
                            
                            
                            InputTextfieldModel(value: appetite, placeholder: NursingTitles.Nutrition.Appetite, apiKey: Key.Params.NursingCareFlow.Nutrition.appetiteId, valueId:self.nutritionDetail?.appetiteId ?? nil, inputType: InputType.Dropdown, dropdownArr: self.dropDownforFieldType(type: NursingDropDownType.NCFS_Appetite),isValid: appetite.count != 0, errorMessage: nil),
                            
                            InputTextfieldModel(value: mealEaten, placeholder: NursingTitles.Nutrition.MealEaten, apiKey: Key.Params.NursingCareFlow.Nutrition.mealEaten, valueId:mealEaten.count != 0 ? mealEaten : nil, inputType: InputType.Text, dropdownArr: nil,isValid: mealEaten.count != 0, errorMessage: nil),
                            
                            InputTextfieldModel(value: typeDiet, placeholder: NursingTitles.Nutrition.TypeOfDiet, apiKey: Key.Params.NursingCareFlow.Nutrition.typeOfDietId, valueId: self.nutritionDetail?.typeOfDietId ?? nil, inputType: InputType.Dropdown, dropdownArr: self.dropDownforCarePlanType(type: NursingDropDownType.DietType),isValid: typeDiet.count != 0, errorMessage: nil),
                            
                            InputTextfieldModel(value: self.nutritionDetail?.dietAmount != nil ? "\(percentageMeal)" : "", placeholder: NursingTitles.Nutrition.MealEatenPercentage, apiKey: Key.Params.NursingCareFlow.Nutrition.dietAmount, valueId: self.nutritionDetail?.dietAmount != nil ? percentageMeal : nil, inputType: InputType.Number, dropdownArr: nil,isValid: "\(percentageMeal)".count != 0, errorMessage: nil),
                            
                            InputTextfieldModel(value: snack, placeholder: NursingTitles.Nutrition.Snack, apiKey: Key.Params.NursingCareFlow.Nutrition.snack, valueId: snack.count != 0 ? snack : nil, inputType: InputType.Text, dropdownArr: nil,isValid: snack.count != 0, errorMessage: nil),
                          
                            self.yesFluidIntack(fluidObject: nil),
                          
                          //self.getFluidIntakeArray(fluidObject: nil),
                      
                          InputTextfieldModel(value: fluidTotal, placeholder: NursingTitles.Nutrition.FluidIntake.TotalAmount, apiKey: Key.Params.NursingCareFlow.Nutrition.numberOfFluidIntake, valueId: self.nutritionDetail?.numberOfFluidIntake ?? nil, inputType: InputType.Number, dropdownArr: nil,isValid: true, errorMessage: nil),
                  ]
        }else{
            return
                          [ InputTextfieldModel(value: foodIntakeStatus, placeholder: YesNONutritionHydration.Food_Intake, apiKey: "", valueId: nil, inputType: InputType.Dropdown, dropdownArr: self.dropDownforFieldType(type: NursingDropDownType.NCFS_NURSING_CARE_FLOW_YN),isValid: true, errorMessage: nil),
                          self.yesFluidIntack(fluidObject: nil),
                          InputTextfieldModel(value: fluidTotal, placeholder: NursingTitles.Nutrition.FluidIntake.TotalAmount, apiKey: Key.Params.NursingCareFlow.Nutrition.numberOfFluidIntake, valueId: self.nutritionDetail?.numberOfFluidIntake ?? nil, inputType: InputType.Number, dropdownArr: nil,isValid: true, errorMessage: nil),
                  ]
        }
      
    }
    func yesFluidIntack(fluidObject : DynamicFluidIntake?) -> InputTextfieldModel{
        let fluidIntakeStatus = self.getYesNO(boolvalue: self.nutritionDetail?.fluidIntake ?? false)
        return InputTextfieldModel(value: fluidIntakeStatus, placeholder: YesNONutritionHydration.Fluid_Intake, apiKey: "", valueId: nil, inputType: InputType.Dropdown, dropdownArr: self.dropDownforFieldType(type: NursingDropDownType.NCFS_NURSING_CARE_FLOW_YN),isValid: true, errorMessage: nil)
    }
    func numberOffluidIntackTotal(fluidObject : DynamicFluidIntake?) -> InputTextfieldModel{
        let fluidTotal = (self.nutritionDetail?.numberOfFluidIntake ?? 0) == 0 ? "" : "\((self.nutritionDetail?.numberOfFluidIntake ?? 0))"
       return InputTextfieldModel(value: fluidTotal, placeholder: NursingTitles.Nutrition.FluidIntake.TotalAmount, apiKey: Key.Params.NursingCareFlow.Nutrition.numberOfFluidIntake, valueId: self.nutritionDetail?.numberOfFluidIntake ?? nil, inputType: InputType.Number, dropdownArr: nil,isValid: true, errorMessage: nil)
    }
    func numberOfBowelTotal(fluidObject : DynamicFluidIntake?) -> InputTextfieldModel{
          let bowelTotal = (self.nutritionDetail?.numberOfBowelMovement ?? 0) == 0 ? "" : "\((self.nutritionDetail?.numberOfBowelMovement ?? 0))"
         return  InputTextfieldModel(value: bowelTotal, placeholder: NursingTitles.Nutrition.Bowel.TotalBowelMovement, apiKey: Key.Params.NursingCareFlow.Nutrition.numberOfBowelMovement, valueId: self.nutritionDetail?.numberOfBowelMovement , inputType: InputType.Number, dropdownArr: nil,isValid: true, errorMessage: nil)
      }
    func numberUrinaryVoidsTotal(fluidObject : DynamicFluidIntake?) -> InputTextfieldModel{
           let urinaryTotal = (self.nutritionDetail?.numberOfUrinaryVoids ?? 0) == 0 ? "" : "\((self.nutritionDetail?.numberOfUrinaryVoids ?? 0))"
        let valueTotalId  = self.nutritionDetail != nil ? 0 : nil
         return InputTextfieldModel(value: urinaryTotal, placeholder: NursingTitles.Nutrition.UrinaryVoids.TotalUrinaryVoids, apiKey: Key.Params.NursingCareFlow.Nutrition.numberOfUrinaryVoids, valueId: self.nutritionDetail?.numberOfUrinaryVoids == nil ? valueTotalId : (self.nutritionDetail?.numberOfUrinaryVoids ?? 0), inputType: InputType.Number, dropdownArr: nil,isValid: true, errorMessage: nil)
      }
    func numberEmisisTotal(fluidObject : DynamicFluidIntake?) -> InputTextfieldModel{
          let emesisTotal = (self.nutritionDetail?.emesisSubTotal
          ?? 0) == 0 ? "" : "\((self.nutritionDetail?.emesisSubTotal ?? 0))"
         return InputTextfieldModel(value: emesisTotal, placeholder: NursingTitles.Nutrition.Emesis.EmesisTotal, apiKey: Key.Params.NursingCareFlow.Nutrition.emesisSubTotal, valueId: self.nutritionDetail?.emesisSubTotal == nil ? 0 : (self.nutritionDetail?.emesisSubTotal ?? 0), inputType: InputType.Number, dropdownArr: nil,isValid: true, errorMessage: nil)
      }
    func numberBloodTotal(fluidObject : DynamicFluidIntake?) -> InputTextfieldModel{
        let bloodTotal = (self.nutritionDetail?.bloodLossTotal ?? 0) == 0 ? "" : "\((self.nutritionDetail?.bloodLossTotal ?? 0))"
       return InputTextfieldModel(value: bloodTotal, placeholder: NursingTitles.Nutrition.BloodLoss.BloodLossTotal, apiKey: Key.Params.NursingCareFlow.Nutrition.bloodLossTotal, valueId: self.nutritionDetail?.bloodLossTotal == nil ? 0 : (self.nutritionDetail?.bloodLossTotal ?? 0), inputType: InputType.Number, dropdownArr: nil,isValid: true , errorMessage: nil)
    }
     
    func foodIntackYesNo(fluidObject : DynamicFluidIntake?) -> [InputTextfieldModel]{
        let appetite = self.getDropdownName(id: self.nutritionDetail?.appetiteId ?? 0, dropdown: self.dropDownforFieldType(type: NursingDropDownType.NCFS_Appetite))
        let mealEaten = self.nutritionDetail?.mealEaten ?? ""
        let typeDiet = self.getDropdownName(id: self.nutritionDetail?.typeOfDietId ?? 0, dropdown: self.dropDownforCarePlanType(type: NursingDropDownType.DietType))
        let percentageMeal =  self.nutritionDetail?.dietAmount  ?? nil
        let snack =  self.nutritionDetail?.snack ?? ""
        var time: String = ""
        if let mealTime = self.nutritionDetail?.mealTime{
        let startTime2 = Utility.getDateFromstring(dateStr: mealTime, dateFormat: DateFormats.server_format_MealTime)
         time = Utility.getStringFromDate(date: startTime2, dateFormat: DateFormats.hh_mm_a)
         }
        return
                [
                 InputTextfieldModel(value: appetite, placeholder: NursingTitles.Nutrition.Appetite, apiKey: Key.Params.NursingCareFlow.Nutrition.appetiteId, valueId:self.nutritionDetail?.appetiteId ?? nil, inputType: InputType.Dropdown, dropdownArr: self.dropDownforFieldType(type: NursingDropDownType.NCFS_Appetite),isValid: true, errorMessage: nil),
                 
                  InputTextfieldModel(value:time, placeholder: NursingTitles.Nutrition.MealTime, apiKey: Key.Params.NursingCareFlow.Nutrition.mealTime, valueId: nil, inputType: InputType.Time, dropdownArr: nil,isValid: true , errorMessage: nil),
                       
                       InputTextfieldModel(value: mealEaten, placeholder: NursingTitles.Nutrition.MealEaten, apiKey: Key.Params.NursingCareFlow.Nutrition.mealEaten, valueId:mealEaten.count != 0 ? mealEaten : nil, inputType: InputType.Text, dropdownArr: nil,isValid: true, errorMessage: nil),
                       
                       InputTextfieldModel(value: typeDiet, placeholder: NursingTitles.Nutrition.TypeOfDiet, apiKey: Key.Params.NursingCareFlow.Nutrition.typeOfDietId, valueId: self.nutritionDetail?.typeOfDietId ?? nil, inputType: InputType.Dropdown, dropdownArr: self.dropDownforCarePlanType(type: NursingDropDownType.DietType),isValid: true, errorMessage: nil),
                       
                       InputTextfieldModel(value: self.nutritionDetail?.dietAmount != nil ? "\(percentageMeal)" : "", placeholder: NursingTitles.Nutrition.MealEatenPercentage, apiKey: Key.Params.NursingCareFlow.Nutrition.dietAmount, valueId: self.nutritionDetail?.dietAmount != nil ? percentageMeal : nil, inputType: InputType.Number, dropdownArr: nil,isValid: true, errorMessage: nil),
                       
                       InputTextfieldModel(value: snack, placeholder: NursingTitles.Nutrition.Snack, apiKey: Key.Params.NursingCareFlow.Nutrition.snack, valueId: snack.count != 0 ? snack : nil, inputType: InputType.Text, dropdownArr: nil,isValid: true, errorMessage: nil),]
    }
    func getFluidIntakeArray(fluidObject : DynamicFluidIntake?) -> [InputTextfieldModel]{
        if let fluid = fluidObject{
            let time = (fluid.fluidIntakeTime ?? "").count != 0 ? Utility.convertServerDateToRequiredDate(dateStr: fluid.fluidIntakeTime ?? "", requiredDateformat: DateFormats.hh_mm_a) : ""
            
            return [InputTextfieldModel(value: fluid.fluidIntake ?? "", placeholder: NursingTitles.Nutrition.FluidIntake.FluidIntake, apiKey: Key.Params.NursingCareFlow.Nutrition.fluidIntake, valueId: fluid.fluidIntake ?? nil, inputType: InputType.Text, dropdownArr: nil,isValid: true, errorMessage: nil, sectionHeader: NursingTitles.Nutrition.FluidIntake.FluidIntake),
                     
                     InputTextfieldModel(value: time, placeholder: NursingTitles.Nutrition.FluidIntake.FluidIntakeTime, apiKey: Key.Params.NursingCareFlow.Nutrition.fluidIntakeTime, valueId: time.count != 0 ? time : nil, inputType: InputType.Time, dropdownArr: nil,isValid: true, errorMessage: nil, sectionHeader: NursingTitles.Nutrition.FluidIntake.FluidIntake),
                     
                     InputTextfieldModel(value: fluid.fluidIntakeAmount, placeholder: NursingTitles.Nutrition.FluidIntake.Amount, apiKey: Key.Params.NursingCareFlow.Nutrition.fluidIntakeAmount, valueId: Int(fluid.fluidIntakeAmount ?? "") ?? nil, inputType: InputType.Number, dropdownArr: nil,isValid: true, errorMessage: nil, sectionHeader: NursingTitles.Nutrition.FluidIntake.FluidIntake)]
        }
        
        return [ InputTextfieldModel(value: "", placeholder: NursingTitles.Nutrition.FluidIntake.FluidIntake, apiKey: Key.Params.NursingCareFlow.Nutrition.fluidIntake, valueId: nil, inputType: InputType.Text, dropdownArr: nil,isValid: true, errorMessage: nil, sectionHeader: NursingTitles.Nutrition.FluidIntake.FluidIntake),
        InputTextfieldModel(value: "", placeholder: NursingTitles.Nutrition.FluidIntake.FluidIntakeTime, apiKey: Key.Params.NursingCareFlow.Nutrition.fluidIntakeTime, valueId: nil, inputType: InputType.Time, dropdownArr: nil,isValid: true, errorMessage: nil, sectionHeader: NursingTitles.Nutrition.FluidIntake.FluidIntake),
        InputTextfieldModel(value: "", placeholder: NursingTitles.Nutrition.FluidIntake.Amount, apiKey: Key.Params.NursingCareFlow.Nutrition.fluidIntakeAmount, valueId: nil, inputType: InputType.Number, dropdownArr: nil,isValid: true, errorMessage: nil, sectionHeader: NursingTitles.Nutrition.FluidIntake.FluidIntake)]
    }
    
    func getOutputCountInput() -> [Any]{
        let valueTotal  = self.nutritionDetail != nil ? "" : ""
        let valueTotalId  = self.nutritionDetail != nil ? 0 : nil

        let bowelTotal = (self.nutritionDetail?.numberOfBowelMovement ?? 0) == 0 ? "" : "\((self.nutritionDetail?.numberOfBowelMovement ?? 0))"
        let urinaryTotal = (self.nutritionDetail?.numberOfUrinaryVoids ?? 0) == 0 ? "" : "\((self.nutritionDetail?.numberOfUrinaryVoids ?? 0))"
        let emesisTotal = (self.nutritionDetail?.emesisSubTotal
            ?? 0) == 0 ? "" : "\((self.nutritionDetail?.emesisSubTotal ?? 0))"
        let bloodTotal = (self.nutritionDetail?.bloodLossTotal ?? 0) == 0 ? "" : "\((self.nutritionDetail?.bloodLossTotal ?? 0))"
        let totalFluidOutput = (self.nutritionDetail?.totalFluidOutput ?? 0) == 0 ? "" : "\((self.nutritionDetail?.totalFluidOutput ?? 0))"

        let perinial = (self.nutritionDetail?.perinealPadsCount ?? 0) == 0 ? "" : "\((self.nutritionDetail?.perinealPadsCount ?? 0))"

        let briefCount = (self.nutritionDetail?.briefPullUp ?? 0) == 0 ? "" : "\((self.nutritionDetail?.briefPullUp ?? 0))"

        let incontitentUrinary = self.getDropdownName(id: self.nutritionDetail?.incontinentUrinaryId ?? 0, dropdown: self.dropDownforFieldType(type: NursingDropDownType.NCFS_NURSING_CARE_FLOW_YN))
        
        let incontitentBowel = self.getDropdownName(id: self.nutritionDetail?.incontinentBowelId ?? 0, dropdown: self.dropDownforFieldType(type: NursingDropDownType.NCFS_NURSING_CARE_FLOW_YN))

        let voidingPattern = self.getDropdownName(id: self.nutritionDetail?.voidingPatternGUId ?? 0, dropdown: self.dropDownforCarePlanType(type: NursingDropDownType.VOIDING_TYPE))
        let checkPerformed = (self.nutritionDetail?.rectalCheckPerformed ?? false) ? "Yes" : "No"
        let rectalCheck = self.nutritionDetail?.rectalCheckPerformed != nil ? checkPerformed : ""

        let bowelCare = self.getDropdownName(id: self.nutritionDetail?.bowelCareId ?? 0, dropdown: self.dropDownforCarePlanType(type: NursingDropDownType.BowelCare))

        let notes = self.nutritionDetail?.notes ?? ""
        let bowelStatus = self.getYesNO(boolvalue: self.nutritionDetail?.bowel ?? false)
        let urinaryVoidStatus = self.getYesNO(boolvalue: self.nutritionDetail?.urinaryVoid ?? false)
        let emesisStatus = self.getYesNO(boolvalue: self.nutritionDetail?.emesis ?? false)
        let bloodLossStatus = self.getYesNO(boolvalue: self.nutritionDetail?.bloodLoss ?? false)
        

        return [InputTextfieldModel(value: bowelStatus, placeholder: YesNONutritionHydration.Bowel, apiKey: "", valueId: nil, inputType: InputType.Dropdown, dropdownArr: self.dropDownforFieldType(type: NursingDropDownType.NCFS_NURSING_CARE_FLOW_YN),isValid: true, errorMessage: nil),
               //self.getBowelArray(bowelObject: nil),
        
                InputTextfieldModel(value: bowelTotal, placeholder: NursingTitles.Nutrition.Bowel.TotalBowelMovement, apiKey: Key.Params.NursingCareFlow.Nutrition.numberOfBowelMovement, valueId: self.nutritionDetail?.numberOfBowelMovement , inputType: InputType.Number, dropdownArr: nil,isValid: true, errorMessage: nil),
            
            InputTextfieldModel(value: urinaryVoidStatus, placeholder: YesNONutritionHydration.Urinary_Voids, apiKey: "", valueId: nil, inputType: InputType.Dropdown, dropdownArr: self.dropDownforFieldType(type: NursingDropDownType.NCFS_NURSING_CARE_FLOW_YN),isValid: true, errorMessage: nil),
           // self.getUrinaryVoidsArray(urinaryObject: nil),
            
            InputTextfieldModel(value: urinaryTotal, placeholder: NursingTitles.Nutrition.UrinaryVoids.TotalUrinaryVoids, apiKey: Key.Params.NursingCareFlow.Nutrition.numberOfUrinaryVoids, valueId: self.nutritionDetail?.numberOfUrinaryVoids == nil ? valueTotalId : (self.nutritionDetail?.numberOfUrinaryVoids ?? 0), inputType: InputType.Number, dropdownArr: nil,isValid: true, errorMessage: nil),
                
            
              InputTextfieldModel(value: emesisStatus, placeholder: YesNONutritionHydration.Emesis, apiKey: "", valueId: nil, inputType: InputType.Dropdown, dropdownArr: self.dropDownforFieldType(type: NursingDropDownType.NCFS_NURSING_CARE_FLOW_YN),isValid: true, errorMessage: nil),
               // self.getEmesisArray(emesisObject: nil),
                
                InputTextfieldModel(value: emesisTotal, placeholder: NursingTitles.Nutrition.Emesis.EmesisTotal, apiKey: Key.Params.NursingCareFlow.Nutrition.emesisSubTotal, valueId: self.nutritionDetail?.emesisSubTotal == nil ? 0 : (self.nutritionDetail?.emesisSubTotal ?? 0), inputType: InputType.Number, dropdownArr: nil,isValid: true, errorMessage: nil),
                    
                    InputTextfieldModel(value: bloodLossStatus, placeholder: YesNONutritionHydration.Blood_Loss, apiKey: "", valueId: nil, inputType: InputType.Dropdown, dropdownArr: self.dropDownforFieldType(type: NursingDropDownType.NCFS_NURSING_CARE_FLOW_YN),isValid: true, errorMessage: nil),
                    //self.getBloodLossArray(bloodLossObject: nil),
                     
                    InputTextfieldModel(value: bloodTotal, placeholder: NursingTitles.Nutrition.BloodLoss.BloodLossTotal, apiKey: Key.Params.NursingCareFlow.Nutrition.bloodLossTotal, valueId: self.nutritionDetail?.bloodLossTotal == nil ? 0 : (self.nutritionDetail?.bloodLossTotal ?? 0), inputType: InputType.Number, dropdownArr: nil,isValid: true , errorMessage: nil),

            
            InputTextfieldModel(value: totalFluidOutput, placeholder: NursingTitles.Nutrition.TotalFluidOutput, apiKey: Key.Params.NursingCareFlow.Nutrition.totalFluidOutput, valueId: self.nutritionDetail?.totalFluidOutput ?? 0, inputType: InputType.Number, dropdownArr: nil,isValid: true, errorMessage: nil),
                
            InputTextfieldModel(value: incontitentUrinary, placeholder: NursingTitles.Nutrition.IncontinentUrinary, apiKey: Key.Params.NursingCareFlow.Nutrition.incontinentUrinaryId, valueId: self.nutritionDetail?.incontinentUrinaryId ?? nil, inputType: InputType.Dropdown, dropdownArr: self.dropDownforFieldType(type: NursingDropDownType.NCFS_NURSING_CARE_FLOW_YN),isValid: incontitentUrinary.count != 0, errorMessage: ConstantStrings.mandatory),
                
            InputTextfieldModel(value: incontitentBowel, placeholder: NursingTitles.Nutrition.IncontinentBowel, apiKey: Key.Params.NursingCareFlow.Nutrition.incontinentBowelId, valueId: self.nutritionDetail?.incontinentBowelId ?? nil, inputType: InputType.Dropdown, dropdownArr: self.dropDownforFieldType(type: NursingDropDownType.NCFS_NURSING_CARE_FLOW_YN),isValid: incontitentBowel.count != 0, errorMessage: ConstantStrings.mandatory),
                
                InputTextfieldModel(value: briefCount, placeholder: NursingTitles.Nutrition.BriefCount, apiKey: Key.Params.NursingCareFlow.Nutrition.briefPullUp, valueId: self.nutritionDetail?.briefPullUp ?? nil, inputType: InputType.Number, dropdownArr: nil,isValid: true, errorMessage: nil),
                
                InputTextfieldModel(value: perinial, placeholder: NursingTitles.Nutrition.PerinealPadsCount, apiKey: Key.Params.NursingCareFlow.Nutrition.perinealPadsCount, valueId: self.nutritionDetail?.perinealPadsCount ?? nil, inputType: InputType.Number, dropdownArr: nil,isValid: true, errorMessage: nil),
                
                InputTextfieldModel(value: voidingPattern, placeholder: NursingTitles.Nutrition.VoidingPatternGU, apiKey: Key.Params.NursingCareFlow.Nutrition.voidingPatternGUId, valueId: self.nutritionDetail?.voidingPatternGUId ?? nil, inputType: InputType.Dropdown, dropdownArr: self.dropDownforProgressNotType(type: ProgressNotsType.Voiding_pattern_GU),isValid: true, errorMessage: nil),
                
                InputTextfieldModel(value: rectalCheck, placeholder: NursingTitles.Nutrition.RectalCheckPerformed, apiKey: Key.Params.NursingCareFlow.Nutrition.rectalCheckPerformed, valueId: self.nutritionDetail?.rectalCheckPerformed ?? nil, inputType: InputType.Dropdown, dropdownArr: ["Yes","No"],isValid: true, errorMessage: nil),
                
                InputTextfieldModel(value: bowelCare, placeholder: NursingTitles.Nutrition.BowelCare, apiKey: Key.Params.NursingCareFlow.Nutrition.bowelCareId, valueId: self.nutritionDetail?.bowelCareId ?? nil, inputType: InputType.Dropdown, dropdownArr: self.dropDownforCarePlanType(type: NursingDropDownType.BowelCare),isValid: true, errorMessage: nil),
                
                //InputTextfieldModel(value: notes, placeholder: NursingTitles.Nutrition.Notes, apiKey: Key.Params.NursingCareFlow.Nutrition.notes, valueId: self.nutritionDetail?.notes ?? nil, inputType: InputType.Text, dropdownArr: nil,isValid: true, errorMessage: nil),
                
        ]

    }
    
    func getBowelArray(bowelObject : DynamicBowel?) -> [InputTextfieldModel]{
        if let bowel = bowelObject{
            let consistency = self.getDropdownName(id: bowel.consistencyId ?? 0, dropdown: self.dropDownforCarePlanType(type: NursingDropDownType.BOWEL_CONSISTENCY))
            let time = (bowel.bowelTime ?? "").count != 0 ? Utility.convertServerDateToRequiredDate(dateStr: bowel.bowelTime ?? "", requiredDateformat: DateFormats.hh_mm_a) : ""

            return [InputTextfieldModel(value:
                bowel.amountBowelId != nil ? "\(bowel.amountBowelId ?? 0)" : "", placeholder: NursingTitles.Nutrition.Bowel.Amount, apiKey: Key.Params.NursingCareFlow.Nutrition.amountBowelId, valueId: bowel.amountBowelId != nil ? bowel.amountBowelId : nil, inputType: InputType.Dropdown, dropdownArr: self.dropDownforFieldType(type: NursingDropDownType.NCFS_BOWEL_AMOUNT_TYPE),isValid: true, errorMessage: nil, sectionHeader: NursingTitles.Nutrition.Bowel.Bowel),
                    InputTextfieldModel(value: consistency, placeholder: NursingTitles.Nutrition.Bowel.Consistency, apiKey: Key.Params.NursingCareFlow.Nutrition.consistencyId, valueId:  bowel.consistencyId ?? nil, inputType: InputType.Dropdown, dropdownArr: self.dropDownforProgressNotType(type: ProgressNotsType.Consistency_Stool),isValid: true, errorMessage: nil, sectionHeader: NursingTitles.Nutrition.Bowel.Bowel),
                    InputTextfieldModel(value: time, placeholder: NursingTitles.Nutrition.Bowel.BowelTime, apiKey: Key.Params.NursingCareFlow.Nutrition.bowelTime, valueId: bowel.bowelTime ?? nil, inputType: InputType.Time, dropdownArr: nil,isValid: true, errorMessage: nil, sectionHeader: NursingTitles.Nutrition.Bowel.Bowel)]

        }
        return [InputTextfieldModel(value: "", placeholder: NursingTitles.Nutrition.Bowel.Amount, apiKey: Key.Params.NursingCareFlow.Nutrition.amountBowelId, valueId: nil, inputType: InputType.Dropdown, dropdownArr: self.dropDownforFieldType(type: NursingDropDownType.NCFS_BOWEL_AMOUNT_TYPE),isValid: true, errorMessage: nil, sectionHeader: NursingTitles.Nutrition.Bowel.Bowel),
                InputTextfieldModel(value: "", placeholder: NursingTitles.Nutrition.Bowel.Consistency, apiKey: Key.Params.NursingCareFlow.Nutrition.consistencyId, valueId: nil, inputType: InputType.Dropdown, dropdownArr: self.dropDownforProgressNotType(type: ProgressNotsType.Consistency_Stool),isValid: true, errorMessage: nil, sectionHeader: NursingTitles.Nutrition.Bowel.Bowel),
        InputTextfieldModel(value: "", placeholder: NursingTitles.Nutrition.Bowel.BowelTime, apiKey: Key.Params.NursingCareFlow.Nutrition.bowelTime, valueId: nil, inputType: InputType.Time, dropdownArr: nil,isValid: true, errorMessage: nil, sectionHeader: NursingTitles.Nutrition.Bowel.Bowel)]
    }
    
    func getUrinaryVoidsArray(urinaryObject : DynamicUrinary?) -> [InputTextfieldModel]{
        if let urinary = urinaryObject{
            let time = (urinary.urinTime ?? "").count != 0 ? Utility.convertServerDateToRequiredDate(dateStr: urinary.urinTime ?? "", requiredDateformat: DateFormats.hh_mm_a) : ""

            return [
                InputTextfieldModel(value: urinary.urinAmount != nil ? urinary.urinAmount : "", placeholder: NursingTitles.Nutrition.UrinaryVoids.Amount, apiKey: Key.Params.NursingCareFlow.Nutrition.urinAmount, valueId: urinary.urinAmount != nil ? Int(urinary.urinAmount ?? ""): nil, inputType: InputType.Number, dropdownArr: nil,isValid: true, errorMessage: nil, sectionHeader: NursingTitles.Nutrition.UrinaryVoids.UrinaryVoids),
                    InputTextfieldModel(value: time, placeholder: NursingTitles.Nutrition.UrinaryVoids.UrineTime, apiKey: Key.Params.NursingCareFlow.Nutrition.urinTime, valueId: urinary.urinTime ?? nil, inputType: InputType.Time, dropdownArr: nil,isValid:true, errorMessage: nil, sectionHeader: NursingTitles.Nutrition.UrinaryVoids.UrinaryVoids),
            InputTextfieldModel(value: urinary.urinColor ?? "", placeholder: NursingTitles.Nutrition.UrinaryVoids.UrineColor, apiKey: Key.Params.NursingCareFlow.Nutrition.urinColor, valueId: urinary.urinColor ?? nil, inputType: InputType.Text, dropdownArr: nil,isValid: true, errorMessage: nil, sectionHeader: NursingTitles.Nutrition.UrinaryVoids.UrinaryVoids)]

        }
        return [InputTextfieldModel(value: "", placeholder: NursingTitles.Nutrition.UrinaryVoids.Amount, apiKey: Key.Params.NursingCareFlow.Nutrition.urinAmount, valueId: nil, inputType: InputType.Number, dropdownArr: nil,isValid: true, errorMessage: nil, sectionHeader: NursingTitles.Nutrition.UrinaryVoids.UrinaryVoids),
        InputTextfieldModel(value: "", placeholder: NursingTitles.Nutrition.UrinaryVoids.UrineTime, apiKey: Key.Params.NursingCareFlow.Nutrition.urinTime, valueId: nil, inputType: InputType.Time, dropdownArr: nil,isValid: true, errorMessage: nil, sectionHeader: NursingTitles.Nutrition.UrinaryVoids.UrinaryVoids),
        InputTextfieldModel(value: "", placeholder: NursingTitles.Nutrition.UrinaryVoids.UrineColor, apiKey: Key.Params.NursingCareFlow.Nutrition.urinColor, valueId: nil, inputType: InputType.Text, dropdownArr: nil,isValid: true, errorMessage: nil, sectionHeader: NursingTitles.Nutrition.UrinaryVoids.UrinaryVoids)]
    }
    
    func getEmesisArray(emesisObject : DynamicEmesis?) -> [InputTextfieldModel]{
        if let emesis = emesisObject{
            let time = (emesis.emesisTime ?? "").count != 0 ? Utility.convertServerDateToRequiredDate(dateStr:emesis.emesisTime ?? "", requiredDateformat: DateFormats.hh_mm_a) : ""
            
            return [InputTextfieldModel(value: emesis.emesisAmount != nil ? emesis.emesisAmount : "", placeholder: NursingTitles.Nutrition.Emesis.Amount, apiKey: Key.Params.NursingCareFlow.Nutrition.emesisAmount, valueId: emesis.emesisAmount != nil ? Int(emesis.emesisAmount ?? ""): nil, inputType: InputType.Number, dropdownArr: nil,isValid: true, errorMessage: nil, sectionHeader: NursingTitles.Nutrition.Emesis.Emesis),
                    
                InputTextfieldModel(value: time, placeholder: NursingTitles.Nutrition.Emesis.EmesisTime, apiKey: Key.Params.NursingCareFlow.Nutrition.emesisTime, valueId: emesis.emesisTime ?? nil, inputType: InputType.Time, dropdownArr: nil,isValid: true, errorMessage: nil, sectionHeader: NursingTitles.Nutrition.Emesis.Emesis),
                
            InputTextfieldModel(value: "", placeholder: "", apiKey: "", valueId: nil, inputType: InputType.Text, dropdownArr: nil,isValid: true, errorMessage: nil, sectionHeader: NursingTitles.Nutrition.Emesis.Emesis)]

        }
        return [InputTextfieldModel(value: "", placeholder: NursingTitles.Nutrition.Emesis.Amount, apiKey: Key.Params.NursingCareFlow.Nutrition.emesisAmount, valueId: nil, inputType: InputType.Number, dropdownArr: nil,isValid: true, errorMessage: nil, sectionHeader: NursingTitles.Nutrition.Emesis.Emesis),
                InputTextfieldModel(value: "", placeholder: NursingTitles.Nutrition.Emesis.EmesisTime, apiKey: Key.Params.NursingCareFlow.Nutrition.emesisTime, valueId: nil, inputType: InputType.Time, dropdownArr: nil,isValid: true, errorMessage: nil, sectionHeader: NursingTitles.Nutrition.Emesis.Emesis),
        InputTextfieldModel(value: "", placeholder: "", apiKey: "", valueId: nil, inputType: InputType.Text, dropdownArr: nil,isValid: true, errorMessage: nil, sectionHeader: NursingTitles.Nutrition.Emesis.Emesis)]
    }
    func getBloodLossArray(bloodLossObject : DynamicBloodLoss?) -> [InputTextfieldModel]{
        if let blood = bloodLossObject{
            let time = (blood.bloodLossTime ?? "").count != 0 ? Utility.convertServerDateToRequiredDate(dateStr:blood.bloodLossTime ?? "", requiredDateformat: DateFormats.hh_mm_a) : ""

            return [InputTextfieldModel(value: blood.bloodLossAmount != nil ? blood.bloodLossAmount : "", placeholder: NursingTitles.Nutrition.BloodLoss.Amount, apiKey: Key.Params.NursingCareFlow.Nutrition.bloodLossAmount, valueId: blood.bloodLossAmount != nil ? Int(blood.bloodLossAmount ?? ""): nil, inputType: InputType.Number, dropdownArr: nil,isValid: true, errorMessage: nil, sectionHeader: NursingTitles.Nutrition.BloodLoss.BloodLoss),
                    InputTextfieldModel(value: time, placeholder: NursingTitles.Nutrition.BloodLoss.BleedingTime, apiKey: Key.Params.NursingCareFlow.Nutrition.bloodLossTime, valueId: blood.bloodLossTime ?? nil, inputType: InputType.Time, dropdownArr: nil,isValid: true, errorMessage: nil, sectionHeader: NursingTitles.Nutrition.BloodLoss.BloodLoss),
            InputTextfieldModel(value: "", placeholder: "", apiKey: "", valueId: nil, inputType: InputType.Text, dropdownArr: nil,isValid: true, errorMessage: nil, sectionHeader: NursingTitles.Nutrition.BloodLoss.BloodLoss)]

        }
        return [InputTextfieldModel(value: "", placeholder: NursingTitles.Nutrition.BloodLoss.Amount, apiKey: Key.Params.NursingCareFlow.Nutrition.bloodLossAmount, valueId: nil, inputType: InputType.Number, dropdownArr: nil,isValid: true, errorMessage: nil, sectionHeader: NursingTitles.Nutrition.BloodLoss.BloodLoss),
                InputTextfieldModel(value: "", placeholder: NursingTitles.Nutrition.BloodLoss.BleedingTime, apiKey: Key.Params.NursingCareFlow.Nutrition.bloodLossTime, valueId: nil, inputType: InputType.Time, dropdownArr: nil,isValid: true, errorMessage: nil, sectionHeader: NursingTitles.Nutrition.BloodLoss.BloodLoss),
        InputTextfieldModel(value: "", placeholder: "", apiKey: "", valueId: nil, inputType: InputType.Text, dropdownArr: nil,isValid: true, errorMessage: nil, sectionHeader: NursingTitles.Nutrition.BloodLoss.BloodLoss)]
    }
    func resetCallData()->[Any]{
         
         var finalArray = [Any]()
         finalArray.append(self.getIntakeInputResetDATA())
         finalArray.append(self.getOutputCountInputResetData())
         return finalArray
         
    
     }
     func getIntakeInputResetDATA() -> [Any]{
              let foodIntakeStatus = self.getYesNO(boolvalue: self.nutritionDetail?.foodIntake ?? false)
               let fluidIntakeStatus = self.getYesNO(boolvalue: self.nutritionDetail?.fluidIntake ?? false)
              return [
                InputTextfieldModel(value: foodIntakeStatus, placeholder: YesNONutritionHydration.Food_Intake, apiKey: "", valueId: nil, inputType: InputType.Dropdown, dropdownArr: self.dropDownforFieldType(type: NursingDropDownType.NCFS_NURSING_CARE_FLOW_YN),isValid: true, errorMessage: nil),
                  
                       InputTextfieldModel(value: fluidIntakeStatus, placeholder: YesNONutritionHydration.Fluid_Intake, apiKey: "", valueId: nil, inputType: InputType.Dropdown, dropdownArr: self.dropDownforFieldType(type: NursingDropDownType.NCFS_NURSING_CARE_FLOW_YN),isValid: true, errorMessage: nil),
              ]
     }
     func getOutputCountInputResetData()->[Any]{
            let bowelStatus = self.getYesNO(boolvalue: self.nutritionDetail?.bowel ?? false)
            let urinaryVoidStatus = self.getYesNO(boolvalue: self.nutritionDetail?.urinaryVoid ?? false)
            let emesisStatus = self.getYesNO(boolvalue: self.nutritionDetail?.emesis ?? false)
            let bloodLossStatus = self.getYesNO(boolvalue: self.nutritionDetail?.bloodLoss ?? false)
            let totalFluidOutput = (self.nutritionDetail?.totalFluidOutput ?? 0) == 0 ? "" : "\((self.nutritionDetail?.totalFluidOutput ?? 0))"

                 let perinial = (self.nutritionDetail?.perinealPadsCount ?? 0) == 0 ? "" : "\((self.nutritionDetail?.perinealPadsCount ?? 0))"

                 let briefCount = (self.nutritionDetail?.briefPullUp ?? 0) == 0 ? "" : "\((self.nutritionDetail?.briefPullUp ?? 0))"

                 let incontitentUrinary = self.getDropdownName(id: self.nutritionDetail?.incontinentUrinaryId ?? 0, dropdown: self.dropDownforFieldType(type: NursingDropDownType.NCFS_NURSING_CARE_FLOW_YN))
                 
                 let incontitentBowel = self.getDropdownName(id: self.nutritionDetail?.incontinentBowelId ?? 0, dropdown: self.dropDownforFieldType(type: NursingDropDownType.NCFS_NURSING_CARE_FLOW_YN))

                 let voidingPattern = self.getDropdownName(id: self.nutritionDetail?.voidingPatternGUId ?? 0, dropdown: self.dropDownforCarePlanType(type: NursingDropDownType.VOIDING_TYPE))
                 let checkPerformed = (self.nutritionDetail?.rectalCheckPerformed ?? false) ? "Yes" : "No"
                 let rectalCheck = self.nutritionDetail?.rectalCheckPerformed != nil ? checkPerformed : ""

                 let bowelCare = self.getDropdownName(id: self.nutritionDetail?.bowelCareId ?? 0, dropdown: self.dropDownforCarePlanType(type: NursingDropDownType.BowelCare))

                 let notes = self.nutritionDetail?.notes ?? ""
            return [
                InputTextfieldModel(value: bowelStatus, placeholder: YesNONutritionHydration.Bowel, apiKey: "", valueId: nil, inputType: InputType.Dropdown, dropdownArr: self.dropDownforFieldType(type: NursingDropDownType.NCFS_NURSING_CARE_FLOW_YN),isValid: true, errorMessage: nil),
                 InputTextfieldModel(value: urinaryVoidStatus, placeholder: YesNONutritionHydration.Urinary_Voids, apiKey: "", valueId: nil, inputType: InputType.Dropdown, dropdownArr: self.dropDownforFieldType(type: NursingDropDownType.NCFS_NURSING_CARE_FLOW_YN),isValid: true, errorMessage: nil),
                  InputTextfieldModel(value: emesisStatus, placeholder: YesNONutritionHydration.Emesis, apiKey: "", valueId: nil, inputType: InputType.Dropdown, dropdownArr: self.dropDownforFieldType(type: NursingDropDownType.NCFS_NURSING_CARE_FLOW_YN),isValid: true, errorMessage: nil),
                  InputTextfieldModel(value: bloodLossStatus, placeholder: YesNONutritionHydration.Blood_Loss, apiKey: "", valueId: nil, inputType: InputType.Dropdown, dropdownArr: self.dropDownforFieldType(type: NursingDropDownType.NCFS_NURSING_CARE_FLOW_YN),isValid: true, errorMessage: nil),
                  InputTextfieldModel(value: totalFluidOutput, placeholder: NursingTitles.Nutrition.TotalFluidOutput, apiKey: Key.Params.NursingCareFlow.Nutrition.totalFluidOutput, valueId: self.nutritionDetail?.totalFluidOutput ?? 0, inputType: InputType.Number, dropdownArr: nil,isValid: true, errorMessage: nil),
                      
                  InputTextfieldModel(value: incontitentUrinary, placeholder: NursingTitles.Nutrition.IncontinentUrinary, apiKey: Key.Params.NursingCareFlow.Nutrition.incontinentUrinaryId, valueId: self.nutritionDetail?.incontinentUrinaryId ?? nil, inputType: InputType.Dropdown, dropdownArr: self.dropDownforFieldType(type: NursingDropDownType.NCFS_NURSING_CARE_FLOW_YN),isValid: incontitentUrinary.count != 0, errorMessage: ConstantStrings.mandatory),
                      
                  InputTextfieldModel(value: incontitentBowel, placeholder: NursingTitles.Nutrition.IncontinentBowel, apiKey: Key.Params.NursingCareFlow.Nutrition.incontinentBowelId, valueId: self.nutritionDetail?.incontinentBowelId ?? nil, inputType: InputType.Dropdown, dropdownArr: self.dropDownforFieldType(type: NursingDropDownType.NCFS_NURSING_CARE_FLOW_YN),isValid: incontitentBowel.count != 0, errorMessage: ConstantStrings.mandatory),
                      
                      InputTextfieldModel(value: briefCount, placeholder: NursingTitles.Nutrition.BriefCount, apiKey: Key.Params.NursingCareFlow.Nutrition.briefPullUp, valueId: self.nutritionDetail?.briefPullUp ?? nil, inputType: InputType.Number, dropdownArr: nil,isValid: self.nutritionDetail?.briefPullUp != nil, errorMessage: nil),
                      
                      InputTextfieldModel(value: perinial, placeholder: NursingTitles.Nutrition.PerinealPadsCount, apiKey: Key.Params.NursingCareFlow.Nutrition.perinealPadsCount, valueId: self.nutritionDetail?.perinealPadsCount ?? nil, inputType: InputType.Number, dropdownArr: nil,isValid: self.nutritionDetail?.perinealPadsCount != nil, errorMessage: nil),
                      
                      InputTextfieldModel(value: voidingPattern, placeholder: NursingTitles.Nutrition.VoidingPatternGU, apiKey: Key.Params.NursingCareFlow.Nutrition.voidingPatternGUId, valueId: self.nutritionDetail?.voidingPatternGUId ?? nil, inputType: InputType.Dropdown, dropdownArr: self.dropDownforCarePlanType(type: NursingDropDownType.VOIDING_TYPE),isValid: voidingPattern.count != 0, errorMessage: nil),
                      
                      InputTextfieldModel(value: rectalCheck, placeholder: NursingTitles.Nutrition.RectalCheckPerformed, apiKey: Key.Params.NursingCareFlow.Nutrition.rectalCheckPerformed, valueId: self.nutritionDetail?.rectalCheckPerformed ?? nil, inputType: InputType.Dropdown, dropdownArr: ["Yes","No"],isValid: rectalCheck.count != 0, errorMessage: nil),
                      
                      InputTextfieldModel(value: bowelCare, placeholder: NursingTitles.Nutrition.BowelCare, apiKey: Key.Params.NursingCareFlow.Nutrition.bowelCareId, valueId: self.nutritionDetail?.bowelCareId ?? nil, inputType: InputType.Dropdown, dropdownArr: self.dropDownforCarePlanType(type: NursingDropDownType.BowelCare),isValid: true, errorMessage: nil),
                      
                      //InputTextfieldModel(value: notes, placeholder: NursingTitles.Nutrition.Notes, apiKey: Key.Params.NursingCareFlow.Nutrition.notes, valueId: self.nutritionDetail?.notes ?? nil, inputType: InputType.Text, dropdownArr: nil,isValid: true, errorMessage: nil),
                
            ]
     }
}
