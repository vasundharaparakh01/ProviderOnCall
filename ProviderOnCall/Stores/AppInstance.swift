//
//  AppInstance.swift
//  AccessEMR
//
//  Created by Vasundhara Parakh on 2/25/20.
//  Copyright © 2020 smartData Enterprises (I) Ltd. All rights reserved.
//

import UIKit

import Foundation

class AppInstance: NSObject {
   
    static let shared = AppInstance()
    
    var user:User?
    var accessToken:String?
    var businessToken:String? 
    var task: URLSessionDataTask?
    var activeTextfieldIndex = 0
    var isAvailableForVirtualConsult : Bool?
    var isClockedIn : Bool?
    var selectedCalendarDate : Date?
    var shouldUpdateDraftStatus = false
    var nutritionNCFParams : [String : Any]?
    var safetyNCFParams : [String : Any]?
    var hygieneNCFParams : [String : Any]?
    var sleepNCFParams : [String : Any]?
    var activityNCFParams : [String : Any]?
    var draftStatus : DraftStatus?
    var isSharingScreen = false
    var telehealthSessionInfo : TelehealthSession?
    override init() {
        super.init()
    }
}
