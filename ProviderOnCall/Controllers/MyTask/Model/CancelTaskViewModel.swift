//
//  CancelTaskViewModel.swift
//  AccessEMR
//
//  Created by Vasundhara Parakh on 4/23/20.
//  Copyright © 2020 smartData Enterprises (I) Ltd. All rights reserved.
//

import UIKit
enum CancelTaskTitles {
    static let cancelType = "Cancel Type"
    static let reason = "Cancellation Reason"
}
class CancelTaskViewModel: BaseViewModel{
    // MARK: - Parameters
    var service:TaskService
    var serviceMaster : MasterService
    var selectedSection = 0
    var vitalsMasterData : MasterData?
    // MARK: - Constructor
    init(with service:TaskService) {
        self.service = service
        self.serviceMaster = MasterService()
    }
    
    var arrData = [ListingSectionModel]()
    var dateOfPlan = ""
    var planAddedBy = ""
    var dropdownCancel : [CancelMaster]?
    
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
//MARK:- NursingCareViewModel
extension CancelTaskViewModel{
    // MARK: - Network calls
    func getCancelMasterData(){
        self.isLoading = true
        serviceMaster.getCancelTaskMasters { (result) in
            if let res = result as? [CancelMaster]
            {
                self.isLoading = false
                self.dropdownCancel = res
                self.shouldUpdateView = true
                
            }else{
                self.errorMessage = Alert.ErrorMessages.invalid_response
            }
        }
    }
    
    func cancelTask(params : [String: Any]){
        self.isLoading = true
        service.cancelTask(params: params)  { (result) in
            self.isLoading = false
            if let res = result as? String{
                self.errorMessage = res
            }else{
                self.isSuccess = true
                self.alertMessage = Alert.Message.cancelledSuccessfully
            }
        }
    }
    
    func getInputArray() -> [Any]{
        var finalArray = [Any]()
        finalArray.append(self.getInput())
        return finalArray
    }
    
    
    func getInput() -> [Any]{
        
        return [InputTextfieldModel(value: "", placeholder: CancelTaskTitles.cancelType, apiKey: Key.Params.cancelTypeId, valueId: nil, inputType: InputType.Dropdown, dropdownArr: self.dropdownCancel ?? [""],isValid: false, errorMessage: ConstantStrings.mandatory),
                
                InputTextfieldModel(value: "", placeholder: CancelTaskTitles.reason, apiKey: Key.Params.cancelReason, valueId: nil, inputType: InputType.Text, dropdownArr: nil,isValid: false, errorMessage: ConstantStrings.mandatory)
            
        ]
    }
    
}
