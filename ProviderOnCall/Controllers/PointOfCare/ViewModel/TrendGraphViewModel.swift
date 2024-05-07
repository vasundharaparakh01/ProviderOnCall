//
//  TrendGraphViewModel.swift
//  AccessEMR
//
//  Created by Sorabh Gupta on 12/18/20.
//  Copyright © 2020 smartData Enterprises (I) Ltd. All rights reserved.
//

import Foundation

class TrendGraphViewModel: BaseViewModel{
    // MARK: - Parameters
    var service:PointOfCareService
    var inputOutPut : InputOutPutChart?
     var trendGraphModel : TrendGraphModel?
    // MARK: - Constructor
    init(with service:PointOfCareService) {
        self.service = service
    }
}
//MARK:- NursingCareViewModel
extension TrendGraphViewModel{
    // MARK: - Network calls

    func getIODetail(patientId : Int, strDate: String, completion:@escaping (Any?) -> Void){
           self.isLoading = true
         service.getIODetail(with: patientId, strdate: strDate) { (result) in
               self.isLoading = false
               if let res = result as? InputOutPutChart{
                self.inputOutPut = res
                 print(res)
                   completion(res)
               }
           }
       }
    func getTrendGraphDetail(patientId : Int, strDate: String, endDate: String, completion:@escaping (Any?) -> Void){
              self.isLoading = true
        
            service.getTrendGraphDetail(with: patientId, strdate: strDate, enddate: endDate) { (result) in
                  self.isLoading = false
                  if let res = result as? TrendGraphModel{
                   self.trendGraphModel = res
                    print(res)
                      completion(res)
                  }
              }
          }
}
