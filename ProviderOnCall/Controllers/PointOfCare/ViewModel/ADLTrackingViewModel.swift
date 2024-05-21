//
//  ADLTrackingViewModel.swift
//  appName
//
//  Created by Vasundhara Parakh on 3/12/20.
//  Copyright © 2020 smartData Enterprises (I) Ltd. All rights reserved.
//

import UIKit
enum ADLSections : Int{
    case Mobility = 0
    case Transfer
    case Dressing
    case EatingDrinking
    case Toileting
    case PersonalHygiene
    case Bathing
    case Continenece
    case Notes
}
enum ADLType{
    static let ADL_SELF_PERFORMANCE_OPTIONS = "ADL_SELF_PERFORMANCE_OPTIONS"
    static let ADL_SUPPORT_PROVIDED_OPTIONS = "ADL_SUPPORT_PROVIDED_OPTIONS"
    static let Continence_Bladder = "Continence_Bladder"
    static let Continence_Bowel = "Continence_Bowel"
}
enum ADLTrackingTitles {
    //common
    static let SelfPerformance = "Self performance"
    static let SupportProvided = "Support provided"
    //getMobility
    static let MovesInBed = "Move in Bed"
    static let WalksInRoom = "Walk in Room"
    static let WalksInCorridor = "Walk in Corridor"
    static let MovesOnUnit = "Move on Unit"
    static let MovesOffUnit = "Move Off Unit"
    //getTransfer
    static let Transfer = "Transfer"
    //getDressing
    static let Dressing = "Dressing"
    static let Undresses = "Undress"
    //getEating
    static let EatsDrinks = "Eat & Drink"
    //getToileting
    static let UsesToilet = "Use Toilet / Commode / Incontinent \nProduct"
    //getPersonalHygiene
    static let PersonalHygiene = "Personal Hygiene"
    //getBathing
    static let Bathing = "Bathing"
    //getContinenece
     static let Bladder = "Bladder"
     static let Bowel = "Bowel"
    //getNotes
     static let Notes = "Notes"
}
enum ADLTrackingHeaders {
    static let Mobility = "Mobility"
    static let Transfer = "Transfer"
    static let Dressing = "Dressing"
    static let EatingDrinking = "Eating & Drinking"
    static let Toileting = "Toileting"
    static let PersonalHygiene = "Personal Hygiene"
    static let Bathing = "Bathing"
    static let Continenece = "Continence"
    static let Notes = "Notes"
}

class ADLTrackingViewModel: BaseViewModel{
    // MARK: - Parameters
    private(set) var service:PointOfCareService
    var serviceMaster = MasterService()
    var adlTracking : ADLTrackingTool?
    // MARK: - Constructor
    init(with service:PointOfCareService) {
        self.service = service
    }
    
    var arrData = [ListingSectionModel]()
    var dateOfPlan = ""
    var planAddedBy = ""
    let headerArray = [ADLTrackingHeaders.Mobility,ADLTrackingHeaders.Transfer,ADLTrackingHeaders.Dressing,ADLTrackingHeaders.EatingDrinking,ADLTrackingHeaders.Toileting,ADLTrackingHeaders.PersonalHygiene,ADLTrackingHeaders.Bathing,ADLTrackingHeaders.Continenece,ADLTrackingHeaders.Notes]
    var dropdownMood : [PointOfCareMasterDropdown]?

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
    
    func titleForSectionHeader(section : Int) -> String{
        let listModel = self.arrData[section]
        return listModel.headerTitle ?? ""
    }
    
    func titleForHeader(section: Int) -> String? {
        return self.headerArray[section]
    }

}
//MARK:- ADLTracking
extension ADLTrackingViewModel{
    // MARK: - Network calls
    func saveADLTracking(params : [String: Any]){
        self.isLoading = true
        service.saveADL(params: params) { (result) in
            self.isLoading = false
            if let res = result as? String{
                self.errorMessage = res
            }else{
                self.isSuccess = true
                self.alertMessage = Alert.Message.formSavedSuccessfully
            }
            
        }
    }
    
    func deleteAldTrackingCare(apiName:String, params : [String: Any]){
        self.isLoading = true
        service.discardNursingCareFlow(apiName: apiName, params: params)  { (result) in
            self.isLoading = false
            if let res = result as? String{
                self.errorMessage = res
            }else{
                self.isSuccess = true
                self.alertMessage = Alert.Message.formResetSuccessfully
            }
        }
    }
    
    func getADLMasters(){
        self.isLoading = true
        serviceMaster.getPointOfCareMasters { (result) in
                        self.isLoading = false
            if let res = result as? [PointOfCareMasterDropdown]
            {
                self.dropdownMood = res
                self.shouldUpdateView = true
            }else{
                self.errorMessage = Alert.ErrorMessages.invalid_response
            }
        }
    }
    func dropDownforFieldType(type: String) -> [PointOfCareMasterDropdown]?{
        if let dropdownArr = self.dropdownMood{
            let dropDownArray = dropdownArr.compactMap { (entity) -> PointOfCareMasterDropdown? in
                if entity.type == type{
                    return entity
                }
                return nil
            }
            return dropDownArray
        }
        return nil
    }
    
    func getDropdownName(id: Int,dropdown:Any? ) -> String{
        var dropdownName = ""
        
        if let dropdownArr = dropdown as? [PointOfCareMasterDropdown]{
            let dropdownList = dropdownArr.compactMap { (entity) -> PointOfCareMasterDropdown? in
                return ((entity.id ?? 0) == id) ? entity : nil
            }
            dropdownName = dropdownList.isEmpty ? "" : dropdownList.first?.value ?? ""
        }
        
        return  dropdownName
    }
    
    func getInputArray() -> [Any]{
        var finalArray = [Any]()
        finalArray.append(self.getMobilityInput())
        finalArray.append(self.getTransferInput())
        finalArray.append(self.getDressingInput())
        finalArray.append(self.getEatingDrinkingInput())
        finalArray.append(self.getToiletingInput())
        finalArray.append(self.getPersonalHygieneInput())
        finalArray.append(self.getBathingInput())
        finalArray.append(self.getContinenceInput())
        finalArray.append(self.getNotesInput())
        return finalArray
    }
    
    func getMobilityInput() -> [Any]{
        let strMovesInBedSelf = self.getDropdownName(id: self.adlTracking?.movesInBedSelfPerformanceId ?? 0, dropdown: self.dropDownforFieldType(type: ADLType.ADL_SELF_PERFORMANCE_OPTIONS))
        let strMovesInBedsupport = self.getDropdownName(id: self.adlTracking?.movesInBedSupportProvidedId ?? 0, dropdown: self.dropDownforFieldType(type: ADLType.ADL_SUPPORT_PROVIDED_OPTIONS))

        
        let strWalksinRoomSelf = self.getDropdownName(id: self.adlTracking?.walksInRoomSelfPerformanceId ?? 0, dropdown: self.dropDownforFieldType(type: ADLType.ADL_SELF_PERFORMANCE_OPTIONS))
        let strWalksinRoomsupport = self.getDropdownName(id: self.adlTracking?.walksInRoomSupportProvidedId ?? 0, dropdown: self.dropDownforFieldType(type: ADLType.ADL_SUPPORT_PROVIDED_OPTIONS))
        
        let strWalksinCorridorSelf = self.getDropdownName(id: self.adlTracking?.walksInHallSelfPerformanceId ?? 0, dropdown: self.dropDownforFieldType(type: ADLType.ADL_SELF_PERFORMANCE_OPTIONS))
        let strWalksinCorridorSupport = self.getDropdownName(id: self.adlTracking?.walksInHallSupportProvidedId ?? 0, dropdown: self.dropDownforFieldType(type: ADLType.ADL_SUPPORT_PROVIDED_OPTIONS))

        let strMovesOnUnitSelf = self.getDropdownName(id: self.adlTracking?.movesOnUnitSelfPerformanceId ?? 0, dropdown: self.dropDownforFieldType(type: ADLType.ADL_SELF_PERFORMANCE_OPTIONS))
        let strMovesOnUnitSupport = self.getDropdownName(id: self.adlTracking?.movesOnUnitSupportProvidedId ?? 0, dropdown: self.dropDownforFieldType(type: ADLType.ADL_SUPPORT_PROVIDED_OPTIONS))

        let strMovesOffUnitSelf = self.getDropdownName(id: self.adlTracking?.movesOffUnitSelfPerformanceId ?? 0, dropdown: self.dropDownforFieldType(type: ADLType.ADL_SELF_PERFORMANCE_OPTIONS))
        let strMovesOffUnitSupport = self.getDropdownName(id: self.adlTracking?.movesOffUnitSupportProvidedId ?? 0, dropdown: self.dropDownforFieldType(type: ADLType.ADL_SUPPORT_PROVIDED_OPTIONS))


        return [[InputTextfieldModel(value: strMovesInBedSelf , placeholder: ADLTrackingTitles.MovesInBed, apiKey: Key.Params.ADLTracking.movesInBedSelfPerformanceId, valueId: self.adlTracking?.movesInBedSelfPerformanceId ?? nil, inputType: InputType.Dropdown, dropdownArr: self.dropDownforFieldType(type: ADLType.ADL_SELF_PERFORMANCE_OPTIONS),isValid: strMovesInBedSelf.count != 0, errorMessage: ConstantStrings.mandatory),
                 
                 InputTextfieldModel(value: strMovesInBedsupport , placeholder: ADLTrackingTitles.MovesInBed, apiKey: Key.Params.ADLTracking.movesInBedSupportProvidedId, valueId: self.adlTracking?.movesInBedSupportProvidedId ?? nil, inputType: InputType.Dropdown, dropdownArr: self.dropDownforFieldType(type: ADLType.ADL_SUPPORT_PROVIDED_OPTIONS),isValid: strMovesInBedsupport.count != 0, errorMessage: ConstantStrings.mandatory)],
                
                [InputTextfieldModel(value: strWalksinRoomSelf, placeholder: ADLTrackingTitles.WalksInRoom, apiKey: Key.Params.ADLTracking.walksInRoomSelfPerformanceId, valueId: self.adlTracking?.walksInRoomSelfPerformanceId ?? nil, inputType: InputType.Dropdown, dropdownArr: self.dropDownforFieldType(type: ADLType.ADL_SELF_PERFORMANCE_OPTIONS),isValid:  strWalksinRoomSelf.count != 0, errorMessage: ConstantStrings.mandatory),
                 InputTextfieldModel(value: strWalksinRoomsupport, placeholder: ADLTrackingTitles.WalksInRoom, apiKey: Key.Params.ADLTracking.walksInRoomSupportProvidedId, valueId: self.adlTracking?.walksInRoomSupportProvidedId ?? nil, inputType: InputType.Dropdown, dropdownArr: self.dropDownforFieldType(type: ADLType.ADL_SUPPORT_PROVIDED_OPTIONS),isValid: strWalksinRoomsupport.count != 0, errorMessage: ConstantStrings.mandatory)],
                
                [InputTextfieldModel(value: strWalksinCorridorSelf, placeholder: ADLTrackingTitles.WalksInCorridor, apiKey: Key.Params.ADLTracking.walksInHallSelfPerformanceId, valueId: self.adlTracking?.walksInHallSelfPerformanceId ?? nil, inputType: InputType.Dropdown, dropdownArr: self.dropDownforFieldType(type: ADLType.ADL_SELF_PERFORMANCE_OPTIONS),isValid: strWalksinCorridorSelf.count != 0, errorMessage: ConstantStrings.mandatory),
                 InputTextfieldModel(value: strWalksinCorridorSupport, placeholder: ADLTrackingTitles.WalksInCorridor, apiKey: Key.Params.ADLTracking.walksInHallSupportProvidedId, valueId: self.adlTracking?.walksInHallSupportProvidedId ?? nil, inputType: InputType.Dropdown, dropdownArr: self.dropDownforFieldType(type: ADLType.ADL_SUPPORT_PROVIDED_OPTIONS),isValid: strWalksinCorridorSupport.count != 0, errorMessage: ConstantStrings.mandatory)],
                
                [InputTextfieldModel(value: strMovesOnUnitSelf, placeholder: ADLTrackingTitles.MovesOnUnit, apiKey: Key.Params.ADLTracking.movesOnUnitSelfPerformanceId, valueId: self.adlTracking?.movesOnUnitSelfPerformanceId ?? nil, inputType: InputType.Dropdown, dropdownArr: self.dropDownforFieldType(type: ADLType.ADL_SELF_PERFORMANCE_OPTIONS),isValid: strMovesOnUnitSelf.count != 0, errorMessage: ConstantStrings.mandatory),
                 InputTextfieldModel(value: strMovesOnUnitSupport, placeholder: ADLTrackingTitles.MovesOnUnit, apiKey: Key.Params.ADLTracking.movesOnUnitSupportProvidedId, valueId: self.adlTracking?.movesOnUnitSupportProvidedId ?? nil, inputType: InputType.Dropdown, dropdownArr: self.dropDownforFieldType(type: ADLType.ADL_SUPPORT_PROVIDED_OPTIONS),isValid: strMovesOnUnitSupport.count != 0, errorMessage: ConstantStrings.mandatory)],
                
                [InputTextfieldModel(value: strMovesOffUnitSelf, placeholder: ADLTrackingTitles.MovesOffUnit, apiKey: Key.Params.ADLTracking.movesOffUnitSelfPerformanceId, valueId: self.adlTracking?.movesOffUnitSelfPerformanceId ?? nil, inputType: InputType.Dropdown, dropdownArr: self.dropDownforFieldType(type: ADLType.ADL_SELF_PERFORMANCE_OPTIONS),isValid: strMovesOffUnitSelf.count != 0, errorMessage: ConstantStrings.mandatory),
                 InputTextfieldModel(value: strMovesOffUnitSupport, placeholder: ADLTrackingTitles.MovesOffUnit, apiKey: Key.Params.ADLTracking.movesOffUnitSupportProvidedId, valueId: self.adlTracking?.movesOffUnitSupportProvidedId ?? nil, inputType: InputType.Dropdown, dropdownArr: self.dropDownforFieldType(type: ADLType.ADL_SUPPORT_PROVIDED_OPTIONS),isValid: strMovesOffUnitSupport.count != 0, errorMessage: ConstantStrings.mandatory)]
        ]
    }
    
    func getTransferInput() ->[Any]{
        let strTransferSelf = self.getDropdownName(id: self.adlTracking?.transferSelfPerformanceId ?? 0, dropdown: self.dropDownforFieldType(type: ADLType.ADL_SELF_PERFORMANCE_OPTIONS))
        let strTransferSupport = self.getDropdownName(id: self.adlTracking?.transferSupportProvidedId ?? 0, dropdown: self.dropDownforFieldType(type: ADLType.ADL_SUPPORT_PROVIDED_OPTIONS))

        return [[InputTextfieldModel(value: strTransferSelf, placeholder: ADLTrackingTitles.Transfer, apiKey: Key.Params.ADLTracking.transferSelfPerformanceId, valueId: self.adlTracking?.transferSelfPerformanceId ?? nil, inputType: InputType.Dropdown, dropdownArr: self.dropDownforFieldType(type: ADLType.ADL_SELF_PERFORMANCE_OPTIONS),isValid: strTransferSelf.count != 0, errorMessage: ConstantStrings.mandatory),
                 InputTextfieldModel(value: strTransferSupport, placeholder: ADLTrackingTitles.Transfer, apiKey: Key.Params.ADLTracking.transferSupportProvidedId, valueId: self.adlTracking?.transferSupportProvidedId ?? nil, inputType: InputType.Dropdown, dropdownArr: self.dropDownforFieldType(type: ADLType.ADL_SUPPORT_PROVIDED_OPTIONS),isValid: strTransferSupport.count != 0, errorMessage: ConstantStrings.mandatory)]]
    }
    
    func getDressingInput() -> [Any]{
        let strDressSelf = self.getDropdownName(id: self.adlTracking?.dresesSelfPerformanceId ?? 0, dropdown: self.dropDownforFieldType(type: ADLType.ADL_SELF_PERFORMANCE_OPTIONS))
        let strDressSupport = self.getDropdownName(id: self.adlTracking?.dresesSupportProvidedId ?? 0, dropdown: self.dropDownforFieldType(type: ADLType.ADL_SUPPORT_PROVIDED_OPTIONS))

        let strUndressSelf = self.getDropdownName(id: self.adlTracking?.unDresesSelfPerformanceId ?? 0, dropdown: self.dropDownforFieldType(type: ADLType.ADL_SELF_PERFORMANCE_OPTIONS))
        let strUndressSupport = self.getDropdownName(id: self.adlTracking?.unDresesSupportProvidedId ?? 0, dropdown: self.dropDownforFieldType(type: ADLType.ADL_SUPPORT_PROVIDED_OPTIONS))

        return [[InputTextfieldModel(value: strDressSelf, placeholder: ADLTrackingTitles.Dressing, apiKey: Key.Params.ADLTracking.dresesSelfPerformanceId, valueId:  self.adlTracking?.dresesSelfPerformanceId ?? nil, inputType: InputType.Dropdown, dropdownArr: self.dropDownforFieldType(type: ADLType.ADL_SELF_PERFORMANCE_OPTIONS),isValid: strDressSelf.count != 0, errorMessage: ConstantStrings.mandatory),
                 InputTextfieldModel(value: strDressSupport, placeholder: ADLTrackingTitles.Dressing, apiKey: Key.Params.ADLTracking.dresesSupportProvidedId, valueId:  self.adlTracking?.dresesSupportProvidedId ?? nil, inputType: InputType.Dropdown, dropdownArr: self.dropDownforFieldType(type: ADLType.ADL_SUPPORT_PROVIDED_OPTIONS),isValid: strDressSupport.count != 0, errorMessage: ConstantStrings.mandatory)],
                
                [InputTextfieldModel(value: strUndressSelf, placeholder: ADLTrackingTitles.Undresses, apiKey: Key.Params.ADLTracking.unDresesSelfPerformanceId, valueId: self.adlTracking?.unDresesSelfPerformanceId ?? nil, inputType: InputType.Dropdown, dropdownArr: self.dropDownforFieldType(type: ADLType.ADL_SELF_PERFORMANCE_OPTIONS),isValid: strUndressSelf.count != 0, errorMessage: ConstantStrings.mandatory),
                 InputTextfieldModel(value: strUndressSupport, placeholder: ADLTrackingTitles.Undresses, apiKey: Key.Params.ADLTracking.unDresesSupportProvidedId, valueId: self.adlTracking?.unDresesSupportProvidedId ?? nil, inputType: InputType.Dropdown, dropdownArr: self.dropDownforFieldType(type: ADLType.ADL_SUPPORT_PROVIDED_OPTIONS),isValid: strUndressSupport.count != 0, errorMessage: ConstantStrings.mandatory)]]
    }
    
    func getEatingDrinkingInput() -> [Any]{
        let strEatsSelf = self.getDropdownName(id: self.adlTracking?.unDresesSelfPerformanceId ?? 0, dropdown: self.dropDownforFieldType(type: ADLType.ADL_SELF_PERFORMANCE_OPTIONS))
        let strEatsSupport = self.getDropdownName(id: self.adlTracking?.unDresesSupportProvidedId ?? 0, dropdown: self.dropDownforFieldType(type: ADLType.ADL_SUPPORT_PROVIDED_OPTIONS))

        return [[InputTextfieldModel(value: strEatsSelf, placeholder: ADLTrackingTitles.EatsDrinks, apiKey: Key.Params.ADLTracking.eatAndDrinkSelfPerformanceId, valueId: self.adlTracking?.eatAndDrinkSelfPerformanceId ?? nil, inputType: InputType.Dropdown, dropdownArr: self.dropDownforFieldType(type: ADLType.ADL_SELF_PERFORMANCE_OPTIONS),isValid: strEatsSelf.count != 0, errorMessage: ConstantStrings.mandatory),
                 InputTextfieldModel(value: strEatsSupport, placeholder: ADLTrackingTitles.EatsDrinks, apiKey: Key.Params.ADLTracking.eatAndDrinkSupportProvidedId, valueId: self.adlTracking?.eatAndDrinkSelfPerformanceId ?? nil, inputType: InputType.Dropdown, dropdownArr: self.dropDownforFieldType(type: ADLType.ADL_SUPPORT_PROVIDED_OPTIONS),isValid: strEatsSupport.count != 0, errorMessage: ConstantStrings.mandatory)]]
    }
    
    func getToiletingInput() -> [Any]{
        let strToiletSelf = self.getDropdownName(id: self.adlTracking?.usesToiletSelfPerformanceId ?? 0, dropdown: self.dropDownforFieldType(type: ADLType.ADL_SELF_PERFORMANCE_OPTIONS))
        let strToiletSupport = self.getDropdownName(id: self.adlTracking?.usesToiletSupportProvidedId ?? 0, dropdown: self.dropDownforFieldType(type: ADLType.ADL_SUPPORT_PROVIDED_OPTIONS))

        return [[InputTextfieldModel(value: strToiletSelf, placeholder: ADLTrackingTitles.UsesToilet, apiKey: Key.Params.ADLTracking.usesToiletSelfPerformanceId, valueId: self.adlTracking?.usesToiletSelfPerformanceId ?? nil, inputType: InputType.Dropdown, dropdownArr: self.dropDownforFieldType(type: ADLType.ADL_SELF_PERFORMANCE_OPTIONS),isValid: strToiletSelf.count != 0, errorMessage: ConstantStrings.mandatory),
                 InputTextfieldModel(value: strToiletSupport, placeholder: ADLTrackingTitles.UsesToilet, apiKey: Key.Params.ADLTracking.usesToiletSupportProvidedId, valueId: self.adlTracking?.usesToiletSupportProvidedId ?? nil, inputType: InputType.Dropdown, dropdownArr: self.dropDownforFieldType(type: ADLType.ADL_SUPPORT_PROVIDED_OPTIONS),isValid: strToiletSupport.count != 0, errorMessage: ConstantStrings.mandatory)]]
    }
    
    func getPersonalHygieneInput() -> [Any]{
        let strPersonalHygieneSelf = self.getDropdownName(id: self.adlTracking?.personalHygieneSelfPerformanceId ?? 0, dropdown: self.dropDownforFieldType(type: ADLType.ADL_SELF_PERFORMANCE_OPTIONS))
        let strPersonalHygieneSupport = self.getDropdownName(id: self.adlTracking?.personalHygieneSupportProvidedId ?? 0, dropdown: self.dropDownforFieldType(type: ADLType.ADL_SUPPORT_PROVIDED_OPTIONS))

        return [[InputTextfieldModel(value: strPersonalHygieneSelf, placeholder: ADLTrackingTitles.PersonalHygiene, apiKey: Key.Params.ADLTracking.personalHygieneSelfPerformanceId, valueId: self.adlTracking?.personalHygieneSelfPerformanceId ?? nil, inputType: InputType.Dropdown, dropdownArr: self.dropDownforFieldType(type: ADLType.ADL_SELF_PERFORMANCE_OPTIONS),isValid: strPersonalHygieneSelf.count != 0, errorMessage: ConstantStrings.mandatory),
                 InputTextfieldModel(value: strPersonalHygieneSupport, placeholder: ADLTrackingTitles.PersonalHygiene, apiKey: Key.Params.ADLTracking.personalHygieneSupportProvidedId, valueId: self.adlTracking?.personalHygieneSupportProvidedId ?? nil, inputType: InputType.Dropdown, dropdownArr: self.dropDownforFieldType(type: ADLType.ADL_SUPPORT_PROVIDED_OPTIONS),isValid: strPersonalHygieneSupport.count != 0, errorMessage: ConstantStrings.mandatory)]]
    }
    
    func getBathingInput() -> [Any]{
        let strBathingSelf = self.getDropdownName(id: self.adlTracking?.bathingSelfPerformanceId ?? 0, dropdown: self.dropDownforFieldType(type: ADLType.ADL_SELF_PERFORMANCE_OPTIONS))
        let strBathingSupport = self.getDropdownName(id: self.adlTracking?.bathingSupportProvidedId ?? 0, dropdown: self.dropDownforFieldType(type: ADLType.ADL_SUPPORT_PROVIDED_OPTIONS))

        return [[InputTextfieldModel(value: strBathingSelf, placeholder: ADLTrackingTitles.Bathing, apiKey: Key.Params.ADLTracking.bathingSelfPerformanceId, valueId: self.adlTracking?.bathingSelfPerformanceId ?? nil, inputType: InputType.Dropdown, dropdownArr: self.dropDownforFieldType(type: ADLType.ADL_SELF_PERFORMANCE_OPTIONS),isValid: strBathingSelf.count != 0, errorMessage: ConstantStrings.mandatory),
                 InputTextfieldModel(value: strBathingSupport, placeholder: ADLTrackingTitles.Bathing, apiKey: Key.Params.ADLTracking.bathingSupportProvidedId, valueId: self.adlTracking?.bathingSupportProvidedId ?? nil, inputType: InputType.Dropdown, dropdownArr: self.dropDownforFieldType(type: ADLType.ADL_SUPPORT_PROVIDED_OPTIONS),isValid: strBathingSupport.count != 0, errorMessage: ConstantStrings.mandatory)]]
    }
    
    func getContinenceInput() -> [Any]{
        let strBladder = self.getDropdownName(id: self.adlTracking?.bladderId ?? 0, dropdown: self.dropDownforFieldType(type: ADLType.Continence_Bladder))
        let strBowel = self.getDropdownName(id: self.adlTracking?.bowelId ?? 0, dropdown: self.dropDownforFieldType(type: ADLType.Continence_Bowel))

        return [[InputTextfieldModel(value: strBladder, placeholder: ADLTrackingTitles.Bladder, apiKey: Key.Params.ADLTracking.bladderId, valueId: self.adlTracking?.bladderId ?? nil, inputType: InputType.Dropdown, dropdownArr: self.dropDownforFieldType(type: ADLType.Continence_Bladder),isValid: strBladder.count != 0, errorMessage: ConstantStrings.mandatory),
                 InputTextfieldModel(value: strBowel, placeholder: ADLTrackingTitles.Bowel, apiKey: Key.Params.ADLTracking.bowelId, valueId: self.adlTracking?.bowelId ?? nil, inputType: InputType.Dropdown, dropdownArr: self.dropDownforFieldType(type: ADLType.Continence_Bowel),isValid: strBowel.count != 0, errorMessage: ConstantStrings.mandatory)]]
    }
    
    func getNotesInput() -> InputTextfieldModel{
        let strNotes = self.adlTracking?.notes ?? ""
        return InputTextfieldModel(value: strNotes, placeholder: ADLTrackingTitles.Notes, apiKey: Key.Params.ADLTracking.notes, valueId: strNotes.count == 0 ? nil : strNotes, inputType: InputType.Text, dropdownArr: nil,isValid: true, errorMessage: ConstantStrings.mandatory)
    }
}

//MARK:- getADLTrackingDetail
extension ADLTrackingViewModel{
    func getADLTrackingDetail(ADLItem : Int,patientId : Int,completion:@escaping (Any?) -> Void){
        
        self.isLoading = true
        service.getADLTracking(with: patientId) { (result) in
            self.isLoading = false
            if let res = result as? ADLTrackingTool{
                self.adlTracking = res
                /*
                 self.arrData.append(self.getMobility(data: res))
                 self.arrData.append(self.getTransfer(data: res))
                 self.arrData.append(self.getDressing(data: res))
                 self.arrData.append(self.getEating(data: res))
                 self.arrData.append(self.getToileting(data: res))
                 self.arrData.append(self.getPersonalHygiene(data: res))
                 self.arrData.append(self.getBathing(data: res))
                 self.arrData.append(self.getContinenece(data: res))
                 self.arrData.append(self.getNotes(data: res))
                 */
                self.isListLoaded = true
                completion(res)
            }
            completion(nil)
        }
      
    }
    /*
    func getMobility(data : ADLTrackingTool) -> ListingSectionModel{
        return ListingSectionModel(headerTitle: "Mobility",
                                   content: [ListModel(title: "Moves in Bed", value: ""),
                                             ListModel(title: "Self performance", value: data.movesInBedSelfValue ?? ConstantStrings.NA),
                                             ListModel(title: "Support provided", value: data.movesInBedSupportValue ?? ConstantStrings.NA),
                                             
                                             ListModel(title: "Walks in Room", value: ""),
                                             ListModel(title: "Self performance", value: data.walksInRoomSelfValue ?? ConstantStrings.NA),
                                             ListModel(title: "Support provided", value: data.walksInRoomSupportValue ?? ConstantStrings.NA),
                                             
                                             ListModel(title: "Walks in Corridor", value: ""),
                                             ListModel(title: "Self performance", value: data.walksInHallSelfValue ?? ConstantStrings.NA),
                                             ListModel(title: "Support provided", value: data.walksInHallSupportValue ?? ConstantStrings.NA),
                                             
                                             ListModel(title: "Moves on Unit", value: ""),
                                             ListModel(title: "Self performance", value: data.movesOnUnitSelfValue ?? ConstantStrings.NA),
                                             ListModel(title: "Support provided", value: data.movesOnUnitSupportValue ?? ConstantStrings.NA),
                                             
                                             ListModel(title: "Moves Off Unit", value: ""),
                                             ListModel(title: "Self performance", value: data.movesOffUnitSelfValue ?? ConstantStrings.NA),
                                             ListModel(title: "Support provided", value: data.movesOffUnitSupportValue ?? ConstantStrings.NA),
        ])
    }
    
    
    func getTransfer(data : ADLTrackingTool) -> ListingSectionModel{
        return ListingSectionModel(headerTitle: "Transfer",
                                   content: [ListModel(title: "Transfer", value: ""),
                                             ListModel(title: "Self performance", value: data.transferSelfValue ?? ConstantStrings.NA),
                                             ListModel(title: "Support provided", value: data.transferSupportValue ?? ConstantStrings.NA),
        ])
    }
    
    func getDressing(data : ADLTrackingTool) -> ListingSectionModel{
        return ListingSectionModel(headerTitle: "Dressing",
                                   content: [ListModel(title: "Dressing", value: ""),
                                             ListModel(title: "Self performance", value: data.dresesSelfValue ?? ConstantStrings.NA),
                                             ListModel(title: "Support provided", value: data.dresesSupportValue ?? ConstantStrings.NA),
                                             
                                             ListModel(title: "Undresses", value: ""),
                                             ListModel(title: "Self performance", value: data.unDresesSelfValue ?? ConstantStrings.NA),
                                             ListModel(title: "Support provided", value: data.unDresesSupportValue ?? ConstantStrings.NA),
                                             
        ])
    }
    
    func getEating(data : ADLTrackingTool) -> ListingSectionModel{
        return ListingSectionModel(headerTitle: "Eating & Drinking",
                                   content: [ListModel(title: "Eats & Drinks", value: ""),
                                             ListModel(title: "Self performance", value: data.eatAndDrinkValue ?? ConstantStrings.NA),
                                             ListModel(title: "Support provided", value: data.eatAndDrinkSuportValue ?? ConstantStrings.NA),
                                             
        ])
    }
    
    func getToileting(data : ADLTrackingTool) -> ListingSectionModel{
        return ListingSectionModel(headerTitle: "Toileting",
                                   content: [ListModel(title: "Uses Toilet / Commode / Incontinent \nProduct", value: ""),
                                             ListModel(title: "Self performance", value: data.usesToiletSelfValue ?? ConstantStrings.NA),
                                             ListModel(title: "Support provided", value: data.usesToiletSupportValue ?? ConstantStrings.NA),
                                             
        ])
    }
    
    func getPersonalHygiene(data : ADLTrackingTool) -> ListingSectionModel{
        return ListingSectionModel(headerTitle: "Personal Hygiene",
                                   content: [ListModel(title: "Personal Hygiene", value: ""),
                                             ListModel(title: "Self performance", value: data.personalHygieneSelfValue ?? ConstantStrings.NA),
                                             ListModel(title: "Support provided", value: data.personalHygieneSupportValue ?? ConstantStrings.NA),
                                             
        ])
    }
    
    func getBathing(data : ADLTrackingTool) -> ListingSectionModel{
        return ListingSectionModel(headerTitle: "Bathing",
                                   content: [ListModel(title: "Bathing", value: ""),
                                             ListModel(title: "Self performance", value: data.bathingSelfValue ?? ConstantStrings.NA),
                                             ListModel(title: "Support provided", value: data.bathingSupportValue ?? ConstantStrings.NA),
                                             
        ])
    }
    
    func getContinenece(data : ADLTrackingTool) -> ListingSectionModel{
        return ListingSectionModel(headerTitle: "Continenece",
                                   content: [ListModel(title: "Bladder", value: data.bladderValue ?? ConstantStrings.NA),
                                             ListModel(title: "Bowel", value:data.bowelValue ?? ConstantStrings.NA)
        ])
    }
    
    func getNotes(data : ADLTrackingTool) -> ListingSectionModel{
        return ListingSectionModel(headerTitle: "Notes",
                                   content: [ListModel(title: "Notes", value: ConstantStrings.NA)])
    }*/
}
