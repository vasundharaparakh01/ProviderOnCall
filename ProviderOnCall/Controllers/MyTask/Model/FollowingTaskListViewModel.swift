//
//  FollowingTaskListViewModel.swift
//  appName
//
//  Created by Vasundhara Parakh on 4/7/20.
//  Copyright © 2020 smartData Enterprises (I) Ltd. All rights reserved.
//

import UIKit

class FollowingTaskListViewModel: BaseViewModel {
    // MARK: - Parameters
    private(set) var service:TaskService
    var arrTask = [Task]()
    var arrFilteredTask = [Task]()
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
         return arrFilteredTask.count
     }
     func roomForIndexPath(_ indexPath: IndexPath) -> Task {
         return arrFilteredTask[indexPath.row]
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
    
    func getFollowingTaskList(pageNo : Int,searchText : String) {
        

        if pageNo == 1{
            self.isLoading = true
        }
        
        if searchText.count > 0 {
            self.arrTask.removeAll()
            self.arrFilteredTask.removeAll()
        }
        service.getFollowingTaskList(searchText: searchText, pageNo: pageNo) { (result) in
            self.isLoading = false
            if let arrResult = result as? [Task]{
                if pageNo == 1 {
                    self.arrTask.removeAll()
                    self.arrFilteredTask.removeAll()
                    self.arrTask = arrResult
                }else{
                    self.arrTask.append(contentsOf: arrResult)
                }
                self.arrFilteredTask = self.arrTask
                
                //Use if need pagination table reload
                self.intForPageNo = arrResult.count == Pagination.pageSize ? self.intForPageNo + 1 : 0
                self.strForIsMore = arrResult.count == Pagination.pageSize ? ConstantStrings.yes : ConstantStrings.no
                //End
                
                //Use if need simple table reload
                //self.isListLoaded = true
                //end
            }else{
                self.isListLoaded = true
            }

        }
        
    }
}
