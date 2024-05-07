//
//  ResidentListViewModel.swift
//  AccessEMR
//
//  Created by Vasundhara Parakh on 2/25/20.
//  Copyright © 2020 smartData Enterprises (I) Ltd. All rights reserved.
//

import UIKit

class ResidentListViewModel: BaseViewModel {
    // MARK: - Parameters
    private(set) var service:ResidentService
    var arrResidents = [Resident]()
    var arrFilteredResidents = [Resident]()
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
         return arrFilteredResidents.count
     }
     func roomForIndexPath(_ indexPath: IndexPath) -> Resident {
        return arrFilteredResidents[indexPath.row]
     }

    // MARK: - Network calls
    func getResidentList(pageNo : Int,searchText : String) {
        

        if pageNo == 1{
            self.isLoading = true
        }
        
        if searchText.count > 0 {
            if  SharedAccessEMR.sharedInstance.strSearchCheck == searchText{
                
            }else{
                SharedAccessEMR.sharedInstance.strSearchCheck = searchText
                self.arrResidents.removeAll()
                self.arrFilteredResidents.removeAll()
            }
            
        }
        service.getResidentList(searchText: searchText, locationId: 0, pageNo: pageNo) { (result) in
            self.isLoading = false
            if let arrResult = result as? [Resident]{
                if pageNo == 1 {
                    self.arrResidents.removeAll()
                    self.arrFilteredResidents.removeAll()
                    self.arrResidents = arrResult
                }else{
                    self.arrResidents.append(contentsOf: arrResult)
                }
                self.arrFilteredResidents = self.arrResidents
                
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
}
