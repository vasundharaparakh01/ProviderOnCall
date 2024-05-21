//
//  SettingsViewModel.swift
//  appName
//
//  Created by Vasundhara Parakh on 5/13/20.
//  Copyright © 2020 smartData Enterprises (I) Ltd. All rights reserved.
//

import UIKit

class SettingsViewModel: BaseViewModel {
    // MARK: - Parameters
    private(set) var service:UserService
    
    // MARK: - Constructor
    init(with service:UserService) {
        self.service = service
    }
    
    func getSettings(){
        self.isLoading = true
        service.getSettings { (result) in
            self.isLoading = false

            if result != nil {
                if let error = result as? String{
                    self.errorMessage = error
                }else{
                    self.shouldUpdateView = true
                }
            }else{
                self.errorMessage = Alert.ErrorMessages.invalid_response
            }

        }
    }
    
    func getClockedInStatus(){
        self.isLoading = true
        service.getClockInStatus { (result) in
            self.isLoading = false

            if result != nil {
                if let error = result as? String{
                    self.errorMessage = error
                }
                self.shouldUpdateView = true

            }else{
                self.errorMessage = Alert.ErrorMessages.invalid_response
            }
        }
    }
    func saveSettings(isAvailable: Bool){
        self.isLoading = true
        service.saveSettings(isAvailable: isAvailable) { (message) in
            self.isLoading = false
            if let serverMessage = message as? String{
                self.errorMessage = serverMessage
                self.shouldUpdateView = true
            }else if let isAvailable = message as? Bool{
                AppInstance.shared.isAvailableForVirtualConsult = isAvailable
                self.errorMessage = "Status changed successfully"
                self.shouldUpdateView = true
            }
        }
    }
}
