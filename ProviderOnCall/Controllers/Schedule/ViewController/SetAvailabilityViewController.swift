//
//  SetAvailabilityViewController.swift
//  AccessEMR
//
//  Created by Vasundhara Parakh on 5/21/20.
//  Copyright © 2020 smartData Enterprises (I) Ltd. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
class SetAvailabilityViewController: BaseViewController {
    @IBOutlet weak var tblView: UITableView!
    var arrInput = [Any]()
    var activeTextfieldTag = 0
    var isReadyToSave = false
    var isValidating = false
    var patientId = 0
    var activeTextfield : InputTextField?
    var selectedSection = 0
    let apiName = APITargetPoint.save_NCF_Nutrition
    var selectedShiftId = 0
    lazy var viewModel: SetAvailabilityViewModel = {
        let obj = SetAvailabilityViewModel(with: VirtualConsultService())
        self.baseViewModel = obj
        return obj
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerNIBs()
        self.initialSetup()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        IQKeyboardManager.shared.previousNextDisplayMode = .alwaysHide

    }
    func initialSetup(){
        //Setup navigation bar
        self.navigationItem.title =  "Availability & Unavailability"
        self.addBackButton()
        self.addrightBarButtonItem()
        self.setupClosures()
        self.viewModel.getShiftDropdown(unitID: 0)
//        self.arrInput = self.viewModel.getInputArray() ?? [""]
//        self.tblView.reloadData()
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
        self.tblView.register(UINib(nibName: ReuseIdentifier.RecursiveTaskCell, bundle: nil), forCellReuseIdentifier: ReuseIdentifier.RecursiveTaskCell)


    }
    func setupClosures() {
        self.viewModel.updateViewClosure = { [weak self] () in
            DispatchQueue.main.async {
                self?.arrInput = self?.viewModel.getInputArray() ?? [""]
                self?.tblView.reloadData()
            }
        }
        
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
        
        let inputParams = self.createAPIParams()
        if inputParams.keys.count == 5{
            self.viewModel.saveAvailability(params: inputParams)
        }
        /*
        /*
        let countFluidIntake = (self.getSubDicts(keyName: Key.Params.NursingCareFlow.Nutrition.dynamicFluidIntake, type: NursingTitles.Nutrition.FluidIntake.FluidIntake).1) * 3
        let countBowel = (self.getSubDicts(keyName: Key.Params.NursingCareFlow.Nutrition.dynamicBowel, type: NursingTitles.Nutrition.Bowel.Bowel).1) * 3
        let countUrinaryVoids = (self.getSubDicts(keyName: Key.Params.NursingCareFlow.Nutrition.dynamicUrinary, type: NursingTitles.Nutrition.UrinaryVoids.UrinaryVoids).1) * 3
        let countEmesis = (self.getSubDicts(keyName: Key.Params.NursingCareFlow.Nutrition.dynamicEmesis, type: NursingTitles.Nutrition.Emesis.Emesis).1) * 2
        let countBloodLoss = (self.getSubDicts(keyName: Key.Params.NursingCareFlow.Nutrition.dynamicBloodLoss, type: NursingTitles.Nutrition.BloodLoss.BloodLoss).1) * 2

        paramsCountLimit += (countFluidIntake + countBowel + countUrinaryVoids + countEmesis + countBloodLoss)*/
         if inputParams.keys.count == 27{
            self.viewModel.saveNursingCare(apiName: apiName, params: self.createAPIParams(isDraft: false, moodID: 0))
        }else{
            self.viewModel.errorMessage = "Please fill missing inputs."
            
        }*/
    }
    
    func createAPIParams() -> [String : Any]{
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
        
        /*
        print("Checkk==== \(self.getSubDicts(keyName: Key.Params.NursingCareFlow.Nutrition.dynamicFluidIntake, type: NursingTitles.Nutrition.FluidIntake.FluidIntake)))")
        print("Checkk==== \(self.getSubDicts(keyName: Key.Params.NursingCareFlow.Nutrition.dynamicBloodLoss, type: NursingTitles.Nutrition.BloodLoss.BloodLoss)))")
        print("Checkk==== \(self.getSubDicts(keyName: Key.Params.NursingCareFlow.Nutrition.dynamicEmesis, type: NursingTitles.Nutrition.Emesis.Emesis)))")
        print("Checkk==== \(self.getSubDicts(keyName: Key.Params.NursingCareFlow.Nutrition.dynamicUrinary, type: NursingTitles.Nutrition.UrinaryVoids.UrinaryVoids)))")
        */
        var paramDict : [String : Any] = [:]
        keyMainArray += keyMainArray
        
        for (_,(key,value)) in keyMainArray.enumerated() {
            if let val  = value as? String{
                if val != ""{
                    paramDict[key] = value
                }
            }else if let val  = value as? Int{
                if val != 0{
                    paramDict[key] = value
                }
            }else{
                paramDict[key] = value
            }
        }
        paramDict.merge(dict: self.getSubDicts(keyName: "available", type: "Availability Date & Time").0)
        paramDict.merge(dict: self.getSubDicts(keyName: "unavailable", type: "Unavailability Date & Time").0)
        paramDict["locationId"] = (AppInstance.shared.user?.staffLocation?[0])?.locationID ?? 0
        paramDict["staffID"] = AppInstance.shared.user?.id ?? 0
        paramDict["masterShiftId"] = self.selectedShiftId
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
                    if dict.valueId != nil {
                    tempDict[dict.apiKey ?? ""] = dict.valueId ?? ""
                    tempDict["locationId"] = (AppInstance.shared.user?.staffLocation?[0])?.locationID ?? 0
                    tempDict["staffID"] = AppInstance.shared.user?.id ?? 0
                    tempDict["isActive"] = true
                    tempDict["isDeleted"] = false
                    tempDict["staffAvailabilityTypeID"] = type == "Availability Date & Time" ? 74 : 75
                    }
                }
                if index == 2{
                    if dict.valueId != nil {
                        subArray.append(tempDict)
                    }
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

extension SetAvailabilityViewController : UITableViewDelegate, UITableViewDataSource{
    
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
                    return Device.IS_IPAD ? 250 : 190
                }
            }
        }
        if let arr = self.arrInput[indexPath.section] as? [Any]{
            if let dictArr = arr[indexPath.row] as? [InputTextfieldModel] , dictArr.count == 2{
                let tfOneDict = dictArr[0]

                let title = tfOneDict.sectionHeader ?? ""
                if title == NursingTitles.Nutrition.Emesis.Emesis || title == NursingTitles.Nutrition.BloodLoss.BloodLoss {
                    return Device.IS_IPAD ? 200 : 160
                }else{
                    return Device.IS_IPAD ? 250 : 190
                }
            }
        }
        return Device.IS_IPAD ? 80 : 60//UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let arr = (self.arrInput[section] as? [Any]){
            return arr.count
        }else{
            if let singleInput = self.arrInput[section] as? InputTextfieldModel{
                return 1
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
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
        //self.arrInput[indexPath.row]
        if let dict = inputDict as? InputTextfieldModel {
            let inputType = dict.inputType
            switch inputType {
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
                let cell = tableView.dequeueReusableCell(withIdentifier: ReuseIdentifier.RecursiveTaskCell, for: indexPath as IndexPath) as! RecursiveTaskCell
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
                    cell.heightInputTf3.constant = 45
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
        if let cell = button.superview?.superview as? RecursiveTaskCell{
            if let indexPath = self.tblView.indexPath(for: cell){
                if let mainArray = self.arrInput[indexPath.section] as? [Any] {
                    var copyMainArray = mainArray
                    var type = ""
                    if let dictArr = mainArray[indexPath.row] as? [InputTextfieldModel] {
                        let tfOneDict = dictArr[0]
                        type = tfOneDict.sectionHeader ?? ""
                    }
                    
                    var addObject = self.viewModel.getAvailabilityInput()
                    
                    switch type {
                    case "Availability Date & Time":
                        addObject = self.viewModel.getAvailabilityInput()
                    case "Unavailability Date & Time":
                        addObject = self.viewModel.getUnAvailabilityInput()
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

        if let cell = button.superview?.superview as? RecursiveTaskCell{
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
extension SetAvailabilityViewController : UITextFieldDelegate{
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
                        }else if let cell = textField.superview?.superview as? RecursiveTaskCell{
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
                                        }else if((dict.inputType ?? "") == InputType.Date){
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
                        if let cell = textField.superview?.superview as? RecursiveTaskCell{
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
                                                        else if((dict.inputType ?? "") == InputType.Date){
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
                    
                    /*
                    
                    if tfToUpdate.text?.count == 0{
                        let index = self.getIndexAndSubIndexFromTag(textFieldTag: self.activeTextfieldTag).0
                        let dictIndex = self.getIndexAndSubIndexFromTag(textFieldTag: self.activeTextfieldTag).1
                        if let cell = textField.superview?.superview as? DoubleInputCell{
                        if let indexPath = self.tblView.indexPath(for: (cell)) {
                            if let dictArr = (self.arrInput[indexPath.section] as! [Any]) as? [InputTextfieldModel]{
                                var copyArr = dictArr
                                let dict = copyArr[dictIndex]

                                 if ((dict.inputType ?? "") == InputType.Dropdown){
                                    if let cell = self.tblView.cellForRow(at: indexPath) as? DoubleInputCell{
                                        cell.pickerView.reloadAllComponents()
                                    }

                                    if let arr = dict.dropdownArr as? [Any]{
                                        let selectedValue = Utility.getSelectedValue(arrDropdown: arr,row: 0)

                                        dict.value = selectedValue.value
                                        dict.valueId = selectedValue.valueID
                                    dict.isValid = true
                                    copyArr[dictIndex] = dict
                                    self.arrInput[index] = copyArr
                                    textField.text = selectedValue.value
                                    }
                                    
//                                    let tempDict = inputDict
//                                    if let arr = tempDict.dropdownArr as? [Any]{
//                                        let selectedValue = Utility.getSelectedValue(arrDropdown: arr,row: 0)
//                                        tempDict.value = selectedValue.value
//                                        tempDict.valueId = selectedValue.valueID
//                                        tempDict.isValid = true
//                                        self.arrInput[self.activeTextfieldTag] = tempDict
//                                        textField.text = selectedValue.value
//                                    }

                                }
                            }else{
                                var copyMainArray = self.arrInput
                                var copySubArray = self.arrInput[indexPath.section] as! [Any]
                                if let dictArr = (self.arrInput[indexPath.section] as! [Any])[indexPath.row] as? [InputTextfieldModel]{
                                    var copyArr = dictArr
                                    let dict = copyArr[dictIndex]
                                    if (dict.inputType ?? "") == InputType.Date || (dict.inputType ?? "") == InputType.Time{
                                        let isDate = (dict.inputType ?? "") == InputType.Date
                                        let dateStr = Utility.getStringFromDate(date: Date(), dateFormat: isDate ? DateFormats.mm_dd_yyyy : DateFormats.hh_mm_a)
                                        
                                        dict.value = dateStr
                                        dict.valueId = Date()
                                        dict.isValid = true
                                        copyArr[dictIndex] = dict
                                        //self.arrInput[index] = copyArr
                                        
                                        copySubArray[indexPath.row] = copyArr
                                        copyMainArray[indexPath.section] = copySubArray
                                        self.arrInput = copyMainArray
                                        
                                        textField.text = dateStr
                                    }else if ((dict.inputType ?? "") == InputType.Dropdown){
                                        if let arr = dict.dropdownArr as? [Any]{
                                            let selectedValue = Utility.getSelectedValue(arrDropdown: arr,row: 0)

                                            dict.value = selectedValue.value
                                            dict.valueId = selectedValue.valueID
                                        dict.isValid = true
                                        copyArr[dictIndex] = dict
                                        //self.arrInput[index] = copyArr
                                            copySubArray[indexPath.row] = copyArr
                                            copyMainArray[indexPath.section] = copySubArray
                                            self.arrInput = copyMainArray

                                        textField.text = selectedValue.value
                                        }
                                    }else{
                                        dict.value = textField.text
                                        dict.valueId = textField.text
                                        dict.isValid = true
                                        copyArr[dictIndex] = dict
                                        self.arrInput[index] = copyArr

                                    }
                                }
                            }
                        }
                        }else{

                        if let inputDict = self.arrInput[index] as? InputTextfieldModel{
                             if ((inputDict.inputType ?? "") == InputType.Dropdown){
                                let tempDict = inputDict
                                if let arr = tempDict.dropdownArr as? [Any]{
                                    let selectedValue = Utility.getSelectedValue(arrDropdown: arr,row: 0)
                                    tempDict.value = selectedValue.value
                                    tempDict.valueId = selectedValue.valueID
                                    tempDict.isValid = true
                                    self.arrInput[self.activeTextfieldTag] = tempDict
                                    textField.text = selectedValue.value
                                }

                            }
                        }else{
                            if let dictArr = self.arrInput[index] as? [InputTextfieldModel]{
                                var copyArr = dictArr
                                let dict = copyArr[dictIndex]
                                if (dict.inputType ?? "") == InputType.Date || (dict.inputType ?? "") == InputType.Time{
                                    let isDate = (dict.inputType ?? "") == InputType.Date
                                    let dateStr = Utility.getStringFromDate(date: Date(), dateFormat: isDate ? DateFormats.mm_dd_yyyy : DateFormats.hh_mm_a)
                                    
                                    dict.value = dateStr
                                    dict.valueId = Date()
                                    dict.isValid = true
                                    copyArr[dictIndex] = dict
                                    self.arrInput[index] = copyArr
                                    textField.text = dateStr
                                }else if ((dict.inputType ?? "") == InputType.Dropdown){
                                    if let arr = dict.dropdownArr as? [Any]{
                                        let selectedValue = Utility.getSelectedValue(arrDropdown: arr,row: 0)

                                        dict.value = selectedValue.value
                                        dict.valueId = selectedValue.valueID
                                    dict.isValid = true
                                    copyArr[dictIndex] = dict
                                    self.arrInput[index] = copyArr
                                    textField.text = selectedValue.value
                                    }
                                }else{
                                    dict.value = textField.text
                                    dict.valueId = textField.text
                                    dict.isValid = true
                                    copyArr[dictIndex] = dict
                                    self.arrInput[index] = copyArr

                                }
                            }
                        }
                        }
                    }else{
                        if let cell = textField.superview?.superview as? DoubleInputCell{
                            cell.pickerView.reloadAllComponents()
                        }
                    }
                    */
                        
                }
//                    else{
//                        self.updateTextfieldAndPickerForRow(row:  self.getSelectedValueIndex(valueTitle: tfToUpdate.text!, textfieldTag: textField.tag), tfToUpdate: textField as! InputTextField)
//                    }
                }
    }
    
    func updateTextfieldAndPickerForRow(row: Int, tfToUpdate : InputTextField){


    }
    
    func getSelectedValueIndex(valueTitle : String, textfieldTag : Int) -> Int{
        //let dict = self.arrInput[textfieldTag]
        return 0
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

        /*
        if textField.tag == self.arrInput.count - 1{
            IQKeyboardManager.shared.toolbarDoneBarButtonItemText = ButtonTitles.done
            textField.keyboardToolbar.doneBarButton.setTarget(self, action: #selector(doneAction(textField:)))
            
        }else{
            IQKeyboardManager.shared.toolbarDoneBarButtonItemText = ButtonTitles.next
            textField.keyboardToolbar.doneBarButton.setTarget(self, action: #selector(nextAction(textField:)))
            
        }*/
        return true
    }
    @objc func doneAction(textField:UITextField){
        textField.resignFirstResponder()

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
                if let indexPath = self.tblView.indexPath(for: (cell)) {
                    if let arrInput = self.arrInput[indexPath.section] as? [Any]{
                        if let dictArr = arrInput as? [InputTextfieldModel]{
                            var copyArr = dictArr
                            let dict = copyArr[indexPath.row]
                            if ((dict.inputType ?? "") == InputType.Dropdown){
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
            if let cell = textField.superview?.superview as? RecursiveTaskCell{
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
        
//            if let cell = self.activeTextfield?.superview?.superview as? RecursiveTaskCell{
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
extension SetAvailabilityViewController : PickerInputCellDelegate{
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
extension SetAvailabilityViewController : DoubleInputCellDelegate{
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
extension SetAvailabilityViewController : DateTimeInputCellDelegate{
    func selectedDateForInput(date: Date, textfieldTag: Int, isDateField : Bool) {
        let dateStr = Utility.getStringFromDate(date: date, dateFormat: isDateField ? DateFormats.mm_dd_yyyy : DateFormats.hh_mm_a)
        debugPrint("Date = \(dateStr) --- Tf tag \(textfieldTag)")
        
        if let cell = self.activeTextfield?.superview?.superview as? DateTimeInputCell{
            
            if let indexPath = self.tblView.indexPath(for: (cell)) {
                if let dictArr = (self.arrInput[indexPath.section] as! [Any]) as? [InputTextfieldModel]{
                    
                    var copyArr = dictArr
                    let dict = copyArr[indexPath.row]
                    
                    if ((dict.inputType ?? "") == InputType.Time){
                        dict.value = dateStr
                        dict.valueId = dateStr
                        dict.isValid = true
                        copyArr[indexPath.row] = dict
                        self.arrInput[indexPath.section] = copyArr
                        cell.inputTf.text = dateStr
                    }
                }
            }
        }else if let cell = self.activeTextfield?.superview?.superview as? RecursiveTaskCell{
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

//MARK:- RecursiveTaskCellDelegate
extension SetAvailabilityViewController : RecursiveTaskCellDelegate{
    func selectedDateForRecursiveInput(date: Date, textfieldTag: Int, isDateField: Bool) {
        let dateStr = Utility.getStringFromDate(date: date, dateFormat: isDateField ? DateFormats.mm_dd_yyyy : DateFormats.hh_mm_a)

        if let cell = self.activeTextfield?.superview?.superview as? RecursiveTaskCell{
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
        if let cell = self.activeTextfield?.superview?.superview as? RecursiveTaskCell{
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
        
        if let cell = self.tblView.cellForRow(at: indexPath) as? RecursiveTaskCell{
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

