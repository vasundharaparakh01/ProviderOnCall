//
//  ResidentService.swift
//  AccessEMR
//
//  Created by Vasundhara Parakh on 2/25/20.
//  Copyright © 2020 smartData Enterprises (I) Ltd. All rights reserved.
//

import UIKit

public class ResidentService: APIService {
    
    func getResidentList(with target:BaseViewModel? = nil, searchText: String, locationId:Int,pageNo : Int, completion:@escaping (Any?) -> Void) {
        var param = [Key.Params.searchKey:searchText.trimmingCharacters(in: .whitespacesAndNewlines),
                     Key.Params.pageNumber : "\(pageNo)",
                     Key.Params.pageSize : "\(Pagination.pageSize)",
                     Key.Params.sortOrder : ""
                     ] as [String : Any]
//        if UserDefaults.getOrganisationType() == OrganisationType.HomeCare || UserDefaults.getOrganisationType() == OrganisationType.Clinic{
//            param[Key.Params.StaffId_Resident] = "\(AppInstance.shared.user?.id ?? 0)"
//        }
        if SharedAccessEMR.sharedInstance.userTypeShared ==  "STAFF"{
                param[Key.Params.StaffId_Resident] = "\(AppInstance.shared.user?.id ?? 0)"
            }
        super.startService(with: .get, path: APITargetPoint.getResidents, parameters: param, files: []) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .Success(let data):
                    // #parse response here
                    var tempResidentArray = [Resident]()
                    if let residentArray = (data as NSDictionary).object(forKey: "data") as? NSArray{
                        for (_,item) in residentArray.enumerated(){
                            if let resident = Resident(dictionary: item as! NSDictionary){
                                tempResidentArray.append(resident)
                            }
                        }
                    }
                    print(tempResidentArray)
                    completion(tempResidentArray)
                case .Error(let error):
                    completion(error)
                }
            }
        }
    }
    
    func getAllResidentsForClockOut(with target:BaseViewModel? = nil, completion:@escaping (Any?,[Resident]?) -> Void) {
        var param = [Key.Params.searchKey:"",
                     Key.Params.pageNumber : "1",
                     Key.Params.pageSize : "100000",
                     Key.Params.sortOrder : ""] as [String : Any]
        
        if UserDefaults.getOrganisationType() == OrganisationType.HomeCare || UserDefaults.getOrganisationType() == OrganisationType.Clinic{
            param[Key.Params.staffId] = "\(AppInstance.shared.user?.id ?? 0)"
        }

        super.startService(with: .get, path: APITargetPoint.getResidents, parameters: param, files: []) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .Success(let data):
                    // #parse response here
                    var tempResidentArray = [Resident]()
                    var allResidentArray = [Resident]()

                    if let residentArray = (data as NSDictionary).object(forKey: "data") as? NSArray{
                        for (_,item) in residentArray.enumerated(){
                            if let resident = Resident(dictionary: item as! NSDictionary){
                                if resident.visitStatus != nil{ //TODO: Change this to Visit Status, if visit status is true then append
                                    tempResidentArray.append(resident)
                                }
                                allResidentArray.append(resident)

                            }
                        }
                    }
                    print(tempResidentArray)
                    completion(tempResidentArray,allResidentArray)
                case .Error(let error):
                    completion(error,nil)
                }
            }
        }
    }
    func getResidentDetail(with target:BaseViewModel? = nil, patientId: Int, completion:@escaping (Any?) -> Void) {
        let param = [Key.Params.id : "\(patientId)"] as [String : Any]
        super.startService(with: .get, path: APITargetPoint.getResidentHeaderInfo, parameters: param, files: []) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .Success(let data):
                    // #parse response here
                    let residentDetail = ResidentDetailHeader(dictionary: (data as NSDictionary).object(forKey: "data") as! NSDictionary)
                    completion(residentDetail)
                case .Error(let error):
                    completion(error)
                }
            }
        }
    }
    
    func getResidentVitals(with target:BaseViewModel? = nil, patientId: Int,pageNo : Int, completion:@escaping (Any?) -> Void) {
        let param = [Key.Params.patientId:patientId,
                     Key.Params.pageNumber : "\(pageNo)",
                     Key.Params.pageSize : "\(Pagination.pageSize)",
                     Key.Params.sortOrder : ""] as [String : Any]
        super.startService(with: .post, path: APITargetPoint.getResidentVitals, parameters: param, files: []) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .Success(let data):
                    // #parse response here
                    var tempVitalsArray = [ResidentVitals]()
                    if let vitalsArray = (data as NSDictionary).object(forKey: "data") as? NSArray{
                        for (_,item) in vitalsArray.enumerated(){
                            if let vitals = ResidentVitals(dictionary: item as! NSDictionary){
                                tempVitalsArray.append(vitals)
                            }
                        }
                    }
                    print(tempVitalsArray)
                    completion(tempVitalsArray)
                case .Error(let error):
                    completion(error)
                }
            }
        }
    }
    
    
    func saveVitals(params : [String : Any],completion:@escaping (Any?) -> Void) {
        super.startService(with: .post, path: APITargetPoint.saveVital, parameters: params, files: []) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .Success(let data):
                    // #parse response here
                    completion(data)
                case .Error(let error):
                    completion(error)
                }
            }
        }
    }
    
    func getResidentAllergies(with target:BaseViewModel? = nil, patientId: Int,pageNo : Int, completion:@escaping (Any?) -> Void) {
        let param = [Key.Params.patientId:"\(patientId)",
                     Key.Params.pageNumber : "\(pageNo)",
                     Key.Params.pageSize : "\(Pagination.pageSize)",
                     Key.Params.sortOrder : ""] as [String : Any]
        super.startService(with: .get, path: APITargetPoint.getResidentAllergies, parameters: param, files: []) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .Success(let data):
                    // #parse response here
                    var tempAllergyArray = [Allergy]()
                    if let allergyArray = (data as NSDictionary).object(forKey: "data") as? NSArray{
                        for (_,item) in allergyArray.enumerated(){
                            if let allergy = Allergy(dictionary: item as! NSDictionary){
                                tempAllergyArray.append(allergy)
                            }
                        }
                    }
                    print(tempAllergyArray)
                    completion(tempAllergyArray)
                case .Error(let error):
                    completion(error)
                }
            }
        }
    }

    func getResidentDiagnosis(with target:BaseViewModel? = nil, patientId: Int,pageNo : Int, completion:@escaping (Any?) -> Void) {
           let param = [Key.Params.patientId:"\(patientId)",
                        Key.Params.pageNumber : "\(pageNo)",
                        Key.Params.pageSize : "\(Pagination.pageSize)",
                        Key.Params.sortOrder : ""] as [String : Any]
           super.startService(with: .get, path: APITargetPoint.getResidentDiagnosis, parameters: param, files: []) { (result) in
               DispatchQueue.main.async {
                   switch result {
                   case .Success(let data):
                       // #parse response here
                       var tempDiagnosisArray = [ResidentDiagnosis]()
                       if let diagnosisArray = (data as NSDictionary).object(forKey: "data") as? NSArray{
                           for (_,item) in diagnosisArray.enumerated(){
                               if let diagnosis = ResidentDiagnosis(dictionary: item as! NSDictionary){
                                   tempDiagnosisArray.append(diagnosis)
                               }
                           }
                       }
                       print(tempDiagnosisArray)
                       completion(tempDiagnosisArray)
                   case .Error(let error):
                       completion(error)
                   }
               }
           }
       }
    
    func getResidentMedication(with target:BaseViewModel? = nil, patientId: Int,pageNo : Int, completion:@escaping (Any?) -> Void) {
        let param = [Key.Params.patientId:"\(patientId)",
                     Key.Params.pageNumber : "\(pageNo)",
                     Key.Params.pageSize : "100000",
                     Key.Params.sortOrder : ""] as [String : Any]
        super.startService(with: .get, path: APITargetPoint.getResidentMedication, parameters: param, files: []) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .Success(let data):
                    // #parse response here
                    var tempMedicationArray = [Medication]()
                    if let medicationArray = (data as NSDictionary).object(forKey: "data") as? NSArray{
                        for (_,item) in medicationArray.enumerated(){
                            if let medication = Medication(dictionary: item as! NSDictionary){
                                tempMedicationArray.append(medication)
                            }
                        }
                    }
                    print(tempMedicationArray)
                    completion(tempMedicationArray)
                case .Error(let error):
                    completion(error)
                }
            }
        }
    }
    func getOverCounterMedication(with target:BaseViewModel? = nil, patientId: Int, completion:@escaping (Any?) -> Void) {
        let param = [Key.Params.patientId:"\(patientId)",
                     Key.Params.pageNumber : "1",
                     Key.Params.pageSize : "100000",
                     Key.Params.sortOrder : ""] as [String : Any]
        super.startService(with: .get, path: APITargetPoint.getOverCounterMedication, parameters: param, files: []) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .Success(let data):
                    // #parse response here
                    var tempMedicationArray = [OtherMedicine]()
                    if let medicationArray = (data as NSDictionary).object(forKey: "data") as? NSArray{
                        for (_,item) in medicationArray.enumerated(){
                            if let medication = OtherMedicine(dictionary: item as! NSDictionary){
                                tempMedicationArray.append(medication)
                            }
                        }
                    }
                    print(tempMedicationArray)
                    completion(tempMedicationArray)
                case .Error(let error):
                    completion(error)
                }
            }
        }
    }
    func getHerbalMedicationMedication(with target:BaseViewModel? = nil, patientId: Int, completion:@escaping (Any?) -> Void) {
        let param = [Key.Params.patientId:"\(patientId)",
                     Key.Params.pageNumber : "1",
                     Key.Params.pageSize : "100000",
                     Key.Params.sortOrder : ""] as [String : Any]
        super.startService(with: .get, path: APITargetPoint.getHerbalMedication, parameters: param, files: []) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .Success(let data):
                    // #parse response here
                    var tempMedicationArray = [OtherMedicine]()
                    if let medicationArray = (data as NSDictionary).object(forKey: "data") as? NSArray{
                        for (_,item) in medicationArray.enumerated(){
                            if let medication = OtherMedicine(dictionary: item as! NSDictionary){
                                tempMedicationArray.append(medication)
                            }
                        }
                    }
                    print(tempMedicationArray)
                    completion(tempMedicationArray)
                case .Error(let error):
                    completion(error)
                }
            }
        }
    }
    func getTARInterventionList(with target:BaseViewModel? = nil, patientId: Int,searchDate:String, searchText : String, completion:@escaping (Any?) -> Void) {
        let param = [Key.Params.patientId: patientId,
                    Key.Params.searchDate: searchDate ,
                Key.Params.searchText: searchText,
            Key.Params.pageNumber : 1,
            Key.Params.pageSize : 100,
            Key.Params.sortOrder : "",
            "createdDate" : searchDate ] as [String : Any]
        super.startService(with: .post, path: APITargetPoint.getTARByPatientId, parameters: param, files: []) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .Success(let data):
                    // #parse response here
                    var tempArray = [TARIntervention]()
                    if let interventionArray = (data as NSDictionary).object(forKey: "data") as? NSArray{
                        for (_,item) in interventionArray.enumerated(){
                            if let intervention = TARIntervention(dictionary: item as! NSDictionary){
                                tempArray.append(intervention)
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
    
    func createTAR(params : [String : Any],completion:@escaping (Any?) -> Void) {
        super.startService(with: .post, path: APITargetPoint.createTAR, parameters: params, files: []) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .Success(let data):
                    // #parse response here
                    completion(data)
                case .Error(let error):
                    completion(error)
                }
            }
        }
    }
    
    func saveIncidentReport(params : [String : Any],completion:@escaping (Any?) -> Void) {
        super.startService(with: .post, path: APITargetPoint.saveUpdateIncidentReport, parameters: params, files: []) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .Success(let data):
                    // #parse response here
                    completion(data)
                case .Error(let error):
                    completion(error)
                }
            }
        }
    }

    func getResidentFoodDiary(with target:BaseViewModel? = nil, params: [String:Any], completion:@escaping (Any?) -> Void) {
        super.startService(with: .post, path: APITargetPoint.getAllPatientFoodDiary, parameters: params, files: []) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .Success(let data):
                    // #parse response here
                    var tempArray = [FoodDiary]()
                    if let foodarray = (data as NSDictionary).object(forKey: "data") as? NSArray{
                        for (_,item) in foodarray.enumerated(){
                            if let diary = FoodDiary(dictionary: item as! NSDictionary){
                                tempArray.append(diary)
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
    
    func getTnC(with target:BaseViewModel? = nil, completion:@escaping (Any?) -> Void) {
        super.startService(with: .get, path: APITargetPoint.getTNC, parameters: nil, files: []) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .Success(let data):
                    // #parse response here
                    let residentDetail = TNCDetail(dictionary: (data as NSDictionary).object(forKey: "data") as! NSDictionary)
                    completion(residentDetail)
                case .Error(let error):
                    completion(error)
                }
            }
        }
    }

    func saveTnC(with target:BaseViewModel? = nil, completion:@escaping (Any?) -> Void) {
        super.startService(with: .post, path: APITargetPoint.saveTNC, parameters: nil, files: []) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .Success(let data):
                    // #parse response here
                    if let dataObj = data as? Dictionary<String,Any>{
                        completion(dataObj["message"])
                    }else{
                        completion("An error has occured. Please try again later.")
                    }
                case .Error(let error):
                    completion(error)
                }
            }
        }
    }
    
    func patientCheckIn(with params : [String:Any],target:BaseViewModel? = nil, completion:@escaping (Any?) -> Void) {
        super.startService(with: .post, path: APITargetPoint.PatientCheckin, parameters: params, files: []) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .Success(let data):
                    // #parse response here
                    if let dataObj = data as? Dictionary<String,Any>{
                        completion(dataObj["message"])
                    }else{
                        completion("An error has occured. Please try again later.")
                    }
                case .Error(let error):
                    completion(error)
                }
            }
        }
    }
    func getTodayLastLocation(with params : [String:Any],target:BaseViewModel? = nil, completion:@escaping (Any?) -> Void) {
           super.startService(with: .get, path: APITargetPoint.StaffGeoLocationGetTodaysLastLocation, parameters: params, files: []) { (result) in
               DispatchQueue.main.async {
                   switch result {
                   case .Success(let data):
                       // #parse response here
                    
                       if let dataObj = LastLocation(dictionary: data as NSDictionary){
                           completion(dataObj)
                       }else{
                           completion("An error has occured. Please try again later.")
                       }
                   case .Error(let error):
                       completion(error)
                   }
               }
           }
       }
    func updateStaffCurrentLocation(with params : [String:Any],target:BaseViewModel? = nil, completion:@escaping (Any?) -> Void) {
        super.startService(with: .post, path: APITargetPoint.UpdateStaffCurrentLocation, parameters: params, files: []) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .Success(let data):
                    // #parse response here
                 
                    if let dataObj = UpdateStaffCurrentLocation(dictionary: data as NSDictionary){
                        completion(dataObj)
                    }else{
                        completion("An error has occured. Please try again later.")
                    }
                case .Error(let error):
                    completion(error)
                }
            }
        }
    }
    func sendCurrentLatLong(with params : [String:Any],target:BaseViewModel? = nil, completion:@escaping (Any?) -> Void) {
        super.startService(with: .post, path:"", parameters: params, files: []) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .Success(let data):
                    // #parse response here
                    if let dataObj = data as? Dictionary<String,Any>{
                        completion(dataObj["message"])
                    }else{
                        completion("An error has occured. Please try again later.")
                    }
                case .Error(let error):
                    completion(error)
                }
            }
        }
    }
    
}

