//
//  AddMealViewModel.swift

//
//  Created by Vasundhara Mehta on 04/08/20.
//  Copyright © 2020 smartData Enterprises (I) Ltd. All rights reserved.
//

import UIKit
enum AddMealTitles{
    static let MealCategory = "Meal Category *"
    static let MealItem = "Meal Item *"
    static let Time = "Time *"
    static let Days = "Days *"
    static let ServingSize = "Serving Size *"
    static let ServingSizePortion = "Serving Size Portion *"
    static let DiningRoom = "Dining Room *"
    static let TypeFood = "Type of Food *"
    static let FoodAllergy = "Food Allergy *"
    static let FluidConsistency = "Fluid Consistency *"
    static let StartDate = "Start Date *"
    static let StopDate = "Stop Date *"
    static let Notes = "Notes"
}
class AddMealViewModel: BaseViewModel {
    var service:PointOfCareService
    var masterService = MasterService()

    var arrData = [ListingSectionModel]()
    var selectedMealIds : String = ""
    var selectedDayIds : String = ""

    var mealCategoryDropdown = [MealMasterDropdown]()
    var mealItemDropdown = [MealMasterDropdown]()
    var mealTypeDropdown = [MealMasterDropdown]()
    var fluidConsistencyDropdown = [MealMasterDropdown]()
    var daysDropdown = [MealMasterDropdown]()
    // MARK: - Constructor
    init(with service:PointOfCareService) {
        self.service = service
        

        self.daysDropdown.append(MealMasterDropdown(dictionary:["id":1001,"name":"Sunday"] as! NSDictionary)!)
        self.daysDropdown.append(MealMasterDropdown(dictionary:["id":2001,"name":"Monday"] as! NSDictionary)!)
        self.daysDropdown.append(MealMasterDropdown(dictionary:["id":3001,"name":"Tuesday"] as! NSDictionary)!)
        self.daysDropdown.append(MealMasterDropdown(dictionary:["id":4001,"name":"Wednesday"] as! NSDictionary)!)
        self.daysDropdown.append(MealMasterDropdown(dictionary:["id":5001,"name":"Thursday"] as! NSDictionary)!)
        self.daysDropdown.append(MealMasterDropdown(dictionary:["id":6001,"name":"Friday"] as! NSDictionary)!)
        self.daysDropdown.append(MealMasterDropdown(dictionary:["id":7001,"name":"Saturday"] as! NSDictionary)!)

    }

    func getDayName(id : Int) -> String{
        switch id {
        case 1001:
            return "Sunday"
        case 2001:
            return "Monday"
        case 3001:
            return "Tuesday"
        case 4001:
            return "Wednesday"
        case 5001:
            return "Thursday"
        case 6001:
            return "Friday"
        case 7001:
            return "Saturday"
        default:
            return ""
        }
        return ""
    }
    
    //MARK: -Table view methods
    func numberOfSection()-> Int{
        return arrData.count
    }
    func numberOfRows(section : Int)-> Int{
        let listModel = self.arrData[section]
        let listArray = listModel.content
        return listArray?.count ?? 0
    }
    func roomForIndexPath(_ indexPath: IndexPath) -> ListModel? {
        let listModel = self.arrData[indexPath.section]
        let listArray = listModel.content
        return listArray?[indexPath.row] ?? ListModel(title: "", value: "")
    }
    
    func titleForHeader(section : Int) -> String{
        if section == self.mealCategoryDropdown.count
        {
            return "Others"
        }
        return self.mealCategoryDropdown[section].name ?? ""
    }

}
//MARK:- Add Task
extension AddMealViewModel{
    // MARK: - Network calls
    func saveMealPlan(params: [String : Any]){
        self.isLoading = true
        service.saveMealPlan(params: params) { (result,isSuccess) in
            self.isLoading = false
            self.isSuccess = isSuccess
            if isSuccess{
                self.alertMessage = (result as? String) ?? "Some error has occured. Please try again later."
            }else{
                self.errorMessage = (result as? String) ?? "Some error has occured. Please try again later."
            }
        }
    }
    
    func getMealMasters(){
        masterService.getMealMasters(with: APITargetPoint.getMealCategory) { (mealCategory) in
            if let category = mealCategory as? [MealMasterDropdown]{
                self.mealCategoryDropdown = category
                
                self.masterService.getMealMasters(with: APITargetPoint.getMealItem) { (mealItem) in
                    if let mealItems = mealItem as? [MealMasterDropdown]{
                        self.mealItemDropdown = mealItems
                        
                        self.masterService.getMealMasters(with: APITargetPoint.getTypeOfFood) { (typeOfFood) in
                            if let foodtype = typeOfFood as? [MealMasterDropdown]{
                                self.mealTypeDropdown = foodtype
                                
                                self.masterService.getMealMasters(with: APITargetPoint.getFluidConsistency) { (fluid) in
                                    if let fluidDropdown = fluid as? [MealMasterDropdown]{
                                        self.fluidConsistencyDropdown = fluidDropdown
                                        
                                        self.shouldUpdateView = true
                                        
                                        
                                    }else{
                                        self.shouldUpdateView = true
                                    }
                                }
                                
                                
                            }else{
                                self.shouldUpdateView = true
                            }
                        }
                        
                    }else{
                        self.shouldUpdateView = true
                    }
                }
                
            }else{
                self.shouldUpdateView = true
            }
        }
    }
    
    func getInputArray() -> [Any]{
        var finalArray = [Any]()
        for (index,_) in self.mealCategoryDropdown.enumerated(){
            finalArray.append(self.getInput(section: index))
        }
        finalArray.append(self.otherInputs())
        return finalArray
    }
    
    func otherInputs() -> [Any]{
            return [InputTextfieldModel(value: "", placeholder: AddMealTitles.DiningRoom, apiKey: Key.Params.AddMeal.servingHall, valueId: nil, inputType: InputType.Text, dropdownArr: nil,isValid: false, errorMessage: ConstantStrings.mandatory),
            
            InputTextfieldModel(value: "", placeholder: AddMealTitles.TypeFood, apiKey: Key.Params.AddMeal.typeOfFoodId, valueId: nil, inputType: InputType.Dropdown, dropdownArr: self.mealTypeDropdown,isValid: false, errorMessage: ConstantStrings.mandatory),
            
            InputTextfieldModel(value: "", placeholder: AddMealTitles.FoodAllergy, apiKey: Key.Params.AddMeal.foodAllergy, valueId: nil, inputType: InputType.Text, dropdownArr: nil,isValid: false, errorMessage: ConstantStrings.mandatory),
            
            InputTextfieldModel(value: "", placeholder: AddMealTitles.FluidConsistency, apiKey: Key.Params.AddMeal.fluidConsistencyId, valueId: nil, inputType: InputType.Dropdown, dropdownArr: self.fluidConsistencyDropdown,isValid: false, errorMessage: ConstantStrings.mandatory),
            
            InputTextfieldModel(value: "", placeholder: AddMealTitles.Notes, apiKey: Key.Params.AddMeal.notes, valueId: nil, inputType: InputType.Text, dropdownArr: nil,isValid: true, errorMessage: ConstantStrings.mandatory)
        ]
    }
    
    
    func getInput(section : Int) -> [Any]{
        let category = self.mealCategoryDropdown[section]
        return [
            [InputTextfieldModel(value: category.name ?? "", placeholder: AddMealTitles.MealCategory, apiKey: Key.Params.AddMeal.mealCategoryId, valueId: category.id ?? 0, inputType: InputType.Dropdown, dropdownArr: self.mealCategoryDropdown,isValid: true, errorMessage: ConstantStrings.mandatory,sectionHeader: AddMealTitles.MealCategory),
            
            InputTextfieldModel(value: "", placeholder: AddMealTitles.Time, apiKey: Key.Params.AddMeal.mealTime, valueId: nil, inputType: InputType.Time, dropdownArr: nil,isValid: false, errorMessage: ConstantStrings.mandatory,sectionHeader: AddMealTitles.MealCategory)],

            self.mealCategoryInput(day: self.getDayName(id: 1001)),
            self.mealCategoryInput(day: self.getDayName(id: 2001)),
            self.mealCategoryInput(day: self.getDayName(id: 3001)),
            self.mealCategoryInput(day: self.getDayName(id: 4001)),
            self.mealCategoryInput(day: self.getDayName(id: 5001)),
            self.mealCategoryInput(day: self.getDayName(id: 6001)),
            self.mealCategoryInput(day: self.getDayName(id: 7001)),
            
            [InputTextfieldModel(value: "", placeholder: AddMealTitles.StartDate, apiKey: Key.Params.AddMeal.startDate, valueId: nil, inputType: InputType.Date, dropdownArr: nil,isValid: false, errorMessage: ConstantStrings.mandatory,sectionHeader: AddMealTitles.MealCategory),
            InputTextfieldModel(value: "", placeholder: AddMealTitles.StopDate, apiKey: Key.Params.AddMeal.stopDate, valueId: nil, inputType: InputType.Date, dropdownArr: nil,isValid: false, errorMessage: ConstantStrings.mandatory,sectionHeader: AddMealTitles.MealCategory)]
        ]
        
    }
    
    func mealCategoryInput(day: String) -> [InputTextfieldModel]{
        return [
            InputTextfieldModel(value: day, placeholder: AddMealTitles.Days, apiKey: Key.Params.AddMeal.mealDays, valueId: day, inputType: InputType.Text, dropdownArr: self.daysDropdown,isValid: true, errorMessage: ConstantStrings.mandatory,sectionHeader: AddMealTitles.MealCategory),
            InputTextfieldModel(value: "", placeholder: AddMealTitles.MealItem, apiKey: Key.Params.AddMeal.mealItemsModel, valueId: nil, inputType: InputType.Text, dropdownArr: self.mealItemDropdown,isValid: false, errorMessage: ConstantStrings.mandatory,sectionHeader: AddMealTitles.MealCategory),
            InputTextfieldModel(value: "", placeholder: AddMealTitles.ServingSize, apiKey: Key.Params.AddMeal.servingSize, valueId: nil, inputType: InputType.Text, dropdownArr: nil,isValid: false, errorMessage: ConstantStrings.mandatory,sectionHeader: AddMealTitles.MealCategory),
            
            InputTextfieldModel(value: "", placeholder: AddMealTitles.ServingSizePortion, apiKey: Key.Params.AddMeal.servingSizePortion, valueId: nil, inputType: InputType.Text, dropdownArr: nil,isValid: false, errorMessage: ConstantStrings.mandatory,sectionHeader: AddMealTitles.MealCategory),


        ]
    }

}

