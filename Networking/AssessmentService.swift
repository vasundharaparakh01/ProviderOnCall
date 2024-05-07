//
//  AssessmentService.swift
//  AccessEMR
//
//  Created by Vasundhara Parakh on 3/30/20.
//  Copyright © 2020 smartData Enterprises (I) Ltd. All rights reserved.
//

import UIKit

class AssessmentService: APIService {
    func saveWoundAssessment(params: [String:Any],target:BaseViewModel? = nil, completion:@escaping (Any?) -> Void){
        super.startService(with: .post, path: APITargetPoint.saveWoundAssessment, parameters: params, files: []) { (result) in
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
    
    func saveAssessment(type: Int,params: [String:Any],target:BaseViewModel? = nil, completion:@escaping (Any?) -> Void){
        var apiPath = ""
        switch type{
        case AssessmentItems.SkinItem.rawValue:
            apiPath = APITargetPoint.saveSkinAssessment
        case AssessmentItems.PainItem.rawValue:
            apiPath = APITargetPoint.savePainAssessment
        case AssessmentItems.NutritionItem.rawValue:
            apiPath = APITargetPoint.saveNutritionAssessment
        case AssessmentItems.FallItem.rawValue:
            apiPath = APITargetPoint.saveFallAssessment
        case AssessmentItems.GlasgowItem.rawValue:
            apiPath = APITargetPoint.saveGlosgowAssessment
        default:
            apiPath = ""
        }
        super.startService(with: .post, path: apiPath, parameters: params, files: []) { (result) in
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
}
