//
//  NCFNutritionViewController.swift
//  AccessEMR
//
//  Created by Vasundhara Parakh on 3/19/20.
//  Copyright © 2020 smartData Enterprises (I) Ltd. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
protocol NutritionFormDelegate {
    func didFinishNutritionForm(isDraft : Bool, selectedSection: Int)
}

class NCFNutritionViewController: BaseViewController {
    var delegate: NutritionFormDelegate?
    
    @IBOutlet weak var tblView: UITableView!
    var arrInput = [Any]()
    var activeTextfieldTag = 0
    var isReadyToSave = false
    var isValidating = false
    var patientId = 0
    var activeTextfield : InputTextField?
    var selectedSection = 0
    let apiName = APITargetPoint.save_NCF_Nutrition
    
    
    var foodIntake = false
    var fluidIntake = false
    var bowel = false
    var urinaryVoid = false
    var emesis = false
    var bloodLoss = false
    
    
    lazy var viewModel: NCFNutritionViewModel = {
        let obj = NCFNutritionViewModel(with: PointOfCareService())
        self.baseViewModel = obj
        return obj
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerNIBs()
        self.initialSetup()
        self.checkActiveInactive()
        
    }
    func checkActiveInactive(){
        if UserDefaults.getPatientStatus() == "Active"{
            self.tblView.isUserInteractionEnabled = true
        }else{
            viewModel.errorMessage = "\(UserDefaults.getOrganisationTypeName()) Status should be Active to fill this form."
            self.tblView.isUserInteractionEnabled = false
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        IQKeyboardManager.shared.previousNextDisplayMode = .alwaysHide
        
    }
    func initialSetup(){
        //Setup navigation bar
        self.navigationItem.title =  NursingHeadingTitles.Nutrition
        self.addBackButton()
        //self.addrightBarButtonItem()
        self.setupClosures()
        self.viewModel.getNCFNutritionDetail(patientId: self.patientId) { (result) in
            self.viewModel.getNursingCareMasterData()
        }
    }
    
    
    override func onLeftBarButtonClicked(_ sender: UIBarButtonItem) {
        self.view.endEditing(true)
       // self.backbuttonClick()
        UIAlertController.showAlert(title: Alert.Title.appName, message: Alert.Message.discard, preferredStyle: .alert, sender: nil , target: self, actions:.Discard,.Continue) { (AlertAction) in
            switch AlertAction {
            case .Continue:
                print("Continue")
            self.prepareDataForAPI()
            case .Discard:
                self.navigationController?.popViewController(animated: true)
            default:
                break
            }
        }
    }
    func prepareDataForAPI(){
        //======= for Validation
        self.isValidating = true
        self.tblView.reloadData()
        //======= Ends
        
        let inputParams = self.createAPIParams(isDraft: false, moodID: self.viewModel.nutritionDetail?.id ?? 0)
        
        var inputKeyCount = 0
        for value in inputParams.keys{
            if value == Key.Params.NursingCareFlow.Nutrition.incontinentUrinaryId{
                inputKeyCount = inputKeyCount + 1
            }
            if value == Key.Params.NursingCareFlow.Nutrition.incontinentBowelId{
                inputKeyCount = inputKeyCount + 1
            }
//            if value == Key.Params.NursingCareFlow.Nutrition.briefPullUp{
//                inputKeyCount = inputKeyCount + 1
//            }
//            if value == Key.Params.NursingCareFlow.Nutrition.perinealPadsCount{
//                inputKeyCount = inputKeyCount + 1
//            }
//            if value == Key.Params.NursingCareFlow.Nutrition.voidingPatternGUId{
//                inputKeyCount = inputKeyCount + 1
//            }
//            if value == Key.Params.NursingCareFlow.Nutrition.rectalCheckPerformed{
//                inputKeyCount = inputKeyCount + 1
//            }
        }
        
        if inputKeyCount < 2{
            self.viewModel.errorMessage = "Please fill missing inputs."
            return
        }
            
        //Change for removing Notes as mandatory
        var copyParams = inputParams
        if inputParams[Key.Params.ADLTracking.notes] == nil{
            copyParams[Key.Params.ADLTracking.notes] = " "
        }
        if inputParams[Key.Params.NursingCareFlow.Nutrition.bowelCareId] == nil{
            copyParams[Key.Params.NursingCareFlow.Nutrition.bowelCareId] = " "
        }
        
        if copyParams.keys.count >= 17{
            self.viewModel.isLoading = true
            AppInstance.shared.nutritionNCFParams = self.createAPIParams(isDraft: false, moodID: self.viewModel.nutritionDetail?.id ?? 0)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0) {
                self.delegate?.didFinishNutritionForm(isDraft: false, selectedSection: self.selectedSection)
                AppInstance.shared.shouldUpdateDraftStatus = true
                self.viewModel.isLoading = false
                self.navigationController?.popViewController(animated: true)
            }
        }else{
            self.viewModel.errorMessage = "Please fill missing inputs."
            
        }
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        IQKeyboardManager.shared.previousNextDisplayMode = .Default
    }
    
    
    func registerNIBs(){
        self.tblView.register(UINib(nibName: ReuseIdentifier.DoubleInputCell, bundle: nil), forCellReuseIdentifier: ReuseIdentifier.DoubleInputCell)
        self.tblView.register(UINib(nibName: ReuseIdentifier.NumberInputCell, bundle: nil), forCellReuseIdentifier: ReuseIdentifier.NumberInputCell)
        self.tblView.register(UINib(nibName: ReuseIdentifier.TextInputCell, bundle: nil), forCellReuseIdentifier: ReuseIdentifier.TextInputCell)
        self.tblView.register(UINib(nibName: ReuseIdentifier.DateTimeInputCell, bundle: nil), forCellReuseIdentifier: ReuseIdentifier.DateTimeInputCell)
        self.tblView.register(UINib(nibName: ReuseIdentifier.PickerInputCell, bundle: nil), forCellReuseIdentifier: ReuseIdentifier.PickerInputCell)
        self.tblView.register(UINib(nibName: ReuseIdentifier.RecursiveBPCell, bundle: nil), forCellReuseIdentifier: ReuseIdentifier.RecursiveBPCell)
        self.tblView.register(UINib(nibName: ReuseIdentifier.TitleCell, bundle: nil), forCellReuseIdentifier: ReuseIdentifier.TitleCell)
    }
    func setupClosures() {
        self.viewModel.updateViewClosure = { [weak self] () in
            DispatchQueue.main.async {
                self?.arrInput = self?.viewModel.getInputArray() ?? [""]
                
                self?.foodIntake = self?.viewModel.nutritionDetail?.foodIntake ?? false
                self?.fluidIntake = self?.viewModel.nutritionDetail?.fluidIntake ?? false
                self?.bowel = self?.viewModel.nutritionDetail?.bowel ?? false
                self?.urinaryVoid = self?.viewModel.nutritionDetail?.urinaryVoid ?? false
                self?.emesis = self?.viewModel.nutritionDetail?.emesis ?? false
                self?.bloodLoss = self?.viewModel.nutritionDetail?.bloodLoss ?? false
                //Set Fluid Recurring Fields
                if let fluidArray = self?.viewModel.nutritionDetail?.dynamicFluidIntake{
                    
                    if !fluidArray.isEmpty{
                        let section = 0
                        var mainArrayCopy = self?.arrInput[section] as! [Any]
                        var rowIndex = 0
                        self?.getArrayIndexFromTitle(title: NursingTitles.Nutrition.FluidIntake.TotalAmount, section: section, completion: { (row) in
                            rowIndex = row
                        })
                        
                        for (index,fluid) in fluidArray.enumerated() {
                            if let fluidObject = self?.viewModel.getFluidIntakeArray(fluidObject: fluid){
                                //                                if index == 0 {
                                //                                    mainArrayCopy[rowIndex + index + 1] = fluidObject
                                //                                }else{
                                mainArrayCopy.insert(fluidObject, at: rowIndex + index)
                                //}
                            }
                        }
                        self?.arrInput[section] = mainArrayCopy
                    }
                }else{
                    let section = 0
                    var rowIndex = 0
                    var mainArrayCopy = self?.arrInput[section] as! [Any]
                    self?.getArrayIndexFromTitle(title: NursingTitles.Nutrition.FluidIntake.TotalAmount, section: section, completion: { (row) in
                        rowIndex = row
                    })
                    mainArrayCopy.remove(at: rowIndex)
                    self?.arrInput[section] = mainArrayCopy
                }
                
                //set Bowel Recurring Fields
                if let bowelArray = self?.viewModel.nutritionDetail?.dynamicBowel{
                    if !bowelArray.isEmpty{
                        let section = 1
                        var mainArrayCopy = self?.arrInput[section] as! [Any]
                        var rowIndex = 0
                        self?.getArrayIndexFromTitle(title: NursingTitles.Nutrition.Bowel.TotalBowelMovement, section: section, completion: { (row) in
                            rowIndex = row
                        })
                        
                        for (index,bowel) in bowelArray.enumerated() {
                            if let bowelObject = self?.viewModel.getBowelArray(bowelObject: bowel){
                                //                                if index == 0 {
                                //                                    mainArrayCopy[rowIndex + index + 1] = bowelObject
                                //                                }else{
                                mainArrayCopy.insert(bowelObject, at: rowIndex + index)
                                
                                //}
                            }
                        }
                        self?.arrInput[section] = mainArrayCopy
                    }
                }else{
                    let section = 1
                    var rowIndex = 0
                    var mainArrayCopy = self?.arrInput[section] as! [Any]
                    self?.getArrayIndexFromTitle(title: NursingTitles.Nutrition.Bowel.TotalBowelMovement, section: section, completion: { (row) in
                        rowIndex = row
                    })
                    mainArrayCopy.remove(at: rowIndex)
                    self?.arrInput[section] = mainArrayCopy
                }
                
                //set Urinary Voids Recurring Fields
                if let urinaryArray = self?.viewModel.nutritionDetail?.dynamicUrinary{
                    if !urinaryArray.isEmpty{
                        let section = 1
                        var mainArrayCopy = self?.arrInput[section] as! [Any]
                        var rowIndex = 0
                        self?.getArrayIndexFromTitle(title: NursingTitles.Nutrition.UrinaryVoids.TotalUrinaryVoids, section: section, completion: { (row) in
                            rowIndex = row
                        })
                        
                        for (index,urinary) in urinaryArray.enumerated() {
                            if let urinaryObject = self?.viewModel.getUrinaryVoidsArray(urinaryObject: urinary){
                                //                                if index == 0 {
                                //                                    mainArrayCopy[rowIndex + index + 1] = urinaryObject
                                //                                }else{
                                mainArrayCopy.insert(urinaryObject, at: rowIndex + index)
                                //}
                            }
                        }
                        self?.arrInput[section] = mainArrayCopy
                    }
                }else{
                    let section = 1
                    var rowIndex = 0
                    var mainArrayCopy = self?.arrInput[section] as! [Any]
                    self?.getArrayIndexFromTitle(title: NursingTitles.Nutrition.UrinaryVoids.TotalUrinaryVoids, section: section, completion: { (row) in
                        rowIndex = row
                    })
                    mainArrayCopy.remove(at: rowIndex)
                    self?.arrInput[section] = mainArrayCopy
                }
                
                //set Emesis Recurring Fields
                if let array = self?.viewModel.nutritionDetail?.dynamicEmesis{
                    
                    if let emesischeck = self?.viewModel.nutritionDetail?.emesis{
                        if emesischeck == true{
                            if !array.isEmpty{
                                let section = 1
                                var mainArrayCopy = self?.arrInput[section] as! [Any]
                                var rowIndex = 0
                                self?.getArrayIndexFromTitle(title: NursingTitles.Nutrition.Emesis.EmesisTotal, section: section, completion: { (row) in
                                    rowIndex = row
                                })
                                
                                for (index,emesis) in array.enumerated() {
                                    if let emesisObj = self?.viewModel.getEmesisArray(emesisObject: emesis){
                                        //                                                           if index == 0 {
                                        //                                                               mainArrayCopy[rowIndex + index + 1] = emesisObj
                                        //                                                           }else{
                                        mainArrayCopy.insert(emesisObj, at: rowIndex + index)
                                        //}
                                    }
                                }
                                self?.arrInput[section] = mainArrayCopy
                            }
                        }else{
                            
                        }
                    }
                    
                    
                }else{
                    let section = 1
                    var rowIndex = 0
                    var mainArrayCopy = self?.arrInput[section] as! [Any]
                    self?.getArrayIndexFromTitle(title: NursingTitles.Nutrition.Emesis.EmesisTotal, section: section, completion: { (row) in
                        rowIndex = row
                    })
                    mainArrayCopy.remove(at: rowIndex)
                    self?.arrInput[section] = mainArrayCopy
                }
                
                //set Blood loss Recurring Fields
                if let array = self?.viewModel.nutritionDetail?.dynamicBloodLoss{
                    if !array.isEmpty{
                        let section = 1
                        var mainArrayCopy = self?.arrInput[section] as! [Any]
                        var rowIndex = 0
                        self?.getArrayIndexFromTitle(title: NursingTitles.Nutrition.BloodLoss.BloodLossTotal, section: section, completion: { (row) in
                            rowIndex = row
                        })
                        var total = 0
                        for (index,bloodloass) in array.enumerated() {
                            total = total + (Int(bloodloass.bloodLossAmount ?? "0") ?? 0)
                            if let bloodLossObj = self?.viewModel.getBloodLossArray(bloodLossObject: bloodloass){
                                
                                //                                if index == 0 {
                                //                                    mainArrayCopy[rowIndex + index + 1] = bloodLossObj
                                //                                }else{
                                mainArrayCopy.insert(bloodLossObj, at: rowIndex + index)
                                // }
                            }
                        }
                        self?.arrInput[section] = mainArrayCopy
                    }
                }else{
                    let section = 1
                    var rowIndex = 0
                    var mainArrayCopy = self?.arrInput[section] as! [Any]
                    self?.getArrayIndexFromTitle(title: NursingTitles.Nutrition.BloodLoss.BloodLossTotal, section: section, completion: { (row) in
                        rowIndex = row
                    })
                    mainArrayCopy.remove(at: rowIndex)
                    self?.arrInput[section] = mainArrayCopy
                }
                
                
                self?.tblView.reloadData()
            }
        }
        
    }
    func getArrayIndexFromTitle(title : String , section : Int,completion:@escaping (Int) -> Void){
        var row = 0
        if let arr =  self.arrInput as? [Any]{
            if let copy = arr [section] as? [Any]{
                for (index,item) in copy.enumerated() {
                    if let dict = item as? InputTextfieldModel{
                        if (dict.placeholder ?? "") == title {
                            row = index
                        }
                    }
                }
            }
        }
        completion(row)
    }
    func addrightBarButtonItem() {
        let rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target:  self, action: #selector(onRightBarButtonItemClicked(_ :)))
        rightBarButtonItem.tintColor = UIColor.white
        navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    // MARK:
    @objc func onRightBarButtonItemClicked(_ sender: UIBarButtonItem) {
        self.view.endEditing(true)
        
        //======= for Validation
        self.isValidating = true
        self.tblView.reloadData()
        //======= Ends
        
        let inputParams = self.createAPIParams(isDraft: false, moodID: self.viewModel.nutritionDetail?.id ?? 0)
        //Change for removing Notes as mandatory
        var copyParams = inputParams
        if inputParams[Key.Params.ADLTracking.notes] == nil{
            copyParams[Key.Params.ADLTracking.notes] = " "
        }
        if inputParams[Key.Params.NursingCareFlow.Nutrition.bowelCareId] == nil{
            copyParams[Key.Params.NursingCareFlow.Nutrition.bowelCareId] = " "
        }
        
        /*
         let countFluidIntake = (self.getSubDicts(keyName: Key.Params.NursingCareFlow.Nutrition.dynamicFluidIntake, type: NursingTitles.Nutrition.FluidIntake.FluidIntake).1) * 3
         let countBowel = (self.getSubDicts(keyName: Key.Params.NursingCareFlow.Nutrition.dynamicBowel, type: NursingTitles.Nutrition.Bowel.Bowel).1) * 3
         let countUrinaryVoids = (self.getSubDicts(keyName: Key.Params.NursingCareFlow.Nutrition.dynamicUrinary, type: NursingTitles.Nutrition.UrinaryVoids.UrinaryVoids).1) * 3
         let countEmesis = (self.getSubDicts(keyName: Key.Params.NursingCareFlow.Nutrition.dynamicEmesis, type: NursingTitles.Nutrition.Emesis.Emesis).1) * 2
         let countBloodLoss = (self.getSubDicts(keyName: Key.Params.NursingCareFlow.Nutrition.dynamicBloodLoss, type: NursingTitles.Nutrition.BloodLoss.BloodLoss).1) * 2
         
         paramsCountLimit += (countFluidIntake + countBowel + countUrinaryVoids + countEmesis + countBloodLoss)*/
        
        if copyParams.keys.count == 27{
            self.viewModel.saveNursingCare(apiName: apiName, params: self.createAPIParams(isDraft: false, moodID: self.viewModel.nutritionDetail?.id ?? 0))
            AppInstance.shared.shouldUpdateDraftStatus = true
            
        }else{
            self.viewModel.errorMessage = "Please fill missing inputs."
            
        }
    }
    @IBAction func saveAsDraftBtn_clicked(_ sender: Any) {
        self.delegate?.didFinishNutritionForm(isDraft: true, selectedSection: self.selectedSection)
        
        self.viewModel.saveNursingCare(apiName: apiName, params: self.createAPIParams(isDraft: true, moodID: self.viewModel.nutritionDetail?.id ?? 0))
        AppInstance.shared.shouldUpdateDraftStatus = true
        
    }
    func backbuttonClick(){
        let pCount = self.createAPIParams(isDraft: false, moodID: self.viewModel.nutritionDetail?.id ?? 0)
        if pCount.count == 15 {
            self.navigationController?.popViewController(animated: true)
            return
        }
        self.delegate?.didFinishNutritionForm(isDraft: false, selectedSection: self.selectedSection)
        self.viewModel.saveNursingCare(apiName: apiName, params: self.createAPIParams(isDraft: false, moodID: self.viewModel.nutritionDetail?.id ?? 0))
        viewModel.redirectControllerClosure = { [weak self] () in
                   DispatchQueue.main.async {
                    self?.navigationController?.popViewController(animated: true)
                   }
               }
        AppInstance.shared.shouldUpdateDraftStatus = false
    }
    
    @IBAction func resetBtn_clicked(_ sender: Any) {
        
        UIAlertController.showAlert(title: Alert.Title.appName, message: Alert.Message.reset, preferredStyle: .alert, sender: nil , target: self, actions:.Yes,.No) { (AlertAction) in
            switch AlertAction {
            case .Yes:
                
                self.resetAPICall()
                //======= for turning off Validation
                self.isValidating = false
                //======= Ends
                self.foodIntake = false
                self.fluidIntake = false
                self.bowel = false
                self.emesis = false
                self.bloodLoss = false
                self.urinaryVoid = false
                
                self.viewModel.nutritionDetail = nil
                self.arrInput = self.viewModel.resetCallData()
                self.tblView.reloadData()
                self.tblView.scrollRectToVisible(CGRect.zero, animated: true)
            default:
                break
            }
        }
        
    }
    func resetAPICall(){
        if self.viewModel.nutritionDetail?.id == 0 ||  self.viewModel.nutritionDetail?.id ==  nil {}else{
            let idH =   "\(self.viewModel.nutritionDetail?.id ?? 0)"
            self.viewModel.deleteNursingCare(apiName: APITargetPoint.NutritionAndHydration_Discard, params: ["Id" : idH])
        }
    }
    
    
    func createAPIParams(isDraft : Bool, moodID: Int) -> [String : Any]{
        var keyMainArray = [( String , Any?)]()
        for (_,arrObj) in self.arrInput.enumerated() {
            if let dict = arrObj as? InputTextfieldModel{
                keyMainArray.append(((dict.apiKey ?? "") , (dict.valueId ?? "")))
            }
            if let dictArr = arrObj as? [Any]{
                for (_,dictObj) in dictArr.enumerated() {
                    if let dict = dictObj as? [InputTextfieldModel],dict.count != 3{
                        let firstObj = dict[0]
                        let secondObj = dict[1]
                        keyMainArray.append(((firstObj.apiKey ?? "") , (firstObj.valueId ?? "")))
                        keyMainArray.append( ((secondObj.apiKey ?? "") , (secondObj.valueId ?? "")))
                    }else if let dict = dictObj as? InputTextfieldModel{
                        keyMainArray.append(((dict.apiKey ?? "") , (dict.valueId ?? "")))
                    }
                    
                }
            }
            
        }
        var paramDict : [String : Any] = [:]
        keyMainArray += keyMainArray
        
        for (_,(key,value)) in keyMainArray.enumerated() {
            if let val  = value as? String{
                if val != ""{
                    paramDict[key] = value
                }
            }else if let val  = value as? Int{
                //if val != 0{
                paramDict[key] = value
                //}
            }else{
                paramDict[key] = value
            }
        }
        paramDict[Key.Params.patientId] = self.patientId
        paramDict[Key.Params.id] = moodID
        paramDict[Key.Params.isDraft] = isDraft
        paramDict.merge(dict: self.getSubDicts(keyName: Key.Params.NursingCareFlow.Nutrition.dynamicFluidIntake, type: NursingTitles.Nutrition.FluidIntake.FluidIntake).0)
        paramDict.merge(dict: self.getSubDicts(keyName: Key.Params.NursingCareFlow.Nutrition.dynamicBloodLoss, type: NursingTitles.Nutrition.BloodLoss.BloodLoss).0)
        paramDict.merge(dict: self.getSubDicts(keyName: Key.Params.NursingCareFlow.Nutrition.dynamicBowel, type: NursingTitles.Nutrition.Bowel.Bowel).0)
        paramDict.merge(dict: self.getSubDicts(keyName: Key.Params.NursingCareFlow.Nutrition.dynamicEmesis, type: NursingTitles.Nutrition.Emesis.Emesis).0)
        paramDict.merge(dict: self.getSubDicts(keyName: Key.Params.NursingCareFlow.Nutrition.dynamicUrinary, type: NursingTitles.Nutrition.UrinaryVoids.UrinaryVoids).0)
        let rectalCheck = ((paramDict[Key.Params.NursingCareFlow.Nutrition.rectalCheckPerformed] as? String) ?? "")
        if rectalCheck.count > 0
        {
            paramDict[Key.Params.NursingCareFlow.Nutrition.rectalCheckPerformed] = rectalCheck == "Yes" ? true : false
        }
        paramDict["foodIntake"] = foodIntake
        paramDict["fluidIntake"] = fluidIntake
        paramDict["bowel"] = bowel
        paramDict["urinaryVoid"] = urinaryVoid
        paramDict["emesis"] = emesis
        paramDict["bloodLoss"] = bloodLoss
        print("paramDict = \(paramDict)")
        return paramDict
    }
    
    func getSubDicts(keyName : String,type: String) -> ([String:Any],Int){
        //var keyName = Key.Params.NursingCareFlow.Nutrition.fluidIntake
        let arr = self.getArrayOfType(type: type)
        var subArray = [[String : Any]]()
        
        for (_,dictArr) in arr.enumerated() {
            var tempDict = [String : Any]()
            for (index,dict) in dictArr.enumerated() {
                if (dict.apiKey ?? "") != ""{
                    tempDict[dict.apiKey ?? ""] = dict.valueId ?? ""
                }
                if index == 2{
                    subArray.append(tempDict)
                }
            }
        }
        return ([keyName : subArray],subArray.count)
    }
    
    func getArrayOfType(type:String) -> [[InputTextfieldModel]]{
        var similarTypeArray = [[InputTextfieldModel]]()
        for (_,arrMain) in self.arrInput.enumerated() {
            if let arrTemp = arrMain as? [Any]{
                for (_,dictArray) in arrTemp.enumerated() {
                    if let dict = dictArray as? [InputTextfieldModel]{
                        if dict[0].sectionHeader == type{
                            similarTypeArray.append(dict)
                        }
                    }
                }
            }
        }
        return similarTypeArray
    }
    
    func getTotalValueOfType(type:String) -> Int{
        var total = 0
        let arr = self.getArrayOfType(type: type)
        for (_,dictArr) in arr.enumerated() {
            var tempDict = [String : Any]()
            for (_,dict) in dictArr.enumerated() {
                if (dict.apiKey ?? "") != ""{
                    tempDict[dict.apiKey ?? ""] = dict.valueId ?? ""
                    if let value = dict.valueId as? String, let intVal = Int(value){
                        if dict.inputType == InputType.Number {
                            total += intVal
                        }
                    }
                }
            }
        }
        if type == NursingTitles.Nutrition.Bowel.Bowel{
            return arr.count
        }
        return total
    }
    
    func getTotalTextfieldForType(type: String) -> (textfield:InputTextField?,section:Int,row:Int){
        var captionOfTotal = ""
        switch type {
        case NursingTitles.Nutrition.FluidIntake.FluidIntake:
            captionOfTotal = NursingTitles.Nutrition.FluidIntake.TotalAmount
        case NursingTitles.Nutrition.Bowel.Bowel:
            captionOfTotal = NursingTitles.Nutrition.Bowel.TotalBowelMovement
        case NursingTitles.Nutrition.UrinaryVoids.UrinaryVoids:
            captionOfTotal = NursingTitles.Nutrition.UrinaryVoids.TotalUrinaryVoids
        case NursingTitles.Nutrition.Emesis.Emesis:
            captionOfTotal = NursingTitles.Nutrition.Emesis.EmesisTotal
        case NursingTitles.Nutrition.BloodLoss.BloodLoss:
            captionOfTotal = NursingTitles.Nutrition.BloodLoss.BloodLossTotal
        case NursingTitles.Nutrition.TotalFluidOutput:
            captionOfTotal = NursingTitles.Nutrition.TotalFluidOutput
            
        default:
            captionOfTotal = ""
        }
        var indexOfTextfield = 0
        var sectionOFTextfield = 0
        for (section,itemArr) in self.arrInput.enumerated() {
            if let dictArr = itemArr as? [Any]{
                for (row,dict) in dictArr.enumerated() {
                    if let dictItem = dict as? InputTextfieldModel{
                        if dictItem.placeholder ?? "" == captionOfTotal{
                            indexOfTextfield = row
                            sectionOFTextfield = section
                            break
                        }
                    }
                }
            }
        }
        var section = 1
        if captionOfTotal == NursingTitles.Nutrition.FluidIntake.TotalAmount{
            section = 0
        }
        if let cell = self.tblView.cellForRow(at: IndexPath(row: indexOfTextfield, section: section)) as? NumberInputCell
        {
            return (cell.inputTf,section,indexOfTextfield)
        }
        
        return (nil,0,0)
    }
}


//MARK:- UITableViewDelegate,UITableViewDataSource

extension NCFNutritionViewController : UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.arrInput.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let arr = self.arrInput[indexPath.section] as? [Any]{
            if let dictArr = arr[indexPath.row] as? [InputTextfieldModel] , dictArr.count == 3{
                let tfOneDict = dictArr[0]
                
                let title = tfOneDict.sectionHeader ?? ""
                if title == NursingTitles.Nutrition.Emesis.Emesis || title == NursingTitles.Nutrition.BloodLoss.BloodLoss {
                    return Device.IS_IPAD ? 200 : 160
                }else{
                    return Device.IS_IPAD ? 260 : 190
                }
            }else if indexPath.section == 0 && indexPath.row == 0{
                return 70
            }
        }
        return Device.IS_IPAD ? 80 : 60//UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let arr = (self.arrInput[section] as? [Any]){
            print("section = \(section)")
            return arr.count
        }else{
            if let singleInput = self.arrInput[section] as? InputTextfieldModel{
                return 1
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0{
            return 0
        }
        return 40
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 40))
        headerView.backgroundColor = UIColor.white
        
        let lblSection = UILabel(frame: CGRect(x: 15, y: 0, width: tableView.frame.size.width - 20, height: 40))
        lblSection.textColor = Color.Blue
        lblSection.text =  self.viewModel.titleForHeader(section: section)
        lblSection.font = UIFont.PoppinsMedium(fontSize: 18)
        headerView.addSubview(lblSection)
        
        
        //headerView.borderWidth = 1.0
        //headerView.borderColor = Color.Line
        
        return headerView
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let arr = (self.arrInput[indexPath.section] as? [Any]){
            let inputDict = arr[indexPath.row]
            if let dict = inputDict as? InputTextfieldModel {
                let inputType = dict.inputType
                switch inputType {
                case InputType.Title:
                    let cell = tableView.dequeueReusableCell(withIdentifier: ReuseIdentifier.TitleCell, for: indexPath as IndexPath) as! TitleCell
                    cell.lblTitle.text = dict.placeholder ?? ""
                    cell.lblTitle.font = Device.IS_IPAD ? UIFont.PoppinsMedium(fontSize: 17) : UIFont.PoppinsMedium(fontSize: 15)
                    cell.lblTitle.textColor = Color.SectionTitleColor
                    cell.btnAdd.isHidden = true
                    cell.selectionStyle = .none
                    return cell
                case InputType.Text:
                    let cell = tableView.dequeueReusableCell(withIdentifier: ReuseIdentifier.TextInputCell, for: indexPath as IndexPath) as! TextInputCell
                    cell.inputTf.tag = indexPath.row
                    let placeholder =  dict.placeholder ?? ""
                    cell.inputTf.placeholder = placeholder
                    self.updateTextfieldAppearance(inputTf: cell.inputTf, dict: dict)
                    cell.inputTf.text = dict.value ?? ""
                    cell.inputTf.delegate = self
                    cell.selectionStyle = .none
                    return cell
                case InputType.Number:
                    let cell = tableView.dequeueReusableCell(withIdentifier: ReuseIdentifier.NumberInputCell, for: indexPath as IndexPath) as! NumberInputCell
                    cell.inputTf.tag = indexPath.row
                    let placeholder =  dict.placeholder ?? ""
                    cell.inputTf.placeholder = placeholder
                    if placeholder == NursingTitles.Nutrition.FluidIntake.TotalAmount || placeholder == NursingTitles.Nutrition.Bowel.TotalBowelMovement || placeholder == NursingTitles.Nutrition.UrinaryVoids.TotalUrinaryVoids || placeholder == NursingTitles.Nutrition.Emesis.EmesisTotal || placeholder == NursingTitles.Nutrition.BloodLoss.BloodLossTotal || placeholder == NursingTitles.Nutrition.TotalFluidOutput{
                        cell.inputTf.isUserInteractionEnabled = false
                    }else{
                        cell.inputTf.isUserInteractionEnabled = true
                    }
                    
                    self.updateTextfieldAppearance(inputTf: cell.inputTf, dict: dict)
                    cell.inputTf.text = dict.value ?? ""
                    cell.inputTf.delegate = self
                    cell.selectionStyle = .none
                    return cell
                case InputType.Dropdown:
                    let cell = tableView.dequeueReusableCell(withIdentifier: ReuseIdentifier.PickerInputCell, for: indexPath as IndexPath) as! PickerInputCell
                    cell.inputTf.tag = indexPath.row
                    cell.inputTf.delegate = self
                    self.updateTextfieldAppearance(inputTf: cell.inputTf, dict: dict)
                    //cell.lblTitle.text =  dict.placeholder ?? ""
                    //cell.inputTf.title = ""
                    let placeholder =  dict.placeholder ?? ""
                    cell.inputTf.placeholder = placeholder
                    print("Input text === \(dict.value ?? "")")
                    cell.inputTf.text = dict.value ?? ""
                    cell.arrDropdown = dict.dropdownArr ?? [Any]()
                    cell.pickerView.reloadAllComponents()
                    cell.selectionStyle = .none
                    cell.delegate = self
                    return cell
                    
                case InputType.Time:
                    let cell = tableView.dequeueReusableCell(withIdentifier: ReuseIdentifier.DateTimeInputCell, for: indexPath as IndexPath) as! DateTimeInputCell
                    cell.inputTf.tag = indexPath.row
                    cell.isDateField = false
                    cell.inputTf.delegate = self
                    cell.delegate = self
                    cell.inputTf.placeholder = dict.placeholder ?? ""
                    cell.setupDatePicker()
                    if (dict.value ?? "").count != 0{
                        cell.inputTf.text = dict.value ?? ""
                    }
                    
                    cell.selectionStyle = .none
                    return cell
                default:
                    return UITableViewCell()
                }
            }else{
                if let dictArr = inputDict as? [InputTextfieldModel] , dictArr.count == 2{
                    let cell = tableView.dequeueReusableCell(withIdentifier: ReuseIdentifier.DoubleInputCell, for: indexPath as IndexPath) as! DoubleInputCell
                    let tfOneDict = dictArr[0]
                    let tfTwoDict = dictArr[1]
                    
                    self.updateTextfieldAppearance(inputTf: cell.inputTf1, dict: tfOneDict)
                    self.updateTextfieldAppearance(inputTf: cell.inputTf2, dict: tfTwoDict)
                    
                    cell.inputTf1.tag = indexPath.row + TagConstants.DoubleTF_FirstTextfield_Tag
                    cell.inputTf2.tag = indexPath.row + TagConstants.DoubleTF_SecondTextfield_Tag
                    cell.inputTf1.delegate = self
                    cell.inputTf2.delegate = self
                    //cell.lblTitle.text = tfOneDict.placeholder ?? ""
                    cell.inputTf1.placeholder = tfOneDict.placeholder ?? ""
                    cell.inputT1_type = tfOneDict.inputType ?? ""
                    if (tfOneDict.inputType ?? "") == InputType.Dropdown{
                        cell.arrDropdown1 = tfOneDict.dropdownArr ?? [Any]()
                        cell.pickerView.reloadAllComponents()
                    }
                    if (tfOneDict.value ?? "").count != 0{
                        cell.inputTf1.text = tfOneDict.value ?? ""
                    }else{
                        cell.inputTf1.text = ""
                    }
                    
                    cell.inputTf2.placeholder = tfTwoDict.placeholder ?? ""
                    cell.inputT2_type = tfTwoDict.inputType ?? ""
                    if (tfTwoDict.inputType ?? "") == InputType.Dropdown{
                        cell.arrDropdown2 = tfTwoDict.dropdownArr ?? [Any]()
                        cell.pickerView.reloadAllComponents()
                    }
                    if (tfTwoDict.value ?? "").count != 0{
                        cell.inputTf2.text = tfTwoDict.value ?? ""
                    }else{
                        cell.inputTf2.text = ""
                    }
                    
                    cell.awakeFromNib()
                    
                    
                    cell.inputTf1.tag = indexPath.row + TagConstants.DoubleTF_FirstTextfield_Tag
                    cell.inputTf2.tag = indexPath.row + TagConstants.DoubleTF_SecondTextfield_Tag
                    cell.delegate = self
                    cell.selectionStyle = .none
                    return cell
                }else{
                    let cell = tableView.dequeueReusableCell(withIdentifier: ReuseIdentifier.RecursiveBPCell, for: indexPath as IndexPath) as! RecursiveBPCell
                    var title = ""
                    if let dictArr = inputDict as? [InputTextfieldModel] {
                        
                        cell.inputTf1.tag = indexPath.row + TagConstants.RecursiveTF_FirstTextfield_Tag
                        cell.inputTf2.tag = indexPath.row + TagConstants.RecursiveTF_SecondTextfield_Tag
                        cell.inputTf3.tag = indexPath.row + TagConstants.RecursiveTF_ThirdTextfield_Tag
                        
                        
                        let tfOneDict = dictArr[0]
                        let tfTwoDict = dictArr[1]
                        let tfThreeDict = dictArr[2]
                        cell.inputTf1.delegate = self
                        cell.inputTf2.delegate = self
                        cell.inputTf3.delegate = self
                        
                        self.updateTextfieldAppearance(inputTf: cell.inputTf1, dict: tfOneDict)
                        self.updateTextfieldAppearance(inputTf: cell.inputTf2, dict: tfTwoDict)
                        self.updateTextfieldAppearance(inputTf: cell.inputTf3, dict: tfThreeDict)
                        
                        debugPrint("Dict 1 = \(tfOneDict.value)")
                        debugPrint("Dict 2 = \(tfTwoDict.value)")
                        debugPrint("Dict 3 = \(tfThreeDict.value)")
                        
                        cell.inputTf1.placeholder = tfOneDict.placeholder ?? ""
                        cell.inputT1_type = tfOneDict.inputType ?? ""
                        if (tfOneDict.inputType ?? "") == InputType.Dropdown{
                            cell.arrDropdown1 = tfOneDict.dropdownArr ?? [Any]()
                            cell.pickerView.reloadAllComponents()
                        }else if ((tfOneDict.inputType ?? "") == InputType.Time){
                            cell.isDateField1 = false
                        }else if ((tfOneDict.inputType ?? "") == InputType.Date){
                            cell.isDateField1 = true
                        }
                        if (tfOneDict.value ?? "").count != 0{
                            cell.inputTf1.text = tfOneDict.value ?? ""
                        }else{
                            cell.inputTf1.text = ""
                        }
                        
                        
                        
                        cell.inputTf2.placeholder = tfTwoDict.placeholder ?? ""
                        cell.inputT2_type = tfTwoDict.inputType ?? ""
                        if (tfTwoDict.inputType ?? "") == InputType.Dropdown{
                            cell.arrDropdown2 = tfTwoDict.dropdownArr ?? [Any]()
                            cell.pickerView.reloadAllComponents()
                        }else if ((tfTwoDict.inputType ?? "") == InputType.Time){
                            cell.isDateField2 = false
                        }else if ((tfTwoDict.inputType ?? "") == InputType.Date){
                            cell.isDateField2 = true
                        }
                        if (tfTwoDict.value ?? "").count != 0{
                            cell.inputTf2.text = tfTwoDict.value ?? ""
                        }else{
                            cell.inputTf2.text = ""
                        }
                        
                        cell.inputTf3.placeholder = tfThreeDict.placeholder ?? ""
                        cell.inputT3_type = tfThreeDict.inputType ?? ""
                        if (tfThreeDict.inputType ?? "") == InputType.Dropdown{
                            cell.arrDropdown3 = tfThreeDict.dropdownArr ?? [Any]()
                            cell.pickerView.reloadAllComponents()
                        }else if ((tfThreeDict.inputType ?? "") == InputType.Time){
                            cell.isDateField3 = false
                        }else if ((tfThreeDict.inputType ?? "") == InputType.Date){
                            cell.isDateField3 = true
                        }
                        if (tfThreeDict.value ?? "").count != 0{
                            cell.inputTf3.text = tfThreeDict.value ?? ""
                        }else{
                            cell.inputTf3.text = ""
                        }
                        
                        title = tfOneDict.sectionHeader ?? ""
                        cell.lblTitle.text = title
                    }
                    
                    cell.btnDelete.alpha = self.canDeleteRecursiveCell(inputArr: self.arrInput) ? 1.0 : 0.3
                    cell.btnAdd.alpha = self.canAddRecursiveCell(inputArr: self.arrInput) ? 1.0 : 0.3
                    
                    if title == NursingTitles.Nutrition.Emesis.Emesis || title == NursingTitles.Nutrition.BloodLoss.BloodLoss {
                        cell.inputTf3.isHidden = true
                        cell.heightInputTf3.constant = 0
                    }else{
                        cell.inputTf3.isHidden = false
                        cell.heightInputTf3.constant = Device.IS_IPAD ? 64 : 44
                    }
                    
                    cell.awakeFromNib()
                    cell.btnAdd.tag = indexPath.row
                    cell.btnDelete.tag = indexPath.row
                    cell.btnAdd.addTarget(self, action: #selector(addButton_clicked(button:)), for: .touchUpInside)
                    cell.btnDelete.addTarget(self, action: #selector(deleteButton_clicked(button:)), for: .touchUpInside)
                    cell.delegate = self
                    
                    cell.selectionStyle = .none
                    return cell
                }
            }
        }else{
            if let dict = self.arrInput[indexPath.section] as? InputTextfieldModel {
                let inputType = dict.inputType
                switch inputType {
                case InputType.Text:
                    let cell = tableView.dequeueReusableCell(withIdentifier: ReuseIdentifier.TextInputCell, for: indexPath as IndexPath) as! TextInputCell
                    cell.inputTf.tag = indexPath.row
                    cell.inputTf.placeholder = dict.placeholder ?? ""
                    self.updateTextfieldAppearance(inputTf: cell.inputTf, dict: dict)
                    
                    cell.inputTf.delegate = self
                    cell.selectionStyle = .none
                    return cell
                default:
                    return UITableViewCell()
                }
            }
        }
        return UITableViewCell()
    }
    @objc func  addButton_clicked(button : UIButton) {
        self.isValidating = false
        if let cell = button.superview?.superview as? RecursiveBPCell{
            if let indexPath = self.tblView.indexPath(for: cell){
                if let mainArray = self.arrInput[indexPath.section] as? [Any] {
                    var copyMainArray = mainArray
                    var type = ""
                    if let dictArr = mainArray[indexPath.row] as? [InputTextfieldModel] {
                        let tfOneDict = dictArr[0]
                        type = tfOneDict.sectionHeader ?? ""
                    }
                    
                    var addObject = self.viewModel.getFluidIntakeArray(fluidObject: nil)
                    
                    switch type {
                    case NursingTitles.Nutrition.FluidIntake.FluidIntake:
                        addObject = self.viewModel.getFluidIntakeArray(fluidObject: nil)
                    case NursingTitles.Nutrition.Bowel.Bowel:
                        addObject = self.viewModel.getBowelArray(bowelObject: nil)
                    case NursingTitles.Nutrition.UrinaryVoids.UrinaryVoids:
                        addObject = self.viewModel.getUrinaryVoidsArray(urinaryObject: nil)
                    case NursingTitles.Nutrition.BloodLoss.BloodLoss:
                        addObject = self.viewModel.getBloodLossArray(bloodLossObject: nil)
                    case NursingTitles.Nutrition.Emesis.Emesis:
                        addObject = self.viewModel.getEmesisArray(emesisObject: nil)
                    default:
                        print("Do nothing")
                    }
                    copyMainArray.insert(addObject, at: indexPath.row + 1)
                    self.arrInput[indexPath.section] = copyMainArray
                    self.tblView.reloadData()
                }
            }
        }
    }
    
    @objc func deleteButton_clicked(button : UIButton) {
        self.isValidating = false
        
        if let cell = button.superview?.superview as? RecursiveBPCell{
            if let indexPath = self.tblView.indexPath(for: cell){
                if let mainArray = self.arrInput[indexPath.section] as? [Any] {
                    var copyMainArray = mainArray
                    var type = ""
                    var count = 0
                    if let dictArr = mainArray[indexPath.row] as? [InputTextfieldModel] {
                        let tfOneDict = dictArr[0]
                        type = tfOneDict.sectionHeader ?? ""
                    }
                    count = self.getArrayOfType(type: type).count
                    if count > 1{
                        copyMainArray.remove(at: indexPath.row)
                        self.arrInput[indexPath.section] = copyMainArray
                        self.tblView.reloadData()
                    }else{
                        self.viewModel.errorMessage = "You need to enter atleast one value"
                    }
                }
            }
        }
        
        /*
         if self.canDeleteRecursiveCell(inputArr: self.arrInput){
         self.arrInput.remove(at: button.tag)
         self.tblView.reloadData()
         }*/
    }
    
    func canDeleteRecursiveCell(inputArr : [Any]) -> Bool{
        return true
        /*
         let arrWithRecursive = inputArr.compactMap { (item) -> Any? in
         if let dict = item as?  [InputTextfieldModel]{
         return dict.count == 3 ? dict : nil
         }
         return nil
         }
         return arrWithRecursive.count == 1 ? false : true*/
    }
    
    func canAddRecursiveCell(inputArr : [Any]) -> Bool{
        let arrWithRecursive = inputArr.compactMap { (item) -> Any? in
            if let dict = item as?  [InputTextfieldModel]{
                return dict.count == 3 ? dict : nil
            }
            return nil
        }
        return arrWithRecursive.count == 3 ? false : true
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func updateTextfieldAppearance(inputTf : InputTextField, dict : InputTextfieldModel){
        if self.isValidating{
            inputTf.lineColor = (dict.isValid ?? false) ? Color.Line : Color.Error
            inputTf.errorMessage = (dict.isValid ?? false) ? "" : (dict.errorMessage ?? "")
        }else{
            inputTf.lineColor =  Color.Line
            inputTf.errorMessage = ""
        }
    }
    
}
//MARK:- UITextFieldDelegate
extension NCFNutritionViewController : UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if self.isValidating {
            self.isValidating = false
            self.tblView.reloadData()
        }
        //Set defualt/selected value on textfield tap
        if let tfToUpdate = textField as? InputTextField{
            tfToUpdate.lineColor =  Color.Line
            tfToUpdate.errorMessage = ""
            
            DispatchQueue.main.async {
                if let activeTf = textField as? InputTextField{
                    self.activeTextfield = activeTf
                }
                AppInstance.shared.activeTextfieldIndex = textField.tag
                self.activeTextfieldTag = textField.tag
                
                if tfToUpdate.text?.count == 0{
                    
                    //let index = self.getIndexAndSubIndexFromTag(textFieldTag: self.activeTextfieldTag).0
                    //let dictIndex = self.getIndexAndSubIndexFromTag(textFieldTag: self.activeTextfieldTag).1
                    
                    if let cell = textField.superview?.superview as? PickerInputCell{
                        if let indexPath = self.tblView.indexPath(for: (cell)) {
                            if let arrInput = self.arrInput[indexPath.section] as? [Any]{
                                if let dictArr = arrInput[indexPath.row] as? [InputTextfieldModel]{
                                    
                                    var copyArr = dictArr
                                    let dict = copyArr[indexPath.row]
                                    if ((dict.inputType ?? "") == InputType.Dropdown){
                                        if let cell = self.tblView.cellForRow(at: indexPath) as? PickerInputCell{
                                            cell.pickerView.reloadAllComponents()
                                        }
                                        
                                        if let arr = dict.dropdownArr as? [Any]{
                                            let selectedValue = Utility.getSelectedValue(arrDropdown: arr,row: 0)
                                            
                                            dict.value = selectedValue.value
                                            dict.valueId = selectedValue.valueID
                                            dict.isValid = true
                                            copyArr[indexPath.row] = dict
                                            self.arrInput[indexPath.section] = copyArr
                                            textField.text = selectedValue.value
                                        }
                                    }
                                }else if let dict = arrInput[indexPath.row] as? InputTextfieldModel{
                                    var copyArr = arrInput
                                    
                                    if ((dict.inputType ?? "") == InputType.Dropdown){
                                        if let cell = self.tblView.cellForRow(at: indexPath) as? PickerInputCell{
                                            cell.pickerView.reloadAllComponents()
                                        }
                                        
                                        if let arr = dict.dropdownArr as? [Any]{
                                            let selectedValue = Utility.getSelectedValue(arrDropdown: arr,row: 0)
                                            
                                            dict.value = selectedValue.value
                                            dict.valueId = selectedValue.valueID
                                            dict.isValid = true
                                            copyArr[indexPath.row] = dict
                                            self.arrInput[indexPath.section] = copyArr
                                            textField.text = selectedValue.value
                                        }
                                    }
                                    
                                }
                            }else{
                                if let dictArr = (self.arrInput[indexPath.section] as? [Any]){
                                    var copyArr = dictArr
                                    if let dict = dictArr[indexPath.row] as? InputTextfieldModel{
                                        if ((dict.inputType ?? "") == InputType.Dropdown){
                                            if let cell = self.tblView.cellForRow(at: indexPath) as? PickerInputCell{
                                                cell.pickerView.reloadAllComponents()
                                            }
                                            
                                            if let arr = dict.dropdownArr as? [Any]{
                                                let selectedValue = Utility.getSelectedValue(arrDropdown: arr,row: 0)
                                                
                                                dict.value = selectedValue.value
                                                dict.valueId = selectedValue.valueID
                                                dict.isValid = true
                                                copyArr[indexPath.row] = dict
                                                self.arrInput[indexPath.section] = copyArr
                                                textField.text = selectedValue.value
                                            }
                                        }
                                        
                                    }
                                }
                            }
                        }
                    }else if let cell = textField.superview?.superview as? DateTimeInputCell{
                        if let indexPath = self.tblView.indexPath(for: (cell)) {
                            if let dictArr = (self.arrInput[indexPath.section] as! [Any]) as? [InputTextfieldModel]{
                                
                                var copyArr = dictArr
                                let dict = copyArr[indexPath.row]
                                
                                if ((dict.inputType ?? "") == InputType.Time){
                                    let isDate = (dict.inputType ?? "") == InputType.Date
                                    let dateStr = Utility.getStringFromDate(date: Date(), dateFormat: isDate ? DateFormats.mm_dd_yyyy : DateFormats.hh_mm_a)
                                    
                                    dict.value = dateStr
                                    dict.valueId = dateStr
                                    dict.isValid = true
                                    copyArr[indexPath.row] = dict
                                    self.arrInput[indexPath.section] = copyArr
                                    textField.text = dateStr
                                }
                            }
                        }
                    }else if let cell = textField.superview?.superview as? DoubleInputCell{
                        if let indexPath = self.tblView.indexPath(for: (cell)) {
                            if let dictArr = (self.arrInput[indexPath.section] as! [Any]) as? [InputTextfieldModel]{
                                
                                var copyArr = dictArr
                                let dict = copyArr[indexPath.row]
                                if ((dict.inputType ?? "") == InputType.Dropdown){
                                    if let cell = self.tblView.cellForRow(at: indexPath) as? DoubleInputCell{
                                        cell.pickerView.reloadAllComponents()
                                    }
                                    
                                    if let arr = dict.dropdownArr as? [Any]{
                                        let selectedValue = Utility.getSelectedValue(arrDropdown: arr,row: 0)
                                        
                                        dict.value = selectedValue.value
                                        dict.valueId = selectedValue.valueID
                                        dict.isValid = true
                                        copyArr[indexPath.row] = dict
                                        self.arrInput[indexPath.section] = copyArr
                                        textField.text = selectedValue.value
                                    }
                                }
                            }else{
                                if let dictArr = (self.arrInput[indexPath.section] as? [Any]){
                                    var copyArr = dictArr
                                    if let dict = dictArr[indexPath.row] as? InputTextfieldModel{
                                        if ((dict.inputType ?? "") == InputType.Dropdown){
                                            if let cell = self.tblView.cellForRow(at: indexPath) as? PickerInputCell{
                                                cell.pickerView.reloadAllComponents()
                                            }
                                            
                                            if let arr = dict.dropdownArr as? [Any]{
                                                let selectedValue = Utility.getSelectedValue(arrDropdown: arr,row: 0)
                                                
                                                dict.value = selectedValue.value
                                                dict.valueId = selectedValue.valueID
                                                dict.isValid = true
                                                copyArr[indexPath.row] = dict
                                                self.arrInput[indexPath.section] = copyArr
                                                textField.text = selectedValue.value
                                            }
                                        }
                                        
                                    }else if let arrSub = dictArr[indexPath.row] as? [InputTextfieldModel]{
                                        var copySubArray = arrSub
                                        let reqdIndex = textField.tag < TagConstants.DoubleTF_SecondTextfield_Tag ? 0 : 1
                                        let dict = arrSub[reqdIndex]
                                        if ((dict.inputType ?? "") == InputType.Dropdown){
                                            if let cell = self.tblView.cellForRow(at: indexPath) as? DoubleInputCell{
                                                cell.pickerView.reloadAllComponents()
                                            }
                                            
                                            if let arr = dict.dropdownArr as? [Any]{
                                                let selectedValue = Utility.getSelectedValue(arrDropdown: arr,row: 0)
                                                
                                                dict.value = selectedValue.value
                                                dict.valueId = selectedValue.valueID
                                                dict.isValid = true
                                                copySubArray[reqdIndex] = dict
                                                copyArr[indexPath.row] = copySubArray
                                                self.arrInput[indexPath.section] = copyArr
                                                textField.text = selectedValue.value
                                            }
                                        }
                                        
                                    }
                                }
                            }
                        }
                    }else if let cell = textField.superview?.superview as? RecursiveBPCell{
                        if let indexPath = self.tblView.indexPath(for: cell){
                            if let mainArray = self.arrInput[indexPath.section] as? [Any]{
                                var copyMainArray = mainArray
                                if let subArray = copyMainArray[indexPath.row] as? [InputTextfieldModel]{
                                    var copySubArray = subArray
                                    let dictIndex = self.getIndexForMultipleTf(textFieldTag: textField.tag)
                                    let dict = copySubArray[dictIndex]
                                    let copyDict = dict
                                    if ((dict.inputType ?? "") == InputType.Dropdown){
                                        cell.pickerView.reloadAllComponents()
                                        if let arr = dict.dropdownArr as? [Any]{
                                            let selectedValue = Utility.getSelectedValue(arrDropdown: arr,row: 0)
                                            copyDict.value = selectedValue.value
                                            copyDict.valueId = selectedValue.valueID
                                            copyDict.isValid = !(selectedValue.value.count == 0)
                                            copySubArray[dictIndex] = copyDict
                                            copyMainArray[indexPath.row] = copySubArray
                                            self.arrInput[indexPath.section] = copyMainArray
                                            textField.text = selectedValue.value
                                        }
                                    }else if ((dict.inputType ?? "") == InputType.Text) || ((dict.inputType ?? "") == InputType.Number) || ((dict.inputType ?? "") == InputType.Decimal){
                                        textField.inputView = nil
                                        copyDict.value = textField.text ?? ""
                                        copyDict.valueId = textField.text ?? ""
                                        copyDict.isValid = !((textField.text ?? "").count == 0)
                                        copySubArray[dictIndex] = copyDict
                                        copyMainArray[indexPath.row] = copySubArray
                                        self.arrInput[indexPath.section] = copyMainArray
                                    }else if((dict.inputType ?? "") == InputType.Time){
                                        cell.setupDatePicker()
                                        let isDate = (dict.inputType ?? "") == InputType.Date
                                        let dateStr = Utility.getStringFromDate(date: Date(), dateFormat: isDate ? DateFormats.mm_dd_yyyy : DateFormats.hh_mm_a)
                                        copyDict.value = dateStr
                                        copyDict.valueId = dateStr
                                        copyDict.isValid = !(dateStr.count == 0)
                                        copySubArray[dictIndex] = copyDict
                                        copyMainArray[indexPath.row] = copySubArray
                                        self.arrInput[indexPath.section] = copyMainArray
                                        textField.text = dateStr
                                    }
                                    
                                    
                                }
                            }
                        }
                    }
                }else{
                    if let cell = textField.superview?.superview as? RecursiveBPCell{
                        if let indexPath = self.tblView.indexPath(for: cell){
                            if let mainArray = self.arrInput[indexPath.section] as? [Any]{
                                var copyMainArray = mainArray
                                if let subArray = copyMainArray[indexPath.row] as? [InputTextfieldModel]{
                                    var copySubArray = subArray
                                    let dictIndex = self.getIndexForMultipleTf(textFieldTag: textField.tag)
                                    let dict = copySubArray[dictIndex]
                                    let copyDict = dict
                                    if ((dict.inputType ?? "") == InputType.Dropdown){
                                        cell.pickerView.reloadAllComponents()
                                    }else if ((dict.inputType ?? "") == InputType.Text) || ((dict.inputType ?? "") == InputType.Number) || ((dict.inputType ?? "") == InputType.Decimal){
                                        copyDict.value = textField.text ?? ""
                                        copyDict.valueId = textField.text ?? ""
                                        copyDict.isValid = !((textField.text ?? "").count == 0)
                                        copySubArray[dictIndex] = copyDict
                                        copyMainArray[indexPath.row] = copySubArray
                                        self.arrInput[indexPath.section] = copyMainArray
                                    }else if((dict.inputType ?? "") == InputType.Time){
                                        cell.setupDatePicker()
                                        let isDate = (dict.inputType ?? "") == InputType.Date
                                        let dateStr = Utility.getStringFromDate(date: Date(), dateFormat: isDate ? DateFormats.mm_dd_yyyy : DateFormats.hh_mm_a)
                                        copyDict.value = dateStr
                                        copyDict.valueId = dateStr
                                        copyDict.isValid = !(dateStr.count == 0)
                                        copySubArray[dictIndex] = copyDict
                                        copyMainArray[indexPath.row] = copySubArray
                                        self.arrInput[indexPath.section] = copyMainArray
                                        textField.text = dateStr
                                    }
                                    
                                    
                                }
                            }
                        }
                    }
                }
                
                
            }
        }
    }
    
    func updateTextfieldAndPickerForRow(row: Int, tfToUpdate : InputTextField){
        
        
    }
    
    func getSelectedValueIndex(valueTitle : String, textfieldTag : Int) -> Int{
        //let dict = self.arrInput[textfieldTag]
        return 0
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let cell = textField.superview?.superview as? RecursiveBPCell{
            if textField.placeholder == NursingTitles.Nutrition.FluidIntake.FluidIntake {
                
                if range.location == 0 && string == " " { // prevent space on first character
                    return false
                }
                
                if textField.text?.last == " " && string == " " { // allowed only single space
                    return false
                }
                
                if string == " " { return true } // now allowing space between name
                let  char = string.cString(using: String.Encoding.utf8)!
                let isBackSpace = strcmp(char, "\\b")
                if (isBackSpace == -92) {
                    return true
                }else{
                if string.rangeOfCharacter(from: CharacterSet.alphanumerics) == nil {
                    self.viewModel.errorMessage = "This field only accepts alphabetic letters."
                    return false
                } }           }
        }
        if let cell = textField.superview?.superview as? TextInputCell{
            if textField.placeholder == NursingTitles.Nutrition.MealEaten {
                if range.location == 0 && string == " " { // prevent space on first character
                    return false
                }
                
                if textField.text?.last == " " && string == " " { // allowed only single space
                    return false
                }
                
                if string == " " { return true } // now allowing space between name
                
//                if string.rangeOfCharacter(from: CharacterSet.letters.inverted) != nil {
//                    self.viewModel.errorMessage = "This field only accepts alphabetic letters."
//                    return false
//                }
                //"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ.,"
                
                let  char = string.cString(using: String.Encoding.utf8)!
                let isBackSpace = strcmp(char, "\\b")
                if (isBackSpace == -92) {
                    return true
                }else{
                guard CharacterSet(charactersIn: "0123456789").isSuperset(of: CharacterSet(charactersIn: string)) else {
                    return true
                }
                self.viewModel.errorMessage = "This field only accepts alphabetic letters."
                return false
                }
                
            }
            
        }
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Here Set The Next return field
        textField.resignFirstResponder()
        /*
         if textField.tag == self.arrInput.count - 1{
         textField.resignFirstResponder()
         return true
         }
         DispatchQueue.main.async {
         if  textField.tag - TagConstants.DoubleTF_FirstTextfield_Tag > 0 && textField.tag - TagConstants.DoubleTF_FirstTextfield_Tag < TagConstants.DoubleTF_FirstTextfield_Tag{
         let tagTf =  textField.tag - TagConstants.DoubleTF_FirstTextfield_Tag
         var indeXPath = IndexPath(row: tagTf, section: 0)
         if let indexPath = self.tblView.indexPath(for: (self.activeTextfield?.superview?.superview as! DoubleInputCell)){
         indeXPath = indexPath
         }
         if let cell = self.tblView.cellForRow(at: indeXPath){
         if cell.isKind(of: DoubleInputCell.self){
         (cell as! DoubleInputCell).inputTf2.becomeFirstResponder()
         }
         }
         }else{
         let tagTf = textField.tag >= TagConstants.DoubleTF_SecondTextfield_Tag ? textField.tag - TagConstants.DoubleTF_SecondTextfield_Tag : textField.tag
         var indeXPath = IndexPath(row: tagTf, section: 0)
         if let indexPath = self.tblView.indexPath(for: (self.activeTextfield?.superview?.superview as! DoubleInputCell)){
         indeXPath = indexPath
         }
         
         if let cell = self.tblView.cellForRow(at: indeXPath){
         if cell.isKind(of: PickerInputCell.self){
         (cell as! PickerInputCell).inputTf.becomeFirstResponder()
         }
         else {
         textField.resignFirstResponder()
         }
         }
         }
         }*/
        return true
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        // Here Set The Next return field
        IQKeyboardManager.shared.toolbarDoneBarButtonItemText = ButtonTitles.done
        textField.keyboardToolbar.doneBarButton.setTarget(self, action: #selector(doneAction(textField:)))
        
        
 
        
        if let cell = textField.superview?.superview as? PickerInputCell{
//            if textField.placeholder == YesNONutritionHydration.Food_Intake{
//                if let indexPath = self.tblView.indexPath(for: (cell)) {
//
//
//                    if let cell = self.tblView.cellForRow(at: indexPath) as? PickerInputCell{
//                        cell.pickerView.reloadAllComponents()
//                         print("indexPath.section = \(indexPath.section)")
//                    }
//                }
                 self.yesNoFirstTime(textField: textField)
            }
            if textField.placeholder == YesNONutritionHydration.Fluid_Intake{
//                if let indexPath = self.tblView.indexPath(for: (cell)) {
//
//
//                    if let cell = self.tblView.cellForRow(at: indexPath) as? PickerInputCell{
//                        cell.pickerView.reloadAllComponents()
//                        print("indexPath.section = \(indexPath.section)")
//                    }
//                }
                 self.yesNoFirstTime(textField: textField)
            }
            if textField.placeholder == YesNONutritionHydration.Bowel{
//                if let indexPath = self.tblView.indexPath(for: (cell)) {
//
//
//                    if let cell = self.tblView.cellForRow(at: indexPath) as? PickerInputCell{
//                        cell.pickerView.reloadAllComponents()
//                        print("indexPath.section = \(indexPath.section)")
//                    }
//                }
                 self.yesNoFirstTime(textField: textField)
            }
            if textField.placeholder == YesNONutritionHydration.Urinary_Voids{
//                if let indexPath = self.tblView.indexPath(for: (cell)) {
//
//
//                    if let cell = self.tblView.cellForRow(at: indexPath) as? PickerInputCell{
//                        cell.pickerView.reloadAllComponents()
//                        print("indexPath.section = \(indexPath.section)")
//                    }
//                }
                 self.yesNoFirstTime(textField: textField)
            }
            if textField.placeholder == YesNONutritionHydration.Emesis{
//                if let indexPath = self.tblView.indexPath(for: (cell)) {
//
//
//                    if let cell = self.tblView.cellForRow(at: indexPath) as? PickerInputCell{
//                        cell.pickerView.reloadAllComponents()
//                        print("indexPath.section = \(indexPath.section)")
//                    }
//                }
                 self.yesNoFirstTime(textField: textField)
            }
            if textField.placeholder == YesNONutritionHydration.Blood_Loss{
//                if let indexPath = self.tblView.indexPath(for: (cell)) {
//
//
//                    if let cell = self.tblView.cellForRow(at: indexPath) as? PickerInputCell{
//                        cell.pickerView.reloadAllComponents()
//                        print("indexPath.section = \(indexPath.section)")
//                    }
//                }
                self.yesNoFirstTime(textField: textField)
             
            }
        return true
        }
        /*}
         if textField.tag == self.arrInput.count - 1{
         IQKeyboardManager.shared.toolbarDoneBarButtonItemText = ButtonTitles.done
         textField.keyboardToolbar.doneBarButton.setTarget(self, action: #selector(doneAction(textField:)))
         
         }else{
         IQKeyboardManager.shared.toolbarDoneBarButtonItemText = ButtonTitles.next
         textField.keyboardToolbar.doneBarButton.setTarget(self, action: #selector(nextAction(textField:)))
         
         }*/
        
    //}
    func yesNoFirstTime(textField:UITextField){
        if let cell = textField.superview?.superview as? PickerInputCell{
                                             if let indexPath = self.tblView.indexPath(for: (cell)) {
                                                 if let arrInput = self.arrInput[indexPath.section] as? [Any]{
                                                     if let dictArr = arrInput[indexPath.row] as? [InputTextfieldModel]{
                                                         
                                                         var copyArr = dictArr
                                                         let dict = copyArr[indexPath.row]
                                                         if ((dict.inputType ?? "") == InputType.Dropdown){
                                                             if let cell = self.tblView.cellForRow(at: indexPath) as? PickerInputCell{
                                                                 cell.pickerView.reloadAllComponents()
                                                             }
                                                             
                                                             if let arr = dict.dropdownArr as? [Any]{
                                                                 let selectedValue = Utility.getSelectedValue(arrDropdown: arr,row: 0)
                                                                 
                                                                 dict.value = selectedValue.value
                                                                 dict.valueId = selectedValue.valueID
                                                                 dict.isValid = true
                                                                 copyArr[indexPath.row] = dict
                                                                 self.arrInput[indexPath.section] = copyArr
                                                                 textField.text = selectedValue.value
                                                             }
                                                         }
                                                     }else if let dict = arrInput[indexPath.row] as? InputTextfieldModel{
                                                         var copyArr = arrInput
                                                         
                                                         if ((dict.inputType ?? "") == InputType.Dropdown){
                                                             if let cell = self.tblView.cellForRow(at: indexPath) as? PickerInputCell{
                                                                 cell.pickerView.reloadAllComponents()
                                                             }
                                                             
                                                             if let arr = dict.dropdownArr as? [Any]{
                                                                 let selectedValue = Utility.getSelectedValue(arrDropdown: arr,row: 0)
                                                                 
                                                                 dict.value = selectedValue.value
                                                                 dict.valueId = selectedValue.valueID
                                                                 dict.isValid = true
                                                                 copyArr[indexPath.row] = dict
                                                                 self.arrInput[indexPath.section] = copyArr
                                                                 textField.text = selectedValue.value
                                                             }
                                                         }
                                                         
                                                     }
                                                 }else{
                                                     if let dictArr = (self.arrInput[indexPath.section] as? [Any]){
                                                         var copyArr = dictArr
                                                         if let dict = dictArr[indexPath.row] as? InputTextfieldModel{
                                                             if ((dict.inputType ?? "") == InputType.Dropdown){
                                                                 if let cell = self.tblView.cellForRow(at: indexPath) as? PickerInputCell{
                                                                     cell.pickerView.reloadAllComponents()
                                                                 }
                                                                 
                                                                 if let arr = dict.dropdownArr as? [Any]{
                                                                     let selectedValue = Utility.getSelectedValue(arrDropdown: arr,row: 0)
                                                                     
                                                                     dict.value = selectedValue.value
                                                                     dict.valueId = selectedValue.valueID
                                                                     dict.isValid = true
                                                                     copyArr[indexPath.row] = dict
                                                                     self.arrInput[indexPath.section] = copyArr
                                                                     textField.text = selectedValue.value
                                                                 }
                                                             }
                                                             
                                                         }
                                                     }
                                                 }
                                             }
                                         }
    }
    @objc func doneAction(textField:UITextField){
        textField.resignFirstResponder()
        
        
        if textField.placeholder == YesNONutritionHydration.Food_Intake{
            print(YesNONutritionHydration.Food_Intake)
            if textField.text == "Yes"{
                self.foodIntake = true
            }else{
                self.foodIntake = false
            }
        }
        
        if textField.placeholder == YesNONutritionHydration.Fluid_Intake{
            print(YesNONutritionHydration.Fluid_Intake)
            if textField.text == "Yes"{
                self.fluidIntake = true
            }else{
                self.fluidIntake = false
            }
        }else if textField.placeholder == YesNONutritionHydration.Bowel{
            print(YesNONutritionHydration.Bowel)
            if textField.text == "Yes"{
                self.bowel = true
            }else{
                self.bowel = false
            }
        }else if textField.placeholder == YesNONutritionHydration.Urinary_Voids{
            print(YesNONutritionHydration.Urinary_Voids)
            if textField.text == "Yes"{
                self.urinaryVoid = true
            }else{
                self.urinaryVoid = false
            }
            
        }else if textField.placeholder == YesNONutritionHydration.Emesis{
            print(YesNONutritionHydration.Emesis)
            if textField.text == "Yes"{
                self.emesis = true
            }else{
                self.emesis = false
            }
            
        }else if textField.placeholder == YesNONutritionHydration.Blood_Loss{
            print(YesNONutritionHydration.Blood_Loss)
            if textField.text == "Yes"{
                self.bloodLoss = true
            }else{
                self.bloodLoss = false
            }
        }
        
        print(textField.tag)
        self.tblView.reloadData()
        
        /*
         if textField.tag == self.arrInput.count - 1{
         textField.resignFirstResponder()
         }*/
    }
    
    @objc func nextAction(textField:UITextField){
        if textField.tag == self.arrInput.count - 1{
            textField.resignFirstResponder()
        }
        DispatchQueue.main.async {
            if  textField.tag - TagConstants.DoubleTF_FirstTextfield_Tag > 0 && textField.tag - TagConstants.DoubleTF_FirstTextfield_Tag < TagConstants.DoubleTF_FirstTextfield_Tag{
                var indeXPath = IndexPath(row: textField.tag - TagConstants.DoubleTF_FirstTextfield_Tag, section: 0)
                if let indexPath = self.tblView.indexPath(for: (self.activeTextfield?.superview?.superview as! DoubleInputCell)){
                    indeXPath = indexPath
                }
                
                
                if let cell = self.tblView.cellForRow(at: indeXPath){
                    if cell.isKind(of: DoubleInputCell.self){
                        (cell as! DoubleInputCell).inputTf2.becomeFirstResponder()
                    }
                }
            }else{
                let tagTf = textField.tag >= TagConstants.DoubleTF_SecondTextfield_Tag ? textField.tag - TagConstants.DoubleTF_SecondTextfield_Tag : textField.tag
                var indeXPath = IndexPath(row: tagTf + 1, section: 0)
                
                if let cell = self.activeTextfield?.superview?.superview as? DoubleInputCell{
                    if let indexPath = self.tblView.indexPath(for:cell){
                        indeXPath = indexPath
                    }
                }
                
                if let cell = self.activeTextfield?.superview?.superview as? PickerInputCell{
                    if let indexPath = self.tblView.indexPath(for:cell){
                        indeXPath = IndexPath(row: indexPath.row + 1, section: indexPath.section)
                    }
                }
                
                if let cell = self.tblView.cellForRow(at: indeXPath ){
                    if cell.isKind(of: PickerInputCell.self){
                        (cell as! PickerInputCell).inputTf.becomeFirstResponder()
                    }
                    else {
                        textField.resignFirstResponder()
                    }
                }
            }
        }
    }
    func yesNowHideShowData(cell : PickerInputCell, textField : UITextField){
        if let indexPath = self.tblView.indexPath(for: cell){
            if let mainArray = self.arrInput[indexPath.section] as? [Any] {
                var copyMainArray = mainArray
                
                var addObject:(Any)? = nil
                var addObject2:(Any)? = nil
                
                if textField.text == "Yes"{
                    if textField.placeholder == YesNONutritionHydration.Food_Intake{
                        let getYN = self.gYesNO(boolvalue: foodIntake)
                        if textField.text == getYN{
                            return
                        }else{
                            foodIntake = self.gYesNOReturnBool(stringN: textField.text ?? "")
                        }
                        addObject = self.viewModel.foodIntackYesNo(fluidObject:nil)
                        var arrayR = addObject as! [InputTextfieldModel]
                        arrayR.reverse()
                        for dict in arrayR{
                            copyMainArray.insert(dict, at: indexPath.row + 1)
                        }
                        self.arrInput[indexPath.section] = copyMainArray
                        self.tblView.reloadData()
                    }
                    else {
                        if textField.placeholder == YesNONutritionHydration.Fluid_Intake{
                            let getYN = self.gYesNO(boolvalue: fluidIntake)
                            if textField.text == getYN{
                                return
                            }else{
                                fluidIntake = self.gYesNOReturnBool(stringN: textField.text ?? "")
                            }
                            
                            addObject = self.viewModel.getFluidIntakeArray(fluidObject: nil)
                            addObject2 = self.viewModel.numberOffluidIntackTotal(fluidObject: nil)
                            let objH = addObject2 as! InputTextfieldModel
                            
                            let boolTest =  self.checkObjectContains(copyMainArray: copyMainArray, objH: objH)
                            if boolTest == false{
                                copyMainArray.insert(objH, at: indexPath.row + 1)
                                self.arrInput[indexPath.section] = copyMainArray
                            }
                        }else if textField.placeholder == YesNONutritionHydration.Bowel{
                            
                            let getYN = self.gYesNO(boolvalue: bowel)
                            if textField.text == getYN{
                                return
                            }else{
                                bowel = self.gYesNOReturnBool(stringN: textField.text ?? "")
                            }
                            
                            
                            addObject = self.viewModel.getBowelArray(bowelObject: nil)
                            addObject2 = self.viewModel.numberOfBowelTotal(fluidObject: nil)
                            let objH = addObject2 as! InputTextfieldModel
                            
                            let boolTest =  self.checkObjectContains(copyMainArray: copyMainArray, objH: objH)
                            if boolTest == false{
                                copyMainArray.insert(objH, at: indexPath.row + 1)
                                self.arrInput[indexPath.section] = copyMainArray
                            }
                            
                        }else if textField.placeholder == YesNONutritionHydration.Urinary_Voids{
                            
                            let getYN = self.gYesNO(boolvalue: urinaryVoid)
                            if textField.text == getYN{
                                return
                            }else{
                                urinaryVoid = self.gYesNOReturnBool(stringN: textField.text ?? "")
                            }
                            
                            addObject = self.viewModel.getUrinaryVoidsArray(urinaryObject: nil)
                            addObject2 = self.viewModel.numberUrinaryVoidsTotal(fluidObject: nil)
                            let objH = addObject2 as! InputTextfieldModel
                            
                            let boolTest =  self.checkObjectContains(copyMainArray: copyMainArray, objH: objH)
                            if boolTest == false{
                                copyMainArray.insert(objH, at: indexPath.row + 1)
                                self.arrInput[indexPath.section] = copyMainArray
                            }
                            
                        }else if textField.placeholder == YesNONutritionHydration.Emesis{
                            let getYN = self.gYesNO(boolvalue: emesis)
                            if textField.text == getYN{
                                return
                            }else{
                                emesis = self.gYesNOReturnBool(stringN: textField.text ?? "")
                            }
                            addObject = self.viewModel.getEmesisArray(emesisObject: nil)
                            addObject2 = self.viewModel.numberEmisisTotal(fluidObject: nil)
                            let objH = addObject2 as! InputTextfieldModel
                            
                            let boolTest =  self.checkObjectContains(copyMainArray: copyMainArray, objH: objH)
                            if boolTest == false{
                                copyMainArray.insert(objH, at: indexPath.row + 1)
                                self.arrInput[indexPath.section] = copyMainArray
                            }
                            
                        }else if textField.placeholder == YesNONutritionHydration.Blood_Loss{
                            let getYN = self.gYesNO(boolvalue: bloodLoss)
                            if textField.text == getYN{
                                return
                            }else{
                                bloodLoss = self.gYesNOReturnBool(stringN: textField.text ?? "")
                            }
                            
                            addObject = self.viewModel.getBloodLossArray(bloodLossObject: nil)
                            addObject2 = self.viewModel.numberBloodTotal(fluidObject: nil)
                            let objH = addObject2 as! InputTextfieldModel
                            
                            let boolTest =  self.checkObjectContains(copyMainArray: copyMainArray, objH: objH)
                            if boolTest == false{
                                copyMainArray.insert(objH, at: indexPath.row + 1)
                                self.arrInput[indexPath.section] = copyMainArray
                            }
                        }
                        if let getobj = addObject{
                            copyMainArray.insert(getobj, at: indexPath.row + 1)
                            self.arrInput[indexPath.section] = copyMainArray
                            self.tblView.reloadData()
                        }
                        
                    }
                    
                }else{
                    if textField.placeholder == YesNONutritionHydration.Food_Intake{
                        let getYN = self.gYesNO(boolvalue: foodIntake)
                        if textField.text == getYN{
                            return
                        }else{
                            foodIntake = self.gYesNOReturnBool(stringN: textField.text ?? "")
                        }
                        print("")
                        if let mainArray = self.arrInput[indexPath.section] as? [Any] {
                            var copyMainArray = mainArray
                            var i: Int = 7
                            for (_,dictArray) in mainArray.enumerated() {
                                i = i - 1
                                copyMainArray.remove(at: i)
                                
                                if i == 1{
                                    break
                                }
                            }
                            self.arrInput[indexPath.section] = copyMainArray
                            self.tblView.reloadData()
                        }
                        
                    }else{
                        
                        if textField.placeholder == YesNONutritionHydration.Fluid_Intake{
                            
                            let getYN = self.gYesNO(boolvalue: fluidIntake)
                            if textField.text == getYN{
                                return
                            }else{
                                fluidIntake = self.gYesNOReturnBool(stringN: textField.text ?? "")
                            }
                            
                        }
                        else if textField.placeholder == YesNONutritionHydration.Bowel{
                            let getYN = self.gYesNO(boolvalue: bowel)
                            if textField.text == getYN{
                                return
                            }else{
                                bowel = self.gYesNOReturnBool(stringN: textField.text ?? "")
                            }
                            
                        }
                        else if textField.placeholder == YesNONutritionHydration.Urinary_Voids{
                            let getYN = self.gYesNO(boolvalue: urinaryVoid)
                            if textField.text == getYN{
                                return
                            }else{
                                urinaryVoid = self.gYesNOReturnBool(stringN: textField.text ?? "")
                            }
                            
                        }
                        else if textField.placeholder == YesNONutritionHydration.Emesis{
                            let getYN = self.gYesNO(boolvalue: emesis)
                            if textField.text == getYN{
                                return
                            }else{
                                emesis = self.gYesNOReturnBool(stringN: textField.text ?? "")
                            }
                            
                        }
                        else if textField.placeholder == YesNONutritionHydration.Blood_Loss{
                            let getYN = self.gYesNO(boolvalue: bloodLoss)
                            if textField.text == getYN{
                                return
                            }else{
                                bloodLoss = self.gYesNOReturnBool(stringN: textField.text ?? "")
                            }
                        }
                        
                        if let mainArray = self.arrInput[indexPath.section] as? [Any] {
                            var copyMainArray = mainArray
                            var type = ""
                            var count = 0
                            if let dictArr = mainArray[indexPath.row] as? [InputTextfieldModel] {
                                let tfOneDict = dictArr[0]
                                type = tfOneDict.sectionHeader ?? ""
                            }
                            var i: Int = -1
                            for (_,dictArray) in copyMainArray.enumerated() {
                                i = i + 1
                                if dictArray is [InputTextfieldModel]{
                                    let dicth = dictArray as? [InputTextfieldModel]
                                    
                                    
                                    if textField.placeholder == YesNONutritionHydration.Fluid_Intake{
                                        if dicth![0].apiKey == Key.Params.NursingCareFlow.Nutrition.fluidIntake{
                                            copyMainArray.remove(at: i)
                                            i = i - 1
                                        }
                                        
                                        
                                    }else if textField.placeholder == YesNONutritionHydration.Bowel{
                                        if dicth![0].apiKey == Key.Params.NursingCareFlow.Nutrition.amountBowelId{
                                            copyMainArray.remove(at: i)
                                            i = i - 1
                                        }
                                        
                                    }else if textField.placeholder == YesNONutritionHydration.Urinary_Voids{
                                        if dicth![0].apiKey == Key.Params.NursingCareFlow.Nutrition.urinAmount{
                                            copyMainArray.remove(at: i)
                                            i = i - 1
                                        }
                                        
                                    }else if textField.placeholder == YesNONutritionHydration.Emesis{
                                        if dicth![0].apiKey == Key.Params.NursingCareFlow.Nutrition.emesisAmount{
                                            copyMainArray.remove(at: i)
                                            i = i - 1
                                        }
                                        
                                    }else if textField.placeholder == YesNONutritionHydration.Blood_Loss{
                                        if dicth![0].apiKey == Key.Params.NursingCareFlow.Nutrition.bloodLossAmount{
                                            copyMainArray.remove(at: i)
                                            i = i - 1
                                        }
                                    }
                                }
                            }
                            print(indexPath.row)
                            count = self.getArrayOfType(type: type).count
                            self.arrInput[indexPath.section] = copyMainArray
                            self.tblView.reloadData()
                            
                            
                            
                            if textField.placeholder == YesNONutritionHydration.Fluid_Intake{
                                
                                self.getArrayIndexFromTitle(title: NursingTitles.Nutrition.FluidIntake.TotalAmount, section: 0, completion: { (row) in
                                    copyMainArray.remove(at: row)
                                    self.arrInput[0] = copyMainArray
                                })
                                
                            }else if textField.placeholder == YesNONutritionHydration.Bowel{
                                self.getArrayIndexFromTitle(title: NursingTitles.Nutrition.Bowel.TotalBowelMovement, section: 1, completion: { (row) in
                                    copyMainArray.remove(at: row)
                                    self.arrInput[1] = copyMainArray
                                })
                                
                            }else if textField.placeholder == YesNONutritionHydration.Urinary_Voids{
                                
                                
                                self.getArrayIndexFromTitle(title: NursingTitles.Nutrition.UrinaryVoids.TotalUrinaryVoids, section: 1, completion: { (row) in
                                    copyMainArray.remove(at: row)
                                    self.arrInput[1] = copyMainArray
                                })
                                
                                
                            }else if textField.placeholder == YesNONutritionHydration.Emesis{
                                self.getArrayIndexFromTitle(title: NursingTitles.Nutrition.Emesis.EmesisTotal, section: 1, completion: { (row) in
                                    copyMainArray.remove(at: row)
                                    self.arrInput[1] = copyMainArray
                                })
                                
                            }else if textField.placeholder == YesNONutritionHydration.Blood_Loss{
                                self.getArrayIndexFromTitle(title: NursingTitles.Nutrition.BloodLoss.BloodLossTotal, section: 1, completion: { (row) in
                                    copyMainArray.remove(at: row)
                                    self.arrInput[1] = copyMainArray
                                })
                            }
                            self.tblView.reloadData()
                            
                            
                        }
                    }
                }
                
            }
            
        }
    }
    func gYesNO( boolvalue: Bool ) -> String{
        if boolvalue{
            return "Yes"
        }else{
            return "No"
        }
    }
    func gYesNOReturnBool( stringN: String ) -> Bool{
        if stringN == "Yes"{
            return true
        }else{
            return false
        }
    }
    func checkObjectContains(copyMainArray : [Any] , objH : InputTextfieldModel) -> Bool{
        var boolTest: Bool = false
        for (_,dictArray) in copyMainArray.enumerated() {
            
            if dictArray is InputTextfieldModel{
                
                if let dict = dictArray as? InputTextfieldModel{
                    if dict.placeholder == objH.placeholder{
                        boolTest = true
                    }
                }}
        }
        return boolTest
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        
        
        
        let indexTuple = self.getIndexAndSubIndexFromTag(textFieldTag: textField.tag)
        var index = indexTuple.0
        let dictIndex = indexTuple.1
        
        if textField.tag < TagConstants.DoubleTF_FirstTextfield_Tag{
            if let cell = self.activeTextfield?.superview?.superview as? TextInputCell{
                if let indexPath = self.tblView.indexPath(for: (cell)){
                    index = indexPath.section
                }
            }
            
            if let cell = textField.superview?.superview as? PickerInputCell{
                
                
                self.yesNowHideShowData(cell: cell, textField: textField)
                
                if let indexPath = self.tblView.indexPath(for: (cell)) {
                    if let arrInput = self.arrInput[indexPath.section] as? [Any]{
                        if let dictArr = arrInput as? [InputTextfieldModel]{
                            var copyArr = dictArr
                            let dict = copyArr[indexPath.row]
                            if ((dict.inputType ?? "") == InputType.Dropdown){
                                print("YesNoData")
                            }else{
                                dict.value = textField.text
                                dict.valueId = textField.text
                                dict.isValid = !(textField.text?.count == 0)
                                self.arrInput[index] = dict
                            }
                        }
                    }
                }
            }else if let cell = textField.superview?.superview as? TextInputCell{
                if let indexPath = self.tblView.indexPath(for: (cell)) {
                    if let dictArr = (self.arrInput[indexPath.section] as? [Any]){
                        var copyArr = dictArr
                        if let dict = dictArr[indexPath.row] as? InputTextfieldModel{
                            if ((dict.inputType ?? "") == InputType.Text) || ((dict.inputType ?? "") == InputType.Number) || ((dict.inputType ?? "") == InputType.Decimal){
                                dict.value = textField.text ?? ""
                                dict.valueId = textField.text ?? ""
                                dict.isValid = true
                                copyArr[indexPath.row] = dict
                                self.arrInput[indexPath.section] = copyArr
                            }
                        }
                    }
                }
            }else if let cell = textField.superview?.superview as? NumberInputCell{
                if let indexPath = self.tblView.indexPath(for: (cell)) {
                    if let dictArr = (self.arrInput[indexPath.section] as? [Any]){
                        var copyArr = dictArr
                        if let dict = dictArr[indexPath.row] as? InputTextfieldModel{
                            if  ((dict.inputType ?? "") == InputType.Number) || ((dict.inputType ?? "") == InputType.Decimal){
                                dict.value = textField.text ?? ""
                                dict.valueId = textField.text ?? ""
                                dict.isValid = true
                                copyArr[indexPath.row] = dict
                                self.arrInput[indexPath.section] = copyArr
                                
                                self.updateTotalTextfield(dictType:  dict.sectionHeader ?? "")
                            }
                        }
                    }
                }
            }
            //            if let dict = self.arrInput[index] as? InputTextfieldModel{
            //                if dict.inputType == InputType.Dropdown {
            //
            //                }else{
            //                    dict.value = textField.text
            //                    dict.valueId = textField.text
            //                    dict.isValid = !(textField.text?.count == 0)
            //                    self.arrInput[index] = dict
            //                }
            //            }else {
            //
            //            }
        }else if textField.tag >= TagConstants.RecursiveTF_FirstTextfield_Tag{
            if let cell = textField.superview?.superview as? RecursiveBPCell{
                if let indexPath = self.tblView.indexPath(for: cell){
                    if let mainArray = self.arrInput[indexPath.section] as? [Any]{
                        var copyMainArray = mainArray
                        if let subArray = copyMainArray[indexPath.row] as? [InputTextfieldModel]{
                            var copySubArray = subArray
                            let dictIndex = self.getIndexForMultipleTf(textFieldTag: textField.tag)
                            var dict = copySubArray[dictIndex]
                            var copyDict = dict
                            if copyDict.inputType == InputType.Dropdown || copyDict.inputType == InputType.Time {
                                if copyDict.sectionHeader == NursingTitles.Nutrition.Bowel.Bowel{
                                    self.updateTotalTextfield(dictType: dict.sectionHeader ?? "")
                                }
                            }else if(copyDict.inputType == InputType.Number){
                                copyDict.value = textField.text
                                copyDict.valueId = textField.text
                                copyDict.isValid = !(textField.text?.count == 0)
                                copySubArray[dictIndex] = copyDict
                                copyMainArray[indexPath.row] = copySubArray
                                self.arrInput[indexPath.section] = copyMainArray
                                
                                self.updateTotalTextfield(dictType: dict.sectionHeader ?? "")
                            }else{
                                copyDict.value = textField.text
                                copyDict.valueId = textField.text
                                copyDict.isValid = !(textField.text?.count == 0)
                                copySubArray[dictIndex] = copyDict
                                copyMainArray[indexPath.row] = copySubArray
                                self.arrInput[indexPath.section] = copyMainArray
                            }
                        }
                    }
                }
            }
            /*
             if let dict = self.arrInput[index] as? InputTextfieldModel{
             if dict.inputType == InputType.Dropdown {
             
             }else{
             dict.value = textField.text
             dict.valueId = textField.text
             dict.isValid = !(textField.text?.count == 0)
             self.arrInput[textField.tag] = dict
             }
             
             }else{
             
             if let dictArr = self.arrInput[index] as? [InputTextfieldModel]{
             var copyArr = dictArr
             let dict = copyArr[dictIndex]
             if dict.inputType == InputType.Dropdown {
             }else{
             dict.value = textField.text ?? ""
             dict.valueId = textField.text
             dict.isValid = !(textField.text?.count == 0)
             copyArr[dictIndex] = dict
             self.arrInput[index] = copyArr
             
             }
             }
             }
             */
        }else{
            
            
            if let dict = self.arrInput[index] as? InputTextfieldModel{
                if dict.inputType == InputType.Dropdown {
                }else{
                    dict.value = textField.text
                    dict.valueId = textField.text
                    dict.isValid = !(textField.text?.count == 0)
                    self.arrInput[textField.tag] = dict
                }
            }else{
                
                if let dictArr = self.arrInput[index] as? [InputTextfieldModel]{
                    var copyArr = dictArr
                    let dict = copyArr[dictIndex]
                    if dict.inputType == InputType.Dropdown {
                        
                    }else{
                        dict.value = textField.text ?? ""
                        dict.valueId = textField.text
                        dict.isValid = !(textField.text?.count == 0)
                        copyArr[dictIndex] = dict
                        self.arrInput[index] = copyArr
                        
                    }
                }else if let arrInput = self.arrInput[index] as? [Any]{
                    if let cell = textField.superview?.superview as? DoubleInputCell{
                        if let indexPath = self.tblView.indexPath(for: (cell)) {
                            if let dictArr = (self.arrInput[indexPath.section] as? [Any]){
                                var copyArr = dictArr
                                if let arrSub = dictArr[indexPath.row] as? [InputTextfieldModel]{
                                    let reqdIndex = self.activeTextfieldTag < TagConstants.DoubleTF_SecondTextfield_Tag ? 0 : 1
                                    var copySubArray = arrSub
                                    let dict = arrSub[reqdIndex]
                                    if ((dict.inputType ?? "") == InputType.Text) || ((dict.inputType ?? "") == InputType.Number) || ((dict.inputType ?? "") == InputType.Decimal){
                                        dict.value = textField.text ?? ""
                                        dict.valueId = textField.text ?? ""
                                        dict.isValid = true
                                        copySubArray[reqdIndex] = dict
                                        copyArr[indexPath.row] = copySubArray
                                        self.arrInput[indexPath.section] = copyArr
                                    }
                                    44                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func updateTotalTextfield(dictType : String){
        print("Total=== \(self.getTotalValueOfType(type:dictType))")
        print("Textfield === \(self.getTotalTextfieldForType(type: dictType))")
        let textfieldInfo = self.getTotalTextfieldForType(type: dictType)
        let section = textfieldInfo.section
        let row = textfieldInfo.row
        if let cell = self.tblView.cellForRow(at: IndexPath(row: row, section: section)) as? NumberInputCell{
            cell.inputTf.text = "\(self.getTotalValueOfType(type: dictType))"
            if let dictArr = (self.arrInput[section] as? [Any]){
                var copyArr = dictArr
                if let dict = dictArr[row] as? InputTextfieldModel{
                    if  ((dict.inputType ?? "") == InputType.Number) || ((dict.inputType ?? "") == InputType.Decimal){
                        dict.value = "\(self.getTotalValueOfType(type: dictType))"
                        dict.valueId = self.getTotalValueOfType(type: dictType)
                        dict.isValid = true
                        copyArr[row] = dict
                        self.arrInput[section] = copyArr
                    }
                }
            }
        }
        self.updateTotalFluidOutput()
    }
    
    func updateTotalFluidOutput(){
        let emesisTotal = self.getTotalValueOfType(type: NursingTitles.Nutrition.Emesis.Emesis)
        let bloodLossTotal = self.getTotalValueOfType(type: NursingTitles.Nutrition.BloodLoss.BloodLoss)
        let urinaryTotal = self.getTotalValueOfType(type: NursingTitles.Nutrition.UrinaryVoids.UrinaryVoids)
        let total = emesisTotal + bloodLossTotal + urinaryTotal
        
        let textfieldInfo = self.getTotalTextfieldForType(type: NursingTitles.Nutrition.TotalFluidOutput)
        let section = textfieldInfo.section
        let row = textfieldInfo.row
        if let cell = self.tblView.cellForRow(at: IndexPath(row: row, section: section)) as? NumberInputCell{
            cell.inputTf.text = "\(total)"
            if let dictArr = (self.arrInput[section] as? [Any]){
                var copyArr = dictArr
                if let dict = dictArr[row] as? InputTextfieldModel{
                    if  ((dict.inputType ?? "") == InputType.Number) || ((dict.inputType ?? "") == InputType.Decimal){
                        dict.value = "\(total)"
                        dict.valueId = total
                        dict.isValid = true
                        copyArr[row] = dict
                        self.arrInput[section] = copyArr
                    }
                }
            }
        }
    }
    //Returns (Int,Int) -> (Index,SubIndex)
    func getIndexAndSubIndexFromTag(textFieldTag : Int) -> (Int,Int){
        var index = textFieldTag
        var dictIndex = 0
        if let cell = self.activeTextfield?.superview?.superview as? PickerInputCell{
            if let indexPath = self.tblView.indexPath(for: cell){
                index = indexPath.section
                dictIndex = indexPath.row
            }
        }
        
        if let cell = self.activeTextfield?.superview?.superview as? TitlePickerInputCell{
            if let indexPath = self.tblView.indexPath(for: cell){
                index = indexPath.section
                dictIndex = indexPath.row
            }
        }
        
        if let cell = self.activeTextfield?.superview?.superview as? TextInputCell{
            if let indexPath = self.tblView.indexPath(for: cell){
                index = indexPath.section
                dictIndex = indexPath.row
            }
        }
        
        if let cell = self.activeTextfield?.superview?.superview as? DoubleInputCell{
            if let indexPath = self.tblView.indexPath(for: cell){
                index = indexPath.section
                dictIndex = indexPath.row
            }
        }
        
        
        /*
         if index < TagConstants.DoubleTF_FirstTextfield_Tag{
         }else if textFieldTag >= TagConstants.RecursiveTF_FirstTextfield_Tag{
         let isFirstTf = index - TagConstants.RecursiveTF_FirstTextfield_Tag > 0 && index - TagConstants.RecursiveTF_FirstTextfield_Tag < TagConstants.DoubleTF_FirstTextfield_Tag
         let isSecondTf = index >= TagConstants.RecursiveTF_SecondTextfield_Tag && index < TagConstants.RecursiveTF_ThirdTextfield_Tag
         
         if  isFirstTf{
         index = index - TagConstants.RecursiveTF_FirstTextfield_Tag
         }else if isSecondTf {
         index = index - TagConstants.RecursiveTF_SecondTextfield_Tag
         }else{
         index = index - TagConstants.RecursiveTF_ThirdTextfield_Tag
         }
         
         if let dict = self.arrInput[index] as? InputTextfieldModel{
         }else{
         if  isFirstTf{
         dictIndex = 0
         }else if isSecondTf {
         dictIndex = 1
         }else{
         dictIndex = 2
         }
         }
         }else{
         let isFirstTf = index - TagConstants.DoubleTF_FirstTextfield_Tag >= 0 && index - TagConstants.DoubleTF_FirstTextfield_Tag < TagConstants.DoubleTF_FirstTextfield_Tag
         let isSecondTf = index >= TagConstants.DoubleTF_SecondTextfield_Tag
         
         if  isFirstTf{
         index = index - TagConstants.DoubleTF_FirstTextfield_Tag
         }else if isSecondTf {
         index = index - TagConstants.DoubleTF_SecondTextfield_Tag
         }
         
         if let dict = self.arrInput[index] as? InputTextfieldModel{
         }else{
         if  isFirstTf{
         dictIndex = 0
         }else if isSecondTf {
         dictIndex = 1
         }
         }
         }*/
        
        return (index,dictIndex)
    }
    
    func getIndexForMultipleTf(textFieldTag : Int) -> Int{
        var index = textFieldTag
        var dictIndex = 0
        if index < TagConstants.DoubleTF_FirstTextfield_Tag{
        }else if textFieldTag >= TagConstants.RecursiveTF_FirstTextfield_Tag{
            let isFirstTf = index - TagConstants.RecursiveTF_FirstTextfield_Tag >= 0 && index - TagConstants.RecursiveTF_FirstTextfield_Tag < TagConstants.DoubleTF_FirstTextfield_Tag
            let isSecondTf = index >= TagConstants.RecursiveTF_SecondTextfield_Tag && index < TagConstants.RecursiveTF_ThirdTextfield_Tag
            
            if  isFirstTf{
                index = index - TagConstants.RecursiveTF_FirstTextfield_Tag
            }else if isSecondTf {
                index = index - TagConstants.RecursiveTF_SecondTextfield_Tag
            }else{
                index = index - TagConstants.RecursiveTF_ThirdTextfield_Tag
            }
            
            //            if let cell = self.activeTextfield?.superview?.superview as? RecursiveBPCell{
            //                if let indexPath = self.tblView.indexPath(for: cell){
            //                    if let mainArray = self.arrInput[indexPath.section] as? [Any]{
            //                        var copyMainArray = mainArray
            //                        if let subArray = copyMainArray[indexPath.row] as? [InputTextfieldModel]{
            //                            let dictIndex = self.getIndexForMultipleTf(textFieldTag: self.activeTextfieldTag)
            //                        }
            //                    }
            //                }
            //            }
            
            
            //        if let dict = self.arrInput[index] as? [Any]{
            //        }else{
            if  isFirstTf{
                dictIndex = 0
            }else if isSecondTf {
                dictIndex = 1
            }else{
                dictIndex = 2
            }
            //  }
        }else{
            let isFirstTf = index - TagConstants.DoubleTF_FirstTextfield_Tag >= 0 && index - TagConstants.DoubleTF_FirstTextfield_Tag < TagConstants.DoubleTF_FirstTextfield_Tag
            let isSecondTf = index >= TagConstants.DoubleTF_SecondTextfield_Tag
            
            if  isFirstTf{
                index = index - TagConstants.DoubleTF_FirstTextfield_Tag
            }else if isSecondTf {
                index = index - TagConstants.DoubleTF_SecondTextfield_Tag
            }
            
            if let dict = self.arrInput[index] as? InputTextfieldModel{
            }else{
                if  isFirstTf{
                    dictIndex = 0
                }else if isSecondTf {
                    dictIndex = 1
                }
            }
        }
        return dictIndex
    }
}


//MARK:- PickerInputCellDelegate
extension NCFNutritionViewController : PickerInputCellDelegate{
    func selectedPickerValueForInput(value: Any, valueID: Any, textfieldTag: Int) {
        debugPrint("value = \(value) --- Tf tag \(textfieldTag)")
        
        if let cell = self.activeTextfield?.superview?.superview as? PickerInputCell{
            if let indexPath = self.tblView.indexPath(for: cell){
                if let dictArr = (self.arrInput[indexPath.section] as? [Any]){
                    var copyArr = dictArr
                    if let dict = dictArr[indexPath.row] as? InputTextfieldModel{
                        let copyDict = dict
                        copyDict.value = (value as? String) ?? ""
                        copyDict.valueId = valueID
                        copyDict.isValid = !(((value as? String) ?? "").count == 0)
                        copyArr[indexPath.row] = copyDict
                        self.arrInput[indexPath.section] = copyArr
                        cell.inputTf.text = (value as? String) ?? ""
                        
                    }
                }
            }
        }
        /*
         let index = self.activeTextfieldTag
         let indexPath = IndexPath(row: index, section: 0)
         if let indexPath = self.tblView.indexPath(for: (self.activeTextfield?.superview?.superview as! PickerInputCell)){
         if let dictArr = (self.arrInput[indexPath.section] as? [Any]){
         var copyArr = dictArr
         if let dict = dictArr[indexPath.row] as? InputTextfieldModel{
         let copyDict = dict
         copyDict.value = (value as? String) ?? ""
         copyDict.valueId = valueID
         copyDict.isValid = true
         copyArr[indexPath.row] = copyDict
         self.arrInput[indexPath.section] = copyArr
         }
         }
         }
         /*
         if let dict = self.arrInput[index] as? InputTextfieldModel{
         let copyDict = dict
         copyDict.value = (value as? String) ?? ""
         copyDict.valueId = valueID
         copyDict.isValid = true
         self.arrInput[index] = copyDict
         }*/
         
         if let cell = self.tblView.cellForRow(at: indexPath) as? PickerInputCell{
         cell.inputTf.text = (value as? String) ?? ""
         }*/
    }
    
}

//MARK:- DoubleInputCellDelegate
extension NCFNutritionViewController : DoubleInputCellDelegate{
    func selectedDateForDoubleInput(date : Date, textfieldTag : Int, isDateField : Bool){
        let dateStr = Utility.getStringFromDate(date: date, dateFormat: isDateField ? DateFormats.mm_dd_yyyy : DateFormats.hh_mm_a)
        
        self.setSelectedValueInTextfield(value: dateStr, valueId: date, index: self.activeTextfieldTag)
    }
    
    func selectedPickerValueForDoubleInput(value : Any, valueID : Any, textfieldTag : Int)
    {
        
        self.setSelectedValueInTextfield(value: value, valueId: valueID, index: self.activeTextfieldTag)
    }
    
    func setSelectedValueInTextfield(value : Any , valueId : Any, index : Int){
        let indexTuple = self.getIndexAndSubIndexFromTag(textFieldTag: self.activeTextfieldTag)
        let index = indexTuple.0
        var dictIndex = indexTuple.1
        
        let isFirstTf = index - TagConstants.DoubleTF_FirstTextfield_Tag >= 0 && index - TagConstants.DoubleTF_FirstTextfield_Tag < TagConstants.DoubleTF_FirstTextfield_Tag
        dictIndex = self.getIndexForMultipleTf(textFieldTag: self.activeTextfieldTag)
        if let indexPath = self.tblView.indexPath(for: (self.activeTextfield?.superview?.superview as! DoubleInputCell)){//IndexPath(row: index, section: 0){
            
            if let dictArr = (self.arrInput[indexPath.section] as! [Any]) as? [InputTextfieldModel]{
                var copyArr = dictArr
                let dict = copyArr[dictIndex]
                dict.value = (value as? String) ?? ""
                dict.valueId = valueId
                dict.isValid = true
                copyArr[dictIndex] = dict
                self.arrInput[index] = copyArr
            }
            let reqdIndex = self.activeTextfieldTag < TagConstants.DoubleTF_SecondTextfield_Tag ? 0 : 1
            
            if let dictArr = (self.arrInput[indexPath.section] as? [Any]){
                var copyArr = dictArr
                if let arrSub = dictArr[indexPath.row] as? [InputTextfieldModel]{
                    var copySubArray = arrSub
                    let dict = arrSub[reqdIndex]
                    if ((dict.inputType ?? "") == InputType.Dropdown){
                        if let arr = dict.dropdownArr as? [Any]{
                            
                            dict.value = (value as? String) ?? ""
                            dict.valueId = valueId
                            dict.isValid = true
                            copySubArray[reqdIndex] = dict
                            copyArr[indexPath.row] = copySubArray
                            self.arrInput[indexPath.section] = copyArr
                        }
                    }
                    
                }
            }
            
            if let cell = self.tblView.cellForRow(at: indexPath) as? DoubleInputCell{
                if  dictIndex == reqdIndex{
                    cell.inputTf1.text = (value as? String) ?? ""
                }else{
                    cell.inputTf2.text = (value as? String) ?? ""
                }
            }
        }
    }
}

//MARK:- DateTimeInputCellDelegate
extension NCFNutritionViewController : DateTimeInputCellDelegate{
    func selectedDateForInput(date: Date, textfieldTag: Int, isDateField : Bool) {
        let dateStr = Utility.getStringFromDate(date: date, dateFormat: isDateField ? DateFormats.mm_dd_yyyy : DateFormats.hh_mm_a)
        debugPrint("Date = \(dateStr) --- Tf tag \(textfieldTag)")
        
        if let cell = self.activeTextfield?.superview?.superview as? DateTimeInputCell{
            if let indexPath = self.tblView.indexPath(for: (cell)) {
                if let dictArr = self.arrInput[indexPath.section] as? [Any]{
                    if let arrayInputTextfieldModel = dictArr as? [InputTextfieldModel]{
                        
                        var copyArr = arrayInputTextfieldModel
                        let dict = copyArr[indexPath.row]
                        
                        if ((dict.inputType ?? "") == InputType.Time){
                            dict.value = dateStr
                            dict.valueId = dateStr
                            dict.isValid = true
                            copyArr[indexPath.row] = dict
                            self.arrInput[indexPath.section] = copyArr
                            cell.inputTf.text = dateStr
                        }
                    }else{
                        if var dictArrH = self.arrInput[indexPath.section] as? [Any]{
                            if let dict = dictArrH [indexPath.row] as? InputTextfieldModel{
                                if ((dict.inputType ?? "") == InputType.Time){
                                    dict.value = dateStr
                                    dict.valueId = dateStr
                                    dict.isValid = true
                                    dictArrH[indexPath.row] = dict
                                    self.arrInput[indexPath.section] = dictArrH
                                    cell.inputTf.text = dateStr
                                }
                            }
                        }
                    }
                }
            }
        }else if let cell = self.activeTextfield?.superview?.superview as? RecursiveBPCell{
            if let indexPath = self.tblView.indexPath(for: cell){
                if let mainArray = self.arrInput[indexPath.section] as? [Any]{
                    var copyMainArray = mainArray
                    if let subArray = copyMainArray[indexPath.row] as? [InputTextfieldModel]{
                        var copySubArray = subArray
                        let dictIndex = self.getIndexForMultipleTf(textFieldTag: self.activeTextfieldTag)
                        var dict = copySubArray[dictIndex]
                        var copyDict = dict
                        dict.value = dateStr
                        dict.valueId = dateStr
                        dict.isValid = true
                        copySubArray[dictIndex] = copyDict
                        copyMainArray[indexPath.row] = copySubArray
                        self.arrInput[indexPath.section] = copyMainArray
                        
                        let isFirstTf = dictIndex == 0
                        let isSecondTf = dictIndex == 1
                        
                        if  isFirstTf{
                            cell.inputTf1.text = dateStr
                        }else if isSecondTf {
                            cell.inputTf2.text = dateStr
                        }else{
                            cell.inputTf3.text = dateStr
                        }
                    }
                }
            }
        }
        
    }
}

//MARK:- RecursiveBPCellDelegate
extension NCFNutritionViewController : RecursiveBPCellDelegate{
    func selectedDateForRecursiveInput(date: Date, textfieldTag: Int, isDateField: Bool) {
        let dateStr = Utility.getStringFromDate(date: date, dateFormat: isDateField ? DateFormats.mm_dd_yyyy : DateFormats.hh_mm_a)
        
        if let cell = self.activeTextfield?.superview?.superview as? RecursiveBPCell{
            if let indexPath = self.tblView.indexPath(for: cell){
                if let mainArray = self.arrInput[indexPath.section] as? [Any]{
                    var copyMainArray = mainArray
                    if let subArray = copyMainArray[indexPath.row] as? [InputTextfieldModel]{
                        var copySubArray = subArray
                        let dictIndex = self.getIndexForMultipleTf(textFieldTag: self.activeTextfieldTag)
                        var dict = copySubArray[dictIndex]
                        var copyDict = dict
                        copyDict.value = dateStr
                        copyDict.valueId = dateStr
                        copyDict.isValid = !(dateStr.count == 0)
                        copySubArray[dictIndex] = copyDict
                        copyMainArray[indexPath.row] = copySubArray
                        self.arrInput[indexPath.section] = copyMainArray
                        
                        let isFirstTf = dictIndex == 0
                        let isSecondTf = dictIndex == 1
                        
                        if  isFirstTf{
                            cell.inputTf1.text = dateStr
                        }else if isSecondTf {
                            cell.inputTf2.text = dateStr
                        }else{
                            cell.inputTf3.text = dateStr
                        }
                        
                        
                        print("Total=== \(self.getTotalValueOfType(type: dict.sectionHeader ?? ""))")
                        print("Textfield === \(self.getTotalTextfieldForType(type: dict.sectionHeader ?? ""))")
                        
                    }
                }
            }
        }
        
    }
    
    func selectedPickerValueForRecursiveInput(value: Any, valueID: Any, textfieldTag: Int) {
        self.setSelectedValueInRecursiveTextfield(value: value, valueId: valueID, index: self.activeTextfieldTag)
        
    }
    
    func setSelectedValueInRecursiveTextfield(value : Any , valueId : Any, index : Int){
        if let cell = self.activeTextfield?.superview?.superview as? RecursiveBPCell{
            if let indexPath = self.tblView.indexPath(for: cell){
                if let mainArray = self.arrInput[indexPath.section] as? [Any]{
                    var copyMainArray = mainArray
                    if let subArray = copyMainArray[indexPath.row] as? [InputTextfieldModel]{
                        var copySubArray = subArray
                        let dictIndex = self.getIndexForMultipleTf(textFieldTag: self.activeTextfieldTag)
                        var dict = copySubArray[dictIndex]
                        var copyDict = dict
                        copyDict.value = (value as? String) ?? ""
                        copyDict.valueId = valueId
                        copyDict.isValid = !(((value as? String) ?? "").count == 0)
                        copySubArray[dictIndex] = copyDict
                        copyMainArray[indexPath.row] = copySubArray
                        self.arrInput[indexPath.section] = copyMainArray
                        
                        let isFirstTf = dictIndex == 0
                        let isSecondTf = dictIndex == 1
                        
                        if  isFirstTf{
                            cell.inputTf1.text = (value as? String) ?? ""
                        }else if isSecondTf {
                            cell.inputTf2.text = (value as? String) ?? ""
                        }else{
                            cell.inputTf3.text = (value as? String) ?? ""
                        }
                        
                        print("Total=== \(self.getTotalValueOfType(type: dict.sectionHeader ?? ""))")
                        print("Textfield === \(self.getTotalTextfieldForType(type: dict.sectionHeader ?? ""))")
                        
                    }
                }
            }
        }else{
            
        }
        
        
        /*
         let indexTuple = self.getIndexAndSubIndexFromTag(textFieldTag: self.activeTextfieldTag)
         let index = indexTuple.0
         let dictIndex = indexTuple.1
         
         let isFirstTf = index - TagConstants.RecursiveTF_FirstTextfield_Tag > 0 && index - TagConstants.RecursiveTF_FirstTextfield_Tag < TagConstants.DoubleTF_FirstTextfield_Tag
         let isSecondTf = index >= TagConstants.RecursiveTF_SecondTextfield_Tag && index < TagConstants.RecursiveTF_ThirdTextfield_Tag
         
         let indexPath = IndexPath(row: index, section: 0)
         
         if let dictArr = self.arrInput[index] as? [InputTextfieldModel]{
         var copyArr = dictArr
         let dict = copyArr[dictIndex]
         dict.value = (value as? String) ?? ""
         dict.valueId = valueId
         dict.isValid = true
         copyArr[dictIndex] = dict
         self.arrInput[index] = copyArr
         }
         
         if let cell = self.tblView.cellForRow(at: indexPath) as? RecursiveBPCell{
         if  isFirstTf{
         cell.inputTf1.text = (value as? String) ?? ""
         }else if isSecondTf {
         cell.inputTf2.text = (value as? String) ?? ""
         }else{
         cell.inputTf3.text = (value as? String) ?? ""
         }
         }*/
    }
    
    
}


