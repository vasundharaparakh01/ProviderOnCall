//
//  CancelTaskViewController.swift
//  appName
//
//  Created by Vasundhara Parakh on 4/23/20.
//  Copyright © 2020 smartData Enterprises (I) Ltd. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class CancelTaskViewController: BaseViewController {
    @IBOutlet weak var tblView: UITableView!
    var arrInput = [Any]()
    var activeTextfieldTag = 0
    var isReadyToSave = false
    var isValidating = false
    var patientId = 0
    var activeTextfield : InputTextField?
    var selectedSection = 0
    var appointmentId = 0
    lazy var viewModel: CancelTaskViewModel = {
        let obj = CancelTaskViewModel(with: TaskService())
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

        self.navigationItem.title = "Cancel Task"
        self.addBackButton()
        self.addrightBarButtonItem()
        self.setupClosures()
        self.viewModel.getCancelMasterData()

        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        IQKeyboardManager.shared.previousNextDisplayMode = .Default
    }

    
    func registerNIBs(){
        self.tblView.register(UINib(nibName: ReuseIdentifier.DoubleInputCell, bundle: nil), forCellReuseIdentifier: ReuseIdentifier.DoubleInputCell)
        self.tblView.register(UINib(nibName: ReuseIdentifier.TextInputCell, bundle: nil), forCellReuseIdentifier: ReuseIdentifier.TextInputCell)
        self.tblView.register(UINib(nibName: ReuseIdentifier.DateTimeInputCell, bundle: nil), forCellReuseIdentifier: ReuseIdentifier.DateTimeInputCell)
        self.tblView.register(UINib(nibName: ReuseIdentifier.PickerInputCell, bundle: nil), forCellReuseIdentifier: ReuseIdentifier.PickerInputCell)


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
        if inputParams.keys.count == 3{
            self.viewModel.cancelTask(params: inputParams)
        }else{
            self.viewModel.errorMessage = "Please fill missing inputs."
        }
    }
    func createAPIParams() -> [String : Any]{
        var keyMainArray = [( String , Any?)]()
        for (_,arrObj) in self.arrInput.enumerated() {
            if let dict = arrObj as? InputTextfieldModel{
                keyMainArray.append(((dict.apiKey ?? "") , (dict.valueId ?? "")))
            }
            if let dictArr = arrObj as? [Any]{
                for (_,dictObj) in dictArr.enumerated() {
                    if let dict = dictObj as? [InputTextfieldModel]{
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
                if val != 0{
                    paramDict[key] = value
                }
            }else{
                paramDict[key] = value
            }
        }
        paramDict[Key.Params.ids] = [self.appointmentId]

        return paramDict
    }

}
//MARK:- UITableViewDelegate,UITableViewDataSource

extension CancelTaskViewController : UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.arrInput.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Device.IS_IPAD ? 90 : 60//UITableView.automaticDimension
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
                    cell.inputTf.placeholder = dict.placeholder ?? ""
                    self.updateTextfieldAppearance(inputTf: cell.inputTf, dict: dict)
                    
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
                    cell.inputTf.placeholder = dict.placeholder ?? ""
                    print("Input text === \(dict.value ?? "")")
                    cell.inputTf.text = dict.value ?? ""
                    cell.arrDropdown = dict.dropdownArr ?? [Any]()
                    cell.pickerView.reloadAllComponents()
                    cell.selectionStyle = .none
                    cell.delegate = self
                    return cell
                default:
                    return UITableViewCell()
                }
            }
        }
        return UITableViewCell()
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
extension CancelTaskViewController : UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if self.isValidating {
            self.isValidating = false
            self.tblView.reloadData()
        }
        if let activeTf = textField as? InputTextField{
            self.activeTextfield = activeTf
        }
        AppInstance.shared.activeTextfieldIndex = textField.tag
        self.activeTextfieldTag = textField.tag
        //Set defualt/selected value on textfield tap
            if let tfToUpdate = textField as? InputTextField{
                 tfToUpdate.lineColor =  Color.Line
                tfToUpdate.errorMessage = ""

                DispatchQueue.main.async {
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
        }
        return true
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        // Here Set The Next return field
        if textField.tag == self.arrInput.count - 1{
            IQKeyboardManager.shared.toolbarDoneBarButtonItemText = ButtonTitles.done
            textField.keyboardToolbar.doneBarButton.setTarget(self, action: #selector(doneAction(textField:)))
            
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
        var index = 0
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
extension CancelTaskViewController : PickerInputCellDelegate{
    func selectedPickerValueForInput(value: Any, valueID: Any, textfieldTag: Int) {
        debugPrint("value = \(value) --- Tf tag \(textfieldTag)")
        
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
        }
    }
    
}

