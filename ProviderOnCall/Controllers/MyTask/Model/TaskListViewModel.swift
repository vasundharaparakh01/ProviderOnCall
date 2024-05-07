//
//  TaskListViewModel.swift
//  AccessEMR
//
//  Created by Vasundhara Parakh on 3/5/20.
//  Copyright © 2020 smartData Enterprises (I) Ltd. All rights reserved.
//

import UIKit

class TaskListViewModel: BaseViewModel {
    // MARK: - Parameters
    var service:TaskService
    var arrTasks = [Task]()
    var strForIsMore = ConstantStrings.no  {
           didSet {
                
               self.reloadListViewClosure?()
           }
    }
    var intForPageNo = 1

    // MARK: - Constructor
    init(with service:TaskService) {
        self.service = service
    }
    

    //MARK: -Table view methods
     func numberOfRows()-> Int{
        return self.arrTasks.count
     }
     func roomForIndexPath(_ indexPath: IndexPath) -> Task {
        return self.arrTasks[indexPath.row]
     }

    // MARK: - Network calls
    func deleteTask(params : [String: Any],completion:@escaping (Any?) -> Void){
        self.isLoading = true
        service.deleteTask(params: params)  { (result) in
            self.isLoading = false
            if let res = result as? String{
                self.errorMessage = res
                completion(res)
            }
        }
    }

    func getTaskList(statusType : String) {
        self.isLoading = true
        service.getTaskList(searchText : statusType) { (result) in
            self.isLoading = false
            if let arrResult = result as? [Task]{
                self.arrTasks = arrResult
                self.isListLoaded = true
            }else{
                self.isListLoaded = false
                self.errorMessage = (result as? String ) ?? Alert.ErrorMessages.invalid_response
            }
        }
    }
    
    func updateTaskStatus(taskStatus : Int, taskID: Int){
        self.isLoading = true
        service.updateTaskStatus(status: taskStatus, taskID: taskID) { (result) in
                        self.isLoading = false
            if let errorString = result as? String{
                self.errorMessage = errorString
            }else{
                self.errorMessage = "Task status changed successfully."
                if taskStatus == TaskStatus.taskIncompleteID || taskStatus == TaskStatus.taskDeclineID {
                    self.getTaskList(statusType: TaskStatus.ToDo.getStatusType())
                }else if (taskStatus == TaskStatus.taskCompleteID){
                    self.getTaskList(statusType: TaskStatus.InProgress.getStatusType())
                }
            }
        }
    }

}
