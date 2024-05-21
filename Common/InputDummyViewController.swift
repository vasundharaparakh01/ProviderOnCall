//
//  InputDummyViewController.swift
//  appName
//
//  Created by Vasundhara Parakh on 3/2/20.
//  Copyright © 2020 smartData Enterprises (I) Ltd. All rights reserved.
//

import UIKit


import UIKit
import IQKeyboardManagerSwift

class InputDummyViewController: BaseViewController {
    @IBOutlet weak var tblView: UITableView!
    lazy var viewModel: AddVitalsViewModel = {
        let obj = AddVitalsViewModel(service: MasterService())
        self.baseViewModel = obj
        return obj
    }()
    var arrInput = [Any]()
    var activeTextfieldTag = 0
    var isReadyToSave = false
    var isValidating = false
    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerNIBs()
        self.initialSetup()
        self.setupClosures()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        IQKeyboardManager.shared.previousNextDisplayMode = .alwaysHide

    }
    func initialSetup(){
        //Setup navigation bar
        self.navigationItem.title = NavigationTitle.AddVital
        self.addBackButton()
        self.addrightBarButtonItem()
        self.viewModel.getVitalsMasterData()
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        IQKeyboardManager.shared.previousNextDisplayMode = .Default
    }

    
    func registerNIBs(){
        self.tblView.register(UINib(nibName: ReuseIdentifier.TextInputCell, bundle: nil), forCellReuseIdentifier: ReuseIdentifier.TextInputCell)
        self.tblView.register(UINib(nibName: ReuseIdentifier.NumberInputCell, bundle: nil), forCellReuseIdentifier: ReuseIdentifier.NumberInputCell)
        self.tblView.register(UINib(nibName: ReuseIdentifier.PickerInputCell, bundle: nil), forCellReuseIdentifier: ReuseIdentifier.PickerInputCell)
        self.tblView.register(UINib(nibName: ReuseIdentifier.DateTimeInputCell, bundle: nil), forCellReuseIdentifier: ReuseIdentifier.DateTimeInputCell)
        self.tblView.register(UINib(nibName: ReuseIdentifier.DecimalInputCell, bundle: nil), forCellReuseIdentifier: ReuseIdentifier.DecimalInputCell)
        self.tblView.register(UINib(nibName: ReuseIdentifier.DoubleInputCell, bundle: nil), forCellReuseIdentifier: ReuseIdentifier.DoubleInputCell)
        self.tblView.register(UINib(nibName: ReuseIdentifier.RecursiveBPCell, bundle: nil), forCellReuseIdentifier: ReuseIdentifier.RecursiveBPCell)

        
    }
    func setupClosures() {
        self.viewModel.updateViewClosure = { [weak self] () in
            DispatchQueue.main.async {
                self?.arrInput = self?.getInputArray() ?? [""]
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
        self.isValidating = true
        self.tblView.reloadData()
        print("API Input Params = \(createAPIParams())")
    }

   

    
    func getInputArray() -> [Any]{
        return [    InputTextfieldModel(value: "", placeholder: "Vital Date & Time *",apiKey: Key.Params.vitalDate, valueId: nil, inputType:InputType.Date, dropdownArr: nil,isValid: false, errorMessage: ConstantStrings.mandatory),
                InputTextfieldModel(value: "", placeholder: "Heart Rate (BPM) *", apiKey: Key.Params.heartRate, valueId: nil, inputType: InputType.Number, dropdownArr: nil,isValid: false, errorMessage: ConstantStrings.mandatory),
                [InputTextfieldModel(value: "", placeholder: "BP Systolic *", apiKey: Key.Params.bpSystolic, valueId: nil, inputType: InputType.Decimal, dropdownArr: nil,isValid: false, errorMessage: ConstantStrings.mandatory),
                InputTextfieldModel(value: "", placeholder: "BP Diastolic *", apiKey: Key.Params.bpDiastolic, valueId: nil, inputType: InputType.Decimal, dropdownArr: nil,isValid: false, errorMessage: ConstantStrings.mandatory),
                InputTextfieldModel(value: "", placeholder: "Position *", apiKey: Key.Params.position, valueId: nil, inputType: InputType.Dropdown, dropdownArr: ["1","2"],isValid: false, errorMessage: ConstantStrings.mandatory)],
                InputTextfieldModel(value: "", placeholder: "BP Method *", apiKey: Key.Params.vitalBPMethodId, valueId: nil, inputType: InputType.Dropdown, dropdownArr: ["1","2"],isValid: false, errorMessage: ConstantStrings.mandatory),
                InputTextfieldModel(value: "", placeholder: "Resp Rate (BPM) *", apiKey: Key.Params.respiration, valueId: nil, inputType: InputType.Dropdown, dropdownArr: ["1","2"],isValid: false, errorMessage: ConstantStrings.mandatory),
                InputTextfieldModel(value: "", placeholder: "sp02 *", apiKey: Key.Params.saturation, valueId: nil, inputType: InputType.Dropdown, dropdownArr: ["1","2"],isValid: false, errorMessage: ConstantStrings.mandatory),
                [InputTextfieldModel(value: "", placeholder: "Body Temperature *", apiKey: Key.Params.temperature, valueId: nil, inputType: InputType.Decimal, dropdownArr: nil,isValid: false, errorMessage: ConstantStrings.mandatory),
                InputTextfieldModel(value: "", placeholder: "Unit *", apiKey: Key.Params.vitalTempUnitId, valueId: nil, inputType: InputType.Dropdown, dropdownArr: ["1","2"],isValid: false, errorMessage: ConstantStrings.mandatory)],
                InputTextfieldModel(value: "", placeholder: "Body temp measurement site *", apiKey: Key.Params.vitalTempMeasurmentSiteId, valueId: nil, inputType: InputType.Dropdown, dropdownArr: ["1","2"],isValid: false, errorMessage: ConstantStrings.mandatory),
                InputTextfieldModel(value: "", placeholder: "Body temp device class *", apiKey: Key.Params.vitalTempDeviceId, valueId: nil, inputType: InputType.Dropdown, dropdownArr: ["1","2"],isValid: false, errorMessage: ConstantStrings.mandatory),
                [InputTextfieldModel(value: "", placeholder: "Height *", apiKey: Key.Params.heightIn, valueId: nil, inputType: InputType.Decimal, dropdownArr: nil,isValid: false, errorMessage: ConstantStrings.mandatory),
                InputTextfieldModel(value: "", placeholder: "Unit *", apiKey: Key.Params.vitalHeightUnitId, valueId: nil, inputType: InputType.Dropdown, dropdownArr: ["cm","feet","inches"],isValid: false, errorMessage: ConstantStrings.mandatory)],
                [InputTextfieldModel(value: "", placeholder: "Weight *", apiKey: Key.Params.weightLbs, valueId: nil, inputType: InputType.Decimal, dropdownArr: nil,isValid: false, errorMessage: ConstantStrings.mandatory),
                InputTextfieldModel(value: "", placeholder: "Unit *", apiKey: Key.Params.vitalWeightUnitId, valueId: nil, inputType: InputType.Dropdown, dropdownArr: ["kg","lbs"],isValid: false, errorMessage: ConstantStrings.mandatory)],
                InputTextfieldModel(value: "", placeholder: "BMI *", apiKey: Key.Params.bmi, valueId: nil, inputType: InputType.Number, dropdownArr: nil,isValid: false, errorMessage: ConstantStrings.mandatory),
                ]
    }
    
    func createAPIParams() -> [String : Any]{
        var keyIdTupleArray = self.arrInput.compactMap { (arrObj) -> ( String , Any?) in
            if let dict = arrObj as? InputTextfieldModel{
                return ((dict.apiKey ?? "") , (dict.valueId ?? ""))
            }
            if let dictArr = arrObj as? [InputTextfieldModel]{
                let firstObj = dictArr[0]
                

                return ((firstObj.apiKey ?? "") , (firstObj.valueId ?? ""))
            }
            return ("","")
        }
        let keyIdTupleArray2 = self.arrInput.compactMap { (arrObj) -> ( String , Any?) in
            if let dictArr = arrObj as? [InputTextfieldModel]{
                let secondtObj = dictArr[1]
                return ((secondtObj.apiKey ?? "") , (secondtObj.valueId ?? ""))
            }
            return ("","")
        }
        
        var paramDict : [String : Any] = [:]
        keyIdTupleArray += keyIdTupleArray2
        for (_,(key,value)) in keyIdTupleArray.enumerated() {
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
        
        return paramDict
    }

}
//MARK:- UITableViewDelegate,UITableViewDataSource

extension InputDummyViewController : UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let inputDict = self.arrInput[indexPath.row]
        if let dictArr = inputDict as? [InputTextfieldModel] , dictArr.count == 3{
            return 190
        }
        return 60
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrInput.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let inputDict = self.arrInput[indexPath.row]
        if let dict = inputDict as? InputTextfieldModel {
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
            case InputType.Number:
                let cell = tableView.dequeueReusableCell(withIdentifier: ReuseIdentifier.NumberInputCell, for: indexPath as IndexPath) as! NumberInputCell
                cell.inputTf.tag = indexPath.row
                cell.inputTf.placeholder = dict.placeholder ?? ""
                self.updateTextfieldAppearance(inputTf: cell.inputTf, dict: dict)

                cell.inputTf.delegate = self
                cell.selectionStyle = .none
                return cell
            case InputType.Date,InputType.Time:
                let cell = tableView.dequeueReusableCell(withIdentifier: ReuseIdentifier.DateTimeInputCell, for: indexPath as IndexPath) as! DateTimeInputCell
                cell.inputTf.tag = indexPath.row
                
                //INVALID HANDLING ------------
                self.updateTextfieldAppearance(inputTf: cell.inputTf, dict: dict)
//                if self.isValidating{
//                    cell.inputTf.lineColor = (dict.isValid ?? false) ? Color.Line : Color.Error
//                    cell.inputTf.errorMessage = (dict.isValid ?? false) ? "" : (dict.errorMessage ?? "")
//                }else{
//                     cell.inputTf.lineColor =  Color.Line
//                    cell.inputTf.errorMessage = ""
//                }
                //INVALID HANDLING ------------
                
                cell.inputTf.delegate = self
                cell.delegate = self
                cell.inputTf.placeholder = dict.placeholder ?? ""
                
                if (dict.value ?? "").count != 0{
                    cell.inputTf.text = dict.value ?? ""
                }
                
                cell.selectionStyle = .none
                return cell
            case InputType.Dropdown:
                let cell = tableView.dequeueReusableCell(withIdentifier: ReuseIdentifier.PickerInputCell, for: indexPath as IndexPath) as! PickerInputCell
                cell.inputTf.tag = indexPath.row
                cell.inputTf.delegate = self
                self.updateTextfieldAppearance(inputTf: cell.inputTf, dict: dict)
                cell.inputTf.placeholder = dict.placeholder ?? ""
                cell.arrDropdown = dict.dropdownArr ?? [Any]()
                cell.pickerView.reloadAllComponents()
                cell.selectionStyle = .none
                cell.delegate = self
                return cell
            case InputType.Decimal:
                let cell = tableView.dequeueReusableCell(withIdentifier: ReuseIdentifier.DecimalInputCell, for: indexPath as IndexPath) as! DecimalInputCell
                cell.inputTf.tag = indexPath.row
                self.updateTextfieldAppearance(inputTf: cell.inputTf, dict: dict)
                cell.inputTf.delegate = self
                cell.inputTf.placeholder = dict.placeholder ?? ""
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
                cell.inputTf1.placeholder = tfOneDict.placeholder ?? ""
                cell.inputT1_type = tfOneDict.inputType ?? ""
                if (tfOneDict.inputType ?? "") == InputType.Dropdown{
                    cell.arrDropdown1 = tfOneDict.dropdownArr ?? [Any]()
                    cell.pickerView.reloadAllComponents()
                }
                if (tfOneDict.value ?? "").count != 0{
                    cell.inputTf1.text = tfOneDict.value ?? ""
                }
                
                cell.inputTf2.placeholder = tfTwoDict.placeholder ?? ""
                cell.inputT2_type = tfTwoDict.inputType ?? ""
                if (tfTwoDict.inputType ?? "") == InputType.Dropdown{
                    cell.arrDropdown2 = tfTwoDict.dropdownArr ?? [Any]()
                    cell.pickerView.reloadAllComponents()
                }
                if (tfTwoDict.value ?? "").count != 0{
                    cell.inputTf2.text = tfTwoDict.value ?? ""
                }
                cell.awakeFromNib()
                
                
                cell.inputTf1.tag = indexPath.row + TagConstants.DoubleTF_FirstTextfield_Tag
                cell.inputTf2.tag = indexPath.row + TagConstants.DoubleTF_SecondTextfield_Tag
                cell.delegate = self
                cell.selectionStyle = .none
                return cell
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: ReuseIdentifier.RecursiveBPCell, for: indexPath as IndexPath) as! RecursiveBPCell
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

                    cell.inputTf3.placeholder = tfThreeDict.placeholder ?? ""
                    cell.inputT3_type = tfThreeDict.inputType ?? ""
                    if (tfThreeDict.inputType ?? "") == InputType.Dropdown{
                        cell.arrDropdown3 = tfThreeDict.dropdownArr ?? [Any]()
                        cell.pickerView.reloadAllComponents()
                    }
                    if (tfThreeDict.value ?? "").count != 0{
                        cell.inputTf3.text = tfThreeDict.value ?? ""
                    }else{
                        cell.inputTf3.text = ""
                    }
                }

                cell.btnDelete.alpha = self.canDeleteRecursiveCell(inputArr: self.arrInput) ? 1.0 : 0.3
                cell.btnAdd.alpha = self.canAddRecursiveCell(inputArr: self.arrInput) ? 1.0 : 0.3

                
                
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
    
    @objc func  addButton_clicked(button : UIButton) {
        
        if self.canAddRecursiveCell(inputArr: self.arrInput){
            let arr =  [InputTextfieldModel(value: "", placeholder: "BP Systolic", apiKey: "bpSystolic", valueId: nil, inputType: InputType.Decimal, dropdownArr: nil,isValid: false, errorMessage: ConstantStrings.mandatory),
                        InputTextfieldModel(value: "", placeholder: "BP Diastolic", apiKey: "bpDiastolic", valueId: nil, inputType: InputType.Decimal, dropdownArr: nil,isValid: false, errorMessage: ConstantStrings.mandatory),
                        InputTextfieldModel(value: "", placeholder: "Position", apiKey: "position", valueId: nil, inputType: InputType.Dropdown, dropdownArr: ["1","2"],isValid: false, errorMessage: ConstantStrings.mandatory)]
            self.arrInput.insert(arr, at: button.tag + 1)
            self.tblView.reloadData()
        }
    }

    @objc func deleteButton_clicked(button : UIButton) {
        if self.canDeleteRecursiveCell(inputArr: self.arrInput){
            self.arrInput.remove(at: button.tag)
            self.tblView.reloadData()
        }
    }

    func canDeleteRecursiveCell(inputArr : [Any]) -> Bool{
        let arrWithRecursive = inputArr.compactMap { (item) -> Any? in
            if let dict = item as?  [InputTextfieldModel]{
                return dict.count == 3 ? dict : nil
            }
            return nil
        }
        return arrWithRecursive.count == 1 ? false : true
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
}
//MARK:- UITextFieldDelegate
extension InputDummyViewController : UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if self.isValidating {
            self.isValidating = false
            self.tblView.reloadData()
        }
        
        self.activeTextfieldTag = textField.tag
        //Set defualt/selected value on textfield tap
            if let tfToUpdate = textField as? InputTextField{
                 tfToUpdate.lineColor =  Color.Line
                tfToUpdate.errorMessage = ""

                DispatchQueue.main.async {
                    if tfToUpdate.text?.count == 0{
                        let index = self.getIndexAndSubIndexFromTag(textFieldTag: self.activeTextfieldTag).0
                        let dictIndex = self.getIndexAndSubIndexFromTag(textFieldTag: self.activeTextfieldTag).1

                        if let inputDict = self.arrInput[index] as? InputTextfieldModel{
                            if (inputDict.inputType ?? "") == InputType.Date  || (inputDict.inputType ?? "") == InputType.Time{
                                let dateStr = Utility.getStringFromDate(date: Date(), dateFormat: DateFormats.MM_dd_yyyy_hh_mm_a)

                                let tempDict = inputDict
                                tempDict.value = dateStr
                                tempDict.valueId = dateStr
                                tempDict.isValid = true
                                 self.arrInput[self.activeTextfieldTag] = tempDict
                                
                                textField.text = dateStr
                            }else if ((inputDict.inputType ?? "") == InputType.Dropdown){
                                let tempDict = inputDict
                                tempDict.value = (tempDict.dropdownArr?[0] as? String) ?? ""
                                tempDict.valueId = (tempDict.dropdownArr?[0] as? String) ?? ""
                                tempDict.isValid = true
                                 self.arrInput[self.activeTextfieldTag] = tempDict
                                textField.text = (tempDict.dropdownArr?[0] as? String) ?? ""

                            }else{
                                let tempDict = inputDict
                                tempDict.value = textField.text
                                tempDict.valueId = textField.text
                                tempDict.isValid = true
                                self.arrInput[self.activeTextfieldTag] = tempDict
                            }
                        }else{
                            if let dictArr = self.arrInput[index] as? [InputTextfieldModel]{
                                var copyArr = dictArr
                                let dict = copyArr[dictIndex]
                                if (dict.inputType ?? "") == InputType.Date  || (dict.inputType ?? "") == InputType.Time{
                                    let dateStr = Utility.getStringFromDate(date: Date(), dateFormat: DateFormats.MM_dd_yyyy_hh_mm_a)
                                    
                                    dict.value = dateStr
                                    dict.valueId = dateStr
                                    dict.isValid = true
                                    copyArr[dictIndex] = dict
                                    self.arrInput[index] = copyArr
                                    textField.text = dateStr
                                }else if ((dict.inputType ?? "") == InputType.Dropdown){
                                    dict.value = (dict.dropdownArr?[0] as? String) ?? ""
                                    dict.valueId = (dict.dropdownArr?[0] as? String) ?? ""
                                    dict.isValid = true
                                    copyArr[dictIndex] = dict
                                    self.arrInput[index] = copyArr
                                    textField.text = (dict.dropdownArr?[0] as? String) ?? ""
                                }else{
                                    dict.value = textField.text
                                    dict.valueId = textField.text
                                    dict.isValid = true
                                    copyArr[dictIndex] = dict
                                    self.arrInput[index] = copyArr

                                }
                            }
                        }

                        
                        self.updateTextfieldAndPickerForRow(row: 0 , tfToUpdate : tfToUpdate)
                    }else{
                        self.updateTextfieldAndPickerForRow(row:  self.getSelectedValueIndex(valueTitle: tfToUpdate.text!, textfieldTag: textField.tag), tfToUpdate: textField as! InputTextField)
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
        
        
        if let _ = textField.superview?.superview as? DecimalInputCell{
            return self.shouldCloseTextfieldFor2Decimal(textField: textField, string: string)
        }
        
        if let _ = textField.superview?.superview as? DoubleInputCell{
            if textField.tag < TagConstants.DoubleTF_SecondTextfield_Tag {
                //Means Input Textfield 1
                if let dictArr = self.arrInput[textField.tag-TagConstants.DoubleTF_FirstTextfield_Tag] as? [InputTextfieldModel] {
                    let dict = dictArr[0]
                    if (dict.inputType ?? "") == InputType.Decimal{
                        return  self.shouldCloseTextfieldFor2Decimal(textField: textField, string: string)
                    }
                }
            }else{
                if let dictArr = self.arrInput[textField.tag-TagConstants.DoubleTF_SecondTextfield_Tag] as? [InputTextfieldModel] {
                    let dict = dictArr[1]
                    if (dict.inputType ?? "") == InputType.Decimal{
                        return  self.shouldCloseTextfieldFor2Decimal(textField: textField, string: string)
                    }
                }
            }
        }
        
        return true
    }

    func shouldCloseTextfieldFor2Decimal(textField : UITextField , string: String) -> Bool{
        let dotString = "."
        if let text = textField.text {
            let isDeleteKey = string.isEmpty
            if !isDeleteKey {
                if text.contains(dotString) {
                    if text.components(separatedBy: dotString)[1].count == 2 {
                        return false
                    }
                }
            }
        }
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            // Here Set The Next return field
        if textField.tag == self.arrInput.count - 1{
                textField.resignFirstResponder()
                return true
        }
        DispatchQueue.main.async {
            if  textField.tag - TagConstants.DoubleTF_FirstTextfield_Tag > 0 && textField.tag - TagConstants.DoubleTF_FirstTextfield_Tag < TagConstants.DoubleTF_FirstTextfield_Tag{
                let tagTf =  textField.tag - TagConstants.DoubleTF_FirstTextfield_Tag
                if let cell = self.tblView.cellForRow(at: IndexPath(row: tagTf, section: 0)){
                    if cell.isKind(of: DoubleInputCell.self){
                        (cell as! DoubleInputCell).inputTf2.becomeFirstResponder()
                    }
                }
            }else{
                let tagTf = textField.tag >= TagConstants.DoubleTF_SecondTextfield_Tag ? textField.tag - TagConstants.DoubleTF_SecondTextfield_Tag : textField.tag
            if let cell = self.tblView.cellForRow(at: IndexPath(row: tagTf + 1, section: 0)){
                if cell.isKind(of: PickerInputCell.self){
                    (cell as! PickerInputCell).inputTf.becomeFirstResponder()
                }
                else if cell.isKind(of: TextInputCell.self){
                    (cell as! TextInputCell).inputTf.becomeFirstResponder()
                }
                else if cell.isKind(of: NumberInputCell.self){
                    (cell as! NumberInputCell).inputTf.becomeFirstResponder()
                }
                else if cell.isKind(of: DateTimeInputCell.self){
                    (cell as! DateTimeInputCell).inputTf.becomeFirstResponder()
                }
                else if cell.isKind(of: DecimalInputCell.self){
                    (cell as! DecimalInputCell).inputTf.becomeFirstResponder()
                }else if cell.isKind(of: DoubleInputCell.self){
                    (cell as! DoubleInputCell).inputTf1.becomeFirstResponder()
                }
                else {
                    textField.resignFirstResponder()
                }
            }
            }
        }
        return true
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        // Here Set The Next return field
        if textField.tag == self.arrInput.count - 1{
            IQKeyboardManager.shared.toolbarDoneBarButtonItemText = ButtonTitles.done
            textField.keyboardToolbar.doneBarButton.setTarget(self, action: #selector(doneAction(textField:)))
            
        }else if (textField.tag >= TagConstants.DoubleTF_SecondTextfield_Tag){
            let index = textField.tag - TagConstants.DoubleTF_SecondTextfield_Tag
            if index == self.arrInput.count - 1{
                IQKeyboardManager.shared.toolbarDoneBarButtonItemText = ButtonTitles.done
                textField.keyboardToolbar.doneBarButton.setTarget(self, action: #selector(doneAction(textField:)))
            }else{
                IQKeyboardManager.shared.toolbarDoneBarButtonItemText = ButtonTitles.next
                textField.keyboardToolbar.doneBarButton.setTarget(self, action: #selector(nextAction(textField:)))
            }
        }else{
            IQKeyboardManager.shared.toolbarDoneBarButtonItemText = ButtonTitles.next
            textField.keyboardToolbar.doneBarButton.setTarget(self, action: #selector(nextAction(textField:)))
            
        }
        return true
    }
    @objc func doneAction(textField:UITextField){
        if textField.tag == self.arrInput.count - 1{
            textField.resignFirstResponder()
        }
    }
       
    @objc func nextAction(textField:UITextField){
        if textField.tag == self.arrInput.count - 1{
            textField.resignFirstResponder()
        }
        DispatchQueue.main.async {
            if  textField.tag - TagConstants.DoubleTF_FirstTextfield_Tag > 0 && textField.tag - TagConstants.DoubleTF_FirstTextfield_Tag < TagConstants.DoubleTF_FirstTextfield_Tag{
                if let cell = self.tblView.cellForRow(at: IndexPath(row: textField.tag - TagConstants.DoubleTF_FirstTextfield_Tag, section: 0)){
                    if cell.isKind(of: DoubleInputCell.self){
                        (cell as! DoubleInputCell).inputTf2.becomeFirstResponder()
                    }
                }
            }else{
                let tagTf = textField.tag >= TagConstants.DoubleTF_SecondTextfield_Tag ? textField.tag - TagConstants.DoubleTF_SecondTextfield_Tag : textField.tag
            if let cell = self.tblView.cellForRow(at: IndexPath(row: tagTf + 1, section: 0)){
                if cell.isKind(of: PickerInputCell.self){
                    (cell as! PickerInputCell).inputTf.becomeFirstResponder()
                }
                else if cell.isKind(of: TextInputCell.self){
                    (cell as! TextInputCell).inputTf.becomeFirstResponder()
                }
                else if cell.isKind(of: NumberInputCell.self){
                    (cell as! NumberInputCell).inputTf.becomeFirstResponder()
                }
                else if cell.isKind(of: DateTimeInputCell.self){
                    (cell as! DateTimeInputCell).inputTf.becomeFirstResponder()
                }
                else if cell.isKind(of: DecimalInputCell.self){
                    (cell as! DecimalInputCell).inputTf.becomeFirstResponder()
                }else if cell.isKind(of: DoubleInputCell.self){
                    (cell as! DoubleInputCell).inputTf1.becomeFirstResponder()
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
        let index = indexTuple.0
        let dictIndex = indexTuple.1
        
        if textField.tag < TagConstants.DoubleTF_FirstTextfield_Tag{
            if let dict = self.arrInput[index] as? InputTextfieldModel{
                dict.value = textField.text
                dict.valueId = textField.text
                dict.isValid = !(textField.text?.count == 0)
                self.arrInput[textField.tag] = dict
            }
        }else if textField.tag >= TagConstants.RecursiveTF_FirstTextfield_Tag{
            
            
            if let dict = self.arrInput[index] as? InputTextfieldModel{
                dict.value = textField.text
                dict.valueId = textField.text
                dict.isValid = !(textField.text?.count == 0)
                self.arrInput[textField.tag] = dict
            }else{

                if let dictArr = self.arrInput[index] as? [InputTextfieldModel]{
                    var copyArr = dictArr
                    let dict = copyArr[dictIndex]
                    dict.value = textField.text ?? ""
                    dict.valueId = textField.text
                    dict.isValid = !(textField.text?.count == 0)
                    copyArr[dictIndex] = dict
                    self.arrInput[index] = copyArr
                }
            }

        }else{
            
            
            if let dict = self.arrInput[index] as? InputTextfieldModel{
                dict.value = textField.text
                dict.valueId = textField.text
                dict.isValid = !(textField.text?.count == 0)
                self.arrInput[textField.tag] = dict
            }else{
                
                if let dictArr = self.arrInput[index] as? [InputTextfieldModel]{
                    var copyArr = dictArr
                    let dict = copyArr[dictIndex]
                    dict.value = textField.text ?? ""
                    dict.valueId = textField.text
                    dict.isValid = !(textField.text?.count == 0)
                    copyArr[dictIndex] = dict
                    self.arrInput[index] = copyArr
                }
            }
        }
    }
    
    //Returns (Int,Int) -> (Index,SubIndex)
    func getIndexAndSubIndexFromTag(textFieldTag : Int) -> (Int,Int){
        var index = textFieldTag
        var dictIndex = 0

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
            let isFirstTf = index - TagConstants.DoubleTF_FirstTextfield_Tag > 0 && index - TagConstants.DoubleTF_FirstTextfield_Tag < TagConstants.DoubleTF_FirstTextfield_Tag
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
        return (index,dictIndex)
    }
}

//MARK:- DateTimeInputCellDelegate
extension InputDummyViewController : DateTimeInputCellDelegate{
    func selectedDateForInput(date: Date, textfieldTag: Int, isDateField : Bool) {
        let dateStr = Utility.getStringFromDate(date: date, dateFormat: DateFormats.MM_dd_yyyy_hh_mm_a)
        debugPrint("Date = \(dateStr) --- Tf tag \(textfieldTag)")
        
        let index = self.activeTextfieldTag
        let indexPath = IndexPath(row: index, section: 0)

        if let dict = self.arrInput[index] as? InputTextfieldModel{
            let copyDict = dict
            copyDict.value = dateStr
            copyDict.valueId = dateStr
            copyDict.isValid = true
            self.arrInput[index] = copyDict
        }
        
        if let cell = self.tblView.cellForRow(at: indexPath) as? DateTimeInputCell{
            cell.inputTf.text = dateStr
        }
    }
}

//MARK:- PickerInputCellDelegate
extension InputDummyViewController : PickerInputCellDelegate{
    func selectedPickerValueForInput(value: Any, valueID : Any, textfieldTag: Int) {
        debugPrint("value = \(value) --- Tf tag \(textfieldTag)")
        
        let index = self.activeTextfieldTag
        let indexPath = IndexPath(row: index, section: 0)

        if let dict = self.arrInput[index] as? InputTextfieldModel{
            let copyDict = dict
            copyDict.value = (value as? String) ?? ""
            copyDict.valueId = valueID
            copyDict.isValid = true
            self.arrInput[index] = copyDict
        }
        
        if let cell = self.tblView.cellForRow(at: indexPath) as? PickerInputCell{
            cell.inputTf.text = (value as? String) ?? ""
        }
    }
    
}


//MARK:- DoubleInputCellDelegate
extension InputDummyViewController : DoubleInputCellDelegate{
    func selectedDateForDoubleInput(date : Date, textfieldTag : Int, isDateField : Bool){
        let dateStr = Utility.getStringFromDate(date: date, dateFormat: DateFormats.MM_dd_yyyy_hh_mm_a)
        
        self.setSelectedValueInTextfield(value: dateStr, valueId: dateStr, index: self.activeTextfieldTag)
    }
    
    func selectedPickerValueForDoubleInput(value : Any, valueID : Any, textfieldTag : Int)
    {
        
        self.setSelectedValueInTextfield(value: value, valueId: valueID, index: self.activeTextfieldTag)
    }
    
    func setSelectedValueInTextfield(value : Any , valueId : Any, index : Int){
        let indexTuple = self.getIndexAndSubIndexFromTag(textFieldTag: self.activeTextfieldTag)
        let index = indexTuple.0
        let dictIndex = indexTuple.1
        
        let isFirstTf = index - TagConstants.DoubleTF_FirstTextfield_Tag > 0 && index - TagConstants.DoubleTF_FirstTextfield_Tag < TagConstants.DoubleTF_FirstTextfield_Tag
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
        
        
        if let cell = self.tblView.cellForRow(at: indexPath) as? DoubleInputCell{
            if  isFirstTf{
                cell.inputTf1.text = (value as? String) ?? ""
            }else{
                cell.inputTf2.text = (value as? String) ?? ""
            }
        }
    }
}

//MARK:- DoubleInputCellDelegate
extension InputDummyViewController : RecursiveBPCellDelegate{
    func selectedDateForRecursiveInput(date: Date, textfieldTag: Int, isDateField: Bool) {
        
    }
    
    func selectedPickerValueForRecursiveInput(value: Any, valueID: Any, textfieldTag: Int) {
        self.setSelectedValueInRecursiveTextfield(value: value, valueId: valueID, index: self.activeTextfieldTag)

    }
    
    func setSelectedValueInRecursiveTextfield(value : Any , valueId : Any, index : Int){
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
        }
    }

    
}

