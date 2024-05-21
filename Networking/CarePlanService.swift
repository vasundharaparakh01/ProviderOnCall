//
//  CarePlanService.swift
//  appName
//
//  Created by Vasundhara Parakh on 3/6/20.
//  Copyright © 2020 smartData Enterprises (I) Ltd. All rights reserved.
//

import UIKit

class CarePlanService: APIService {
    func getCommunicationPlan(with patientId : Int,target:BaseViewModel? = nil, completion:@escaping (Any?) -> Void) {
        let param = [Key.Params.patientId: "\(patientId)"] as [String : Any]
        super.startService(with: .get, path: APITargetPoint.getCommunicationPlan, parameters: param, files: []) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .Success(let data):
                    // #parse response here
                    if let arrCommunication = (data as NSDictionary).object(forKey: "data") as? NSArray{
                        if let object = arrCommunication.firstObject as? NSDictionary{
                            let detail = Communication(dictionary: object)
                            completion(detail)
                        }else{
                            completion("No Records")
                        }
                    }else{
                        completion(data["message"])
                    }
                case .Error(let error):
                    completion(error)
                }
            }
        }
    }
    func getRoutinePlan(with patientId : Int,target:BaseViewModel? = nil, completion:@escaping (Any?) -> Void) {
        let param = [Key.Params.patientId: "\(patientId)"] as [String : Any]
        super.startService(with: .get, path: APITargetPoint.getRoutinePlan, parameters: param, files: []) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .Success(let data):
                    // #parse response here
                    if let arrRoutine = (data as NSDictionary).object(forKey: "data") as? NSArray{
                        if let object = arrRoutine.firstObject as? NSDictionary{
                            let detail = Routine(dictionary: object)
                            completion(detail)
                        }else{
                            completion("No Records")
                        }
                    }else{
                        completion(data["message"])
                    }
                case .Error(let error):
                    completion(error)
                }
            }
        }
    }
    
    func getCarePlanDetails(carePlanItem : Int,apiPath: String ,patientId : Int,target:BaseViewModel? = nil, completion:@escaping (Any?) -> Void) {
        let param = [Key.Params.patientId: "\(patientId)"] as [String : Any]
        super.startService(with: .get, path: apiPath, parameters: param, files: []) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .Success(let data):
                    // #parse response here
                    if let array = (data as NSDictionary).object(forKey: "data") as? NSArray{
                        if let object = array.firstObject as? NSDictionary{
                            switch carePlanItem {
                            case CarePlanItems.ConginitiveStatusItem.rawValue:
                                let detail = ConginitiveStatus(dictionary: object)
                                completion(detail)
                            case CarePlanItems.BehavioursItem.rawValue:
                                let detail = Behaviour(dictionary: object)
                                completion(detail)
                            case CarePlanItems.SafetyItem.rawValue:
                                let detail = Safety(dictionary: object)
                                completion(detail)
                            case CarePlanItems.NutritionItem.rawValue:
                                let detail = Nutrition(dictionary: object)
                                completion(detail)
                            case CarePlanItems.BathingItem.rawValue:
                                let detail = Bathing(dictionary: object)
                                completion(detail)
                            case CarePlanItems.DressingItem.rawValue:
                                let detail = Dressing(dictionary: object)
                                completion(detail)
                            case CarePlanItems.HygieneItem.rawValue:
                                let detail = Hygiene(dictionary: object)
                                completion(detail)
                            case CarePlanItems.SkinItem.rawValue:
                                let detail = Skin(dictionary: object)
                                completion(detail)
                            case CarePlanItems.MobilityItem.rawValue:
                                let detail = Mobility(dictionary: object)
                                completion(detail)
                            case CarePlanItems.TransferItem.rawValue:
                                let detail = Transfer(dictionary: object)
                                completion(detail)
                            case CarePlanItems.ToiletingItem.rawValue:
                                let detail = Toileting(dictionary: object)
                                completion(detail)
                            case CarePlanItems.BladderContineneceItem.rawValue:
                                let detail = BladderContinence(dictionary: object)
                                completion(detail)
                            case CarePlanItems.BowelContineneceItem.rawValue:
                                let detail = BowelContinenece(dictionary: object)
                                completion(detail)
                            default:
                                completion("")
                            }
                        }else{
                          completion("No Records")
                      }
                    }else{
                        completion(data["message"])
                    }
                case .Error(let error):
                    completion(error)
                }
            }
        }
    }
}
