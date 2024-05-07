//
//  LoginAPIManager.swift
//  AccessEMR
//
//  Created by Vasundhara Parakh on 2/25/20.
//  Copyright © 2020 smartData Enterprises (I) Ltd. All rights reserved.
//

import Foundation
import UIKit

public class UserService: APIService {
    
    func doLogin(with target:BaseViewModel? = nil, email: String, password:String, completion:@escaping (Any?) -> Void) {
        print(UIDevice.current.getIP())
        //let ipAddress = (target?.getIPAddress() ?? "")
        let param = [Key.Params.userName:email,
                     Key.Params.password: password,
                     "deviceToken": UserDefaults.getDeviceToken(),
                     Key.Params.ipAddress: UIDevice.current.getIP() ?? "",
                    ] as [String : Any]
        super.startService(with: .post, path: APITargetPoint.login, parameters: param, files: []) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .Success(let data):
                    // #parse response here
                    if let datadict = (data as NSDictionary).object(forKey: Key.Response.data) as? NSDictionary{
                    let user = User(dictionary:datadict)
                    if let token = (data as NSDictionary).object(forKey: Key.Response.access_token) as? String{
                        AppInstance.shared.accessToken = token
                        AppInstance.shared.user = user
                        UserDefaults.setAccessToken(token: token)

                    }
                    
                    completion(user)
                    }else{
                        completion("Failed to retrieve data")

                    }
                case .Error(let error):
                    completion(error)
                }
            }
        }
    }
    
    func forgotPassword(with userName : String, target:BaseViewModel? = nil, completion:@escaping (Any?) -> Void) {
        
        let dynamicURL : String = Config.resetPassword_URL + UserDefaults.getBusinessURL() + "/web/reset-password"
        
        let params = [Key.Params.userName : userName,Key.Params.resetPasswordURL : dynamicURL] as! [String:Any]
        super.startService(with: .post, path: APITargetPoint.forgotPassword, parameters: params, files: []) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .Success(let data):
                    // #parse response here
                    completion((data as NSDictionary).object(forKey: Key.Response.message) as! String)
                case .Error(let error):
                    completion(error)
                }
            }
        }
    }
    
    func getSettings(target:BaseViewModel? = nil, completion:@escaping (Any?) -> Void) {
        let params : [String:Any] = [Key.Params.staffID : "\(AppInstance.shared.user?.id ?? 0)"]
        super.startService(with: .get, path: APITargetPoint.getStaffSetting, parameters: params, files: []) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .Success(let data):
                    // #parse response here
                    if let dict = (data as NSDictionary).object(forKey: Key.Response.data) as? [String : Any]{
                        if let isAvailable = dict[Key.Response.staffVirtualStatus] as? Bool{
                            AppInstance.shared.isAvailableForVirtualConsult = isAvailable
                        }
                        if let isClockIn = dict[Key.Response.clockInStatus] as? Bool{
                            AppInstance.shared.isClockedIn = isClockIn
                        }
                        completion(true)
                    }else{
                        completion(nil)
                    }
                case .Error(let error):
                    completion(error)
                }
            }
        }
    }
    
    func getClockInStatus(target:BaseViewModel? = nil, completion:@escaping (Any?) -> Void) {
        super.startService(with: .post, path: APITargetPoint.getClockInStatus, parameters: nil, files: []) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .Success(let data):
                    // #parse response here
                    if let isClockedIn = (data as NSDictionary).object(forKey: Key.Response.data) as? Bool{
                        AppInstance.shared.isClockedIn = isClockedIn
                        completion(isClockedIn)
                    }else{
                        completion(nil)
                    }
                case .Error(let error):
                    completion(error)
                }
            }
        }
    }
    
    func saveSettings(isAvailable : Bool,target:BaseViewModel? = nil, completion:@escaping (Any?) -> Void) {
        let params : [String:Any] = [Key.Params.staffID : "\(AppInstance.shared.user?.id ?? 0)",Key.Params.isAvailabel : "\(isAvailable)" ]
        super.startService(with: .get, path: APITargetPoint.updateStaffSetting, parameters: params, files: []) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .Success(let data):
                    // #parse response here
                    if let available = ((data as NSDictionary).object(forKey: "data") as! NSDictionary).object(forKey: "isStaffAvailable") as? Bool{
                        completion(available)
                    }else if let message = (data as NSDictionary).object(forKey: Key.Response.message) as? String{
                        completion(message)
                    }else{
                        completion("Please try again later")
                    }
                case .Error(let error):
                    completion(error)
                }
            }
        }
    }
    func getNotifications(with target:BaseViewModel? = nil, completion:@escaping (Any?) -> Void) {
        super.startService(with: .get, path: APITargetPoint.getNotification, parameters: nil, files: []) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .Success(let data):
                    // #parse response here
                    var tempArray = [NotificationList]()
                    if let array = (data as NSDictionary).object(forKey: "data") as? NSArray{
                        for (_,item) in array.enumerated(){
                            if let notification = NotificationList(dictionary: item as! NSDictionary){
                                tempArray.append(notification)
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
    func deleteNotifications(ids : [Int],target:BaseViewModel? = nil, completion:@escaping (Any?) -> Void) {
        let params : [String:Any] = [Key.Params.ids : ids ]
        super.startService(with: .post, path: APITargetPoint.deleteBulkNotification, parameters: params, files: []) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .Success(let data):
                    // #parse response here
                    //completion((data as NSDictionary).object(forKey: Key.Response.message) as! String)
                    completion(data)
                case .Error(let error):
                    completion(error)
                }
            }
        }
    }
    
    func verifyBusinessToken(with businessName : String, target:BaseViewModel? = nil, completion:@escaping (Any?) -> Void) {
        let param = [Key.Params.BusinessName:businessName] as [String : Any]
        super.startService(with: .get, path: APITargetPoint.verifyBusiness, parameters: param, files: []) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .Success(let data):
                    // #parse response here
                    if let datadict = (data as NSDictionary).object(forKey: Key.Response.data) as? NSDictionary{
                        let tokenDetail = BusinessTokenModel(dictionary:datadict)
                        if let token = tokenDetail?.businessToken as? String{
                            UserDefaults.setBusinessToken(token: token)
                        }
                        if let orgType = tokenDetail?.organization?.organizationType as? Int{
                            UserDefaults.setOrganisationType(typeId: orgType)
                        }
                        completion(tokenDetail)
                    }else{
                        completion("Failed to retrieve data")
                    }
                case .Error(let error):
                    completion(error)
                }
            }
        }
    }
    
    func clockOutUser(target:BaseViewModel? = nil, completion:@escaping (Any?) -> Void) {
        super.startService(with: .post, path: APITargetPoint.clockOut, parameters: nil, files: []) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .Success(let data):
                    // #parse response here
                    if let clockOut = (data as NSDictionary).object(forKey: Key.Response.message) as? String{
                        completion("Clocked out successfully.")
                    }else{
                        completion("Please try again later.")
                    }
    case .Error(let error):
                    completion(error)
                }
            }
        }
    }
}

