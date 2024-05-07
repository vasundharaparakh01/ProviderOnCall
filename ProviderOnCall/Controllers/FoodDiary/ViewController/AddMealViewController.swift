//
//  AddMealViewController.swift
//  AccessEMR
//
//  Created by Vasundhara Mehta on 04/08/20.
//  Copyright © 2020 smartData Enterprises (I) Ltd. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import FSCalendar

class AddMealViewController: BaseViewController {
    @IBOutlet weak var tblView: UITableView!
    var arrInput = [Any]()
    var selectedMealIds = [[String : String]]()
    var selectedDayIds = [[String : String]]()
    var activeTextfieldTag = 0
    var activeTextfield : InputTextField?
    var selectedDateString = ""
    var minTime : Date? = Date()
    var maxTime : Date?
    var isValidating = false
    var patientId = 0
    lazy var viewModel: AddMealViewModel = {
        let obj = AddMealViewModel(with: PointOfCareService())
        self.baseViewModel = obj
        return obj
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialSetup()
    }

    func initialSetup(){

        self.addrightBarButtonItem()
        self.registerNIBs()
        self.setupClosures()
        self.addBackButton()
        self.navigationItem.title = NavigationTitle.AddMealPlan
        self.viewModel.getMealMasters()
        
    }
    func addrightBarButtonItem() {
        let rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target:  self, action: #selector(onRightBarButtonItemClicked(_ :)))
        rightBarButtonItem.tintColor = UIColor.white
        navigationItem.rightBarButtonItem = rightBarButtonItem
    }

    @objc func onRightBarButtonItemClicked(_ sender: UIBarButtonItem) {
        self.view.endEditing(true)
        
        //======= for Validation
        self.isValidating = true
        self.tblView.reloadData()
        //======= Ends
        
        let inputParams = self.createAPIParams()
        //Change for removing Notes as mandatory
        var copyParams = inputParams
        if inputParams[Key.Params.AddMeal.notes] == nil{
            copyParams[Key.Params.AddMeal.notes] = " "
        }
        
        if copyParams.keys.count == 7 &&
            self.isMealsArrayValid(input: inputParams, index: 0) &&
            self.isMealsArrayValid(input: inputParams, index: 1) &&
            self.isMealsArrayValid(input: inputParams, index: 2){
            //TODO: Call save api
            self.viewModel.saveMealPlan(params: inputParams)
        }else{
            self.viewModel.errorMessage = "Please fill missing inputs."
        }
    }
    func isMealsArrayValid(input : [String : Any],index : Int) -> Bool{
        if let breakFastDictArray = input[Key.Params.AddMeal.mealItemMapping] as? [[String:Any]]{
            let breakFastDict = breakFastDictArray[index]
            if breakFastDict.keys.count != 5 {
                return false
            }else{
                var isMealDetailValid = [Bool]()
                if let mealDetailsArray = breakFastDict[Key.Params.AddMeal.mealDetails] as? [[String:Any]]{
                    print("MealDetail == \(mealDetailsArray)")
                    
                    for (_,item) in mealDetailsArray.enumerated() {
                        let isMealItemsValid = (item[Key.Params.AddMeal.mealItemsModel] as? [Int] ?? [0]) != [0]
                        let isServingSizeValid = (item[Key.Params.AddMeal.servingSize] as? String ?? "") != ""
                        let isServingSizePortionValid = (item[Key.Params.AddMeal.servingSizePortion] as? String ?? "") != ""
                        
                        if isMealItemsValid && isServingSizeValid && isServingSizePortionValid{
                            isMealDetailValid.append(true)
                        }else{
                            isMealDetailValid.append(false)
                        }
                    }
                    let filterValid = isMealDetailValid.filter({$0 == true})
                    
                    if filterValid.count != 7 {
                        return false
                    }
                }
            }
        }
        return true
    }
    func registerNIBs(){
        self.tblView.register(UINib(nibName: ReuseIdentifier.DoubleInputCell, bundle: nil), forCellReuseIdentifier: ReuseIdentifier.DoubleInputCell)
        self.tblView.register(UINib(nibName: ReuseIdentifier.TextInputCell, bundle: nil), forCellReuseIdentifier: ReuseIdentifier.TextInputCell)
        
        self.tblView.register(UINib(nibName: ReuseIdentifier.PickerInputCell, bundle: nil), forCellReuseIdentifier: ReuseIdentifier.PickerInputCell)
        
        self.tblView.register(UINib(nibName: ReuseIdentifier.DateTimeInputCell, bundle: nil), forCellReuseIdentifier: ReuseIdentifier.DateTimeInputCell)
        
        self.tblView.register(UINib(nibName: ReuseIdentifier.NumberInputCell, bundle: nil), forCellReuseIdentifier: ReuseIdentifier.NumberInputCell)
        
        self.tblView.register(UINib(nibName: ReuseIdentifier.CheckmarkInputCell, bundle: nil), forCellReuseIdentifier: ReuseIdentifier.CheckmarkInputCell)
        
        self.tblView.register(UINib(nibName: ReuseIdentifier.RecursiveBPCell, bundle: nil), forCellReuseIdentifier: ReuseIdentifier.RecursiveBPCell)

        
        self.tblView.register(UINib(nibName: ReuseIdentifier.RecursiveMealCell, bundle: nil), forCellReuseIdentifier: ReuseIdentifier.RecursiveMealCell)

    }
    
    func setupClosures() {
        self.viewModel.updateViewClosure = { [weak self] () in
            DispatchQueue.main.async {
                self?.arrInput = self?.viewModel.getInputArray() ?? [""]
                self?.tblView.reloadData()
            }
        }
        
        self.viewModel.reloadListViewClosure = { [weak self] () in
            DispatchQueue.main.async {
            }
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
                    if let dict = dictObj as? [InputTextfieldModel],dict.count != 4{
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
                    paramDict[key] = val
                }
            }else if let val  = value as? Int{
                //if val != 0{
                    paramDict[key] = val
                //}
            }else{
                paramDict[key] = value
            }
        }
        paramDict[Key.Params.patientId] = self.patientId
        paramDict[Key.Params.AddMeal.mealCategoryId] = nil
        paramDict[Key.Params.AddMeal.startDate] = nil
        paramDict[Key.Params.AddMeal.stopDate] = nil
        paramDict[Key.Params.AddMeal.mealTime] = nil

        var dict = [String : Any]()
        var arrOfSubDicts = [[String:Any]]()
        arrOfSubDicts.append((self.getSubDictsOfMealDetail(keyName: Key.Params.AddMeal.mealDetails, type: AddMealTitles.MealCategory,indexOfDict: 0).0)["mealDetails"] as! [String : Any])
        arrOfSubDicts.append((self.getSubDictsOfMealDetail(keyName: Key.Params.AddMeal.mealDetails, type: AddMealTitles.MealCategory,indexOfDict: 1).0)["mealDetails"] as! [String : Any])
        arrOfSubDicts.append((self.getSubDictsOfMealDetail(keyName: Key.Params.AddMeal.mealDetails, type: AddMealTitles.MealCategory,indexOfDict: 2).0)["mealDetails"] as! [String : Any])

        dict[Key.Params.AddMeal.mealItemMapping] = arrOfSubDicts
        paramDict.merge(dict: dict)

        /*
        paramDict.merge(dict: self.getSubDictsOfMealDetail(keyName: Key.Params.AddMeal.mealDetails, type: AddMealTitles.MealCategory,indexOfDict: 0).0)
        paramDict.merge(dict: self.getSubDictsOfMealDetail(keyName: Key.Params.AddMeal.mealDetails, type: AddMealTitles.MealCategory,indexOfDict: 1).0)
        paramDict.merge(dict: self.getSubDictsOfMealDetail(keyName: Key.Params.AddMeal.mealDetails, type: AddMealTitles.MealCategory,indexOfDict: 2).0)
        */
        
        /*
        if let startDate = paramDict[Key.Params.AddMeal.startDate] as? Date{
            paramDict[Key.Params.AddMeal.startDate] = Utility.getStringFromDate(date: startDate, dateFormat: "yyyy-MM-dd") + "T00:00:00.000Z"
        }
        if let endDate = paramDict[Key.Params.AddMeal.stopDate] as? Date{
            paramDict[Key.Params.AddMeal.stopDate] = Utility.getStringFromDate(date: endDate, dateFormat: "yyyy-MM-dd") + "T00:00:00.000Z"
        }
        */
        
        return paramDict
    }
    
    func getCategoryNameFromID(idCategory : Int) -> String{
        let categoryNameArray = self.viewModel.mealCategoryDropdown.compactMap { (dropdown) -> String? in
            return (dropdown.id ?? 0) == idCategory ? (dropdown.name ?? "") : nil
        }
        return  categoryNameArray.count > 0 ? (categoryNameArray.first ?? "") : ""
    }
    
    func getSubDictsOfMealDetail(keyName : String,type: String,indexOfDict : Int) -> ([String:Any],Int){
        let arr = self.getArrayOfType(type: type)
        var subArray = [[String : Any]]()
        var mealDetailsubArray = [[String : Any]]()
        var finalDict = [String : Any]()
        for (numberIndex,dictArr) in arr.enumerated() {
            var mainDict = [String : Any]()
            if numberIndex == indexOfDict{

            for (index1,dict2) in dictArr.enumerated() {
                var tempDict = [String : Any]()
                for (index,dict) in dict2.enumerated() {

                    /*
                     if (dict.apiKey ?? "") == Key.Params.AddMeal.mealItemsModel{
                     let arr = ((dict.valueId ?? "") as? String)?.components(separatedBy: ",")
                     let intArr = arr?.compactMap({Int($0) ?? 0})
                     tempDict[dict.apiKey ?? ""] = intArr
                     }else if (dict.apiKey ?? "") == Key.Params.AddMeal.mealDays{
                     let arr = ((dict.valueId ?? "") as? String)?.components(separatedBy: ",")
                     if let intArr = arr?.compactMap({Int($0) ?? 0}){
                     let daysNameArr = intArr.map { (dayInt) -> String in
                     return self.viewModel.getDayName(id: dayInt)
                     }
                     tempDict[dict.apiKey ?? ""] = daysNameArr
                     }
                     }else*/
                    if (dict.apiKey ?? "") != ""{
                        if dict.apiKey ?? "" == Key.Params.AddMeal.startDate{
                            if let startDate = dict.valueId as? Date{
                                tempDict[dict.apiKey ?? ""]  = Utility.getStringFromDate(date: startDate, dateFormat: "yyyy-MM-dd") + "T00:00:00.000Z"
                                mainDict[dict.apiKey ?? ""] = Utility.getStringFromDate(date: startDate, dateFormat: "yyyy-MM-dd") + "T00:00:00.000Z"

                            }
                        }else if (dict.apiKey ?? "" == Key.Params.AddMeal.stopDate){
                            if let stopDate = dict.valueId as? Date{
                                tempDict[dict.apiKey ?? ""]  = Utility.getStringFromDate(date: stopDate, dateFormat: "yyyy-MM-dd") + "T00:00:00.000Z"
                                mainDict[dict.apiKey ?? ""] = Utility.getStringFromDate(date: stopDate, dateFormat: "yyyy-MM-dd") + "T00:00:00.000Z"
                            }
                        }else if (dict.apiKey ?? "" == Key.Params.AddMeal.mealTime){
                            if let startDate = dict.valueId as? Date{
                                tempDict[dict.apiKey ?? ""]  = Utility.getStringFromDate(date: startDate, dateFormat: DateFormats.hh_mm_a)
                                mainDict[dict.apiKey ?? ""] = Utility.getStringFromDate(date: startDate, dateFormat: DateFormats.hh_mm_a)
                            }
                        }else{
                            if dict.apiKey ?? "" == Key.Params.AddMeal.mealItemsModel{
                                
                                let idsArrayStr = ((dict.valueId ?? "") as! String).components(separatedBy: ",")
                                let idsArrayInt = idsArrayStr.compactMap({Int($0) as? Int ?? 0})
                                tempDict[dict.apiKey ?? ""] = idsArrayInt
                                mainDict[dict.apiKey ?? ""] = idsArrayInt

                            }else{
                                tempDict[dict.apiKey ?? ""] = dict.valueId ?? ""
                                mainDict[dict.apiKey ?? ""] = dict.valueId ?? ""
                            }
                        }
                        
                    }
                    if dict2.count == 4{
                        if index == 3{
                            //mealDetailsubArray.append(contentsOf: subArray)
                            //subArray.append(contentsOf: mealDetailsubArray)
                            subArray.append(tempDict)
                            mainDict[Key.Params.AddMeal.mealDetails] = subArray
                        }
                        
                    }
                    /*else if dict2.count == 2{
                        if index == 1{
                            subArray.append(tempDict)
                        }
                    }*/
                }
                }
                //if indexOfDict == dictArr.count{
                    print("SubArraayyy === \(mainDict)")
                    finalDict = mainDict
               // }

            }

        }
        //finalDict[Key.Params.AddMeal.stopDate] = nil
        //finalDict[Key.Params.AddMeal.startDate] = nil
        finalDict[Key.Params.AddMeal.servingSize] = nil
        finalDict[Key.Params.AddMeal.servingSizePortion] = nil
        finalDict[Key.Params.AddMeal.mealDays] = nil
        finalDict[Key.Params.AddMeal.type] = self.getCategoryNameFromID(idCategory:  finalDict[Key.Params.AddMeal.mealCategoryId] as? Int ?? 0)
        finalDict[Key.Params.AddMeal.mealItemsModel] = nil
        finalDict[Key.Params.AddMeal.mealCategoryId] = nil

        return ([keyName : finalDict],subArray.count)
    }
    
}

//MARK:- UITableViewDelegate,UITableViewDataSource

extension AddMealViewController : UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.arrInput.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let arr = self.arrInput[indexPath.section] as? [Any]{
            if let dictArr = arr[indexPath.row] as? [InputTextfieldModel] , dictArr.count == 4{
                return Device.IS_IPAD ? 290 : 220
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
        return self.viewModel.titleForHeader(section: section).count == 0 ? 0 : 50
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 40))
        headerView.backgroundColor = UIColor.white
        
        let lblSection = UILabel(frame: CGRect(x: 15, y: 10, width: tableView.frame.size.width - 20, height: 30))
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
                    cell.inputTf.placeholder = dict.placeholder ?? ""
                    cell.inputTf.text = dict.value ?? ""
                    self.updateTextfieldAppearance(inputTf: cell.inputTf, dict: dict)
                    cell.inputTf.delegate = self
                    cell.selectionStyle = .none
                    return cell
                case InputType.Number:
                    let cell = tableView.dequeueReusableCell(withIdentifier: ReuseIdentifier.NumberInputCell, for: indexPath as IndexPath) as! NumberInputCell
                    cell.inputTf.tag = indexPath.row
                    let placeholder =  dict.placeholder ?? ""
                    cell.inputTf.placeholder = placeholder
                    self.updateTextfieldAppearance(inputTf: cell.inputTf, dict: dict)
                    cell.inputTf.text = dict.value ?? ""
                    cell.inputTf.delegate = self
                    cell.selectionStyle = .none
                    return cell
                case InputType.Date:
                    let cell = tableView.dequeueReusableCell(withIdentifier: ReuseIdentifier.DateTimeInputCell, for: indexPath as IndexPath) as! DateTimeInputCell
                    cell.inputTf.tag = indexPath.row
                    cell.isDateField = true
                    cell.inputTf.delegate = self
                    cell.delegate = self
                    cell.inputTf.placeholder = dict.placeholder ?? ""
                    //cell.datePicker.minimumDate = Date()
                    cell.setupDatePicker()
                    if (dict.value ?? "").count != 0{
                        cell.inputTf.text = dict.value ?? ""
                    }
                    
                    cell.selectionStyle = .none
                    self.updateTextfieldAppearance(inputTf: cell.inputTf, dict: dict)
                    
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
                case InputType.Checkmark:
                    let cell = tableView.dequeueReusableCell(withIdentifier: ReuseIdentifier.CheckmarkInputCell, for: indexPath as IndexPath) as! CheckmarkInputCell
                    cell.lblTitle.text = dict.placeholder ?? ""
                    cell.btnCheck.tag = indexPath.row
                    cell.btnCheck.setImage(((dict.valueId as? Bool) ?? false) ? UIImage.filledCircle() : UIImage.unfilledCircle() , for: .normal)
                    cell.btnCheck.addTarget(self, action: #selector(self.btnCheck_clicked(button:)), for: .touchUpInside)
                    cell.selectionStyle = .none
                    cell.btnCheck.isHidden =  (dict.placeholder ?? "") == ""
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
                    
                    if indexPath.section == ADLSections.Continenece.rawValue{
                        cell.inputTf1.placeholder = ADLTrackingTitles.Bladder
                        cell.inputTf2.placeholder = ADLTrackingTitles.Bowel
                        //cell.lblTitle.text = ADLTrackingHeaders.Continenece
                    }
                    
                    cell.awakeFromNib()
                    
                    
                    cell.inputTf1.tag = indexPath.row + TagConstants.DoubleTF_FirstTextfield_Tag
                    cell.inputTf2.tag = indexPath.row + TagConstants.DoubleTF_SecondTextfield_Tag
                    cell.delegate = self
                    cell.inputT2_type = tfTwoDict.inputType ?? ""
                    cell.inputT1_type = tfOneDict.inputType ?? ""
                    
                    if cell.inputTf1.placeholder == AddMealTitles.MealCategory{
                        cell.inputTf1.isUserInteractionEnabled = false
                    }else{
                        cell.inputTf1.isUserInteractionEnabled = true
                    }
                    
                    cell.selectionStyle = .none
                    return cell
                }else{
                    let cell = tableView.dequeueReusableCell(withIdentifier: ReuseIdentifier.RecursiveMealCell, for: indexPath as IndexPath) as! RecursiveMealCell
                    var title = ""
                    if let dictArr = inputDict as? [InputTextfieldModel] {
                        
                        cell.inputTf1.tag = indexPath.row + TagConstants.RecursiveTF_FirstTextfield_Tag
                        cell.inputTf2.tag = indexPath.row + TagConstants.RecursiveTF_SecondTextfield_Tag
                        cell.inputTf3.tag = indexPath.row + TagConstants.RecursiveTF_ThirdTextfield_Tag
                        cell.inputTf4.tag = indexPath.row + TagConstants.RecursiveTF_FourthTextfield_Tag


                        let tfOneDict = dictArr[0]
                        let tfTwoDict = dictArr[1]
                        let tfThreeDict = dictArr[2]
                        let tfFourDict = dictArr[3]

                        cell.inputTf1.delegate = self
                        cell.inputTf2.delegate = self
                        cell.inputTf3.delegate = self
                        cell.inputTf4.delegate = self

                        self.updateTextfieldAppearance(inputTf: cell.inputTf1, dict: tfOneDict)
                        self.updateTextfieldAppearance(inputTf: cell.inputTf2, dict: tfTwoDict)
                        self.updateTextfieldAppearance(inputTf: cell.inputTf3, dict: tfThreeDict)
                        self.updateTextfieldAppearance(inputTf: cell.inputTf4, dict: tfFourDict)

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
                        
                        cell.inputTf4.placeholder = tfFourDict.placeholder ?? ""
                        cell.inputT4_type = tfFourDict.inputType ?? ""
                        if (tfFourDict.inputType ?? "") == InputType.Dropdown{
                            cell.arrDropdown4 = tfFourDict.dropdownArr ?? [Any]()
                            cell.pickerView.reloadAllComponents()
                        }else if ((tfFourDict.inputType ?? "") == InputType.Time){
                            cell.isDateField4 = false
                        }else if ((tfFourDict.inputType ?? "") == InputType.Date){
                            cell.isDateField4 = true
                        }
                        if (tfFourDict.value ?? "").count != 0{
                            cell.inputTf4.text = tfFourDict.value ?? ""
                        }else{
                            cell.inputTf4.text = ""
                        }
                        
                        title = tfOneDict.sectionHeader ?? ""
                        cell.lblTitle.text = ""//title
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
                    
                    cell.btnAdd.isHidden = true
                    cell.btnDelete.isHidden = true
                    
                   if cell.inputTf1.placeholder == AddMealTitles.Days{
                        cell.inputTf1.isUserInteractionEnabled = false
                    }else{
                        cell.inputTf1.isUserInteractionEnabled = true
                    }
                    
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
        if let cell = button.superview?.superview as? RecursiveMealCell{
            if let indexPath = self.tblView.indexPath(for: cell){
                if let mainArray = self.arrInput[indexPath.section] as? [Any] {
                    var copyMainArray = mainArray
                    let addObject = self.viewModel.mealCategoryInput(day: "Sunday")
                    copyMainArray.insert(addObject, at: indexPath.row + 1)
                    self.arrInput[indexPath.section] = copyMainArray
                    self.tblView.reloadData()
                }
            }
        }
    }

    @objc func deleteButton_clicked(button : UIButton) {
        self.isValidating = false

        if let cell = button.superview?.superview as? RecursiveMealCell{
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

    }

    func canDeleteRecursiveCell(inputArr : [Any]) -> Bool{
        return true
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
    
    func getArrayOfType(type:String) -> [[[InputTextfieldModel]]]{
        var subArray = [[[InputTextfieldModel]]]()

        for (_,arrMain) in self.arrInput.enumerated() {
            var similarTypeArray = [[InputTextfieldModel]]()
            if let arrTemp = arrMain as? [Any]{
                for (_,dictArray) in arrTemp.enumerated() {
                    if let dict = dictArray as? [InputTextfieldModel]{
                        if dict[0].sectionHeader == type{
                            similarTypeArray.append(dict)
                        }
                    }
                }
            }
            subArray.append(similarTypeArray)
        }
        
        return subArray
    }
    @objc func  btnCheck_clicked(button : UIButton) {
        if let cell = button.superview?.superview as? CheckmarkInputCell{
            if let indexPath = self.tblView.indexPath(for: cell){
                if let dictArr = (self.arrInput[indexPath.section] as? [Any])  {
                    var copyArr = dictArr
                    let emailtf = InputTextfieldModel(value: "", placeholder: "Email", apiKey: "emailId", valueId: nil, inputType: InputType.Text, dropdownArr: nil,isValid: false, errorMessage: ConstantStrings.mandatory)
                    if let dict = copyArr[indexPath.row] as? InputTextfieldModel{
                        if ((dict.valueId as? Bool) ?? false){
                            copyArr.remove(at:  indexPath.row + 1)
                        }else{
                            copyArr.insert(emailtf, at: indexPath.row + 1)
                        }
                        
                        dict.value = ""
                        dict.valueId = !((dict.valueId as? Bool) ?? false)
                        dict.isValid = true
                        copyArr[indexPath.row] = dict
                        self.arrInput[indexPath.section] = copyArr
                        cell.btnCheck.setImage(((dict.valueId as? Bool) ?? false) ? UIImage.filledCircle() : UIImage.unfilledCircle() , for: .normal)
                        self.tblView.reloadData()
                    }
                }
                
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
    
    func showMultiValuePicker(indexPath : IndexPath,dropDownArray : [Any]){
        
        
        var pickerData : [[String:String]] = [[String:String]]()
        
        for (index,item) in dropDownArray.enumerated() {
            if let itemTaskType = item as? MealMasterDropdown{
                pickerData.append(["value":"\(itemTaskType.id ?? 0)","display":itemTaskType.name ?? ""])
            }
        }
        
        var valuesIdsArray = [String]()
        if let dictArr = (self.arrInput[indexPath.section] as? [Any]){
            var copyArr = dictArr[indexPath.row] as! [InputTextfieldModel]
            let dictIndex = self.getIndexForMultipleTf(textFieldTag: self.activeTextfieldTag)
            let dict = copyArr[dictIndex]
            
            let arrOfDropdown = (dict.dropdownArr as! [MealMasterDropdown])
            if let selectedIds = (dict.valueId as? String)?.components(separatedBy: ",").map({Int($0) ?? 0}){
                let selMealIds = arrOfDropdown.compactMap { (entity) -> [String:String]? in
                    if  selectedIds.contains((entity.id ?? 0)){
                        return ["value": "\(entity.id ?? 0)" , "display" : entity.name ?? ""]
                    }
                    return nil
                }
                if (dict.placeholder ?? "") == AddMealTitles.MealItem{
                    self.selectedMealIds = selMealIds
                    valuesIdsArray = self.selectedMealIds.compactMap { (entity) -> String? in
                        return entity["value"]
                    }

                }else{
                    self.selectedDayIds = selMealIds
                    valuesIdsArray = self.selectedDayIds.compactMap { (entity) -> String? in
                        return entity["value"]
                    }

                }
                
            }
            MultiPickerDialog().show(title: "Select",doneButtonTitle:"Done", cancelButtonTitle:"Cancel" ,options: pickerData, selected:  valuesIdsArray) {
                values -> Void in
                let valueArr = values.compactMap { ( entity) -> String? in
                    return entity["display"]
                }
                let valueIdsArr = values.compactMap { (entity) -> String? in
                    return entity["value"]
                }
                
                if let dictArr = (self.arrInput[indexPath.section] as? [Any]){
                    var copyArr = dictArr
                    if let dictArray = dictArr[indexPath.row] as? [InputTextfieldModel]{
                        var copyDictArray = dictArray
                        let dictIndex = self.getIndexForMultipleTf(textFieldTag: self.activeTextfieldTag)

                        let dict = copyDictArray[dictIndex] as! InputTextfieldModel
                        var copyOfDict = dict
                        if (dict.placeholder ?? "") == AddMealTitles.MealItem{
                            self.selectedMealIds = values
                        }else{
                            self.selectedDayIds = values
                        }
                        
                        let uniqueStaffIds = Array(Set(self.selectedMealIds))
                        let uniqueStaffvalueArr = uniqueStaffIds.compactMap { (entity) -> String? in
                            return entity["display"]
                        }
                        let uniqueIdsvalueArr = uniqueStaffIds.compactMap { (entity) -> String? in
                            return entity["value"]
                        }
                        var finalString = ""
                        
                        let stringValue = valueArr.joined(separator: ", ")
                        let stringIds = valueIdsArr.joined(separator: ",")
                        if (dict.placeholder ?? "") == AddMealTitles.MealItem{
                            self.viewModel.selectedMealIds = stringIds
                        }else{
                            self.viewModel.selectedDayIds = stringIds
                        }
                        copyOfDict.value = stringValue
                        copyOfDict.valueId = stringIds
                        finalString = stringValue
                        
                        
                        copyOfDict.isValid = true
                        copyDictArray[dictIndex] = copyOfDict
                        copyArr[indexPath.row] = copyDictArray
                        self.arrInput[indexPath.section] = copyArr
                        
                        self.activeTextfield?.text = finalString
//                        if let cell = self.tblView.cellForRow(at: IndexPath(row: indexPath.row, section: indexPath.section )) as? TextInputCell{
//                            cell.inputTf.text = finalString
//                        }
                        
                        print("SELECTED MEALS \(self.selectedMealIds)")
                        print("SELECTED Days \(self.selectedDayIds)")

                    }
                }
            }
        }
    }
}
//MARK:- UITextFieldDelegate
extension AddMealViewController : UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
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
                        let index = self.getIndexAndSubIndexFromTag(textFieldTag: self.activeTextfieldTag).0
                        let dictIndex = self.getIndexForMultipleTf(textFieldTag: self.activeTextfieldTag)//self.getIndexAndSubIndexFromTag(textFieldTag: self.activeTextfieldTag).1
                        if let cell = textField.superview?.superview as? NumberInputCell{
                        }else if let cell = textField.superview?.superview as? TextInputCell{
                            if let indexPath = self.tblView.indexPath(for: (cell)) {
                                
                                if (textField.placeholder ?? "") == AddMealTitles.MealItem {
                                    self.showMultiValuePicker(indexPath: indexPath,dropDownArray: self.viewModel.mealItemDropdown ?? [""])
                                }else if(textField.placeholder ?? "") == AddMealTitles.Days{
                                    self.showMultiValuePicker(indexPath: indexPath,dropDownArray: self.viewModel.daysDropdown ?? [""])

                                }
                                
                            }
                        }
                        else if let cell = textField.superview?.superview as? DateTimeInputCell{
                            if let indexPath = self.tblView.indexPath(for: (cell)) {
                                if let dictArr = (self.arrInput[indexPath.section] as? [Any])  {
                                    var copyArr = dictArr
                                    if let dict = copyArr[indexPath.row] as? InputTextfieldModel{
                                        if((dict.inputType ?? "") == InputType.Date || (dict.inputType ?? "") == InputType.Time)
                                        {
                                                
                                                let isDate = (dict.inputType ?? "") == InputType.Date
                                                let dateStr = Utility.getStringFromDate(date: Date(), dateFormat: isDate ? DateFormats.mm_dd_yyyy : DateFormats.hh_mm_a)
                                            if isDate{
                                                self.selectedDateString = Utility.getStringFromDate(date: Date(), dateFormat: DateFormats.YYYY_MM_DD)
                                            }
                                                dict.value = dateStr
                                            dict.valueId = self.selectedDateString//dateStr//Date()
                                                dict.isValid = true
                                                copyArr[indexPath.row] = dict
                                                self.arrInput[indexPath.section] = copyArr
                                                
                                                textField.text = dateStr
                                                
                                        }
                                    }
                                }
                            }
                        }
                        else if let cell = textField.superview?.superview as? DoubleInputCell{
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
                                    }else if((dict.inputType ?? "") == InputType.Date || (dict.inputType ?? "") == InputType.Time)
                                    {
                                        
                                        //cell.datePicker1.minimumDate = self.minTime
                                        //cell.datePicker1.maximumDate = self.maxTime

                                        //cell.datePicker2.minimumDate = self.minTime
                                       // cell.datePicker2.maximumDate = self.maxTime

                                        cell.datePicker1.setDate(self.minTime ?? Date(), animated: true)
                                        cell.datePicker2.setDate(self.minTime ?? Date(), animated: true)

                                        cell.datePicker1.reloadInputViews()
                                        cell.datePicker2.reloadInputViews()
                                        

                                        let isDate = (dict.inputType ?? "") == InputType.Date
                                            let dateStr = Utility.getStringFromDate(date: self.minTime ?? Date(), dateFormat: isDate ? DateFormats.mm_dd_yyyy : DateFormats.hh_mm_a)

                                        dict.value = dateStr
                                        dict.valueId = self.minTime ?? Date()
                                        dict.isValid = true
                                         copySubArray[reqdIndex] = dict
                                         copyArr[indexPath.row] = copySubArray
                                         self.arrInput[indexPath.section] = copyArr

                                        textField.text = dateStr
                                        
                                    }else if ((dict.inputType ?? "") == InputType.Dropdown){
                                        
                                        if let cell = self.tblView.cellForRow(at: indexPath) as? DoubleInputCell{
                                            cell.pickerView.reloadAllComponents()
                                            
                                            if let arr = dict.dropdownArr as? [Any]{
                                                cell.pickerView.selectRow(0, inComponent: 0, animated: false)
                                                
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
                       /* if let indexPath = self.tblView.indexPath(for: (cell)) {
                            if let dictArr = (self.arrInput[indexPath.section] as! [Any]) as? [InputTextfieldModel]{
                                var copyArr = dictArr
                                let dict = copyArr[dictIndex]

                                 if ((dict.inputType ?? "") == InputType.Dropdown){
                                    if let cell = self.tblView.cellForRow(at: indexPath) as? DoubleInputCell{
                                        cell.pickerView.reloadAllComponents()
                                    }

                                    if let arr = dict.dropdownArr as? [Any]{
                                        cell.pickerView.selectRow(0, inComponent: 0, animated: false)

                                        let selectedValue = Utility.getSelectedValue(arrDropdown: arr,row: 0)

                                        dict.value = selectedValue.value
                                        dict.valueId = selectedValue.valueID
                                    dict.isValid = true
                                    copyArr[indexPath.row] = dict
                                    self.arrInput[indexPath.section] = copyArr
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

                                 }else if ((dict.inputType ?? "") == InputType.Number){
                                    dict.value = textField.text
                                    dict.valueId = textField.text
                                    dict.isValid = true
                                    copyArr[indexPath.row] = dict
                                    self.arrInput[indexPath.section] = copyArr
                                 }else if((dict.inputType ?? "") == InputType.Date || (dict.inputType ?? "") == InputType.Time)
                                    {
                                        let isDate = (dict.inputType ?? "") == InputType.Date
                                        let dateStr = Utility.getStringFromDate(date: Date(), dateFormat: isDate ? DateFormats.mm_dd_yyyy : DateFormats.hh_mm_a)

                                        dict.value = dateStr
                                        dict.valueId = Date()
                                        dict.isValid = true
                                         copyArr[indexPath.row] = dict
                                         self.arrInput[indexPath.section] = copyArr

                                        textField.text = dateStr
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
                                        dict.valueId = dateStr
                                        dict.isValid = true
                                        copyArr[dictIndex] = dict
                                        //self.arrInput[index] = copyArr
                                        
                                        copySubArray[indexPath.row] = copyArr
                                        copyMainArray[indexPath.section] = copySubArray
                                        self.arrInput = copyMainArray
                                        
                                        textField.text = dateStr
                                    }else if ((dict.inputType ?? "") == InputType.Dropdown){
                                        if let cell = self.tblView.cellForRow(at: indexPath) as? DoubleInputCell{
                                            cell.pickerView.reloadAllComponents()
                                        }
                                        if let arr = dict.dropdownArr as? [Any]{
                                            cell.pickerView.selectRow(0, inComponent: 0, animated: false)

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
                        }*/
                        }else if let cell = textField.superview?.superview as? PickerInputCell{
                        if let indexPath = self.tblView.indexPath(for: (cell)) {
                            if let dictArr = (self.arrInput[indexPath.section] as? [Any])  {
                                var copyArr = dictArr
                                if let dict = copyArr[indexPath.row] as? InputTextfieldModel{
                                    if ((dict.inputType ?? "") == InputType.Dropdown){
                                        
                                        let tempDict = dict
                                        if let arr = tempDict.dropdownArr as? [Any]{
                                            cell.pickerView.selectRow(0, inComponent: 0, animated: false)
                                            
                                            let selectedValue = Utility.getSelectedValue(arrDropdown: arr,row: 0)
                                            tempDict.value = selectedValue.value
                                            tempDict.valueId = selectedValue.valueID
                                            tempDict.isValid = true
                                            copyArr[indexPath.row] = tempDict
                                            self.arrInput[indexPath.section] = copyArr
                                            textField.text = selectedValue.value
                                            
                                            
                                        }
                                    }else if ((dict.inputType ?? "") == InputType.Text || (dict.inputType ?? "") == InputType.Number){
                                        let tempDict = dict

                                        tempDict.value = textField.text
                                        tempDict.valueId = textField.text
                                        tempDict.isValid = true
                                        copyArr[indexPath.row] = tempDict
                                        self.arrInput[indexPath.section] = copyArr
                                    }
                                    
                                }
                            }
                        }
                        }else if let cell = textField.superview?.superview as? RecursiveMealCell{
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
                                        }else if (textField.placeholder ?? "") == AddMealTitles.MealItem {
                                            self.showMultiValuePicker(indexPath: indexPath,dropDownArray: self.viewModel.mealItemDropdown ?? [""])
                                        }else if (textField.placeholder ?? "") == AddMealTitles.Days {
                                            self.showMultiValuePicker(indexPath: indexPath,dropDownArray: self.viewModel.daysDropdown ?? [""])
                                        }else if ((dict.inputType ?? "") == InputType.Text) || ((dict.inputType ?? "") == InputType.Number) || ((dict.inputType ?? "") == InputType.Decimal){
                                            textField.inputView = nil
                                            copyDict.value = textField.text ?? ""
                                            if dict.placeholder ?? "" != AddMealTitles.MealItem || dict.placeholder ?? "" != AddMealTitles.Days{
                                                copyDict.valueId = textField.text ?? ""
                                            }
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
                        else{

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
                                    dict.valueId = dateStr//Date()
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
                            }else{
                                if let dict = self.arrInput[index] as? InputTextfieldModel{
                                    
//                                    if ((dict.inputType ?? "") == InputType.Text || (dict.inputType ?? "") == InputType.Number){
//                                        dict.value = textField.text
//                                        dict.valueId = textField.text
//                                        dict.isValid = true
//                                        copyArr[dictIndex] = dict
//                                        self.arrInput[index] = copyArr
//
//                                    }
                                }
                            }
                        }
                        }
                    }else{
                        if let cell = textField.superview?.superview as? DoubleInputCell{
                            cell.pickerView.reloadAllComponents()
                        }
                        
                        if let cell = textField.superview?.superview as? TextInputCell{
                            if let indexPath = self.tblView.indexPath(for: (cell)) {
                                if let dictArr = (self.arrInput[indexPath.section] as? [Any])  {
                                    if let dict = dictArr[indexPath.row] as? InputTextfieldModel{
                                        //TODO: Handle Multipicker
                                    }
                                }
                            }
                        }
                        
                        if let cell = textField.superview?.superview as? RecursiveMealCell{
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
                                                               }else if (textField.placeholder ?? "") == AddMealTitles.MealItem {
                                                                   self.showMultiValuePicker(indexPath: indexPath,dropDownArray: self.viewModel.mealItemDropdown ?? [""])
                                                               }else if (textField.placeholder ?? "") == AddMealTitles.Days {
                                                                   self.showMultiValuePicker(indexPath: indexPath,dropDownArray: self.viewModel.daysDropdown ?? [""])
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


    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            // Here Set The Next return field
        textField.resignFirstResponder()
        return true
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
        }
        return true*/
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        // Here Set The Next return field
        IQKeyboardManager.shared.toolbarDoneBarButtonItemText = ButtonTitles.done
        textField.keyboardToolbar.doneBarButton.setTarget(self, action: #selector(doneAction(textField:)))
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
                                        
                                    }
                                }
                            }
                        }
                    }else if let cell = textField.superview?.superview as? DateTimeInputCell{
                        if let indexPath = self.tblView.indexPath(for: (cell)) {
                            if let dictArr = (self.arrInput[indexPath.section] as? [Any]){
                                var copyArr = dictArr
                                if let dict = dictArr[indexPath.row] as? InputTextfieldModel{
                                        dict.value = textField.text ?? ""
                                        dict.valueId = self.selectedDateString //textField.text ?? ""
                                        dict.isValid = true
                                        copyArr[indexPath.row] = dict
                                        self.arrInput[indexPath.section] = copyArr
                                    
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
                    if let cell = textField.superview?.superview as? RecursiveMealCell{
                        if let indexPath = self.tblView.indexPath(for: cell){
                            if let mainArray = self.arrInput[indexPath.section] as? [Any]{
                                var copyMainArray = mainArray
                                if let subArray = copyMainArray[indexPath.row] as? [InputTextfieldModel]{
                                    var copySubArray = subArray
                                    let dictIndex = self.getIndexForMultipleTf(textFieldTag: textField.tag)
                                    var dict = copySubArray[dictIndex]
                                    var copyDict = dict
                                    if copyDict.inputType == InputType.Dropdown || copyDict.inputType == InputType.Time {
                                        
                                    }else if(copyDict.inputType == InputType.Number){
                                        copyDict.value = textField.text
                                        copyDict.valueId = textField.text
                                        copyDict.isValid = !(textField.text?.count == 0)
                                        copySubArray[dictIndex] = copyDict
                                        copyMainArray[indexPath.row] = copySubArray
                                        self.arrInput[indexPath.section] = copyMainArray
                                        
                                    }else if(copyDict.placeholder == AddMealTitles.MealItem){
                                    }else if(copyDict.placeholder == AddMealTitles.Days){
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
                        
                        if let arrInput = self.arrInput[index] as? [Any]{
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
                                            }else{
                                                
                                                    
                                            }
                                      }
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
         return (index,dictIndex)
        
    }
    
    func getIndexForMultipleTf(textFieldTag : Int) -> Int{
        var index = textFieldTag
        var dictIndex = 0
        if index < TagConstants.DoubleTF_FirstTextfield_Tag{
        }else if textFieldTag >= TagConstants.RecursiveTF_FirstTextfield_Tag{
            let isFirstTf = index - TagConstants.RecursiveTF_FirstTextfield_Tag >= 0 && index - TagConstants.RecursiveTF_FirstTextfield_Tag < TagConstants.DoubleTF_FirstTextfield_Tag
            let isSecondTf = index >= TagConstants.RecursiveTF_SecondTextfield_Tag && index < TagConstants.RecursiveTF_ThirdTextfield_Tag
            let isThirdTf = index >= TagConstants.RecursiveTF_ThirdTextfield_Tag && index < TagConstants.RecursiveTF_FourthTextfield_Tag

            if  isFirstTf{
                index = index - TagConstants.RecursiveTF_FirstTextfield_Tag
            }else if isSecondTf {
                index = index - TagConstants.RecursiveTF_SecondTextfield_Tag
            }else if isThirdTf {
                index = index - TagConstants.RecursiveTF_ThirdTextfield_Tag
            }else{
                index = index - TagConstants.RecursiveTF_FourthTextfield_Tag
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
            }else if isThirdTf {
                dictIndex = 2
            }else{
                dictIndex = 3
            }
            //  }
        }else{
            let isFirstTf = index - TagConstants.DoubleTF_FirstTextfield_Tag >= 0 && index - TagConstants.DoubleTF_FirstTextfield_Tag < TagConstants.DoubleTF_FirstTextfield_Tag
            let isSecondTf = index >= TagConstants.DoubleTF_SecondTextfield_Tag
            
            if  isFirstTf{
                index = index - TagConstants.DoubleTF_FirstTextfield_Tag
            }else if isSecondTf {
                index = index - TagConstants.DoubleTF_SecondTextfield_Tag
            }else if isSecondTf {
                index = index - TagConstants.DoubleTF_SecondTextfield_Tag
            }
            
            if let dict = (self.arrInput[0] as! [Any])[index] as? InputTextfieldModel{
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

//MARK:- DoubleInputCellDelegate
extension AddMealViewController : DoubleInputCellDelegate{
    func selectedDateForDoubleInput(date : Date, textfieldTag : Int, isDateField : Bool){
        let dateStr = Utility.getStringFromDate(date: date, dateFormat: isDateField ? DateFormats.mm_dd_yyyy : DateFormats.hh_mm_a)
        if self.checkStaffAvailability(date: date) {
            self.setSelectedValueInTextfield(value: dateStr, valueId: date, index: self.activeTextfieldTag)
        }else{
            self.viewModel.errorMessage = "This provider is not available on this date."
        }
    }
    
    func checkStaffAvailability(date:Date ) -> Bool{
        return true
    }
    
    func isDaySame(fromDate: Date,toDate : Date) -> Bool{
        let diff = Calendar.current.dateComponents([.day], from: fromDate, to: toDate)
        return diff.day == 0
    }
    func convertServerTimeToValidTime(dateStr : String) -> Date?{
        let str = dateStr.replacingOccurrences(of: "T", with: " ")
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DateFormats.server_format
        let date = dateFormatter.date(from: str)
        return date
    }
    func selectedPickerValueForDoubleInput(value : Any, valueID : Any, textfieldTag : Int)
    {
        
        self.setSelectedValueInTextfield(value: value, valueId: valueID, index: self.activeTextfieldTag)
    }
    
    func setSelectedValueInTextfield(value : Any , valueId : Any, index : Int){
        let indexTuple = self.getIndexAndSubIndexFromTag(textFieldTag: self.activeTextfieldTag)
        let index = indexTuple.0
        let dictIndex = self.getIndexForMultipleTf(textFieldTag: self.activeTextfieldTag)
        
        let isFirstTf = index - TagConstants.DoubleTF_FirstTextfield_Tag >= 0 && index - TagConstants.DoubleTF_FirstTextfield_Tag < TagConstants.DoubleTF_FirstTextfield_Tag
        
        let isFirstTfActive = self.activeTextfieldTag - TagConstants.DoubleTF_FirstTextfield_Tag >= 0 && self.activeTextfieldTag - TagConstants.DoubleTF_FirstTextfield_Tag < TagConstants.DoubleTF_FirstTextfield_Tag

        if let indexPath = self.tblView.indexPath(for: (self.activeTextfield?.superview?.superview as! DoubleInputCell)){//IndexPath(row: index, section: 0){

        if let dictArr = (self.arrInput[indexPath.section] as? [Any]){
            let copySectionArray = dictArr
            var copyArr = dictArr[indexPath.row] as! [InputTextfieldModel]
            let dict = copyArr[isFirstTfActive ? 0 : 1]
            dict.value = (value as? String) ?? ""
            dict.valueId = valueId
            dict.isValid = true
            copyArr[isFirstTfActive ? 0 : 1] = dict
            self.arrInput[index] = copyArr
            self.arrInput[indexPath.section] = copySectionArray
            
        }
        
        if let cell = self.tblView.cellForRow(at: indexPath) as? DoubleInputCell{
            if  (isFirstTfActive ? 0 : 1) == 0{
                if let dictArr = (self.arrInput[indexPath.section] as? [Any]){
                    var copyArr = dictArr[indexPath.row] as! [InputTextfieldModel]
                    let dict = copyArr[isFirstTfActive ? 0 : 1]

                }

                cell.inputTf1.text = (value as? String) ?? ""
            }else{
                if let dictArr = (self.arrInput[indexPath.section] as? [Any]){
                    let copyArr = dictArr[indexPath.row] as! [InputTextfieldModel]
                    let dict = copyArr[isFirstTfActive ? 0 : 1]
                }
                cell.inputTf2.text = (value as? String) ?? ""
            }
        }
        }
    }
}
//MARK:- PickerInputCellDelegate
extension AddMealViewController : PickerInputCellDelegate{
    func selectedPickerValueForInput(value: Any, valueID : Any, textfieldTag: Int) {
        
        if let indexPath = self.tblView.indexPath(for: (self.activeTextfield?.superview?.superview as! PickerInputCell)){
            if let dictArr = (self.arrInput[indexPath.section] as? [Any])  {
                var copyArr = dictArr
                if let dict = copyArr[indexPath.row] as? InputTextfieldModel{
                    if ((dict.inputType ?? "") == InputType.Dropdown){
                        let tempDict = dict
                        tempDict.value = (value as? String) ?? ""
                        tempDict.valueId = valueID
                        tempDict.isValid = true
                        copyArr[indexPath.row] = tempDict
                        self.arrInput[indexPath.section] = copyArr
                        self.activeTextfield?.text = (value as? String) ?? ""
                        
                    }
                }
            }
        }
    }
    
}

//MARK:- DateTimeInputCellDelegate
extension AddMealViewController : DateTimeInputCellDelegate{
    func selectedDateForInput(date: Date, textfieldTag: Int, isDateField : Bool) {
        let dateStr = Utility.getStringFromDate(date: date, dateFormat: isDateField ? DateFormats.mm_dd_yyyy : DateFormats.hh_mm_a)
        debugPrint("Date = \(dateStr) --- Tf tag \(textfieldTag)")
        let serverDate = Utility.getStringFromDate(date: date, dateFormat:  DateFormats.YYYY_MM_DD)

        self.selectedDateString = serverDate
        let indexTuple = self.getIndexAndSubIndexFromTag(textFieldTag: self.activeTextfieldTag)
               let index = indexTuple.0
        let dictIndex = self.getIndexForMultipleTf(textFieldTag: self.activeTextfieldTag)//indexTuple.1
               
               let isFirstTf = index - TagConstants.DoubleTF_FirstTextfield_Tag >= 0 && index - TagConstants.DoubleTF_FirstTextfield_Tag < TagConstants.DoubleTF_FirstTextfield_Tag
               
        if let cell = self.activeTextfield?.superview?.superview as? DoubleInputCell{
               if let indexPath = self.tblView.indexPath(for: cell){//IndexPath(row: index, section: 0){

                if let dictArr = (self.arrInput[indexPath.section] as! [Any]) as? [InputTextfieldModel]{
                    var copyArr = dictArr
                    let dict = copyArr[dictIndex]
                    dict.value = dateStr
                    dict.valueId = serverDate//dateStr
                    dict.isValid = true
                    copyArr[dictIndex] = dict
                    self.arrInput[index] = copyArr
                    
                    
                }
               
                   if  dictIndex == 0{
                       cell.inputTf1.text = dateStr
                   }else{
                       cell.inputTf2.text = dateStr
                   }
               }
        }else if let cell = self.activeTextfield?.superview?.superview as? DateTimeInputCell{
            if let indexPath = self.tblView.indexPath(for: cell){
                if let dictArr = (self.arrInput[indexPath.section] as? [Any])  {
                    var copyArr = dictArr
                    if let dict = copyArr[indexPath.row] as? InputTextfieldModel{
                        if((dict.inputType ?? "") == InputType.Date || (dict.inputType ?? "") == InputType.Time)
                        {
                            let isDate = (dict.inputType ?? "") == InputType.Date
                            
                            dict.value = dateStr
                            dict.valueId = dateStr//Date()
                            dict.isValid = true
                            copyArr[indexPath.row] = dict
                            self.arrInput[indexPath.section] = copyArr
                            
                            cell.inputTf.text = dateStr
                        }
                    }
                }
            }
        }
        
    }
}
//MARK:- RecursiveMealCellDelegate
extension AddMealViewController : RecursiveMealCellDelegate{
    func selectedDateForRecursiveMeal(date: Date, textfieldTag: Int, isDateField: Bool) {
        let dateStr = Utility.getStringFromDate(date: date, dateFormat: isDateField ? DateFormats.mm_dd_yyyy : DateFormats.hh_mm_a)

        if let cell = self.activeTextfield?.superview?.superview as? RecursiveMealCell{
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
                    }
                }
            }
        }
        
    }
    
    func selectedPickerValueForRecursiveMeal(value: Any, valueID: Any, textfieldTag: Int) {
        self.setSelectedValueInRecursiveTextfield(value: value, valueId: valueID, index: self.activeTextfieldTag)

    }
    
    func setSelectedValueInRecursiveTextfield(value : Any , valueId : Any, index : Int){
        if let cell = self.activeTextfield?.superview?.superview as? RecursiveMealCell{
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
                        

                    }
                }
            }
        }else{
            
        }
    }

    
}

