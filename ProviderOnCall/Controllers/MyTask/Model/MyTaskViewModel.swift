//
//  MyTaskViewModel.swift
//  AccessEMR
//
//  Created by Vasundhara Parakh on 3/5/20.
//  Copyright © 2020 smartData Enterprises (I) Ltd. All rights reserved.
//

import UIKit

class MyTaskViewModel: BaseViewModel {
    // MARK: - Parameters
    var service:TaskService
    var serviceMaster = MasterService()
    var arrTasks = [TaskMaster]()
    // MARK: - Constructor
    init(with service:TaskService) {
        self.service = service
    }
    
    //MARK: -Table view methods
    func numberOfSection()-> Int{
        return arrTasks.count
    }
    func numberOfRows(section : Int)-> Int{
        return arrTasks.count
    }
    func roomForIndexPath(_ indexPath: IndexPath) -> TaskMaster? {
        return arrTasks[indexPath.row]
    }

}

extension MyTaskViewModel{
    func getTaskMasterData(){
        self.isLoading = true
        serviceMaster.getTaskMasters { (result) in
            self.isLoading = false

            if let res = result as? [TaskMaster]
            {
                self.arrTasks = res
                self.isListLoaded = true
            }  else{
                self.errorMessage = Alert.ErrorMessages.invalid_response
            }
        }
    }
}
