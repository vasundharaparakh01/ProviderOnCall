//
//  ESASGraphViewModel.swift
//  appName
//
//  Created by Vasundhara Parakh on 3/25/20.
//  Copyright © 2020 smartData Enterprises (I) Ltd. All rights reserved.
//

import UIKit

class ESASGraphViewModel: BaseViewModel{
    // MARK: - Parameters
    var service:PointOfCareService
    var serviceMaster : MasterService
    var selectedSection = 0
    var vitalsMasterData : MasterData?
    var locationID : Int = (AppInstance.shared.user?.staffLocation?[0])?.locationID ?? 0
    var selectedUnitID : Int = 0

    var locationName : String = ""
    var selectedShift : Shift?
    var graphArray : [TrendGraph]?
    var titleArray = [String]() {
        didSet {
            var tempArray = [UIColor]()
            for (_,item) in titleArray.enumerated(){
                tempArray.append(UIColor.random)
            }
            self.categoryColorArray = tempArray
            self.reloadListViewClosure?()
        }
    }
    var selectedCategory : String = ""
    var selectedCategoryIndex : Int?

    var categoryColorArray = [UIColor]()
    
    var dropdownUnit : [UnitMaster]?

    // MARK: - Constructor
    init(with service:PointOfCareService) {
        self.service = service
        self.serviceMaster = MasterService()
    }
    
    var arrData = [Any]()

    var dropdownLocation : [LocationMaster]?
    var dropdownShift : [Shift]?

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
//MARK:- ESASGraphViewModel
extension ESASGraphViewModel{
    // MARK: - Network calls
    func getESASGraphDetail( params : [String: Any]){
        self.isLoading = true
        service.getESASGraphDetail(params: params) { (result) in
            self.isLoading = false
            if let res = result as? [TrendGraph]{
                self.graphArray = res
                self.titleArray = self.getArrayOfCategories()
            }else{
                self.graphArray?.removeAll()
                self.titleArray.removeAll()
                self.errorMessage = (result as? String) ?? Alert.ErrorMessages.invalid_response
            }
        }
        /*
        self.isLoading = true
        service.saveESASRating( params: params)  { (result) in
            self.isLoading = false

            if let res = result as? String{
                self.errorMessage = res
            }else{
            self.isSuccess = true
            self.alertMessage = Alert.Message.formSavedSuccessfully
            }
        }*/
    }
    func getArrayOfCategories() -> [String]{
        if let arr = self.graphArray{
            let arrTitles = arr.compactMap{$0.text ?? ""}
            return arrTitles
        }
        return [String]()
    }
    
    func getGraphDataForCategory(type: String) -> [GraphDetails]?{
        if let arr = self.graphArray{
            let filteredArray = arr.filter{$0.text == type}
            return filteredArray.count > 0 ? (filteredArray.first?.graphDetails ?? nil) : nil
               }
        return nil
    }
    
    func getIndexOfCategory(type: String) -> Int?{
        if let arr = self.graphArray{
            for (index,item) in arr.enumerated(){
                if item.text == type{
                    return index
                }
            }
        }
        return nil
    }
    
    func getLocationDropdown(patientID: Int){
        self.getUnitDropdown { (result) in
            self.isLoading = false

            if let res = result as? [UnitMaster]
            {
                self.dropdownUnit = res
                self.shouldUpdateView = true

            }else{
                self.errorMessage = Alert.ErrorMessages.invalid_response
            }
        }
        /*
        self.isLoading = true
        serviceMaster.getLocationDropdown(patientID: patientID, completion: { (result) in
            if let res = result as? [LocationMaster]
            {
                self.isLoading = false
                
                var locationId = 0
                if res.count > 0{
                    locationId =  res[0].locationID ?? 0
                    self.locationID = locationId
                    self.locationName = res[0].locationName ?? ""
                }
                self.getShiftDropdown(locationId: self.locationID) { (shiftArray) in
                    self.isLoading = false
                    if let resShift = shiftArray as? [Shift]
                    {
                        self.dropdownShift = resShift
                        self.dropdownLocation = res
                        self.shouldUpdateView = true

                    }else{
                        self.errorMessage = Alert.ErrorMessages.invalid_response
                    }
                }
            }else{
                self.isLoading = false
                self.errorMessage = Alert.ErrorMessages.invalid_response
            }
            
        })*/
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
    func getShiftDropdown(locationId : Int,completion:@escaping (Any?) -> Void){
        self.isLoading = true
        serviceMaster.getShiftByUnitDropdown(unitID: self.selectedUnitID, shiftType: 3) { (result) in
            self.isLoading = false
            if let res = result as? [Shift]
            {
                self.dropdownShift = res
                completion(res)
            }else{
                self.errorMessage = Alert.ErrorMessages.invalid_response
            }
        }
        /*
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
        }*/
    }

    func getInputArray() -> [Any]{
         let unitName = self.getDropdownName(id: 0, dropdown: self.dropdownUnit ?? [""])
        self.selectedUnitID =  0
        return [
            [
                InputTextfieldModel(value: unitName, placeholder: ScheduleTitles.Unit, apiKey: "unitId", valueId: self.selectedUnitID, inputType: InputType.Dropdown, dropdownArr: self.dropdownUnit ?? [""],isValid: false, errorMessage: ConstantStrings.mandatory),
                
             InputTextfieldModel(value: self.selectedShift?.shiftName ?? "", placeholder: "Shift", apiKey: Key.Params.ESAS.Rating.shiftId, valueId: self.selectedShift?.id ?? 0, inputType: InputType.Dropdown, dropdownArr: self.dropdownShift ?? [""],isValid: false, errorMessage: ConstantStrings.mandatory)]
                ]
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
        
}
