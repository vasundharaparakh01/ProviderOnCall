//
//  ESASFormViewController.swift
//  AccessEMR
//
//  Created by Vasundhara Parakh on 3/23/20.
//  Copyright © 2020 smartData Enterprises (I) Ltd. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import StepSlider
class ESASFormViewController: BaseViewController {
    @IBOutlet weak var tblView: UITableView!
    lazy var viewModel: ESASFormViewModel = {
        let obj = ESASFormViewModel(with: PointOfCareService())
        self.baseViewModel = obj
        return obj
    }()
    var shiftSelectedID = 0
    var arrInput = [Any]()
    var activeTextfieldTag = 0
    var isReadyToSave = false
    var isValidating = false
    var patientHeaderInfo : PatientBasicHeaderInfo?
    let colorArray = [Color.ESASColor0,Color.ESASColor1,Color.ESASColor2,Color.ESASColor3,Color.ESASColor4,Color.ESASColor5,Color.ESASColor6,Color.ESASColor7,Color.ESASColor8,Color.ESASColor9,Color.ESASColor10]
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
        self.navigationItem.title = NavigationTitle.PointOfCareSections.ESASRating
        self.addBackButton()
        self.addrightBarButtonItem()
        self.viewModel.getESASRatingDetail(patientId: self.patientHeaderInfo?.patientID ?? 0, unitId: self.patientHeaderInfo?.unitId ?? 0) { (result) in
            self.viewModel.getLocationDropdown(patientID: self.patientHeaderInfo?.patientID ?? 0)
        }
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        IQKeyboardManager.shared.previousNextDisplayMode = .Default
    }

    
    func registerNIBs(){
        self.tblView.register(UINib(nibName: ReuseIdentifier.DoubleInputCell, bundle: nil), forCellReuseIdentifier: ReuseIdentifier.DoubleInputCell)
        self.tblView.register(UINib(nibName: ReuseIdentifier.SliderCell, bundle: nil), forCellReuseIdentifier: ReuseIdentifier.SliderCell)
        self.tblView.register(UINib(nibName: ReuseIdentifier.TitleCell, bundle: nil), forCellReuseIdentifier: ReuseIdentifier.TitleCell)
        self.tblView.register(UINib(nibName: ReuseIdentifier.RecursiveESASCell, bundle: nil), forCellReuseIdentifier: ReuseIdentifier.RecursiveESASCell)
    }
    func setupClosures() {
        self.viewModel.updateViewClosure = { [weak self] () in
            DispatchQueue.main.async {
                self?.arrInput = self?.viewModel.getInputArray() ?? [""]
                
                var otherTypeArr = [OtherTypeModel]()
                if let arr = self?.viewModel.esasRatingDetail?.otherTypeModel{
                    otherTypeArr = arr
                }
                
                for (_,otherType) in otherTypeArr.enumerated(){
                    self?.arrInput.insert(self?.viewModel.getRecursiveESASCell(model: otherType), at: self?.arrInput.count ?? 0)
                }
                
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
        
        let inputParams = createAPIParams(esasRatingID: self.viewModel.esasRatingDetail?.id ?? 0, isDraft: false)
        let hasLocation = self.viewModel.selectedUnitID != 0// inputParams[Key.Params.ESAS.Rating.locationId] != nil
        //let hasShift = inputParams[Key.Params.ESAS.Rating.shiftId] != nil
        
        var hasShift: Bool = false
        if inputParams[Key.Params.ESAS.Rating.shiftId] == nil || inputParams[Key.Params.ESAS.Rating.shiftId] as! Int == 0{
            hasShift = false
        }else{
            hasShift = true
        }
        //let hasShift = inputParams[Key.Params.ESAS.Rating.shiftId] != nil
        

        let isValidAddedFields = self.checkAllAddedFieldsAreValid()
        if hasLocation && hasShift && isValidAddedFields{
            self.viewModel.saveESASRating(params: inputParams)
        }else{
            self.viewModel.errorMessage = "Please fill missing inputs."
        }
        print("API Input Params = \(createAPIParams(esasRatingID: 0, isDraft: false))")
    }
    
    @IBAction func saveAsDraftBtn_clicked(_ sender: Any) {
        let inputParams = createAPIParams(esasRatingID: self.viewModel.esasRatingDetail?.id ?? 0, isDraft: true)
        
        var hasShift: Bool = false
        if inputParams[Key.Params.ESAS.Rating.shiftId] == nil || inputParams[Key.Params.ESAS.Rating.shiftId] as! Int == 0{
            hasShift = false
        }else{
            hasShift = true
        }
        if hasShift{
            self.viewModel.saveAsDraftESASRating(params: inputParams)
        }else{
            self.viewModel.errorMessage = "Shift is required."
        }
        //self.viewModel.saveAsDraftESASRating(params: inputParams)
        //self.viewModel.saveESASRating(params: inputParams)
        //print("API Input Params = \(createAPIParams(esasRatingID: self.viewModel.esasRatingDetail?.id ?? 0, isDraft: true))")
    }
    
    @IBAction func resetBtn_clicked(_ sender: Any) {
        
        UIAlertController.showAlert(title: Alert.Title.appName, message: Alert.Message.reset, preferredStyle: .alert, sender: nil , target: self, actions:.Yes,.No) { (AlertAction) in
                    switch AlertAction {
                    case .Yes:
                        self.arrInput = self.viewModel.getInputArray() ?? [""]
                      self.tblView.reloadData()
                      self.tblView.scrollRectToVisible(CGRect.zero, animated: true)
                    default:
                        break
                    }
                }

    }
   

    
    
    
    func createAPIParams(esasRatingID : Int, isDraft : Bool) -> [String : Any]{
        var keyIdTupleArray = self.arrInput.compactMap { (arrObj) -> ( String , Any?) in
            if let dict = arrObj as? InputTextfieldModel{
                if (dict.inputType ?? "") != InputType.AddESASRating{
                    return ((dict.apiKey ?? "") , (dict.valueId ?? ""))
                }
                return ("","")
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
        paramDict[Key.Params.ESAS.Rating.shiftId] = shiftSelectedID
        paramDict[Key.Params.patientId] = self.patientHeaderInfo?.patientID ?? 0
        paramDict[Key.Params.id] = esasRatingID
        paramDict[Key.Params.isDraft] = isDraft
        paramDict["locationId"] = (AppInstance.shared.user?.staffLocation?[0])?.locationID ?? 0
        paramDict["unitId"] = self.viewModel.selectedUnitID ?? 0
        paramDict["otherTypeModel"] = self.dictForAddedRows()
        return paramDict
    }

    func dictForAddedRows() -> [[String : Any]]{
        var tempArray = [[String : Any]]()
        for (_,item) in self.arrInput.enumerated(){
            if let dict = item as? InputTextfieldModel{
                if (dict.inputType ?? "") == InputType.AddESASRating{
                    var dictTemp = [String:Any]()
                    if (dict.placeholder ?? "").contains("|"){
                        let splitArr = (dict.placeholder ?? "").components(separatedBy: "|")
                        dictTemp["esasRatingTypeMasterId"] = Int(splitArr.last ?? "0") ?? 0
                    }
                    else{
                        dictTemp["esasRatingTypeMasterId"] = 0
                    }
                    dictTemp["otherType"] = dict.value ?? ""
                    dictTemp["otherTypeNumber"] = dict.sliderValue ?? 0
                    tempArray.append(dictTemp)
                }
            }
        }
        return tempArray
    }
    
    func checkAllAddedFieldsAreValid() -> Bool{
        var tempArray = [InputTextfieldModel]()
        for (_,item) in self.arrInput.enumerated(){
            if let dict = item as? InputTextfieldModel{
                if (dict.inputType ?? "") == InputType.AddESASRating{
                    tempArray.append(dict)
                }
            }
        }
        let validArr = self.arrInput.compactMap { (dict) -> Bool? in
            if let item = dict as? InputTextfieldModel{
                if (item.inputType ?? "") == InputType.AddESASRating{
                    return ((item.isValid ?? nil) ?? false) ? true : nil
                }
            }
            return nil
        }
        
        return validArr.count == tempArray.count
    }
}
//MARK:- UITableViewDelegate,UITableViewDataSource

extension ESASFormViewController : UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let inputDict = self.arrInput[indexPath.row]
        if let dict = inputDict as? InputTextfieldModel {
            if (dict.inputType ?? "") == InputType.Slider as String{
                return UITableView.automaticDimension
            }else if (dict.inputType ?? "") == InputType.Title as String{
                return 40
            }else if (dict.inputType ?? "") == InputType.AddESASRating as String{
                return Device.IS_IPAD ? 170 : 155
            }
        }
        return 70
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrInput.count
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
                let inputDict = self.arrInput[indexPath.row]
        if let dict = inputDict as? InputTextfieldModel {
           if (dict.inputType ?? "") == InputType.Slider as String{
            print("Normal === \(dict.sliderValue) valueidd = \(dict.valueId) ,,, valueee =\(dict.value) ROWWWW ==\(indexPath.row)")
            }
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let inputDict = self.arrInput[indexPath.row]
        if let dict = inputDict as? InputTextfieldModel {
            if (dict.inputType ?? "") == InputType.Title as String{
                let cell = tableView.dequeueReusableCell(withIdentifier: ReuseIdentifier.TitleCell, for: indexPath as IndexPath) as! TitleCell
                cell.lblTitle.text = dict.placeholder ?? ""
                if (dict.placeholder ?? "") == "Other Problem"{
                    cell.btnAdd.isHidden = false
                    cell.btnAdd.tag = indexPath.row
                    cell.btnAdd.addTarget(self, action: #selector(addButton_clicked(button:)), for: .touchUpInside)
                }else{
                    cell.btnAdd.isHidden = true
                }
                cell.selectionStyle = .none
                return cell
            }

            else if (dict.inputType ?? "") == InputType.Slider as String{
                let cell = tableView.dequeueReusableCell(withIdentifier: ReuseIdentifier.SliderCell, for: indexPath as IndexPath) as! SliderCell
                cell.slider.setIndex(UInt((dict.sliderValue ?? 0)), animated: false)
                //cell.slider.index = UInt((dict.sliderValue ?? 0))
                cell.lblValue.text = dict.value ?? ""
                cell.lblTitle.text = dict.placeholder ?? ""
                cell.lblMinRange.text = dict.minRangeTitle ?? ""
                cell.lblMaxRange.text = dict.maxRangeTitle ?? ""
                cell.slider.tag = indexPath.row
                let sliderValue = (dict.sliderValue ?? 0) as! Int
                cell.lblValue.textColor = self.colorArray[sliderValue]
                cell.slider.sliderCircleColor = self.colorArray[sliderValue]
                cell.slider.tintColor = self.colorArray[sliderValue]
                print("Normal === \(dict.sliderValue) ROWWWW ==\(indexPath.row)")
/*
                if sliderValue <= 4{
                    cell.lblValue.textColor = Color.LowSliderColor
                    cell.slider.sliderCircleColor = Color.LowSliderColor
                    cell.slider.tintColor = Color.LowSliderColor

                }else if sliderValue <= 7{
                    cell.lblValue.textColor = Color.MediumSliderColor
                    cell.slider.sliderCircleColor = Color.MediumSliderColor
                    cell.slider.tintColor = Color.MediumSliderColor

                }else{
                    cell.lblValue.textColor = Color.HighSliderColor
                    cell.slider.sliderCircleColor = Color.HighSliderColor
                    cell.slider.tintColor = Color.HighSliderColor

                }
                */
                cell.slider.addTarget(self, action: #selector(self.sliderValueChanged(slider:)), for: .valueChanged)
                cell.selectionStyle = .none
                return cell
            }else if (dict.inputType ?? "") == InputType.AddESASRating as String{
                let cell = tableView.dequeueReusableCell(withIdentifier: ReuseIdentifier.RecursiveESASCell, for: indexPath as IndexPath) as! RecursiveESASCell
                cell.slider.setIndex(UInt((dict.sliderValue ?? 0)), animated: false)

                //cell.slider.index = UInt((dict.sliderValue ?? 0))
                cell.lblSliderValue.text = "\(dict.sliderValue ?? 0)"
                
                var placeholder = dict.placeholder ?? ""
                if (dict.placeholder ?? "").contains("|"){
                    let splitArr = (dict.placeholder ?? "").components(separatedBy: "|")
                    placeholder = splitArr.first ?? ""
                }
                cell.inputTf1.placeholder = placeholder
                cell.inputTf1.text = dict.value ?? ""
                cell.inputTf1.tag = indexPath.row
                cell.inputTf1.delegate = self
                cell.btnAdd.tag = indexPath.row
                cell.btnDelete.tag = indexPath.row
                cell.btnAdd.addTarget(self, action: #selector(addButton_clicked(button:)), for: .touchUpInside)
                cell.btnDelete.addTarget(self, action: #selector(deleteButton_clicked(button:)), for: .touchUpInside)
                
                cell.slider.tag = indexPath.row
                cell.slider.addTarget(self, action: #selector(self.sliderValueChanged(slider:)), for: .valueChanged)
                self.updateTextfieldAppearance(inputTf: cell.inputTf1, dict: dict)

                let sliderValue = (dict.sliderValue ?? 0)
                cell.lblSliderValue.textColor = self.colorArray[sliderValue]
                cell.slider.sliderCircleColor = self.colorArray[sliderValue]
                cell.slider.tintColor = self.colorArray[sliderValue]

                /*
                if sliderValue <= 4{
                    cell.lblSliderValue.textColor = Color.LowSliderColor
                    cell.slider.sliderCircleColor = Color.LowSliderColor
                    cell.slider.tintColor = Color.LowSliderColor

                }else if sliderValue <= 7{
                    cell.lblSliderValue.textColor = Color.MediumSliderColor
                    cell.slider.sliderCircleColor = Color.MediumSliderColor
                    cell.slider.tintColor = Color.MediumSliderColor

                }else{
                    cell.lblSliderValue.textColor = Color.HighSliderColor
                    cell.slider.sliderCircleColor = Color.HighSliderColor
                    cell.slider.tintColor = Color.HighSliderColor

                }*/
                cell.selectionStyle = .none
                return cell

            }
            return UITableViewCell()
        }
        else{
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
            }
        }
        return UITableViewCell()
    }
    @objc func  addButton_clicked(button : UIButton) {
        self.isValidating = false
        let arr =  self.viewModel.getRecursiveESASCell(model: nil)
        self.arrInput.insert(arr, at: self.arrInput.count)
        self.tblView.reloadData()
        self.tblView.scrollToRow(at: IndexPath(row: self.arrInput.count - 1, section: 0), at: .bottom, animated: true)
    }
    
    @objc func deleteButton_clicked(button : UIButton) {
        self.isValidating = false
        self.arrInput.remove(at: button.tag)
        self.tblView.reloadData()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    @objc func  sliderValueChanged(slider : StepSlider) {
        DispatchQueue.main.async {
        let inputDict = self.arrInput[slider.tag]
        if let dict = inputDict as? InputTextfieldModel {
            let copyDict = dict
            if (dict.apiKey ?? "") == "otherTypeModel"{
            }else{
                copyDict.value = "\(slider.index)"
            }
            copyDict.valueId = Int(slider.index)
            copyDict.sliderValue = Int(slider.index)
            print("Changes slider Val = \(Int(slider.index)) ==== INDEX =\(slider.tag)")
            self.arrInput[slider.tag] = copyDict
            if let cell = self.tblView.cellForRow(at: IndexPath(row: slider.tag, section: 0)) as? SliderCell{
                //cell.slider.setIndex(UInt((dict.sliderValue ?? 0)), animated: false)
                print("SliderCell === \(slider.index)")

                //cell.slider.index = slider.index
                cell.lblValue.text = "\(slider.index)"
                
                let sliderValue = Int(slider.index)
                cell.lblValue.textColor = self.colorArray[sliderValue]
                cell.slider.sliderCircleColor = self.colorArray[sliderValue]
                cell.slider.tintColor = self.colorArray[sliderValue]

                /*
                if sliderValue <= 4{
                    cell.lblValue.textColor = Color.LowSliderColor
                    cell.slider.sliderCircleColor = Color.LowSliderColor
                    cell.slider.tintColor = Color.LowSliderColor

                }else if sliderValue <= 7{
                    cell.lblValue.textColor = Color.MediumSliderColor
                    cell.slider.sliderCircleColor = Color.MediumSliderColor
                    cell.slider.tintColor = Color.MediumSliderColor

                }else{
                    cell.lblValue.textColor = Color.HighSliderColor
                    cell.slider.sliderCircleColor = Color.HighSliderColor
                    cell.slider.tintColor = Color.HighSliderColor

                }*/
                if let ddd = self.arrInput[slider.tag] as? InputTextfieldModel{
                print("On chnage === \(ddd.sliderValue) valueidd = \(ddd.valueId) ,,, valueee =\(ddd.value) ROWWWW ==\(slider.tag)")
                }

                
            }
            if let cell = self.tblView.cellForRow(at: IndexPath(row: slider.tag, section: 0)) as? RecursiveESASCell{
                //cell.slider.index = slider.index
                cell.lblSliderValue.text = "\(slider.index)"
                let sliderValue = Int(slider.index)
                cell.lblSliderValue.textColor = self.colorArray[sliderValue]
                cell.slider.sliderCircleColor = self.colorArray[sliderValue]
                cell.slider.tintColor = self.colorArray[sliderValue]

                /*
                let sliderValue = Int(slider.index)
                if sliderValue <= 4{
                    cell.lblSliderValue.textColor = Color.LowSliderColor
                    cell.slider.sliderCircleColor = Color.LowSliderColor
                    cell.slider.tintColor = Color.LowSliderColor

                }else if sliderValue <= 7{
                    cell.lblSliderValue.textColor = Color.MediumSliderColor
                    cell.slider.sliderCircleColor = Color.MediumSliderColor
                    cell.slider.tintColor = Color.MediumSliderColor

                }else{
                    cell.lblSliderValue.textColor = Color.HighSliderColor
                    cell.slider.sliderCircleColor = Color.HighSliderColor
                    cell.slider.tintColor = Color.HighSliderColor

                }*/
                
            }
        }
        }
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
extension ESASFormViewController : UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if self.isValidating {
            self.isValidating = false
            self.tblView.reloadData()
        }
        AppInstance.shared.activeTextfieldIndex = textField.tag
        self.activeTextfieldTag =  textField.tag
        //Set defualt/selected value on textfield tap
            if let tfToUpdate = textField as? InputTextField{
                 tfToUpdate.lineColor =  Color.Line
                tfToUpdate.errorMessage = ""

                DispatchQueue.main.async {
                    if tfToUpdate.text?.count == 0{
                        if let cell = tfToUpdate.superview?.superview as? DoubleInputCell{
                            if let indexPath = self.tblView.indexPath(for: cell){
                                if tfToUpdate.placeholder == "Shift"{
                                    self.viewModel.getShiftDropdownByUnit(unitID: self.viewModel.selectedUnitID) {  (result) in
                                        self.viewModel.isLoading = false
                                        if let res = result as? [Shift]{
                                            if !res.isEmpty{
                                                if let dictArr = self.arrInput[indexPath.row] as? [InputTextfieldModel]{
                                                    var copyDictArr = dictArr
                                                    if let dict = dictArr[1] as? InputTextfieldModel{
                                                        let copyDict = dict
                                                        copyDict.value =  res[0].shiftName ?? ""
                                                        copyDict.valueId = res[0].id ?? 0
                                                        self.shiftSelectedID = copyDict.valueId as! Int
                                                        copyDict.isValid = true
                                                        copyDictArr[1] = copyDict
                                                        self.arrInput[indexPath.row] = copyDictArr
                                                        tfToUpdate.text = res[0].shiftName ?? ""
                                                        cell.arrDropdown2 = res
                                                    }
                                                }
                                            }
                                        }
                                        cell.pickerView.reloadAllComponents()
                                    }
                                }else{
                                    if let dictArr = self.arrInput[indexPath.row] as? [InputTextfieldModel]{
                                        var copyDictArr = dictArr
                                        if let dict = dictArr[1] as? InputTextfieldModel{
                                            let copyDict = dict
                                            copyDict.value =  self.viewModel.dropdownUnit?[0].unitName ?? ""//res[0].shiftName ?? ""
                                            copyDict.valueId = self.viewModel.dropdownUnit?[0].id ?? 0
                                            copyDict.isValid = true
                                            copyDictArr[0] = copyDict
                                            self.arrInput[indexPath.row] = copyDictArr
                                            tfToUpdate.text = self.viewModel.dropdownUnit?[0].unitName ?? ""
                                            cell.arrDropdown1 = self.viewModel.dropdownUnit ?? [""]
                                            self.viewModel.selectedUnitID =  self.viewModel.dropdownUnit?[0].id ?? 0
                                            self.viewModel.selectedUnitID = self.viewModel.dropdownUnit?[0].id ?? 0
                                        }
                                    }
                                    cell.pickerView.reloadAllComponents()

                                }
                            }
                        }
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
        
        self.viewModel.updateViewClosure = { [weak self] () in
            DispatchQueue.main.async {
                self?.arrInput = self?.viewModel.getInputArray() ?? [""]
                
                var otherTypeArr = [OtherTypeModel]()
                if let arr = self?.viewModel.esasRatingDetail?.otherTypeModel{
                    otherTypeArr = arr
                }
                
                for (_,otherType) in otherTypeArr.enumerated(){
                    self?.arrInput.insert(self?.viewModel.getRecursiveESASCell(model: otherType), at: self?.arrInput.count ?? 0)
                }
                
                self?.tblView.reloadData()
            }
        }
        self.viewModel.getESASRatingDetailSelected(patientId: self.patientHeaderInfo?.patientID ?? 0, unitId: 0, shiftId: shiftSelectedID, locationId: 0) { (result) in
            
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
                    if (dict.inputType ?? "") == InputType.Text{
                    dict.value = textField.text ?? ""
                    dict.valueId = textField.text
                    dict.isValid = !(textField.text?.count == 0)
                    copyArr[dictIndex] = dict
                    self.arrInput[index] = copyArr
                    }
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
        return (index,dictIndex)
    }
}


//MARK:- DoubleInputCellDelegate
extension ESASFormViewController : DoubleInputCellDelegate{
    func selectedDateForDoubleInput(date : Date, textfieldTag : Int, isDateField : Bool){
        let dateStr = Utility.getStringFromDate(date: date, dateFormat: DateFormats.MM_dd_yyyy_hh_mm_a)
        
        self.setSelectedValueInTextfield(value: dateStr, valueId: dateStr, index: self.activeTextfieldTag)
    }
    
    func selectedPickerValueForDoubleInput(value : Any, valueID : Any, textfieldTag : Int)
    {
        
        self.setSelectedValueInTextfield(value: value, valueId: valueID, index: self.activeTextfieldTag)
    }
    
    func setSelectedValueInTextfield(value : Any , valueId : Any, index : Int){
        shiftSelectedID = valueId as? Int ?? 0
        let indexTuple = self.getIndexAndSubIndexFromTag(textFieldTag: self.activeTextfieldTag)
        let index = indexTuple.0
        let dictIndex = indexTuple.1
        
        let isFirstTf = dictIndex == 0
        let indexPath = IndexPath(row: index, section: 0)
        
        if let dictArr = self.arrInput[index] as? [InputTextfieldModel]{
            var copyArr = dictArr
            
            
            if dictIndex == 0 {
                let dict = copyArr[dictIndex]
                dict.value = (value as? String) ?? ""
                dict.valueId = valueId
                dict.isValid = true
                copyArr[dictIndex] = dict
                
                let dict1 = copyArr[1]
                dict1.value = ""
                dict1.valueId = nil
                dict1.isValid = false
                copyArr[1] = dict1
                
                self.arrInput[index] = copyArr
                self.viewModel.selectedUnitID = (valueId as? Int) ?? 0
            }else{
                let dict = copyArr[dictIndex]
                dict.value = (value as? String) ?? ""
                dict.valueId = valueId
                dict.isValid = true
                copyArr[dictIndex] = dict
                self.arrInput[index] = copyArr
            }
            
        }
        
        
        if let cell = self.tblView.cellForRow(at: indexPath) as? DoubleInputCell{
            if  isFirstTf{
                cell.inputTf1.text = (value as? String) ?? ""
                cell.inputTf2.text = ""
            }else{
                cell.inputTf2.text = (value as? String) ?? ""
            }
        }
    }
}
