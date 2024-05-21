//
//  InventoryService.swift
//  appName
//
//  Created by Vasundhara Parakh on 4/21/20.
//  Copyright © 2020 smartData Enterprises (I) Ltd. All rights reserved.
//

import UIKit

class InventoryService: APIService {
    func getInventoryList(with target:BaseViewModel? = nil, searchText: String,pageNo : Int, completion:@escaping (Any?) -> Void) {
        let param = [Key.Params.searchText:searchText,
                     Key.Params.pageNumber : pageNo,
                     Key.Params.pageSize : Pagination.pageSize,
                     Key.Params.sortOrder : "",
                     Key.Params.isMedication : false,
                     Key.Params.isReorder : false
                    ] as [String : Any]
        super.startService(with: .post, path: APITargetPoint.getInventoryList, parameters: param, files: []) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .Success(let data):
                    // #parse response here
                    var tempArray = [InventoryItem]()
                    if let array = (data as NSDictionary).object(forKey: "data") as? NSArray{
                        for (_,item) in array.enumerated(){
                            if let inventoryItem = InventoryItem(dictionary: item as! NSDictionary){
                                tempArray.append(inventoryItem)
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
    
    func deleteInventoryItem(itemId: Int ,completion:@escaping (Any?) -> Void) {
           let param = [Key.Params.id:itemId,
                       ] as [String : Any]
           super.startService(with: .post, path: APITargetPoint.deleteInventoryItem, parameters: param, files: []) { (result) in
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
    
    func getInventoryAddDetail(itemId: Int ,completion:@escaping (Any?) -> Void) {
        let param = ["Id":"\(itemId)",
                    ] as [String : Any]
        super.startService(with: .get, path: APITargetPoint.getInventoryAddDetail, parameters: param, files: []) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .Success(let data):
                    // #parse response here
                    var tempArray = [Inventory]()
                    if let array = (data as NSDictionary).object(forKey: "data") as? NSArray{
                        for (_,item) in array.enumerated(){
                            if let inventoryItem = Inventory(dictionary: item as! NSDictionary){
                                tempArray.append(inventoryItem)
                            }
                        }
                    }
                    completion(tempArray.count > 0 ? tempArray.first : "No data found")
                case .Error(let error):
                    completion(error)
                }
            }
        }
    }
    
    func getInventoryDetail(itemId: Int ,completion:@escaping (Any?) -> Void) {
        let param = ["Id":"\(itemId)",
                    ] as [String : Any]
        super.startService(with: .get, path: APITargetPoint.getInventoryDetail, parameters: param, files: []) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .Success(let data):
                    // #parse response here
                    var tempArray = [Inventory]()
                    if let array = (data as NSDictionary).object(forKey: "data") as? NSArray{
                        for (_,item) in array.enumerated(){
                            if let inventoryItem = Inventory(dictionary: item as! NSDictionary){
                                tempArray.append(inventoryItem)
                            }
                        }
                    }
                    completion(tempArray.count > 0 ? tempArray.first : "No data found")
                case .Error(let error):
                    completion(error)
                }
            }
        }
    }
    func addInventory(params: [String:Any],target:BaseViewModel? = nil, completion:@escaping (Any?) -> Void){
        super.startService(with: .post, path: APITargetPoint.addInventory, parameters: params, files: []) { (result) in
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
    
    func saveInventoryTrack(params: [String:Any],target:BaseViewModel? = nil, completion:@escaping (Any?) -> Void){
        super.startService(with: .post, path: APITargetPoint.saveInventoryTrack, parameters: params, files: []) { (result) in
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
    
    func addInventoryReorder(params: [String:Any],target:BaseViewModel? = nil, completion:@escaping (Any?) -> Void){
        super.startService(with: .post, path: APITargetPoint.saveReorder, parameters: params, files: []) { (result) in
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
    
    func getPatientList(with target:BaseViewModel? = nil, searchText: String,pageNo : Int, completion:@escaping (Any?) -> Void) {
        let param = [Key.Params.searchKey:searchText,
                     Key.Params.pageNumber : "\(pageNo)",
                     Key.Params.pageSize : "\(Pagination.pageSize)",
                     Key.Params.sortOrder : "",
                    ] as [String : Any]
        super.startService(with: .get, path: APITargetPoint.getPatients, parameters: param, files: []) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .Success(let data):
                    // #parse response here
                    var tempArray = [PatientList]()
                    if let array = (data as NSDictionary).object(forKey: "data") as? NSArray{
                        for (_,item) in array.enumerated(){
                            if let patient = PatientList(dictionary: item as! NSDictionary){
                                tempArray.append(patient)
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
}

