//
//  MasterService.swift
//  AccessEMR
//
//  Created by Vasundhara Parakh on 3/2/20.
//  Copyright © 2020 smartData Enterprises (I) Ltd. All rights reserved.
//

import UIKit

class MasterService: APIService {
    
    func getVitalMasters(with target:BaseViewModel? = nil, completion:@escaping (Any?) -> Void) {
        let param = [Key.Params.masterdata: MasterDataKeys.vitalMasterKeys] as [String : Any]
        super.startService(with: .post, path: APITargetPoint.getMasterData, parameters: param, files: []) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .Success(let data):
                    // #parse response here
                    if let data = data["data"] as? Dictionary<String,Any>{
                        let detail = MasterData(dictionary: data as NSDictionary)
                        completion(detail)
                    }else{
                        completion(data["message"])
                    }
                case .Error(let error):
                    completion(error)
                }
            }
        }
    }
    
    func getPointOfCareMasters(with target:BaseViewModel? = nil, completion:@escaping (Any?) -> Void) {
        let param = [Key.Params.masterdata: MasterDataKeys.pointOfCareKeys] as [String : Any]
        super.startService(with: .post, path: APITargetPoint.getMasterData, parameters: param, files: []) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .Success(let data):
                    // #parse response here
                    
                    var tempMasterArray = [PointOfCareMasterDropdown]()

                    if let data = data["data"] as? Dictionary<String,Any>{
                        if let masterArray = data["pointOfCareMasterDropdown"] as? NSArray{
                            for (_,item) in masterArray.enumerated(){
                                if let dropdown = PointOfCareMasterDropdown(dictionary: item as! NSDictionary){
                                    tempMasterArray.append(dropdown)
                                }
                            }
                        }
                    }
                    
                    print(tempMasterArray)
                    completion(tempMasterArray)
                case .Error(let error):
                    completion(error)
                }
            }
        }
    }
    
    func getCarePlanMasters(with target:BaseViewModel? = nil, completion:@escaping (Any?) -> Void) {
        let param = [Key.Params.masterdata: MasterDataKeys.carePlanKeys] as [String : Any]
        super.startService(with: .post, path: APITargetPoint.getMasterData, parameters: param, files: []) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .Success(let data):
                    // #parse response here
                    
                    var tempMasterArray = [CarePlanMaster]()

                    if let data = data["data"] as? Dictionary<String,Any>{
                        if let masterArray = data["carePlanDropDown"] as? NSArray{
                            for (_,item) in masterArray.enumerated(){
                                if let dropdown = CarePlanMaster(dictionary: item as! NSDictionary){
                                    tempMasterArray.append(dropdown)
                                }
                            }
                        }
                    }
                    
                    print(tempMasterArray)
                    completion(tempMasterArray)
                case .Error(let error):
                    completion(error)
                }
            }
        }
    }
    func getPatientMasterProgressNotes(with target:BaseViewModel? = nil, completion:@escaping (Any?) -> Void) {
        let param = [Key.Params.masterdata: MasterDataKeys.carePlanKeys] as [String : Any]
        super.startService(with: .get, path: APITargetPoint.getPatientMasterProgressNotes, parameters: nil, files: []) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .Success(let data):
                    var tempProgressNots = [ProgressNotesMaster]()
                    if let locationArray = (data as NSDictionary).object(forKey: "data") as? NSArray{
                        for (_,item) in locationArray.enumerated(){
                            if let resident = ProgressNotesMaster(dictionary: item as! NSDictionary){
                                tempProgressNots.append(resident)
                            }
                        }
                    }
                    print(tempProgressNots)
                    completion(tempProgressNots)
                case .Error(let error):
                    completion(error)
                }
            }
        }
    }
    
    func getLocationDropdown(patientID: Int,with target:BaseViewModel? = nil, completion:@escaping (Any?) -> Void) {
        let param = [Key.Params.patientId: "\(patientID)"] as [String : Any]
        super.startService(with: .get, path: APITargetPoint.getLocation, parameters: param, files: []) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .Success(let data):
                    // #parse response here
                    
                    var tempLocationArray = [LocationMaster]()
                    if let locationArray = (data as NSDictionary).object(forKey: "data") as? NSArray{
                        for (_,item) in locationArray.enumerated(){
                            if let resident = LocationMaster(dictionary: item as! NSDictionary){
                                tempLocationArray.append(resident)
                            }
                        }
                    }
                    print(tempLocationArray)
                    completion(tempLocationArray)
                case .Error(let error):
                    completion(error)
                }
            }
        }
    }
    
    func getShiftDropdown(locationID: Int,with target:BaseViewModel? = nil, completion:@escaping (Any?) -> Void) {
        let param = [Key.Params.ESAS.Rating.locationId: "\(locationID)"] as [String : Any]
        super.startService(with: .get, path: APITargetPoint.getShift, parameters: param, files: []) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .Success(let data):
                    // #parse response here
                    
                    var tempShiftArray = [Shift]()
                    if let shiftArray = (data as NSDictionary).object(forKey: "data") as? NSArray{
                        for (_,item) in shiftArray.enumerated(){
                            if let shift = Shift(dictionary: item as! NSDictionary){
                                tempShiftArray.append(shift)
                            }
                        }
                    }
                    print(tempShiftArray)
                    completion(tempShiftArray)
                case .Error(let error):
                    completion(error)
                }
            }
        }
    }
    func getShiftByUnitDropdown(unitID: Int, shiftType: Int ,with target:BaseViewModel? = nil, completion:@escaping (Any?) -> Void) {
        var param = [String : Any]()
        if shiftType == 0{
            param = [Key.Params.AddTask.unitId: "\(unitID)"] as [String : Any]
        }else{
            param = [Key.Params.AddTask.unitId: "\(unitID)",
            Key.Params.AddTask.shiftType: "\(shiftType)"] as [String : Any]
        }
       
        super.startService(with: .get, path: APITargetPoint.getShiftByUnitId, parameters: param, files: []) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .Success(let data):
                    // #parse response here
                    
                    var tempShiftArray = [Shift]()
                    if let shiftArray = (data as NSDictionary).object(forKey: "data") as? NSArray{
                        for (_,item) in shiftArray.enumerated(){
                            if let shift = Shift(dictionary: item as! NSDictionary){
                                tempShiftArray.append(shift)
                            }
                        }
                    }
                    print(tempShiftArray)
                    completion(tempShiftArray)
                case .Error(let error):
                    completion(error)
                }
            }
        }
    }
    func getStaffPatientDropdown(locationID: Int,roleId: Int,unitID: Int,shiftId: Int?, with target:BaseViewModel? = nil, completion:@escaping (Any?) -> Void) {
        //let param = ["locationIds": "\(locationID)","roleId" : "\(roleId)", Key.Params.AddTask.unitId : "\(unitID)"] as [String : Any]
        var param = ["locationIds": "\(locationID)", Key.Params.AddTask.unitId : "\(unitID)",
                    "permissionKey" : "SCHEDULING_LIST_VIEW_OTHERSTAFF_SCHEDULES"] as [String : Any]
        if shiftId != nil{
            param["shiftId"] = "\(shiftId ?? 0)"
        }
        super.startService(with: .get, path: APITargetPoint.getPatientStaffDropdown, parameters: param, files: []) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .Success(let data):
                    // #parse response here
                    // #parse response here
                    if let data = data["data"] as? Dictionary<String,Any>{
                        let detail = PatientStaffMaster(dictionary: data as NSDictionary)
                        completion(detail)
                    }else{
                        completion(data["message"])
                    }
                case .Error(let error):
                    completion(error)
                }
            }
        }
    }
    
    func getUnitDropdown(locationID: Int, with target:BaseViewModel? = nil, completion:@escaping (Any?) -> Void) {
        let param = ["locationId": "\(locationID)"] as [String : Any]
        super.startService(with: .get, path: APITargetPoint.getUnitByLocationId, parameters: param, files: []) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .Success(let data):
                    // #parse response here
                    var tempArray = [UnitMaster]()
                    if let array = (data as NSDictionary).object(forKey: "data") as? NSArray{
                        for (_,item) in array.enumerated(){
                            if let entity = UnitMaster(dictionary: item as! NSDictionary){
                                tempArray.append(entity)
                            }
                        }
                    }
                    print(tempArray)
                    completion(tempArray)
                case .Error(let error):
                    completion(error)
                }
            }
        }
    }
    
    func getShiftSchedule(shiftId: Int, with target:BaseViewModel? = nil, completion:@escaping (Any?) -> Void) {
        let param = ["shiftId": "\(shiftId)"] as [String : Any]
        super.startService(with: .get, path: APITargetPoint.getShiftSchedule, parameters: param, files: []) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .Success(let data):
                    // #parse response here
                    // #parse response here
                    if let data = data["data"] as? Dictionary<String,Any>{
                        let detail = ShiftSchedule(dictionary: data as NSDictionary)
                        completion(detail)
                    }else{
                        completion(data["message"])
                    }
                case .Error(let error):
                    completion(error)
                }
            }
        }
    }
    func getResidentListDropdown(with target:BaseViewModel? = nil, completion:@escaping (Any?) -> Void) {
        let param = ["StaffId": "\(AppInstance.shared.user?.id ?? 0)"] as [String : Any]
          super.startService(with: .get, path: APITargetPoint.getMasterResidentList, parameters: param, files: []) { (result) in
              DispatchQueue.main.async {
                  switch result {
                  case .Success(let data):
                      // #parse response here
                      
                      var tempArray = [MasterResidentList]()
                      if let array = (data as NSDictionary).object(forKey: "data") as? NSArray{
                          for (_,item) in array.enumerated(){
                              if let entity = MasterResidentList(dictionary: item as! NSDictionary){
                                  tempArray.append(entity)
                              }
                          }
                      }
                      print(tempArray)
                      completion(tempArray)
                  case .Error(let error):
                      completion(error)
                  }
              }
          }
      }
    func getAssessmentMasters(with target:BaseViewModel? = nil, completion:@escaping (Any?) -> Void) {
        let param = [Key.Params.masterdata: MasterDataKeys.assessmentKeys] as [String : Any]
        super.startService(with: .post, path: APITargetPoint.getMasterData, parameters: param, files: []) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .Success(let data):
                    // #parse response here
                    
                    var tempMasterArray = [AllAssessmentMasters]()
                    
                    if let data = data["data"] as? Dictionary<String,Any>{
                        if let masterArray = data["allAssessmentMasters"] as? NSArray{
                            for (_,item) in masterArray.enumerated(){
                                if let dropdown = AllAssessmentMasters(dictionary: item as! NSDictionary){
                                    tempMasterArray.append(dropdown)
                                }
                            }
                        }
                    }
                    print(tempMasterArray)
                    completion(tempMasterArray)
                case .Error(let error):
                    completion(error)
                }
            }
        }
    }
    func getAssessmentMastersFallAssesment(with target:BaseViewModel? = nil, completion:@escaping (Any?) -> Void) {
        let param = [Key.Params.masterdata: MasterDataKeys.assessmentKeys] as [String : Any]
        super.startService(with: .post, path: APITargetPoint.getMasterData, parameters: param, files: []) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .Success(let data):
                    // #parse response here
                    
                    var tempMasterArray = [AllAssessmentMasters]()
                    var fallBodyTempUnit = [FallBodyTempUnit]()
                    var masterVitalPositionFall = [MasterVitalPositionFall]()
                    
                    if let data = data["data"] as? Dictionary<String,Any>{
                        if let masterArray = data["allAssessmentMasters"] as? NSArray{
                            for (_,item) in masterArray.enumerated(){
                                if let dropdown = AllAssessmentMasters(dictionary: item as! NSDictionary){
                                    tempMasterArray.append(dropdown)
                                }
                            }
                        }
                        
                        if let masterArray = data["masterVitalBodyTempUnit"] as? NSArray{
                            for (_,item) in masterArray.enumerated(){
                                if let dropdown = FallBodyTempUnit(dictionary: item as! NSDictionary){
                                    fallBodyTempUnit.append(dropdown)
                                }
                            }
                            SharedAccessEMR.sharedInstance.fallBodyTempUnit = fallBodyTempUnit
                        }
                        
                        if let masterArray = data["masterVitalPosition"] as? NSArray{
                                for (_,item) in masterArray.enumerated(){
                                    if let dropdown = MasterVitalPositionFall(dictionary: item as! NSDictionary){
                                            masterVitalPositionFall.append(dropdown)
                                            }
                                    }
                        SharedAccessEMR.sharedInstance.masterVitalPositionFall = masterVitalPositionFall
                        }
 
                    }
                    print(tempMasterArray)
                    completion(tempMasterArray)
                case .Error(let error):
                    completion(error)
                }
            }
        }
    }
    func postFallAssessment(with target:BaseViewModel? = nil, param : [String : Any], completion:@escaping (Any?) -> Void) {
        super.startService(with: .post, path: APITargetPoint.createFallAssessment, parameters: param, files: []) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .Success(let data):
                    // #parse response here
                    if let data = data["data"] as? Dictionary<String,Any>{
                     completion(data)
                    }
                case .Error(let error):
                    completion(error)
                }
            }
        }
    }
    func getTaskMasters(with target:BaseViewModel? = nil, completion:@escaping (Any?) -> Void) {
        let param = [Key.Params.masterdata: MasterDataKeys.TaskKeys] as [String : Any]
        super.startService(with: .post, path: APITargetPoint.getMasterData, parameters: param, files: []) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .Success(let data):
                    // #parse response here
                    
                    var tempMasterArray = [TaskMaster]()

                    if let data = data["data"] as? Dictionary<String,Any>{
                        if let masterArray = data["masterTaskType"] as? NSArray{
                            for (_,item) in masterArray.enumerated(){
                                if let dropdown = TaskMaster(dictionary: item as! NSDictionary){
                                    tempMasterArray.append(dropdown)
                                }
                            }
                        }
                    }
                    
                    print(tempMasterArray)
                    completion(tempMasterArray)
                case .Error(let error):
                    completion(error)
                }
            }
        }
    }

    func getCancelTaskMasters(with target:BaseViewModel? = nil, completion:@escaping (Any?) -> Void) {
        let param = [Key.Params.masterdata: MasterDataKeys.CancelTaskKeys] as [String : Any]
        super.startService(with: .post, path: APITargetPoint.getMasterData, parameters: param, files: []) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .Success(let data):
                    // #parse response here
                    
                    var tempMasterArray = [CancelMaster]()

                    if let data = data["data"] as? Dictionary<String,Any>{
                        if let masterArray = data["masterCancelType"] as? NSArray{
                            for (_,item) in masterArray.enumerated(){
                                if let dropdown = CancelMaster(dictionary: item as! NSDictionary){
                                    tempMasterArray.append(dropdown)
                                }
                            }
                        }
                    }
                    
                    print(tempMasterArray)
                    completion(tempMasterArray)
                case .Error(let error):
                    completion(error)
                }
            }
        }
    }
    
    func getAddTaskMasters(with target:BaseViewModel? = nil, completion:@escaping (Any?) -> Void) {
        let param = [Key.Params.masterdata: MasterDataKeys.addTaskKeys] as [String : Any]
        super.startService(with: .post, path: APITargetPoint.getMasterData, parameters: param, files: []) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .Success(let data):
                    // #parse response here
                    if let data = data["data"] as? Dictionary<String,Any>{
                        let detail = AddTaskMasters(dictionary: data as NSDictionary)
                        completion(detail)
                    }else{
                        completion(data["message"])
                    }
                case .Error(let error):
                    completion(error)
                }
            }
        }
    }
    
    func getMedicationMasters(with target:BaseViewModel? = nil, completion:@escaping (Any?) -> Void) {
        let param = [Key.Params.masterdata: MasterDataKeys.MedicationKeys] as [String : Any]
        super.startService(with: .post, path: APITargetPoint.getMasterData, parameters: param, files: []) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .Success(let data):
                    // #parse response here
                    if let data = data["data"] as? Dictionary<String,Any>{
                        let detail = MedicationMaster(dictionary: data as NSDictionary)
                        completion(detail?.medicationsList)
                    }else{
                        completion(data["message"])
                    }
                case .Error(let error):
                    completion(error)
                }
            }
        }
    }
    
    func getInventoryMasters(with target:BaseViewModel? = nil, completion:@escaping (Any?) -> Void) {
        let param = [Key.Params.masterdata: MasterDataKeys.InventoryMasterKeys] as [String : Any]
        super.startService(with: .post, path: APITargetPoint.getMasterData, parameters: param, files: []) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .Success(let data):
                    // #parse response here
                    if let data = data["data"] as? Dictionary<String,Any>{
                        let inventoryMaster = InventoryMaster(dictionary: data as NSDictionary)
                        completion(inventoryMaster)
                    }else{
                        completion(data["message"])
                    }
                case .Error(let error):
                    completion(error)
                }
            }
        }
    }
    
    func getTARMaster(with target:BaseViewModel? = nil, completion:@escaping (Any?) -> Void) {
        let param = [Key.Params.masterdata: MasterDataKeys.TARKeys] as [String : Any]
        super.startService(with: .post, path: APITargetPoint.getMasterData, parameters: param, files: []) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .Success(let data):
                    // #parse response here
                    var tempMasterArray = [MasterTaskType]()

                    if let data = data["data"] as? Dictionary<String,Any>{
                        if let masterArray = data["masterTaskType"] as? NSArray{
                            for (_,item) in masterArray.enumerated(){
                                if let dropdown = MasterTaskType(dictionary: item as! NSDictionary){
                                    tempMasterArray.append(dropdown)
                                }
                            }
                        }
                    }
                    print(tempMasterArray)
                    completion(tempMasterArray)
                case .Error(let error):
                    completion(error)
                }
            }
        }
    }
    
    func getMealMasters(with apiName: String,target:BaseViewModel? = nil, completion:@escaping (Any?) -> Void) {
        super.startService(with: .post, path: apiName, parameters: nil, files: []) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .Success(let data):
                    // #parse response here
                    var tempArray = [MealMasterDropdown]()
                    if let array = (data as NSDictionary).object(forKey: "data") as? NSArray{
                        for (_,item) in array.enumerated(){
                            if let entity = MealMasterDropdown(dictionary: item as! NSDictionary){
                                tempArray.append(entity)
                            }
                        }
                    }
                    print(tempArray)
                    completion(tempArray)
                case .Error(let error):
                    completion(error)
                }
            }
        }
    }
}

