//
//  ScheduleViewModel.swift
//  AccessEMR
//
//  Created by Vasundhara Parakh on 5/13/20.
//  Copyright © 2020 smartData Enterprises (I) Ltd. All rights reserved.
//

import UIKit
enum ScheduleTitles{
    static let Staff = "Other Providers"
    static let Resident = UserDefaults.getOrganisationTypeName()//"Resident"
    static let Unit = "Unit"
    static let Shift = "Shift"
    static let SelectDate  = "Select Date"
    static let StartTime = "Start Time"
    static let EndTime = "End Time"
    static let Notes = "Notes"
    static let AllowAnonymousMember = "Allow Anonymous Member"
    static let PrimaryStaff = "Primary Provider"

}
class ScheduleViewModel: BaseViewModel{
    // MARK: - Parameters
    var service:VirtualConsultService
    var serviceMaster = MasterService()
    // MARK: - Constructor
    init(with service:VirtualConsultService) {
        self.service = service
    }
    var appointmentList = [Appointments]()
    var arrData = [ListingSectionModel]()
    var dateOfPlan = ""
    var planAddedBy = ""
    let headerArray = ["",AddTaskTitles.Headers.Assignment,AddTaskTitles.Headers.SpecifiedResident,AddTaskTitles.Headers.Priority,AddTaskTitles.Headers.Status]
    var locationID : Int = (AppInstance.shared.user?.staffLocation?[0])?.locationID ?? 0
    var unitID : Int = 0
    var selectedStaffIds : String = ""
    var selectedResidentIds : String = ""
    var selectedShiftId : Int = 0
    var selectedStaffId : Int = 0
    var dropdownMasterData : AddTaskMasters?
    var dropdownUnit : [UnitMaster]?
    var dropdownResident : [MasterResidentList]?
    var dropdownStaffPatient : PatientStaffMaster?
    var dropdownShift : [Shift]?

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

    func numberOfRowsForAppointmentList()-> Int{
        return self.appointmentList.count
    }
    func roomForIndexPathForAppointmentList(_ indexPath: IndexPath) -> Appointments? {
        return appointmentList[indexPath.row]
    }

}
//MARK:- Add Task
extension ScheduleViewModel{
    // MARK: - Network calls
    func getPatientAppointmentList(date: Date){
        let serverDate = Utility.getStringFromDate(date: date, dateFormat: DateFormats.YYYY_MM_DD)
        self.isLoading = true
        let params = [Key.Params.locationIds : "\(self.locationID)",
            Key.Params.shiftId : self.selectedShiftId == 0 ? "" : "\(self.selectedShiftId)",
            Key.Params.staffID : self.selectedStaffId == 0 ? "" : "\(self.selectedStaffId)",
            Key.Params.fromDate : serverDate,
            Key.Params.toDate : serverDate,
            "type" : "StaffScheduling",
            Key.Params.patientIds : self.selectedResidentIds
        ]
        service.getPatientAppointment(params: params) { (result) in
            self.isLoading = false
            if let res = result as? [Appointments]{
                self.appointmentList = res
                self.isListLoaded = true
            }
        }
    }
    
    func getStaffAvailability(shiftId : Int){
        
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
        /*
        serviceMaster.getAddTaskMasters {(result) in
            if let res = result as? AddTaskMasters
            {
                self.dropdownMasterData = res
                self.getResidentDropdown { (result) in
                    self.isLoading = false

                    if let res = result as? [MasterResidentList]
                    {
                        self.getUnitDropdown { (resultUnit) in
                            self.isLoading = false
                            if let dropdown = resultUnit as? [UnitMaster]{
                                self.dropdownUnit = dropdown
                            }
                            self.shouldUpdateView = true
                            
                        }
                    }else{
                        self.errorMessage = Alert.ErrorMessages.invalid_response
                    }
                }
            }else{
                self.isLoading = false

                self.errorMessage = Alert.ErrorMessages.invalid_response
            }
        }*/
    }
    
    func getShiftDropdown(unitID : Int,completion:@escaping (Any?) -> Void){
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
    
    func getStaffPatientDropdown(locationId : Int,roleId:Int,unitID: Int,completion:@escaping (Any?) -> Void){
        self.isLoading = true
        serviceMaster.getStaffPatientDropdown(locationID: locationId,roleId: roleId,unitID: unitID, shiftId: nil) { (result) in
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
    
    func getResidentInput() -> [Any]{
        return [InputTextfieldModel(value: "", placeholder: AddTaskTitles.residentName, apiKey: Key.Params.AddTask.PatientID, valueId: nil, inputType: InputType.Text, dropdownArr: self.dropdownResident ?? [""],isValid: false, errorMessage: ConstantStrings.mandatory)
        ]
    }
    
    func getInput() -> [Any]{
        return [[InputTextfieldModel(value: "", placeholder: ScheduleTitles.Unit, apiKey: Key.Params.AddTask.ServiceLocationID, valueId: nil, inputType: InputType.Dropdown, dropdownArr: self.dropdownUnit ?? [""],isValid: false, errorMessage: ConstantStrings.mandatory),
                 InputTextfieldModel(value: "", placeholder: ScheduleTitles.Shift, apiKey: Key.Params.AddTask.shiftId, valueId: nil, inputType: InputType.Dropdown, dropdownArr: self.dropdownShift ?? [""],isValid: false, errorMessage: ConstantStrings.mandatory)],
                  
                 InputTextfieldModel(value: "", placeholder: ScheduleTitles.Staff, apiKey: Key.Params.AddTask.AppointmentStaffs, valueId: nil, inputType: InputType.Text, dropdownArr: [""],isValid: false, errorMessage: ConstantStrings.mandatory),
                 
                 InputTextfieldModel(value: "", placeholder: ScheduleTitles.Resident, apiKey: Key.Params.AddTask.AppointmentStaffs, valueId: nil, inputType: InputType.Text, dropdownArr: [""],isValid: false, errorMessage: ConstantStrings.mandatory),
         ]
    }
    
   

}

