//
//  SetAvailabilityViewModel.swift

//
//  Created by Vasundhara Parakh on 5/21/20.
//  Copyright © 2020 smartData Enterprises (I) Ltd. All rights reserved.
//

import UIKit

class SetAvailabilityViewModel: BaseViewModel{
    // MARK: - Parameters
    var service:VirtualConsultService
    var serviceMaster : MasterService
    // MARK: - Constructor
    init(with service:VirtualConsultService) {
        self.service = service
        self.serviceMaster = MasterService()
    }
    
    var arrData = [ListingSectionModel]()

    var dropdownShift = [Shift]()

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

        return ""
    }
    
}
//MARK:- NursingCareViewModel
extension SetAvailabilityViewModel{
    
    func saveAvailability(params:[String:Any]){
        self.isLoading = true
        service.saveAvailability(params: params) { (result) in
            self.isLoading = false

            self.alertMessage = (result as? String) ?? ""
        }
    }
    func getShiftDropdown(unitID : Int){
        self.isLoading = true
        serviceMaster.getShiftByUnitDropdown(unitID: unitID, shiftType: 0) { (result) in
            self.isLoading = false
            if let res = result as? [Shift]
            {
                self.dropdownShift = res
                self.shouldUpdateView = true
            }else{
                self.errorMessage = Alert.ErrorMessages.invalid_response
            }
        }
    }
    func getInputArray() -> [Any]{
        var finalArray = [Any]()
        finalArray.append(self.getInput())
        return finalArray
    }
    
    func getInput() -> [Any]{
        return [
            //InputTextfieldModel(value: "", placeholder: "Shift", apiKey: "masterShiftId", valueId: nil, inputType: InputType.Dropdown, dropdownArr: self.dropdownShift ,isValid: false, errorMessage: ConstantStrings.mandatory),
                
                
            self.getAvailabilityInput(),
            
            self.getUnAvailabilityInput(),


        ]
    }
    func getAvailabilityInput() -> [InputTextfieldModel]{
        return [ InputTextfieldModel(value: "", placeholder: "Date", apiKey: "date", valueId: nil, inputType: InputType.Date, dropdownArr: nil,isValid: true, errorMessage: ConstantStrings.mandatory, sectionHeader: "Availability Date & Time"),
        InputTextfieldModel(value: "", placeholder: "Start Time", apiKey: "startTime", valueId: nil, inputType: InputType.Time, dropdownArr: nil,isValid: true, errorMessage: ConstantStrings.mandatory, sectionHeader: "Availability Date & Time"),
        InputTextfieldModel(value: "", placeholder: "End Time", apiKey: "endTime", valueId: nil, inputType: InputType.Time, dropdownArr: nil,isValid: true, errorMessage: ConstantStrings.mandatory, sectionHeader: "Availability Date & Time")]
    }
    
    func getUnAvailabilityInput() -> [InputTextfieldModel]{
        return [ InputTextfieldModel(value: "", placeholder: "Date", apiKey: "date", valueId: nil, inputType: InputType.Date, dropdownArr: nil,isValid: true, errorMessage: ConstantStrings.mandatory, sectionHeader: "Unavailability Date & Time"),
        InputTextfieldModel(value: "", placeholder: "Start Time", apiKey: "startTime", valueId: nil, inputType: InputType.Time, dropdownArr: nil,isValid: true, errorMessage: ConstantStrings.mandatory, sectionHeader: "Unavailability Date & Time"),
        InputTextfieldModel(value: "", placeholder: "End Time", apiKey: "endTime", valueId: nil, inputType: InputType.Time, dropdownArr: nil,isValid: true, errorMessage: ConstantStrings.mandatory, sectionHeader: "Unavailability Date & Time")]
    }
    
}
