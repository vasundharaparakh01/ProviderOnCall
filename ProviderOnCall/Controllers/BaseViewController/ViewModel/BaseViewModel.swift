//
//  BaseViewModel.swift
//  appNamePOC
//
//  Created by Amit Shukla on 28/01/20.
//  Copyright © 2020 smartData Enterprises (I) Ltd. All rights reserved.
//

import Foundation


enum AlertType {
    case normal
    case warning
    case error
    case success
    case custom
}

class BaseViewModel: NSObject {

    var isLoading: Bool = false {
        didSet {
            self.updateLoadingStatus?()
        }
    }
    
    var alertMessage: String? {
        didSet {
            self.showAlertClosure?(.success)
        }
    }
    
    var errorMessage: String? {
        didSet {
            self.showAlertClosure?(.error)
        }
    }
    
    var isSuccess:Bool? {
        didSet {
            if isSuccess ?? false {
                self.redirectControllerClosure?()
            }
        }
    }
    
    var isFailed:Bool? {
        didSet {
            self.showAlertClosure?(.error)
        }
    }
    
    var isListLoaded:Bool? {
        didSet {
            if isListLoaded ?? false {
                self.reloadListViewClosure?()
            }
        }
    }
    
    var shouldUpdateView:Bool? {
        didSet {
            if shouldUpdateView ?? false {
                self.updateViewClosure?()
            }
        }
    }
    
    var shouldUpdateViewForCalendar :Bool? {
        didSet {
            if shouldUpdateViewForCalendar ?? false {
                self.updateViewForCalendarClosure?()
            }
        }
    }
    
    var showAlertClosure: ((_ type: AlertType)->())?
    var updateLoadingStatus: (()->())?
    var reloadListViewClosure: (()->())?
    var updateInitialViewClosure: (()->())?
    var redirectControllerClosure: (()->())?
    var updateViewClosure: (()->())?
    var updateViewForCalendarClosure: (()->())?

    
    func validate(value: String,type: InputTypes,errorMessage: String, inValidMessage: String,isMandatory:Bool? = true)->(type:ValidationType,message:String?){
          if (isMandatory ?? true) ? (value.trimSpaces().count == 0) : false{
              return (.invalid,errorMessage)
          }else{
              switch type {
              case .email:
                  return isValid(text: value, regEx: Predicates.email) ? (.valid,nil) :  (.invalid,inValidMessage)
              case .password:
                  return isValid(text: value, regEx: Predicates.username) ? (.valid,nil) :  (.invalid,inValidMessage)
              case .mobile:
                  return isValid(text: value, regEx: Predicates.mobileNo) ? (.valid,nil) :  (.invalid,inValidMessage)
              case .text:
                  return isValid(text: value, regEx: Predicates.text) ? (.valid,nil) :  (.invalid,inValidMessage)
              case .alphanumeric:
                  return isValid(text: value, regEx: Predicates.username) ? (.valid,nil) :  (.invalid,inValidMessage)
            case .username:
                    return (.valid,nil)
              case .numeric:
                  return isValid(text: value, regEx: Predicates.numeric) ? (.valid,nil) :  (.invalid,inValidMessage)
              }
          }
          
      }

    func isValid(text: String,regEx: String)->Bool{
        let pred = NSPredicate(format:"SELF MATCHES %@", regEx)
        return pred.evaluate(with: text)
    }

//    func getIPAddress() -> String {
//        var address: String = ""
//        var ifaddr: UnsafeMutablePointer<ifaddrs>? = nil
//        if getifaddrs(&ifaddr) == 0 {
//            var ptr = ifaddr
//            while ptr != nil {
//                defer { ptr = ptr?.pointee.ifa_next }
//
//                let interface = ptr?.pointee
//                let addrFamily = interface?.ifa_addr.pointee.sa_family
//                if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {
//
//                      if let name: String = String(cString: (interface?.ifa_name)!), name == "en0" {
//                        var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
//                        getnameinfo(interface?.ifa_addr, socklen_t((interface?.ifa_addr.pointee.sa_len)!), &hostname, socklen_t(hostname.count), nil, socklen_t(0), NI_NUMERICHOST)
//                        address = String(cString: hostname)
//                     }
//                }
//            }
//            freeifaddrs(ifaddr)
//        }
//        return address.count == 0 ? "simulator" : address
//    }
}
