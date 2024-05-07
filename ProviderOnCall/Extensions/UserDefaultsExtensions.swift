//
//  UserDefaultsExtensions.swift
//  AccessEMR
//
//  Created by Vasundhara Parakh on 2/25/20.
//  Copyright © 2020 smartData Enterprises (I) Ltd. All rights reserved.
//

import Foundation

extension UserDefaults {
    
    class func setDeviceToken(token:String){
        
        self.standard.setValue(token, forKey: UserDefaultKeys.udKey_deviceToken)
        
    }
    class func setDeviceId(deviceId:String){
        
        self.standard.setValue(deviceId, forKey: UserDefaultKeys.udKey_deviceId)
        
    }
    
    class func setPassword(password:String){
        
        self.standard.setValue(password, forKey: UserDefaultKeys.udKey_password)
        
    }
    
    class func setUsername(userName:String){
        
        self.standard.setValue(userName, forKey: UserDefaultKeys.udKey_userName)
        
    }
    class func setAccessToken(token:String){
        
        self.standard.setValue(token, forKey: UserDefaultKeys.udKey_accessToken)
        
    }
    class func setBusinessToken(token:String){
        
        self.standard.setValue(token, forKey: UserDefaultKeys.udKey_businessToken)
        
    }
    class func setOrganisationTypeName(token:String){
        self.standard.setValue(token, forKey: UserDefaultKeys.udKey_orgTypeName)
        
    }
    class func setBusinessURL(token:String){
        self.standard.setValue(token, forKey: UserDefaultKeys.businessURL)
        
    }
    class func setOrganisationType(typeId:Int){
        self.standard.setValue(typeId, forKey: UserDefaultKeys.udKey_orgType)
    }
    
    class func getDeviceToken ()-> String {
        
        if self.standard.value(forKey:  UserDefaultKeys.udKey_deviceToken) != nil {
            if self.standard.value(forKey:  UserDefaultKeys.udKey_deviceToken) as! String == ""{
                return "simulator"
            }else{
                return self.standard.value(forKey:  UserDefaultKeys.udKey_deviceToken) as! String
            }
        }else{
            return "simulator"
        }
    }
    
    class func getdeviceId() -> String {
        
        if self.standard.value(forKey: UserDefaultKeys.udKey_deviceId) != nil{
            if self.standard.value(forKey: UserDefaultKeys.udKey_deviceId) as! String == ""{
                return "simulator"
            }else{
                return self.standard.value(forKey: UserDefaultKeys.udKey_deviceId) as! String
            }
        }else{
            
            return "simulator"
        }
        
    }
    
    class func getPassword() -> String? {
        
        if self.standard.value(forKey: UserDefaultKeys.udKey_password) != nil{
            if self.standard.value(forKey: UserDefaultKeys.udKey_password) as! String == ""{
                return nil
            }else{
                return self.standard.value(forKey: UserDefaultKeys.udKey_password) as! String
            }
        }else{
            
            return nil
        }
        
    }
    
    class func getUsername() -> String? {
        
        if self.standard.value(forKey: UserDefaultKeys.udKey_userName) != nil{
            if self.standard.value(forKey: UserDefaultKeys.udKey_userName) as! String == ""{
                return nil
            }else{
                return self.standard.value(forKey: UserDefaultKeys.udKey_userName) as! String
            }
        }else{
            
            return nil
        }
        
    }

    class func getAccessToken() -> String? {
        
        if self.standard.value(forKey: UserDefaultKeys.udKey_accessToken) != nil{
            if self.standard.value(forKey: UserDefaultKeys.udKey_accessToken) as! String == ""{
                return nil
            }else{
                return self.standard.value(forKey: UserDefaultKeys.udKey_accessToken) as? String
            }
        }else{
            
            return nil
        }
        
    }
    class func getBusinessURL() -> String {
        return self.standard.value(forKey: UserDefaultKeys.businessURL) as? String ?? ""
    }
    
    class func getRememberMe() -> Bool? {
        return (self.standard.value(forKey: UserDefaultKeys.udKey_rememberMe) as? Bool) ?? false
    }
    
    class func getBusinessToken() -> String? {
        
        if self.standard.value(forKey: UserDefaultKeys.udKey_businessToken) != nil{
            if self.standard.value(forKey: UserDefaultKeys.udKey_businessToken) as! String == ""{
                return nil
            }else{
                return self.standard.value(forKey: UserDefaultKeys.udKey_businessToken) as? String
            }
        }else{
            
            return nil
        }
        
    }
    class func getOrganisationTypeName() -> String {
        
        if self.standard.value(forKey: UserDefaultKeys.udKey_orgTypeName) != nil{
            if self.standard.value(forKey: UserDefaultKeys.udKey_orgTypeName) as! String == ""{
                return "Resident"
            }else{
                return self.standard.value(forKey: UserDefaultKeys.udKey_orgTypeName) as? String ?? "Resident"
            }
        }else{
            return "Resident"
        }
    }
    
    class func getOrganisationType() -> Int {
        if self.standard.value(forKey: UserDefaultKeys.udKey_orgType) != nil{
            if self.standard.value(forKey: UserDefaultKeys.udKey_orgType) as! Int == 0{
                return 0
            }else{
                return self.standard.value(forKey: UserDefaultKeys.udKey_orgType) as? Int ?? 0
            }
        }else{
            return 0
        }
    }
    class func setPatientStatus(token:String){
           
           self.standard.setValue(token, forKey: UserDefaultKeys.patient_status)
           
       }
    class func getPatientStatus() -> String{
        return self.standard.value(forKey: UserDefaultKeys.patient_status) as? String ?? ""
        
    }
}
