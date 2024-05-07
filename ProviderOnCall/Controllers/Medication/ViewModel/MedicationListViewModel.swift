//
//  MedicationListViewModel.swift
//  AccessEMR
//
//  Created by Vasundhara Parakh on 2/28/20.
//  Copyright © 2020 smartData Enterprises (I) Ltd. All rights reserved.
//

import UIKit

class MedicationListViewModel: BaseViewModel {
    // MARK: - Parameters
    private(set) var service:ResidentService
    var arrMedication = [Medication]()
    var arrOverCounterMedication = [OtherMedicine]()
    var arrHerbalMedication = [OtherMedicine]()

    var strForIsMore = ConstantStrings.no  {
        didSet {
            
            self.reloadListViewClosure?()
        }
    }
    var intForPageNo = 1
    
    // MARK: - Constructor
    init(with service:ResidentService) {
        self.service = service
    }
    
    //MARK: -Table view methods
    func numberOfRows()-> Int{
        return arrMedication.count
    }
    func roomForIndexPath(_ indexPath: IndexPath) -> Medication {
        return arrMedication[indexPath.row]
    }
    
    // MARK: - Network calls
    func getMedicationList(pageNo : Int,patientID : Int) {
        if pageNo == 1{
            self.isLoading = true
        }
        
        service.getResidentMedication(patientId: patientID, pageNo: pageNo) { (result) in
            self.isLoading = false
            if let arrResult = result as? [Medication]{
                if pageNo == 1 {
                    self.arrMedication.removeAll()
                    self.arrMedication = arrResult
                }else{
                    self.arrMedication.append(contentsOf: arrResult)
                }
                
                //Use if need pagination table reload
                self.intForPageNo = arrResult.count == Pagination.pageSize ? self.intForPageNo + 1 : 0
                self.strForIsMore = arrResult.count == Pagination.pageSize ? ConstantStrings.yes : ConstantStrings.no
                //End
                
                //Use if need simple table reload
                //self.isListLoaded = true
                //end
            }else{
                self.isListLoaded = true
            }
        }
        

        
    }
    
    func getOverCounterMedicationList(patientID : Int) {
            self.isLoading = true
        service.getOverCounterMedication(patientId: patientID) { (result) in
            self.isLoading = false
            if let arrResult = result as? [OtherMedicine]{
                self.arrOverCounterMedication = arrResult
                self.isListLoaded = true
            }
        }
    }
    
    func getHerbalMedicationList(patientID : Int) {
            self.isLoading = true
        service.getHerbalMedicationMedication(patientId: patientID) { (result) in
            self.isLoading = false
            if let arrResult = result as? [OtherMedicine]{
                self.arrHerbalMedication = arrResult
                self.isListLoaded = true
            }
        }
    }
}
