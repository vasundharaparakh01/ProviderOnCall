//
//  EMARService.swift
//  appName
//
//  Created by Vasundhara Parakh on 4/13/20.
//  Copyright © 2020 smartData Enterprises (I) Ltd. All rights reserved.
//

import UIKit

class EMARService: APIService {
    func getEMARList(searchText : String,pageNo : Int, with target:BaseViewModel? = nil, completion:@escaping (Any?) -> Void) {
        let param = [Key.Params.searchText : searchText,
                     Key.Params.pageNumber : "\(pageNo)",
                     Key.Params.pageSize : "\(Pagination.pageSize)",
                     Key.Params.sortOrder : ""] as [String : Any]

        super.startService(with: .get, path: APITargetPoint.getEMARList, parameters: param, files: []) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .Success(let data):
                    // #parse response here
                    var tempArray = [EMARList]()
                    if let array = (data as NSDictionary).object(forKey: "data") as? NSArray{
                        for (_,item) in array.enumerated(){
                            if let task = EMARList(dictionary: item as! NSDictionary){
                                tempArray.append(task)
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
    
    func getEMARListByTime(date :  String,searchText : String,pageNo : Int, with target:BaseViewModel? = nil, completion:@escaping (Any?) -> Void) {
        let param = [ Key.Params.searchDate :date,
                      Key.Params.searchText : searchText,
                      Key.Params.pageNumber : "\(pageNo)",
                      Key.Params.pageSize : "\(Pagination.pageSize)",
                      Key.Params.sortOrder : ""] as [String : Any]
        
        super.startService(with: .get, path: APITargetPoint.getEMARListByTime, parameters: param, files: []) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .Success(let data):
                    // #parse response here
                    var tempArray = [EMARList]()
                    if let array = (data as NSDictionary).object(forKey: "data") as? NSArray{
                        for (_,item) in array.enumerated(){
                            if let task = EMARList(dictionary: item as! NSDictionary){
                                tempArray.append(task)
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
    
    func getPrescriptionList(apiName : String,drugId : String, with target:BaseViewModel? = nil, completion:@escaping (Any?) -> Void){
        let param = [Key.Params.drugId : drugId] as [String : Any]

        super.startService(with: .get, path: apiName, parameters: param, files: []) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .Success(let data):
                    // #parse response here
                    switch apiName {
                    case PrescriptionList.DrugDisease:
                        var tempArray = [DrugDisease]()
                        if let array = (data as NSDictionary).object(forKey: "data") as? NSArray{
                            for (_,item) in array.enumerated(){
                                if let task = DrugDisease(dictionary: item as! NSDictionary){
                                    tempArray.append(task)
                                }
                            }
                        }
                        print(tempArray)
                        completion(tempArray)
                    case PrescriptionList.DrugSideEffect:
                    var tempArray = [DrugSideEffect]()
                    if let array = (data as NSDictionary).object(forKey: "data") as? NSArray{
                        for (_,item) in array.enumerated(){
                            if let task = DrugSideEffect(dictionary: item as! NSDictionary){
                                tempArray.append(task)
                            }
                        }
                    }
                    print(tempArray)
                    completion(tempArray)
                    default:
                         completion(nil)
                    }
                case .Error(let error):
                    completion(error)
                }
            }
        }
    }
    
    func getDrugHistory(patientId : Int, with target:BaseViewModel? = nil, completion:@escaping (Any?) -> Void){
        let param = [Key.Params.patientId : "\(patientId)"] as [String : Any]

        super.startService(with: .get, path: APITargetPoint.getPatientDrugHistory, parameters: param, files: []) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .Success(let data):
                    // #parse response here
                    var tempArray = [DrugHistory]()
                    if let array = (data as NSDictionary).object(forKey: "data") as? NSArray{
                        for (_,item) in array.enumerated(){
                            if let task = DrugHistory(dictionary: item as! NSDictionary){
                                tempArray.append(task)
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
    
    func getDrugIndication(drugIds : String, with target:BaseViewModel? = nil, completion:@escaping (Any?) -> Void){
           let param = [Key.Params.drugId : drugIds] as [String : Any]

           super.startService(with: .get, path: APITargetPoint.getDrugIndicationBulk, parameters: param, files: []) { (result) in
               DispatchQueue.main.async {
                   switch result {
                   case .Success(let data):
                       // #parse response here
                       var tempArray = [DrugIndication]()
                       if let array = (data as NSDictionary).object(forKey: "data") as? NSArray{
                           for (_,item) in array.enumerated(){
                               if let task = DrugIndication(dictionary: item as! NSDictionary){
                                   tempArray.append(task)
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
    
    func getDrugDuplicateTherapy(param : [String:Any], with target:BaseViewModel? = nil, completion:@escaping (Any?) -> Void){

           super.startService(with: .post, path: APITargetPoint.getDrugDuplicateTherapyBulk, parameters: param, files: []) { (result) in
               DispatchQueue.main.async {
                   switch result {
                   case .Success(let data):
                       // #parse response here
                       var tempArray = [DrugDuplicateTherapy]()
                       if let array = (data as NSDictionary).object(forKey: "data") as? NSArray{
                           for (_,item) in array.enumerated(){
                               if let task = DrugDuplicateTherapy(dictionary: item as! NSDictionary){
                                   tempArray.append(task)
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
    
    func getDrugGeriatrics(param : [String:Any], with target:BaseViewModel? = nil, completion:@escaping (Any?) -> Void){

           super.startService(with: .post, path: APITargetPoint.geriatricsPrecautionBulkPost, parameters: param, files: []) { (result) in
               DispatchQueue.main.async {
                   switch result {
                   case .Success(let data):
                       // #parse response here
                       var tempArray = [DrugGeriatrics]()
                       if let array = (data as NSDictionary).object(forKey: "data") as? NSArray{
                           for (_,item) in array.enumerated(){
                               if let task = DrugGeriatrics(dictionary: item as! NSDictionary){
                                   tempArray.append(task)
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
    
    func getDrugAllergy(param : [String:Any], with target:BaseViewModel? = nil, completion:@escaping (Any?) -> Void){

           super.startService(with: .post, path: APITargetPoint.getDrugAllergyBulkPost, parameters: param, files: []) { (result) in
               DispatchQueue.main.async {
                   switch result {
                   case .Success(let data):
                       // #parse response here
                       var tempArray = [DrugAllergy]()
                       if let array = (data as NSDictionary).object(forKey: "data") as? NSArray{
                           for (_,item) in array.enumerated(){
                               if let task = DrugAllergy(dictionary: item as! NSDictionary){
                                   tempArray.append(task)
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
    func getDrugInteraction(param : [String:Any], with target:BaseViewModel? = nil, completion:@escaping (Any?) -> Void){

           super.startService(with: .post, path: APITargetPoint.getDrugInterationBulk, parameters: param, files: []) { (result) in
               DispatchQueue.main.async {
                print("Drud-Drug Interation====\n \(result)")
                

                   switch result {
                   case .Success(let data):

                       // #parse response here
                       var tempArray = [DrugInteraction]()
                       if let array = (data as NSDictionary).object(forKey: "data") as? NSArray{
                           for (_,item) in array.enumerated(){
                               if let task = DrugInteraction(dictionary: item as! NSDictionary){
                                   tempArray.append(task)
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
    
    func getDrugFood(param : [String:Any], with target:BaseViewModel? = nil, completion:@escaping (Any?) -> Void){

           super.startService(with: .post, path: APITargetPoint.getDrugFoodFamilyEducationBulk, parameters: param, files: []) { (result) in
               DispatchQueue.main.async {
                print("Food Interation====\n \(result)")

                   switch result {
                    
                   case .Success(let data):
                       // #parse response here
                       var tempArray = [DrugFood]()
                       if let array = (data as NSDictionary).object(forKey: "data") as? NSArray{
                           for (_,item) in array.enumerated(){
                               if let task = DrugFood(dictionary: item as! NSDictionary){
                                   tempArray.append(task)
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
    
    func getEMRPatientMedicationList(param : [String:Any],selectedDate : String, with target:BaseViewModel? = nil, completion:@escaping (Any?) -> Void){
        let selectedStartDate = Utility.getDateFromstring(dateStr: selectedDate.replacingOccurrences(of: "T00:00:00.000Z", with: ""), dateFormat: "yyyy-MM-dd")
        
              super.startService(with: .post, path: APITargetPoint.getEMRPatientMedicationList, parameters: param, files: []) { (result) in
                  DispatchQueue.main.async {
                      switch result {
                      case .Success(let data):
                          // #parse response here
                          var tempArray = [PatientMedication]()
                          if let array = (data as NSDictionary).object(forKey: "data") as? NSArray{
                              for (_,item) in array.enumerated(){
                                if let medication = PatientMedication(dictionary: item as! NSDictionary){
                                    
                                    var startDate = Utility.getDateFromstring(dateStr: (medication.startDate ?? "").replacingOccurrences(of: "T", with: " "), dateFormat: "yyyy-MM-dd hh:mm:ss")
                                    let endDate = Utility.getDateFromstring(dateStr: (medication.endDate ?? "").replacingOccurrences(of: "T", with: " "), dateFormat: "yyyy-MM-dd hh:mm:ss")
                                    
                                    print("SelectedDate = \(selectedStartDate)")
                                    print("StartDate = \((Utility.getDateFromstring(dateStr: (medication.startDate ?? "").replacingOccurrences(of: "T", with: " "), dateFormat: "yyyy-MM-dd hh:mm:ss")))")
                                    print("EndDate = \((Utility.getDateFromstring(dateStr: (medication.endDate ?? "").replacingOccurrences(of: "T", with: " "), dateFormat: "yyyy-MM-dd hh:mm:ss")))")

                                    
                                    var isValidDate = false
                                    
                                    if let medSubArray = medication.patientScheduleDateTimeDetails{
                                        let subArrayDates = medSubArray.compactMap { (ent) -> Date? in
                                            
                                            let date = Utility.getDateFromstring(dateStr: (ent.medicationDate ?? "").replacingOccurrences(of: "T", with: " "), dateFormat: "yyyy-MM-dd HH:mm:ss")
                                            let finalDate = Utility.getDateFromstring(dateStr: Utility.getStringFromDate(date: date, dateFormat: "yyyy-MM-dd"), dateFormat: "yyyy-MM-dd")
                                            return finalDate
                                        }
                                        
                                        if subArrayDates.contains(selectedStartDate){
                                            isValidDate = true
                                        }
                                    }
                                    
                                    
                                    if selectedStartDate == startDate || selectedStartDate == endDate{
                                        isValidDate = true
                                    }else if (selectedStartDate.isBetweeen(date: startDate, andDate: endDate)){
                                        
                                        isValidDate = true
                                    }

                                    if isValidDate{
                                      tempArray.append(medication)
                                    }
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
    
    func saveEditMedication(params: [String:Any],target:BaseViewModel? = nil, completion:@escaping (Any?) -> Void){
        super.startService(with: .post, path: APITargetPoint.saveEditMedication, parameters: params, files: []) { (result) in
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
    
    func getMedicationDetail(params: [String:Any],target:BaseViewModel? = nil, completion:@escaping (Any?) -> Void){
        super.startService(with: .post, path: APITargetPoint.getMedicationDetail, parameters: params, files: []) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .Success(let data):
                    // #parse response here
                    var tempArray = [MedicationDetail]()
                    if let array = (data as NSDictionary).object(forKey: "data") as? NSArray{
                        for (_,item) in array.enumerated(){
                            if let medication = MedicationDetail(dictionary: item as! NSDictionary){
                                tempArray.append(medication)
                            }
                        }
                    }
                    completion(tempArray.count > 0 ? tempArray.first : nil)
                case .Error(let error):
                    completion(error)
                }
            }
        }
    }
    
    func updateForMissedMedication(patientId : Int,target:BaseViewModel? = nil, completion:@escaping (Any?) -> Void){
        let params = ["PatientId" : "\(patientId)"]
        super.startService(with: .get, path: APITargetPoint.updateForMissedMedication, parameters: params, files: []) { (result) in
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
    
    func getViewPrescriptionDetail(medicationId : Int,target:BaseViewModel? = nil, completion:@escaping (Any?) -> Void){
        let params = ["id" : "\(medicationId)"]
        super.startService(with: .get, path: APITargetPoint.getCurrentmedicationById, parameters: params, files: []) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .Success(let data):
                    // #parse response here
                    var tempArray = [CurrentMedication]()
                    if let array = (data as NSDictionary).object(forKey: "data") as? NSArray{
                        for (_,item) in array.enumerated(){
                            if let medication = CurrentMedication(dictionary: item as! NSDictionary){
                                tempArray.append(medication)
                            }
                        }
                    }
                    completion(tempArray)
                case .Error(let error):
                    completion(error)
                }
            }
        }
    }
}

