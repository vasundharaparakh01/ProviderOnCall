//
//  AddScheduleViewModel.swift
//  AccessEMR
//
//  Created by Vasundhara Parakh on 5/15/20.
//  Copyright © 2020 smartData Enterprises (I) Ltd. All rights reserved.
//

import UIKit

class AddScheduleViewModel: BaseViewModel {
    // MARK: - Parameters
    var service:VirtualConsultService
    var serviceMaster = MasterService()
    var arrData = [ListingSectionModel]()
    var dropdownUnit : [UnitMaster]?
    var dropdownResident : [MasterResidentList]?
    var dropdownStaffPatient : PatientStaffMaster?
    var dropdownShift : [Shift]?
    var locationID : Int = (AppInstance.shared.user?.staffLocation?[0])?.locationID ?? 0
    var unitID : Int = 0
    var selectedStaffIds : String = ""
    var selectedResidentIds : String = ""
    var selectedShiftId : Int = 0
    var selectedStaffId : Int = 0
    var availabilityList = [AvailabilityByDayName]()

    // MARK: - Constructor
    init(with service:VirtualConsultService) {
        self.service = service
    }
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

}
//MARK:- Add Task
extension AddScheduleViewModel{
    // MARK: - Network calls
    func saveSchedule(params: [String : Any]){
        self.isLoading = true
        service.saveVCSchedule(params: params) { (result,isSuccess) in
            self.isLoading = false
            self.isSuccess = isSuccess
            if isSuccess{
                self.alertMessage = (result as? String) ?? "Some error has occured. Please try again later."
            }else{
                self.errorMessage = (result as? String) ?? "Some error has occured. Please try again later."
            }
        }
    }
    func saveScheduleAppointment(params: [String : Any]){
        self.isLoading = true
        service.saveVCScheduleAppointment(params: params) { (result,isSuccess) in
            self.isLoading = false
            self.isSuccess = isSuccess
            if isSuccess{
                self.alertMessage = (result as? String) ?? "Some error has occured. Please try again later."
            }else{
                self.errorMessage = (result as? String) ?? "Some error has occured. Please try again later."
            }
        }
    }
    func getStaffAvailability(shiftId : Int){
        
    }
    
    func getAvailabilityList(fromDate: String,toDate: String, shiftId : Int,staffId : Int){
        self.isLoading = true
        service.getAvailabilityList(fromDate: fromDate, toDate: toDate, shiftId: shiftId, staffId: staffId) { (result) in
            self.isLoading = false
            if let res = result as? [AvailabilityByDayName]{
                self.availabilityList = res
            }
            self.shouldUpdateViewForCalendar = true

        }
    }
    func getScheduleMasters(){
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
    
    func getShiftDropdown(unitID : Int,completion:@escaping (Any?) -> Void){
        self.isLoading = true
        serviceMaster.getShiftByUnitDropdown(unitID: unitID, shiftType: 1) { (result) in
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
    
    func getStaffAvailability(type : String ,shiftId : Int,date:String,completion:@escaping (Any?) -> Void){
        service.getStaffAvailabilitySlots(type: type, date: date, shiftId: shiftId) { (result) in
            if let res = result as? StaffAvailabilitySlot
            {
                completion(res)
            }else{
               completion(nil)
            }
        }
    }
    
    func getStaffPatientDropdown(locationId : Int,roleId:Int,unitID: Int,shiftId : Int?,completion:@escaping (Any?) -> Void){
        self.isLoading = true
        serviceMaster.getStaffPatientDropdown(locationID: locationId,roleId: roleId,unitID: unitID,shiftId: shiftId) { (result) in
            if let res = result as? PatientStaffMaster
            {
                completion(res)
            }else{
                self.isLoading = false
                self.errorMessage = Alert.ErrorMessages.invalid_response
            }
        }
    }
    
    func getUnitDropdown(completion:@escaping (Any?) -> Void){
        self.isLoading = true
        serviceMaster.getUnitDropdown(locationID: self.locationID) { (result) in
                        if let res = result as? [UnitMaster]
            {
                completion(res)
            }else{
                self.isLoading = false
                self.errorMessage = Alert.ErrorMessages.invalid_response
            }

        }
        
    }
    
    func getShiftScheduleByShiftID(shiftId : Int,completion:@escaping (Any?) -> Void){
        self.isLoading = true
        serviceMaster.getShiftSchedule(shiftId: shiftId) { (result) in
            if let res = result as? ShiftSchedule
            {
                completion(res)
            }else{
                self.isLoading = false
                self.errorMessage = Alert.ErrorMessages.invalid_response
            }
        }
    }
    
    func getResidentDropdown(completion:@escaping (Any?) -> Void){
        self.isLoading = true
        serviceMaster.getResidentListDropdown { (result) in
            if let res = result as? [MasterResidentList]
            {
                self.dropdownResident = res
                completion(res)
            }else{
                self.isLoading = false
                self.errorMessage = Alert.ErrorMessages.invalid_response
            }
        }
    }
    func getInputArray() -> [Any]{
        var finalArray = [Any]()
        finalArray.append(self.getInput())
        return finalArray
    }
    
    func getInputArrayForVitualSchedule() -> [Any]{
        var finalArray = [Any]()
        finalArray.append(self.getInputForVirtualConsult())
        return finalArray
    }

    func getInput() -> [Any]{
        return [[InputTextfieldModel(value: "", placeholder: ScheduleTitles.Unit, apiKey: "", valueId: nil, inputType: InputType.Dropdown, dropdownArr: self.dropdownUnit ?? [""],isValid: false, errorMessage: ConstantStrings.mandatory),
                
                InputTextfieldModel(value: "", placeholder: ScheduleTitles.Shift, apiKey: Key.Params.createVCSchedule.shiftId, valueId: nil, inputType: InputType.Dropdown, dropdownArr: self.dropdownShift ?? [""],isValid: false, errorMessage: ConstantStrings.mandatory)],
                 
               InputTextfieldModel(value: "", placeholder: ScheduleTitles.Staff, apiKey: "", valueId: nil, inputType: InputType.Text, dropdownArr: [""],isValid: false, errorMessage: ConstantStrings.mandatory),
                
                InputTextfieldModel(value: "", placeholder: ScheduleTitles.Resident, apiKey: "", valueId: nil, inputType: InputType.Text, dropdownArr: self.dropdownResident ?? [""],isValid: false, errorMessage: ConstantStrings.mandatory),
                
                InputTextfieldModel(value: "", placeholder: ScheduleTitles.SelectDate, apiKey: "", valueId: nil, inputType: InputType.Date, dropdownArr: nil,isValid: false, errorMessage: ConstantStrings.mandatory),
                
                InputTextfieldModel(value: "", placeholder: "", apiKey: "", valueId: nil, inputType: InputType.Checkmark, dropdownArr: nil,isValid: false, errorMessage: ConstantStrings.mandatory),
                
                [InputTextfieldModel(value: "", placeholder: ScheduleTitles.StartTime, apiKey: Key.Params.createVCSchedule.startDateTime, valueId: nil, inputType: InputType.Time, dropdownArr: nil,isValid: false, errorMessage: ConstantStrings.mandatory),
                
                 InputTextfieldModel(value: "", placeholder: ScheduleTitles.EndTime, apiKey: Key.Params.createVCSchedule.endDateTime, valueId: nil, inputType: InputType.Time, dropdownArr: nil,isValid: false, errorMessage: ConstantStrings.mandatory)],
                
                InputTextfieldModel(value: "", placeholder: ScheduleTitles.Notes, apiKey: Key.Params.createVCSchedule.notes, valueId: nil, inputType: InputType.Text, dropdownArr: nil,isValid: false, errorMessage: ConstantStrings.mandatory),
        ]
        
    }
    
    
    func getInputForVirtualConsult() -> [Any]{
        return [
            [InputTextfieldModel(value: "", placeholder: ScheduleTitles.Unit, apiKey: "unitId", valueId: nil, inputType: InputType.Dropdown, dropdownArr: self.dropdownUnit ?? [""],isValid: false, errorMessage: ConstantStrings.mandatory),

                InputTextfieldModel(value: "", placeholder: ScheduleTitles.Shift, apiKey: Key.Params.createVCSchedule.shiftId, valueId: nil, inputType: InputType.Dropdown, dropdownArr: self.dropdownShift ?? [""],isValid: false, errorMessage: ConstantStrings.mandatory)],
                 
                InputTextfieldModel(value: "", placeholder: ScheduleTitles.PrimaryStaff, apiKey: ScheduleTitles.PrimaryStaff, valueId: nil, inputType: InputType.Dropdown, dropdownArr: [""],isValid: false, errorMessage: ConstantStrings.mandatory),

               InputTextfieldModel(value: "", placeholder: ScheduleTitles.Staff, apiKey: "", valueId: nil, inputType: InputType.Text, dropdownArr: [""],isValid: false, errorMessage: ConstantStrings.mandatory),
                
                InputTextfieldModel(value: "", placeholder: ScheduleTitles.Resident, apiKey: "", valueId: nil, inputType: InputType.Text, dropdownArr: self.dropdownResident ?? [""],isValid: false, errorMessage: ConstantStrings.mandatory),
                
                InputTextfieldModel(value: "", placeholder: ScheduleTitles.SelectDate, apiKey: "", valueId: nil, inputType: InputType.Text, dropdownArr: nil,isValid: false, errorMessage: ConstantStrings.mandatory),
                
                //InputTextfieldModel(value: "", placeholder: "", apiKey: "", valueId: nil, inputType: InputType.Checkmark, dropdownArr: nil,isValid: false, errorMessage: ConstantStrings.mandatory),
                
                [InputTextfieldModel(value: "", placeholder: ScheduleTitles.StartTime, apiKey: Key.Params.createVCSchedule.startDateTime, valueId: nil, inputType: InputType.Time, dropdownArr: nil,isValid: false, errorMessage: ConstantStrings.mandatory),
                
                 InputTextfieldModel(value: "", placeholder: ScheduleTitles.EndTime, apiKey: Key.Params.createVCSchedule.endDateTime, valueId: nil, inputType: InputType.Time, dropdownArr: nil,isValid: false, errorMessage: ConstantStrings.mandatory)],
                
                InputTextfieldModel(value: "", placeholder: ScheduleTitles.AllowAnonymousMember, apiKey: Key.Params.createVCSchedule.anoymousCallMemberModels, valueId: nil, inputType: InputType.Checkmark, dropdownArr: nil,isValid: false, errorMessage: ConstantStrings.mandatory),

                InputTextfieldModel(value: "", placeholder: ScheduleTitles.Notes, apiKey: Key.Params.createVCSchedule.notes, valueId: nil, inputType: InputType.Text, dropdownArr: nil,isValid: false, errorMessage: ConstantStrings.mandatory),
        ]
    }

}

