//
//  ResidentDetailViewModel.swift
//  appName
//
//  Created by Vasundhara Parakh on 2/26/20.
//  Copyright © 2020 smartData Enterprises (I) Ltd. All rights reserved.
//

import UIKit

class ResidentDetailViewModel: BaseViewModel {
    // MARK: - Parameters
    private(set) var service:ResidentService
    var residentDetailHeader : ResidentDetailHeader? {
           didSet {
               self.updateViewClosure?()
           }
    }

    // MARK: - Constructor
    init(with service:ResidentService) {
        self.service = service
    }
    
    func getResidentDetail(patientId : Int){
        self.isLoading = true
        service.getResidentDetail(patientId: patientId) { (result) in
                        self.isLoading = false
            if let residentDetail = result as? ResidentDetailHeader{
                self.residentDetailHeader = residentDetail
            }
        }
    }
    
}
