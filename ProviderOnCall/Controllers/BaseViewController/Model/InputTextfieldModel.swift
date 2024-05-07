//
//  InputTextfieldModel.swift
//  AccessEMR
//
//  Created by Vasundhara Parakh on 2/19/20.
//  Copyright © 2020 smartData Enterprises (I) Ltd. All rights reserved.
//

import UIKit

class InputTextfieldModel {
    var value: String?
    var placeholder:String?
    var apiKey : String?
    var valueId : Any?
    var inputType : String?
    var dropdownArr : [Any]?
    var isValid : Bool?
    var errorMessage : String?
    var sectionHeader : String?
    var minRangeTitle : String?
    var maxRangeTitle : String?
    var sliderValue : Int?

     init(value: String?, placeholder: String? , apiKey: String? , valueId : Any? ,inputType : String? , dropdownArr: [Any]?  , isValid : Bool? , errorMessage : String?){
        self.value = value
        self.placeholder = placeholder
        self.apiKey = apiKey
        self.valueId = valueId
        self.inputType = inputType
        self.dropdownArr = dropdownArr
        self.isValid = isValid
        self.errorMessage = errorMessage
    }
    
    init(value: String?, placeholder: String? , apiKey: String? , valueId : Any? ,inputType : String? , dropdownArr: [Any]?  , isValid : Bool? , errorMessage : String?,sectionHeader : String){
        self.value = value
        self.placeholder = placeholder
        self.apiKey = apiKey
        self.valueId = valueId
        self.inputType = inputType
        self.dropdownArr = dropdownArr
        self.isValid = isValid
        self.errorMessage = errorMessage
        self.sectionHeader = sectionHeader
    }
    
    init(value: String?, placeholder: String? , apiKey: String? , valueId : Any? ,inputType : String?, isValid : Bool? , errorMessage : String?,sectionHeader : String,minRangeTitle : String, maxRangeTitle : String,sliderValue: Int){
        self.value = value
        self.placeholder = placeholder
        self.apiKey = apiKey
        self.valueId = valueId
        self.inputType = inputType
        self.isValid = isValid
        self.errorMessage = errorMessage
        self.sectionHeader = sectionHeader
        self.minRangeTitle = minRangeTitle
        self.maxRangeTitle = maxRangeTitle
        self.sliderValue = sliderValue

    }
    
    init(value: String?, placeholder: String? , apiKey: String? , valueId : Any? ,inputType : String?, isValid : Bool? , errorMessage : String?,sliderValue: Int){
        self.value = value
        self.placeholder = placeholder
        self.apiKey = apiKey
        self.valueId = valueId
        self.inputType = inputType
        self.isValid = isValid
        self.errorMessage = errorMessage
        self.sliderValue = sliderValue
    }
}
