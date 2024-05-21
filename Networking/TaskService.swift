//
//  TaskService.swift
//  appName
//
//  Created by Vasundhara Parakh on 3/5/20.
//  Copyright © 2020 smartData Enterprises (I) Ltd. All rights reserved.
//

import UIKit

class TaskService: APIService {
    func getTaskList(searchText : String, with target:BaseViewModel? = nil, completion:@escaping (Any?) -> Void) {
        let param = [Key.Params.searchText : searchText,
                     Key.Params.searchKey:"",
                     Key.Params.pageNumber : 1,
                     Key.Params.pageSize : 10000000,
                     Key.Params.sortOrder : ""] as [String : Any]

        super.startService(with: .post, path: APITargetPoint.getTaskList, parameters: param, files: []) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .Success(let data):
                    // #parse response here
                    var tempArray = [Task]()
                    if let array = (data as NSDictionary).object(forKey: "data") as? NSArray{
                        for (_,item) in array.enumerated(){
                            if let task = Task(dictionary: item as! NSDictionary){
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
    
    func getFollowingTaskList(searchText : String,pageNo : Int, with target:BaseViewModel? = nil, completion:@escaping (Any?) -> Void) {
        let param = [Key.Params.searchText : searchText,
                     Key.Params.pageNumber : "\(pageNo)",
                     Key.Params.pageSize : "\(Pagination.pageSize)",
                     Key.Params.sortOrder : ""] as [String : Any]

        super.startService(with: .post, path: APITargetPoint.getFollowingTaskList, parameters: param, files: []) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .Success(let data):
                    // #parse response here
                    var tempArray = [Task]()
                    if let array = (data as NSDictionary).object(forKey: "data") as? NSArray{
                        for (_,item) in array.enumerated(){
                            if let task = Task(dictionary: item as! NSDictionary){
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

    func updateTaskStatus(status : Int, taskID: Int, with target:BaseViewModel? = nil, completion:@escaping (Any?) -> Void ){
        let param = [Key.Params.taskStatusId : "\(status)",
                     Key.Params.taskId : "\(taskID)"] as [String : Any]

        super.startService(with: .get, path: APITargetPoint.updateTaskStatus, parameters: param, files: []) { (result) in
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
    
    func saveTask(params : [String : Any], with target:BaseViewModel? = nil, completion:@escaping (Any?) -> Void){
        let finalParams = [Key.Params.AddTask.patientAppointmentModels : params[Key.Params.AddTask.patientAppointmentModels]] as! [String: Any]
        super.startService(with: .post, path: APITargetPoint.saveTask, parameters: finalParams, files: []) { (result) in
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
    
    func deleteTask(params : [String : Any], with target:BaseViewModel? = nil, completion:@escaping (Any?) -> Void){
        super.startService(with: .get, path: APITargetPoint.deleteTask, parameters: params, files: []) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .Success(let data):
                    // #parse response here
                    completion("Task has been deleted successfully.")
                case .Error(let error):
                    completion(error)
                }
            }
        }
    }
    
    func cancelTask(params : [String : Any], with target:BaseViewModel? = nil, completion:@escaping (Any?) -> Void){
        super.startService(with: .post, path: APITargetPoint.cancelTask, parameters: params, files: []) { (result) in
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
