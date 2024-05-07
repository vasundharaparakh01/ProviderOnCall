//
//  LastLocation.swift
//  AccessEMR
//
//  Created by Sorabh Gupta on 12/28/20.
//  Copyright © 2020 smartData Enterprises (I) Ltd. All rights reserved.
//

import Foundation
public class LastLocation {
    public var access_token : String?
    public var expires_in : Int?
    public var message : String?
    public var statusCode : Int?
    public var appError : String?
    public var firstTimeLogin : Bool?
    public var openDefaultClient : Bool?
    public var locationRange : Int?
    public var data : DataLastLocation?
    
    public class func modelsFromDictionaryArray(array:NSArray) -> [LastLocation]
    {
        var models:[LastLocation] = []
        for item in array
        {
            models.append(LastLocation(dictionary: item as! NSDictionary)!)
        }
        return models
    }
    
    required public init?(dictionary: NSDictionary) {
        
        access_token = dictionary["access_token"] as? String
        expires_in = dictionary["expires_in"] as? Int
        message = dictionary["message"] as? String
        statusCode = dictionary["statusCode"] as? Int
        appError = dictionary["appError"] as? String
        firstTimeLogin = dictionary["firstTimeLogin"] as? Bool
        openDefaultClient = dictionary["openDefaultClient"] as? Bool
        locationRange = dictionary["locationRange"] as? Int
        if (dictionary["data"] != nil) { data = DataLastLocation(dictionary: dictionary["data"] as! NSDictionary) }
    }
    
    public func dictionaryRepresentation() -> NSDictionary {
        
        let dictionary = NSMutableDictionary()
        
        dictionary.setValue(self.access_token, forKey: "access_token")
        dictionary.setValue(self.expires_in, forKey: "expires_in")
        dictionary.setValue(self.message, forKey: "message")
        dictionary.setValue(self.statusCode, forKey: "statusCode")
        dictionary.setValue(self.appError, forKey: "appError")
        dictionary.setValue(self.firstTimeLogin, forKey: "firstTimeLogin")
        dictionary.setValue(self.openDefaultClient, forKey: "openDefaultClient")
        dictionary.setValue(self.locationRange, forKey: "locationRange")
        dictionary.setValue(self.data?.dictionaryRepresentation(), forKey: "data")
        
        return dictionary
    }
    
}
public class DataLastLocation {
    public var id : Int?
    public var staffID : Int?
    public var appointmentId : Int?
    public var latitude : String?
    public var longitude : String?
    public var mileage : Double?
    public var updatedTimeStamp : String?
    public var organizationID : Int?
    public var isActive : Bool?
    public var isDeleted : Bool?
    public var createdBy : Int?
    public var createdDate : String?
    
    public class func modelsFromDictionaryArray(array:NSArray) -> [DataLastLocation]
    {
        var models:[DataLastLocation] = []
        for item in array
        {
            models.append(DataLastLocation(dictionary: item as! NSDictionary)!)
        }
        return models
    }
    
    required public init?(dictionary: NSDictionary) {
        SharedAccessEMR.sharedInstance.intMapID = dictionary["id"] as? Int
        id = dictionary["id"] as? Int
        staffID = dictionary["staffID"] as? Int
        appointmentId = dictionary["appointmentId"] as? Int
        latitude = dictionary["latitude"] as? String
        longitude = dictionary["longitude"] as? String
        mileage = dictionary["mileage"] as? Double
        updatedTimeStamp = dictionary["updatedTimeStamp"] as? String
        organizationID = dictionary["organizationID"] as? Int
        isActive = dictionary["isActive"] as? Bool
        isDeleted = dictionary["isDeleted"] as? Bool
        createdBy = dictionary["createdBy"] as? Int
        createdDate = dictionary["createdDate"] as? String
    }
    
    public func dictionaryRepresentation() -> NSDictionary {
        
        let dictionary = NSMutableDictionary()
        
        dictionary.setValue(self.id, forKey: "id")
        dictionary.setValue(self.staffID, forKey: "staffID")
        dictionary.setValue(self.appointmentId, forKey: "appointmentId")
        dictionary.setValue(self.latitude, forKey: "latitude")
        dictionary.setValue(self.longitude, forKey: "longitude")
        dictionary.setValue(self.mileage, forKey: "mileage")
        dictionary.setValue(self.updatedTimeStamp, forKey: "updatedTimeStamp")
        dictionary.setValue(self.organizationID, forKey: "organizationID")
        dictionary.setValue(self.isActive, forKey: "isActive")
        dictionary.setValue(self.isDeleted, forKey: "isDeleted")
        dictionary.setValue(self.createdBy, forKey: "createdBy")
        dictionary.setValue(self.createdDate, forKey: "createdDate")
        
        return dictionary
    }
    
}
public class UpdateStaffCurrentLocation {
    public var access_token : String?
    public var expires_in : Int?
    public var message : String?
    public var statusCode : Int?
    public var appError : String?
    public var firstTimeLogin : Bool?
    public var openDefaultClient : Bool?
    public var locationRange : Int?
    
    public class func modelsFromDictionaryArray(array:NSArray) -> [LastLocation]
    {
        var models:[LastLocation] = []
        for item in array
        {
            models.append(LastLocation(dictionary: item as! NSDictionary)!)
        }
        return models
    }
    
    required public init?(dictionary: NSDictionary) {
        
        access_token = dictionary["access_token"] as? String
        expires_in = dictionary["expires_in"] as? Int
        message = dictionary["message"] as? String
        statusCode = dictionary["statusCode"] as? Int
        appError = dictionary["appError"] as? String
        firstTimeLogin = dictionary["firstTimeLogin"] as? Bool
        openDefaultClient = dictionary["openDefaultClient"] as? Bool
        locationRange = dictionary["locationRange"] as? Int
    }
    
    public func dictionaryRepresentation() -> NSDictionary {
        
        let dictionary = NSMutableDictionary()
        
        dictionary.setValue(self.access_token, forKey: "access_token")
        dictionary.setValue(self.expires_in, forKey: "expires_in")
        dictionary.setValue(self.message, forKey: "message")
        dictionary.setValue(self.statusCode, forKey: "statusCode")
        dictionary.setValue(self.appError, forKey: "appError")
        dictionary.setValue(self.firstTimeLogin, forKey: "firstTimeLogin")
        dictionary.setValue(self.openDefaultClient, forKey: "openDefaultClient")
        dictionary.setValue(self.locationRange, forKey: "locationRange")
        
        return dictionary
    }
    
}
