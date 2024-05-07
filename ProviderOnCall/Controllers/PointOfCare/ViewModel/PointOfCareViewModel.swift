//
//  PointOfCareViewModel.swift
//  AccessEMR
//
//  Created by Vasundhara Parakh on 2/28/20.
//  Copyright © 2020 smartData Enterprises (I) Ltd. All rights reserved.
//

import UIKit

class PointOfCareViewModel: BaseViewModel {
    // MARK: - Parameters
    private(set) var service:ResidentService
    
    // MARK: - Constructor
    init(with service:ResidentService) {
        self.service = service
    }
    
}
