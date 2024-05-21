//
//  ESASFormViewModel.swift
//  appName
//
//  Created by Vasundhara Parakh on 3/23/20.
//  Copyright © 2020 smartData Enterprises (I) Ltd. All rights reserved.
//

import UIKit

class ESASFormViewModel: BaseViewModel{
    // MARK: - Parameters
    var service:PointOfCareService
    var serviceMaster : MasterService
    var selectedSection = 0
    var vitalsMasterData : MasterData?
    var locationID : Int = (AppInstance.shared.user?.staffLocation?[0])?.locationID ?? 0
    var selectedUnitID : Int = 0

    var locationName : String = ""
    var selectedShift : Shift?
    
    var esasRatingDetail : ESASRatingDetail?
    // MARK: - Constructor
    init(with service:PointOfCareService) {
        self.service = service
        self.serviceMaster = MasterService()
    }
    
    var arrData = [Any]()

    var dropdownLocation : [LocationMaster]?
    var dropdownShift : [Shift]?
    var dropdownShiftByLocation : [Shift]?

    var dropdownUnit : [UnitMaster]?

    //MARK: -Table view methods
    func numberOfSection()-> Int{
        return 1
    }
    func numberOfRows(section : Int)-> Int{
        return arrData.count
    }
    func roomForIndexPath(_ indexPath: IndexPath) -> Any? {
        return arrData[indexPath.row]
    }
    
    
}
//MARK:- NursingCareViewModel
extension ESASFormViewModel{
    // MARK: - Network calls
    func saveESASRating( params : [String: Any]){
        self.isLoading = true
        service.saveESASRating( params: params)  { (result) in
            self.isLoading = false

            if let res = result as? String{
                self.errorMessage = res
            }else{
            self.isSuccess = true
            self.alertMessage = Alert.Message.formSavedSuccessfully
            }
        }
    }
    func saveAsDraftESASRating( params : [String: Any]){
        self.isLoading = true
        service.saveAsDraftESASRating( params: params)  { (result) in
            self.isLoading = false
            if let res = result as? String{
                self.errorMessage = res
            }else{
            self.isSuccess = true
            self.alertMessage = Alert.Message.formSavedSuccessfully
            }
        }
    }
    func getUnitDropdown(completion:@escaping (Any?) -> Void){
        self.isLoading = true
        serviceMaster.getUnitDropdown(locationID: (AppInstance.shared.user?.staffLocation?[0])?.locationID ?? 0) { (result) in
                        if let res = result as? [UnitMaster]
            {
                
                completion(res)
            }else{
                self.isLoading = false
                self.errorMessage = Alert.ErrorMessages.invalid_response
            }

        }
        
    }
    
    func getShiftDropdownByUnit(unitID : Int,completion:@escaping (Any?) -> Void){
        self.isLoading = true
        serviceMaster.getShiftByUnitDropdown(unitID: unitID, shiftType: 3) { (result) in
            if let res = result as? [Shift]
            {
                self.dropdownShift = res
                completion(res)
            }else{
                self.isLoading = false
                self.errorMessage = Alert.ErrorMessages.invalid_response
            }
        }
    }
    func getLocationDropdown(patientID: Int){
        self.isLoading = true
        self.getUnitDropdown { (resultUnit) in
            self.isLoading = false
            if let dropdown = resultUnit as? [UnitMaster]{
                self.dropdownUnit = dropdown
                
                self.shouldUpdateView = true
            }else{
                self.errorMessage = Alert.ErrorMessages.invalid_response
            }
            
        }
    }
    
    func getShiftDropdown(locationId : Int,completion:@escaping (Any?) -> Void){
        self.isLoading = true
        serviceMaster.getShiftDropdown(locationID: locationId) { (result) in
            if let res = result as? [Shift]
            {
                self.dropdownShift = res
                completion(res)
            }else{
                self.isLoading = false
                self.errorMessage = Alert.ErrorMessages.invalid_response
            }
        }
    }
//    func getESASRatingDetail(patientId : Int,completion:@escaping (Any?) -> Void){
//        self.isLoading = true
//        service.getESASRatingDetail(with: patientId) { (result) in
//            self.isLoading = false
//            if let res = result as? ESASRatingDetail{
//                self.esasRatingDetail = res
//                self.isListLoaded = true
//                completion(res)
//            }
//            completion(nil)
//        }
//    }
    func getESASRatingDetail(patientId : Int, unitId : Int ,completion:@escaping (Any?) -> Void){
        self.isLoading = true
        service.getESASRatingDetail(with: patientId, unitId: unitId) { (result) in
            self.isLoading = false
            if let res = result as? ESASRatingDetail{
                self.esasRatingDetail = res
                self.isListLoaded = true
                completion(res)
            }
            completion(nil)
        }
    }
    func getESASRatingDetailSelected(patientId : Int, unitId : Int ,shiftId : Int, locationId : Int, completion:@escaping (Any?) -> Void){
        self.isLoading = true
        
        service.getESASRatingDetailSelected(with: patientId, unitId: self.selectedUnitID, shiftID: shiftId, locationID: selectedShift?.locationId ?? 0) { (result) in
            self.isLoading = false
            if let res = result as? ESASRatingDetail{
                self.esasRatingDetail = res
                self.shouldUpdateView = true
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

        if let dropdownArr = dropdown as? [UnitMaster]{
            let dropdownList = dropdownArr.compactMap { (entity) -> UnitMaster? in
                return ((entity.id ?? 0) == id) ? entity : nil
            }
            dropdownName = dropdownList.isEmpty ? "" : dropdownList.first?.unitName ?? ""
        }
        return  dropdownName
    }
    func getInputArray() -> [Any]{
        if self.esasRatingDetail != nil{
            
            let shiftName = self.getDropdownName(id: self.esasRatingDetail?.shiftId ?? 0, dropdown: self.dropdownShift)
            self.selectedShift = Shift(dictionary: ["shiftName" : shiftName,"id" : self.esasRatingDetail?.shiftId ?? 0])
            
            self.selectedUnitID =   0
            // self.esasRatingDetail?.unitId ?? 0
        }
        
        //let unitName = self.getDropdownName(id: self.esasRatingDetail?.unitId ?? 0, dropdown: self.dropdownUnit ?? [""])
        let unitName = self.getDropdownName(id:  0, dropdown: self.dropdownUnit ?? [""])
        let shiftName = self.esasRatingDetail?.shiftName ?? ""
        return [
            [
                InputTextfieldModel(value: unitName, placeholder: ScheduleTitles.Unit, apiKey: "unitId", valueId: self.selectedUnitID, inputType: InputType.Dropdown, dropdownArr: self.dropdownUnit ?? [""],isValid: false, errorMessage: ConstantStrings.mandatory),
                //InputTextfieldModel(value: self.locationName, placeholder: "Location", apiKey: Key.Params.ESAS.Rating.locationId, valueId: self.locationID, inputType: InputType.Dropdown, dropdownArr: self.dropdownLocation ?? [""],isValid: self.locationName.count > 0 ? true : false, errorMessage: ConstantStrings.mandatory),
                InputTextfieldModel(value: shiftName, placeholder: "Shift", apiKey: Key.Params.ESAS.Rating.shiftId, valueId: self.selectedShift?.id ?? 0, inputType: InputType.Dropdown, dropdownArr: self.dropdownShift ?? [""],isValid: shiftName.count != 0, errorMessage: ConstantStrings.mandatory)],
                
            InputTextfieldModel(value: "", placeholder: "Please select the number that best describes", apiKey: "", valueId: 0, inputType: InputType.Title, dropdownArr: nil, isValid: true, errorMessage: ""),
            
                InputTextfieldModel(value: "\(self.esasRatingDetail?.pain ?? 0)", placeholder: "Pain", apiKey: Key.Params.ESAS.Rating.pain, valueId: self.esasRatingDetail?.pain ?? 0, inputType: InputType.Slider, isValid: true, errorMessage: "", sectionHeader: "", minRangeTitle: "No Pain", maxRangeTitle: "Worst Possible Pain",sliderValue: self.esasRatingDetail?.pain ?? 0),
                
                InputTextfieldModel(value: "\(self.esasRatingDetail?.tired ?? 0)", placeholder: "Tiredness", apiKey: Key.Params.ESAS.Rating.tired, valueId: self.esasRatingDetail?.tired ?? 0, inputType: InputType.Slider, isValid: true, errorMessage: "", sectionHeader: "", minRangeTitle: "Not Tired", maxRangeTitle: "Worst Possible Tiredness",sliderValue: self.esasRatingDetail?.tired ?? 0),
                
                InputTextfieldModel(value: "\(self.esasRatingDetail?.nauseated ?? 0)", placeholder: "Nausea", apiKey: Key.Params.ESAS.Rating.nauseated, valueId: self.esasRatingDetail?.nauseated ?? 0, inputType: InputType.Slider, isValid: true, errorMessage: "", sectionHeader: "", minRangeTitle: "Not Nauseated", maxRangeTitle: "Worst Possible Nausea",sliderValue: self.esasRatingDetail?.nauseated ?? 0),

                InputTextfieldModel(value: "\(self.esasRatingDetail?.depressed ?? 0)", placeholder: "Depression", apiKey: Key.Params.ESAS.Rating.depressed, valueId: self.esasRatingDetail?.depressed ?? 0, inputType: InputType.Slider, isValid: true, errorMessage: "", sectionHeader: "", minRangeTitle: "Not Depressed", maxRangeTitle: "Worst Possible Depression",sliderValue: self.esasRatingDetail?.depressed ?? 0),
            
            InputTextfieldModel(value: "\(self.esasRatingDetail?.anxious ?? 0)", placeholder: "Anxiety", apiKey: Key.Params.ESAS.Rating.anxious, valueId: self.esasRatingDetail?.anxious ?? 0, inputType: InputType.Slider, isValid: true, errorMessage: "", sectionHeader: "", minRangeTitle: "Not Anxious", maxRangeTitle: "Worst Possible Anxiety",sliderValue: self.esasRatingDetail?.anxious ?? 0),
            
            InputTextfieldModel(value: "\(self.esasRatingDetail?.drowsy ?? 0)", placeholder: "Drowsiness", apiKey: Key.Params.ESAS.Rating.drowsy, valueId: self.esasRatingDetail?.drowsy ?? 0, inputType: InputType.Slider, isValid: true, errorMessage: "", sectionHeader: "", minRangeTitle: "Not Drowsy", maxRangeTitle: "Worst Possible Drowsiness",sliderValue: self.esasRatingDetail?.drowsy ?? 0),

            
            InputTextfieldModel(value: "\(self.esasRatingDetail?.appetite ?? 0)", placeholder: "Appetite", apiKey: Key.Params.ESAS.Rating.appetite, valueId: self.esasRatingDetail?.appetite ?? 0, inputType: InputType.Slider, isValid: true, errorMessage: "", sectionHeader: "", minRangeTitle: "Best Appetite", maxRangeTitle: "Worst Possible Appetite",sliderValue: self.esasRatingDetail?.appetite ?? 0),
            
            InputTextfieldModel(value: "\(self.esasRatingDetail?.wellbeing ?? 0)", placeholder: "Feeling of Wellbeing", apiKey: Key.Params.ESAS.Rating.wellbeing, valueId: self.esasRatingDetail?.wellbeing ?? 0, inputType: InputType.Slider, isValid: true, errorMessage: "", sectionHeader: "", minRangeTitle: "Best Feeling of Wellbeing", maxRangeTitle: "Worst Possible Feeling of Wellbeing",sliderValue: self.esasRatingDetail?.wellbeing ?? 0),

            InputTextfieldModel(value: "\(self.esasRatingDetail?.shortnessOfBreath ?? 0)", placeholder: "Shortness of Breath", apiKey: Key.Params.ESAS.Rating.shortnessOfBreath, valueId: self.esasRatingDetail?.shortnessOfBreath ?? 0, inputType: InputType.Slider, isValid: true, errorMessage: "", sectionHeader: "", minRangeTitle: "No Shortness of Breath", maxRangeTitle: "Worst Possible Shortness of Breath",sliderValue: self.esasRatingDetail?.shortnessOfBreath ?? 0),
            
            InputTextfieldModel(value: "", placeholder: "Other Problem", apiKey: "", valueId: 0, inputType: InputType.Title, dropdownArr: nil, isValid: true, errorMessage: ""),
            
                ]
    }
    func getRecursiveESASCell(model : OtherTypeModel?) -> InputTextfieldModel{
        if let otherType = model{
            let type = otherType.otherType ?? ""
            let number = otherType.otherTypeNumber ?? 0
            let ratingID = otherType.esasRatingTypeMasterId ?? 0
            return InputTextfieldModel(value: type, placeholder: "Add Type|\(ratingID)", apiKey: "otherTypeModel", valueId: number, inputType: InputType.AddESASRating, isValid: type.count != 0, errorMessage: ConstantStrings.mandatory, sliderValue: number)

        }
        return InputTextfieldModel(value: "", placeholder: "Add Type", apiKey: "otherTypeModel", valueId: 0, inputType: InputType.AddESASRating, isValid: false, errorMessage: ConstantStrings.mandatory, sliderValue: 0)
    }
    
    
}
