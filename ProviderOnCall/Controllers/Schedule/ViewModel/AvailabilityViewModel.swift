//
//  AvailabilityViewModel.swift
//  AccessEMR
//
//  Created by Vasundhara Parakh on 5/21/20.
//  Copyright © 2020 smartData Enterprises (I) Ltd. All rights reserved.
//

import UIKit

class AvailabilityViewModel: BaseViewModel {
    // MARK: - Parameters
    var service:VirtualConsultService
    var serviceMaster = MasterService()
    var availabilityList = [AvailabilityByDayName]()
    var locationID : Int = (AppInstance.shared.user?.staffLocation?[0])?.locationID ?? 0

    // MARK: - Constructor
    init(with service:VirtualConsultService) {
        self.service = service
    }
    
    func getUnitDropdown(completion:@escaping (Any?) -> Void){
        self.isLoading = true
        serviceMaster.getUnitDropdown(locationID: self.locationID) { (result) in
            self.isLoading = false

                        if let res = result as? [UnitMaster]
            {
                completion(res)
            }else{
                self.errorMessage = Alert.ErrorMessages.invalid_response
            }

        }
        
    }
    func getShiftDropdown(unitID : Int,completion:@escaping (Any?) -> Void){
        self.isLoading = true
        serviceMaster.getShiftByUnitDropdown(unitID: unitID, shiftType: 0) { (result) in
            self.isLoading = false
            if let res = result as? [Shift]
            {
                completion(res)
            }else{
                self.errorMessage = Alert.ErrorMessages.invalid_response
            }
        }
    }
    
    func getAvailabilityList(fromDate: String,toDate: String, shiftId : Int){
        self.isLoading = true
        service.getAvailabilityList(fromDate: fromDate, toDate: toDate, shiftId: shiftId, staffId: AppInstance.shared.user?.id ?? 0) { (result) in
            self.isLoading = false
            if let res = result as? [AvailabilityByDayName]{
                self.availabilityList = res
            }
            self.shouldUpdateViewForCalendar = true

        }
    }
}
