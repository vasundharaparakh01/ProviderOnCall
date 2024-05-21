//
//  AddTaskViewModel.swift
//  appName
//
//  Created by Vasundhara Parakh on 4/7/20.
//  Copyright © 2020 smartData Enterprises (I) Ltd. All rights reserved.
//

import UIKit
enum AddTaskTitles{
    enum Headers {
        static let Assignment = "Assignment"
        static let SpecifiedResident = "Specified \(UserDefaults.getOrganisationTypeName())"
        static let Priority = "Priority"
        static let Status = "Status"
    }
    static let selectTaskType = "Select Task Type"
    static let taskDescription = "Task Description"
    static let location = "Location"
    static let shift = "Shift"
    static let role = "Role"
    static let assignedto = "Assigned To"
    static let following = "I'm Following"
    static let startDue = "Start Date"
    static let dueDate = "Due Date"
    static let residentName = "\(UserDefaults.getOrganisationTypeName()) Name"
    static let priority = "Priority"
    static let status = "Status"
    static let unit = "Unit"

}
class AddTaskViewModel: BaseViewModel{
    // MARK: - Parameters
    var service:TaskService
    var serviceMaster = MasterService()
    // MARK: - Constructor
    init(with service:TaskService) {
        self.service = service
    }

    var arrData = [ListingSectionModel]()
    var dateOfPlan = ""
    var planAddedBy = ""
    let headerArray = ["",
                       AddTaskTitles.Headers.Assignment,
                       AddTaskTitles.Headers.SpecifiedResident,
                       AddTaskTitles.Headers.Priority,
                       AddTaskTitles.Headers.Status]
    var locationID : Int = (AppInstance.shared.user?.staffLocation?[0])?.locationID ?? 0
    var unitID : Int = 0

    var dropdownMasterData : AddTaskMasters?
    var dropdownUnit : [UnitMaster]?
    var dropdownResident : [MasterResidentList]?
    var dropdownStaffPatient : PatientStaffMaster?
    var dropdownShift : [Shift]?
    var availabilityList = [AvailabilityByDayName]()

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
        if section == 2{
          return  "Specified \(UserDefaults.getOrganisationTypeName())"
        }
        return self.headerArray[section]
    }

}
//MARK:- Add Task
extension AddTaskViewModel{
    // MARK: - Network calls
    func saveTask(params : [String: Any]){
        self.isLoading = true
        service.saveTask(params: params) { (result) in
            self.isLoading = false
            if let res = result as? String{
                self.errorMessage = res
            }else{
                self.isSuccess = true
                self.alertMessage = Alert.Message.formSavedSuccessfully
            }
            
         }
    }
    func getAvailabilityList(fromDate: String,toDate: String, shiftId : Int,staffId : Int){
        self.isLoading = true
        VirtualConsultService().getAvailabilityList(fromDate: fromDate, toDate: toDate, shiftId: shiftId,staffId: staffId) { (result) in
            self.isLoading = false
            if let res = result as? [AvailabilityByDayName]{
                self.availabilityList = res
            }
            self.shouldUpdateViewForCalendar = true

        }
    }
    
    func getTaskMasters(){
        self.isLoading = true
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
        }
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
    
    func getStaffPatientDropdown(locationId : Int,roleId:Int,unitID: Int,shiftId:Int,completion:@escaping (Any?) -> Void){
        self.isLoading = true
        serviceMaster.getStaffPatientDropdown(locationID: self.locationID,roleId: roleId,unitID: unitID, shiftId: shiftId) { (result) in
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
        finalArray.append(self.getFirstSection())
        finalArray.append(self.getAssignmentInput())
        finalArray.append(self.getResidentInput())
        finalArray.append(self.getPriorityInput())
        //finalArray.append(self.getStatusInput())
        return finalArray
    }
    func getFirstSection() -> [Any]{
        return [InputTextfieldModel(value: "", placeholder: AddTaskTitles.selectTaskType, apiKey: Key.Params.AddTask.TaskTypeID, valueId: nil, inputType: InputType.Text, dropdownArr: self.dropdownMasterData?.masterTaskType ?? [""],isValid: false, errorMessage: ConstantStrings.mandatory),
                
        InputTextfieldModel(value: "", placeholder: AddTaskTitles.taskDescription, apiKey: Key.Params.AddTask.Notes, valueId: nil, inputType: InputType.Text, dropdownArr: nil,isValid: false, errorMessage: nil),
        ]
    }
    
    func getResidentInput() -> [Any]{
        return [InputTextfieldModel(value: "", placeholder: "\(UserDefaults.getOrganisationTypeName()) Name",
                apiKey: Key.Params.AddTask.PatientID, valueId: nil, inputType: InputType.Text, dropdownArr: self.dropdownResident ?? [""],isValid: true, errorMessage: nil)
        ]
    }
    
    func getAssignmentInput() -> [Any]{
        return [[InputTextfieldModel(value: "", placeholder: AddTaskTitles.unit, apiKey: Key.Params.AddTask.ServiceLocationID, valueId: nil, inputType: InputType.Dropdown, dropdownArr: self.dropdownUnit ?? [""],isValid: false, errorMessage: ConstantStrings.mandatory),
                 InputTextfieldModel(value: "", placeholder: AddTaskTitles.shift, apiKey: Key.Params.AddTask.shiftId, valueId: nil, inputType: InputType.Dropdown, dropdownArr: self.dropdownShift ?? [""],isValid: false, errorMessage: ConstantStrings.mandatory)],
                  
                InputTextfieldModel(value: "", placeholder: AddTaskTitles.assignedto, apiKey: Key.Params.AddTask.AppointmentStaffs, valueId: nil, inputType: InputType.Dropdown, dropdownArr: [""],isValid: false, errorMessage: ConstantStrings.mandatory),
                  
                InputTextfieldModel(value: "", placeholder: "I'm Following", apiKey: Key.Params.AddTask.isImFollowing, valueId: false, inputType: InputType.Checkmark, dropdownArr: nil,isValid: false, errorMessage: ConstantStrings.mandatory),
                
                  [InputTextfieldModel(value: "", placeholder: AddTaskTitles.startDue, apiKey: Key.Params.AddTask.StartDateTime, valueId: nil, inputType: InputType.Text, dropdownArr: nil,isValid: false, errorMessage: ConstantStrings.mandatory),
                  InputTextfieldModel(value: "", placeholder: AddTaskTitles.dueDate, apiKey: Key.Params.AddTask.EndDateTime, valueId: nil, inputType: InputType.Text, dropdownArr: nil,isValid: false, errorMessage: nil)]
                  
         ]
    }
    
    func getPriorityInput() -> [Any]{
        return [InputTextfieldModel(value: "", placeholder: AddTaskTitles.priority, apiKey: Key.Params.AddTask.TaskPriorityId, valueId: nil, inputType: InputType.Dropdown, dropdownArr: self.dropdownMasterData?.masterTaskPriority ?? [""],isValid: false, errorMessage: ConstantStrings.mandatory)
        ]
    }

    func getStatusInput() -> [Any]{
        return [InputTextfieldModel(value: "", placeholder: AddTaskTitles.status, apiKey: Key.Params.AddTask.TaskStatusId, valueId: nil, inputType: InputType.Dropdown, dropdownArr: self.dropdownMasterData?.masterTaskStatus ?? [""],isValid: false, errorMessage: ConstantStrings.mandatory)
        ]
    }

}

