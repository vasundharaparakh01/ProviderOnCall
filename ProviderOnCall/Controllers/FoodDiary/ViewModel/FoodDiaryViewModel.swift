//
//  FoodDiaryViewModel.swift
//  AccessEMR
//
//  Created by Vasundhara Parakh on 3/3/20.
//  Copyright © 2020 smartData Enterprises (I) Ltd. All rights reserved.
//

import UIKit

class FoodDiaryViewModel: BaseViewModel {
    // MARK: - Parameters
    var service:ResidentService
    // MARK: - Constructor
    init(with service:ResidentService) {
        self.service = service
    }
    var foodDiaryList = [FoodDiary]()
    var breakfastList = [FoodDiary]()
    var lunchList = [FoodDiary]()
    var dinnerList = [FoodDiary]()
}
extension FoodDiaryViewModel{
    // MARK: - Network calls
    func getPatientFoodDiary(patientID: Int,date: Date){
        let serverDate = Utility.getStringFromDate(date: date, dateFormat: DateFormats.YYYY_MM_DD)
        self.isLoading = true
        let params : [String : Any] = [Key.Params.patientId : patientID,
            Key.Params.startDate : serverDate + "T00:00:00.000Z" ,
            Key.Params.stopDate : serverDate + "T23:59:59.000Z"
        ]
        self.isLoading = true
        service.getResidentFoodDiary(params: params) { (result) in
            self.isLoading = false
            if let foodList = result as? [FoodDiary]{
                self.foodDiaryList = foodList
                
                self.breakfastList = foodList.compactMap({ (entity) -> FoodDiary? in
                    return entity.mealCategoryName == "Breakfast" ? entity : nil
                })
                
                self.lunchList = foodList.compactMap({ (entity) -> FoodDiary? in
                    return entity.mealCategoryName == "Lunch" ? entity : nil
                })
                
                self.dinnerList = foodList.compactMap({ (entity) -> FoodDiary? in
                    return entity.mealCategoryName == "Diner" ? entity : nil
                })
                
                self.isListLoaded = true
            }else if let error = result as? String{
                self.foodDiaryList.removeAll()
                self.breakfastList.removeAll()
                self.lunchList.removeAll()
                self.dinnerList.removeAll()

                self.isListLoaded = true

                if error != "Data not found"{
                    self.errorMessage = error
                }
            }
        }
        
    }
}
