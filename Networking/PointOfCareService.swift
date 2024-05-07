//
//  PointOfCareService.swift
//  AccessEMR
//
//  Created by Vasundhara Parakh on 3/12/20.
//  Copyright © 2020 smartData Enterprises (I) Ltd. All rights reserved.
//

import UIKit

class PointOfCareService: APIService {
    
    func getADLTracking(with patientId : Int,target:BaseViewModel? = nil, completion:@escaping (Any?) -> Void){
        let param = [Key.Params.patientId: "\(patientId)"] as [String : Any]
        super.startService(with: .get, path: APITargetPoint.getADLTracking, parameters: param, files: []) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .Success(let data):
                    // #parse response here
                        if let object = data["data"] as? Dictionary<String,Any>{
                            let detail = ADLTrackingTool(dictionary: object as NSDictionary)
                            completion(detail)
                        }else{
                            completion("No Records")
                        }
                case .Error(let error):
                    completion(error)
                }
            }
        }
    }
    
    func getMoodAndBehaviour(with patientId : Int,target:BaseViewModel? = nil, completion:@escaping (Any?) -> Void){
        let param = [Key.Params.patientId: "\(patientId)"] as [String : Any]
        super.startService(with: .get, path: APITargetPoint.getMoodAndBehaviour, parameters: param, files: []) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .Success(let data):
                    // #parse response here
                    if let object = data["data"] as? Dictionary<String,Any>{
                        let detail = MoodTrackingTool(dictionary: object as NSDictionary)
                        completion(detail)
                    }else{
                        completion("No Records")
                    }                case .Error(let error):
                    completion(error)
                }
            }
        }
    }
    func getSafetySecurityDetail(with patientId : Int,target:BaseViewModel? = nil, completion:@escaping (Any?) -> Void){
        let param = [Key.Params.patientId: "\(patientId)"] as [String : Any]
        super.startService(with: .get, path: APITargetPoint.getSafetySecurity, parameters: param, files: []) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .Success(let data):
                    // #parse response here
                    if let object = data["data"] as? Dictionary<String,Any>{
                        let detail = SafetySecurityDetail(dictionary: object as NSDictionary)
                        completion(detail)
                    }else{
                        completion("No Records")
                    }                case .Error(let error):
                    completion(error)
                }
            }
        }
    }
    func getPersonalHygieneDetail(with patientId : Int,target:BaseViewModel? = nil, completion:@escaping (Any?) -> Void){
        let param = [Key.Params.patientId: "\(patientId)"] as [String : Any]
        super.startService(with: .get, path: APITargetPoint.getPersonalHygoeneDetail, parameters: param, files: []) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .Success(let data):
                    // #parse response here
                    if let object = data["data"] as? Dictionary<String,Any>{
                        let detail = PersonalHygiene(dictionary: object as NSDictionary)
                        completion(detail)
                    }else{
                        completion("No Records")
                    }                case .Error(let error):
                    completion(error)
                }
            }
        }
    }
    func getActivityDetail(with patientId : Int,target:BaseViewModel? = nil, completion:@escaping (Any?) -> Void){
        let param = [Key.Params.patientId: "\(patientId)"] as [String : Any]
        super.startService(with: .get, path: APITargetPoint.getActivityDetail, parameters: param, files: []) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .Success(let data):
                    // #parse response here
                    if let object = data["data"] as? Dictionary<String,Any>{
                        let detail = ActivityDetail(dictionary: object as NSDictionary)
                        completion(detail)
                    }else{
                        completion("No Records")
                    }                case .Error(let error):
                    completion(error)
                }
            }
        }
    }
    func getSleepRestDetail(with patientId : Int,target:BaseViewModel? = nil, completion:@escaping (Any?) -> Void){
        let param = [Key.Params.patientId: "\(patientId)"] as [String : Any]
        super.startService(with: .get, path: APITargetPoint.getSleepRestDetail, parameters: param, files: []) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .Success(let data):
                    // #parse response here
                    if let object = data["data"] as? Dictionary<String,Any>{
                        let detail = SleepRest(dictionary: object as NSDictionary)
                        completion(detail)
                    }else{
                        completion("No Records")
                    }                case .Error(let error):
                    completion(error)
                }
            }
        }
    }
    func getESASRatingDetail(with patientId : Int, unitId : Int ,target:BaseViewModel? = nil, completion:@escaping (Any?) -> Void){
        let param = [Key.Params.patientId: "\(patientId)" ,
                     Key.Params.UnitId: "\(unitId)" ] as [String : Any]
        super.startService(with: .get, path: APITargetPoint.getESASRatingDetail, parameters: param, files: []) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .Success(let data):
                    // #parse response here
                    if let object = data["data"] as? Dictionary<String,Any>{
                        let detail = ESASRatingDetail(dictionary: object as NSDictionary)
                        completion(detail)
                    }else{
                        completion("No Records")
                    }                case .Error(let error):
                    completion(error)
                }
            }
        }
    }
    func getESASRatingDetailSelected(with patientId : Int,
                                     unitId : Int,
                                     shiftID : Int,
                                     locationID : Int,
                                     target:BaseViewModel? = nil, completion:@escaping (Any?) -> Void){
        let param = [Key.Params.patientId: "\(patientId)" ,
                     Key.Params.UnitId: "\(unitId)",
                     Key.Params.shiftId: "\(shiftID)",
                     Key.Params.locationId: "1"] as [String : Any]
        super.startService(with: .get, path: APITargetPoint.getESASRatingDetail, parameters: param, files: []) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .Success(let data):
                    // #parse response here
                    if let object = data["data"] as? Dictionary<String,Any>{
                        let detail = ESASRatingDetail(dictionary: object as NSDictionary)
                        completion(detail)
                    }else{
                        completion("No Records")
                    }                case .Error(let error):
                    completion(error)
                }
            }
        }
    }
    
    func getNCFNutritionDetail(with patientId : Int,target:BaseViewModel? = nil, completion:@escaping (Any?) -> Void){
        let param = [Key.Params.patientId: "\(patientId)"] as [String : Any]
        super.startService(with: .get, path: APITargetPoint.getNCFNutritionDetail, parameters: param, files: []) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .Success(let data):
                    // #parse response here
                    var tempArray = [NCFNutritionDetail]()
                    if let nutritionArr = (data as NSDictionary).object(forKey: "data") as? NSArray{
                        for (_,item) in nutritionArr.enumerated(){
                            if let nutrition = NCFNutritionDetail(dictionary: item as! NSDictionary){
                                tempArray.append(nutrition)
                            }
                        }
                    }
                    completion(tempArray.isEmpty ? nil : tempArray.first)
               case .Error(let error):
                    completion(error)
                }
            }
        }
    }
    func getIODetail(with patientId : Int, strdate : String ,target:BaseViewModel? = nil, completion:@escaping (Any?) -> Void){
           let param = [Key.Params.patientId: "\(patientId)",Key.Params.date: strdate
            ] as [String : Any]
           super.startService(with: .get, path: APITargetPoint.getInputOutputDetail, parameters: param, files: []) { (result) in
               DispatchQueue.main.async {
                   switch result {
                   case .Success(let data):
                       // #parse response here
                        let detail = InputOutPutChart(dictionary: data as NSDictionary)
                        completion(detail)
                  case .Error(let error):
                       completion(error)
                   }
               }
           }
       }
    func getTrendGraphDetail(with patientId : Int, strdate : String, enddate : String ,target:BaseViewModel? = nil, completion:@escaping (Any?) -> Void){
        let param = [Key.Params.patientId: "\(patientId)",
            Key.Params.toDate: enddate,
            Key.Params.fromDate: strdate
         ] as [String : Any]
        super.startServiceCodable(with: .get, path: APITargetPoint.InputOutputTrendGraph, parameters: param, files: []) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .Success(let data):
                     completion(data)
               case .Error(let error):
                    completion(error)
                }
            }
        }
    }
    func saveADL(params: [String:Any],target:BaseViewModel? = nil, completion:@escaping (Any?) -> Void){
        super.startService(with: .post, path: APITargetPoint.saveADL, parameters: params, files: []) { (result) in
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
    func saveMoodAndBehaviour(params: [String:Any],target:BaseViewModel? = nil, completion:@escaping (Any?) -> Void){
        super.startService(with: .post, path: APITargetPoint.saveMoodAndBehaviour, parameters: params, files: []) { (result) in
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
    
    func saveNursingCareFlow(apiName:String,params: [String:Any],target:BaseViewModel? = nil, completion:@escaping (Any?) -> Void){
        super.startService(with: .post, path: apiName, parameters: params, files: []) { (result) in
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
    func discardNursingCareFlow(apiName:String,params: [String:Any],target:BaseViewModel? = nil, completion:@escaping (Any?) -> Void){
           super.startService(with: .get, path: apiName, parameters: params, files: []) { (result) in
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
    
    func saveESASRating(params: [String:Any],target:BaseViewModel? = nil, completion:@escaping (Any?) -> Void){
        super.startService(with: .post, path: APITargetPoint.saveESASRating, parameters: params, files: []) { (result) in
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
    func saveAsDraftESASRating(params: [String:Any],target:BaseViewModel? = nil, completion:@escaping (Any?) -> Void){
        super.startService(with: .post, path: APITargetPoint.saveAsDraftESASRating, parameters: params, files: []) { (result) in
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
    func getESASGraphDetail(params: [String:Any],target:BaseViewModel? = nil, completion:@escaping (Any?) -> Void){
        super.startService(with: .get, path: APITargetPoint.getESASGraph, parameters: params, files: []) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .Success(let data):
                    // #parse response here
                    var tempGraphArray = [TrendGraph]()
                    if let graphArray = (data as NSDictionary).object(forKey: "data") as? NSArray{
                        for (_,item) in graphArray.enumerated(){
                            if let graphDetail = TrendGraph(dictionary: item as! NSDictionary){
                                tempGraphArray.append(graphDetail)
                            }
                        }
                    }
                    print(tempGraphArray)
                    completion(tempGraphArray)
                case .Error(let error):
                    completion(error)
                }
            }
        }
    }
    
    func getDraftStatus(with patientId : Int,target:BaseViewModel? = nil, completion:@escaping (Any?) -> Void){
        let param = [Key.Params.patientId: "\(patientId)",
            "isFreshEntry" : AppInstance.shared.shouldUpdateDraftStatus ? "false" : "true"] as [String : Any]
        super.startService(with: .get, path: APITargetPoint.getDraftStatus, parameters: param, files: []) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .Success(let data):
                    // #parse response here
                    if let object = data["data"] as? Dictionary<String,Any>{
                        let detail = DraftStatus(dictionary: object as NSDictionary)
                        completion(detail)
                    }else{
                        completion("No Records")
                    }                case .Error(let error):
                    completion(error)
                }
            }
        }
    }
    
    func saveMealPlan(with target:BaseViewModel? = nil,params : [String: Any], completion:@escaping (Any?, Bool) -> Void) {
        super.startService(with: .post, path:  APITargetPoint.saveMealPlan , parameters: params, files: []) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .Success(let data):
                    // #parse response here
                    if let dataObj = data as? Dictionary<String,Any>{
                        completion("Meal plan has been saved.",true)
                    }else{
                        completion("An error has occured. Please try again later.",false)
                    }
                case .Error(let error):
                    completion(error,false)
                }
            }
        }
    }
}
