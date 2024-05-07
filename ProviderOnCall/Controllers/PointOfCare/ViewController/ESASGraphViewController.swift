//
//  ESASGraphViewController.swift
//  AccessEMR
//
//  Created by Vasundhara Parakh on 3/25/20.
//  Copyright © 2020 smartData Enterprises (I) Ltd. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import Charts
import FSCalendar

class ESASGraphViewController: BaseViewController {
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var graphView: LMLineGraphView!
    @IBOutlet weak var lineChartView: LineChartView!
    @IBOutlet weak var lblGraphTitle: UILabel!
    @IBOutlet weak var tabsView: TabCollectionView!
    @IBOutlet weak var lblyAxisBottom: UILabel!
    @IBOutlet weak var lblyAxisTop: UILabel!
    @IBOutlet weak var tfFromDate: UITextField!
    @IBOutlet weak var tfTodate: UITextField!
    
     var staffId : Int?
     var locationID : Int?
    var startDateUpdated : Date?
    var endDateUpdated : Date?
    
    
    let startDate = Date.startOfMonth(Date())
    let endDate = Date.endOfMonth(Date())
    var startDateStr = String()
    var endDateStr = String()

    lazy var viewModel: ESASGraphViewModel = {
        let obj = ESASGraphViewModel(with: PointOfCareService())
        self.baseViewModel = obj
        return obj
    }()
    var arrInput = [Any]()
    var activeTextfieldTag = 0
    var isReadyToSave = false
    var isValidating = false
    var patientHeaderInfo : PatientBasicHeaderInfo?
    var graphData : [GraphDetails]?
    var selectedGraphData = [[GraphDetails]]()
    var dataSet = [LineChartDataSet]()
    var finalTitlesArray = [GraphDetails]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerNIBs()
        self.initialSetup()
        self.setupClosures()
        
      

    }
    @objc func tapFromDateDone() {
        if let datePicker = self.tfFromDate.inputView as? UIDatePicker { // 2-1
            //datePicker.setValidation()
            let dateformatter = DateFormatter() // 2-2
            dateformatter.dateFormat = DateFormats.YYYY_MM_DD
            startDateUpdated = datePicker.date
            startDateStr = dateformatter.string(from: datePicker.date)
            self.tfFromDate.text = dateformatter.string(from: datePicker.date) //2-4
        }
        self.tfFromDate.resignFirstResponder() // 2-5
        
    }
    @objc func tapToDateDone() {
        if let datePicker = self.tfTodate.inputView as? UIDatePicker { // 2-1
            //datePicker.setValidation()
            let dateformatter = DateFormatter() // 2-2
            dateformatter.dateFormat = DateFormats.YYYY_MM_DD
            
            //dateformatter.dateStyle = .medium // 2-3
            endDateUpdated = datePicker.date
//            if startDateUpdated ?? Date()  > datePicker.date {
//                self.viewModel.errorMessage = "End date cannot be before start date."
//                return
//            }
            self.tfTodate.text = dateformatter.string(from: datePicker.date)
            endDateStr = dateformatter.string(from: datePicker.date)
            tfTodate.text = endDateStr//2-4
        }
        self.tfTodate.resignFirstResponder() // 2-5
        
    }
    @IBAction func ApplyFilert(_ sender: UIButton) {
        if startDateUpdated ?? Date()  > endDateUpdated ?? Date() {
            self.viewModel.errorMessage = "End date cannot be before start date."
            return
        }
        if self.staffId ?? -1 > 0{
            let params = [
                Key.Params.ESAS.Rating.locationId : "\(self.locationID ?? 0)" ,
                Key.Params.ESAS.Rating.shiftId : "\(self.staffId ?? 0)",
                Key.Params.patientId : "\(self.patientHeaderInfo?.patientID ?? 0)",
                "unitId" : "\(self.viewModel.selectedUnitID)",
                "startDate" : self.startDateStr,
                "endDate" : self.endDateStr]
            self.viewModel.getESASGraphDetail(params: params)
        }else{
            self.viewModel.errorMessage = "Shift is required."
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        IQKeyboardManager.shared.previousNextDisplayMode = .alwaysHide

    }
    func initialSetup(){
        //Setup navigation bar
        //self.setupGraphView()
        
        startDateStr = Utility.getStringFromDate(date: startDate(), dateFormat: DateFormats.YYYY_MM_DD)
        tfFromDate.text = startDateStr
        endDateStr = Utility.getStringFromDate(date: endDate(), dateFormat: DateFormats.YYYY_MM_DD)
        tfTodate.text = endDateStr
        startDateUpdated = startDate()
        endDateUpdated = endDate()
        
        self.tfFromDate.setInputViewDatePicker(target: self, selector: #selector(tapFromDateDone))
        self.tfTodate.setInputViewDatePicker(target: self, selector: #selector(tapToDateDone))

        self.navigationItem.title = NavigationTitle.PointOfCareSections.ESASGraph
        self.addBackButton()
        self.viewModel.getLocationDropdown(patientID: self.patientHeaderInfo?.patientID ?? 0)
        self.lblyAxisTop.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2)
        self.lblyAxisBottom.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2)
        self.lineChartView.data = LineChartData()
        self.lblGraphTitle.text = "Please select unit & shift!"
    }
    
    func updateTabView(){
        self.tabsView.delegate = self
        self.tabsView.dataSourceArray.removeAll()
        self.tabsView.dataSourceArray = self.viewModel.titleArray
        self.tabsView.colorArray = self.viewModel.categoryColorArray
        self.tabsView.tabCollection.reloadData()
        
        self.lblGraphTitle.text = ""

    }
    
    func setupGraphView(graphDetailArr : [GraphDetails]){
        self.lblGraphTitle.text = Date().month

        self.finalTitlesArray.removeAll()
        var totalX  = 0
        for (index,item) in self.selectedGraphData.enumerated(){
            for (index1,subitem) in (item as! [GraphDetails]).enumerated(){
                print((subitem as! GraphDetails).day)
            }
            if item.count > totalX{
                totalX = item.count
                finalTitlesArray = item
            }
        }
        if self.finalTitlesArray.count > 0{
            let startDate = Utility.convertServerDateToRequiredDate(dateStr: self.finalTitlesArray.first?.createdDate ?? "", requiredDateformat: "MMM dd")
            var endDate = ""
            if self.finalTitlesArray.count > 1{
                endDate = " - " + Utility.convertServerDateToRequiredDate(dateStr: self.finalTitlesArray.last?.createdDate ?? "", requiredDateformat: "MMM dd")
            }
            self.lblGraphTitle.text = startDate + endDate
        }
        
        self.lineChartView.backgroundColor = .white
        lineChartView.gridBackgroundColor = .white
        lineChartView.drawGridBackgroundEnabled = true
        lineChartView.drawBordersEnabled = true
        lineChartView.chartDescription?.enabled = false
        lineChartView.pinchZoomEnabled = false
        lineChartView.dragEnabled = true
        lineChartView.setScaleEnabled(true)
        lineChartView.legend.enabled = false
        lineChartView.rightAxis.enabled = false
        lineChartView.xAxis.labelPosition = .bottom
        let leftAxis = lineChartView.leftAxis
        leftAxis.axisMaximum = 10
        leftAxis.axisMinimum = 0
        leftAxis.granularity = 1.0
        leftAxis.labelCount = 11
        leftAxis.granularityEnabled = true
        leftAxis.labelFont = UIFont.PoppinsMedium(fontSize: 12)
        leftAxis.labelTextColor = Color.DarkGray

        let rightAxis = lineChartView.rightAxis
        rightAxis.axisMaximum = 10
        rightAxis.axisMinimum = 0
        rightAxis.granularity = 1.0
        rightAxis.granularityEnabled = true
        rightAxis.axisLineColor = UIColor.white
        
        let xAxis = lineChartView.xAxis
        xAxis.axisMaximum = Double(totalX-1)
        xAxis.axisMinimum = 0
        //xAxis.granularity = 1.0
        xAxis.granularityEnabled = true
        xAxis.labelFont = UIFont.PoppinsMedium(fontSize: 12)
        xAxis.labelTextColor = Color.DarkGray

        
        
        let months = finalTitlesArray.compactMap({ (entity) -> String in
            return "\(Utility.convertServerDateToRequiredDate(dateStr: entity.createdDate ?? "", requiredDateformat: DateFormats.mm_dd_yy))"
        })
        xAxis.valueFormatter = IndexAxisValueFormatter(values:months)
        xAxis.granularity = 1.0
        xAxis.labelCount = months.count
        //self.lineChartView.setVisibleXRangeMaximum(6)

        self.setDataCount()
        
        /*
        // Generate sample data
        let xAxisValues = self.xAxisValues();
        let plot1 : LMGraphPlot = self.plotGraph();
        
        // Line Graph View 1
        self.graphView.layout.xAxisScrollableOnly = true
        self.graphView.xAxisValues = xAxisValues;
        self.graphView.yAxisMinValue = 0;
        self.graphView.yAxisMaxValue = 10;
        self.graphView.layout.yAxisSegmentCount = 10;
        self.graphView.yAxisUnit = "";
        self.graphView.title = Date().month.capitalized;
        self.graphView.layout.titleLabelFont = UIFont.PoppinsMedium(fontSize: 18)
        self.graphView.layout.titleLabelColor = Color.DarkGray
        self.graphView.layout.yAxisGridHidden = false
        self.graphView.layout.xAxisGridHidden = false
        self.graphView.graphPlots = [plot1]
        */
    }
    func setDataCount() {
        
        let block: (Int) -> ChartDataEntry = { (i) -> ChartDataEntry in
            var val = Double(0)
            if let arrData = self.graphData{
                val = Double(arrData[i].value ?? 0)
            }
            //val = Double(arc4random_uniform(10))
            return ChartDataEntry(x: Double(i), y: val)
        }
        
        
        
//        if let graphData = self.graphData{
//            for (index,graphInfo) in graphData.enumerated() {
//                let set = LineChartDataSet(entries: [ChartDataEntry(x: Double(index), y: Double(graphInfo.value ?? 0))], label: "DataSet \(index)")
//            set.lineWidth = 2.5
//            set.circleRadius = 5
//            set.circleHoleRadius = 0
//            let color = self.viewModel.categoryColorArray[self.viewModel.selectedCategoryIndex ?? 0]
//            set.setColor(color)
//            set.setCircleColor(color)
//            set.mode = .cubicBezier
//            let gradientColors = [color.withAlphaComponent(0.5).cgColor,
//                                  color.withAlphaComponent(0.5).cgColor]
//            let gradient = CGGradient(colorsSpace: nil, colors: gradientColors as CFArray, locations: nil)!
//
//            set.fillAlpha = 1
//            set.fill = Fill(linearGradient: gradient, angle: 90) //.linearGradient(gradient, angle: 90)
//            set.drawFilledEnabled = true
//            dataSet.append(set)
//            }
//        }
        var indexToUpdate = 0

        for (index,arrSelectedGraphs) in self.selectedGraphData.enumerated(){
            let arrData = arrSelectedGraphs
            let dataSets = (0..<self.selectedGraphData.count).map { i -> LineChartDataSet in
                let yVals = (0..<self.selectedGraphData[i].count).map{ (index) -> ChartDataEntry in
                    var val = Double(0)
                    
                    if let arrData = self.graphData{
                        val = Double(self.selectedGraphData[i][index].value ?? 0)
                        indexToUpdate = index
                        
                        for (indexNew,item) in self.finalTitlesArray.enumerated() {
                            let dayRepeated = self.finalTitlesArray.compactMap { (ent) -> Int? in
                                return ent.day == (self.selectedGraphData[i][index].day ?? 0) ? ent.day : nil
                            }
                            if dayRepeated.count == 1{
                                if (item.day ?? 0) == (self.selectedGraphData[i][index].day ?? 0){
                                    indexToUpdate = indexNew
                                }
                            }
                            /*else{
                                let firstIndex = self.finalTitlesArray.firstIndex(where: {$0.day == (self.selectedGraphData[i][index].day ?? 0)})
                                indexToUpdate = (firstIndex ?? 0) + index

                            }*/
                        }
                    }
                    //val = Double(arc4random_uniform(10))
                    return ChartDataEntry(x: Double(indexToUpdate), y: val)
                }
                //(block)
                
                  /*  arrData.compactMap { (graphDetail) -> ChartDataEntry in
                    let val = Double(graphDetail.value ?? 0)
                    return ChartDataEntry(x: Double(i), y: val)
                }//(0..<arrData.count).map(block)*/
                let set = LineChartDataSet(entries: yVals, label: "DataSet \(i+1)")
                set.lineWidth = 2.5
                set.circleRadius = 5
                set.circleHoleRadius = 0
                set.valueTextColor = UIColor.clear
                var color = UIColor.clear
                if let categpryIndex = self.viewModel.getIndexOfCategory(type: self.selectedGraphData[i][0].text ?? ""){
                    color = self.viewModel.categoryColorArray[categpryIndex]
                }
                
                set.setColor(color)
                set.setCircleColor(color)
                set.mode = .cubicBezier
                let gradientColors = [color.withAlphaComponent(0.5).cgColor,
                                      color.withAlphaComponent(0.5).cgColor]
                let gradient = CGGradient(colorsSpace: nil, colors: gradientColors as CFArray, locations: nil)!
                
                set.fillAlpha = 1
                set.fill = Fill(linearGradient: gradient, angle: 90) //.linearGradient(gradient, angle: 90)
                set.drawFilledEnabled = true
                return set
            }
            dataSet = dataSets
            
        }
        
        //dataSets[0].lineDashLengths = [5, 5]
//        dataSets[0].colors = ChartColorTemplates.vordiplom()
//        //dataSets[0].mode = .cubicBezier
//        dataSets[0].circleColors = ChartColorTemplates.vordiplom()
        
        let data = LineChartData(dataSets: dataSet)
        data.setValueFont(.systemFont(ofSize: 0, weight: .light))
        self.lineChartView.notifyDataSetChanged()
        self.lineChartView.data = self.selectedGraphData.count == 0 ? nil : data
        self.lineChartView.setVisibleXRangeMaximum(6)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        IQKeyboardManager.shared.previousNextDisplayMode = .Default
    }

    
    func registerNIBs(){
        self.tblView.register(UINib(nibName: ReuseIdentifier.DoubleInputCell, bundle: nil), forCellReuseIdentifier: ReuseIdentifier.DoubleInputCell)
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
                self?.lblGraphTitle.text = Date().month
                //print("Titles Array == \(self?.viewModel.titleArray)")
                //print("Color Array == \(self?.viewModel.categoryColorArray)")
                self?.dataSet.removeAll()
                self?.selectedGraphData.removeAll()
                self?.lineChartView.data = nil
                self?.lineChartView.notifyDataSetChanged()
                self?.updateTabView()

            }
        }
    }
    
}
//MARK:- UITableViewDelegate,UITableViewDataSource

extension ESASGraphViewController : UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrInput.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let inputDict = self.arrInput[indexPath.row]
        if let dict = inputDict as? InputTextfieldModel {
            return UITableViewCell()
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
//                if (tfOneDict.value ?? "").count != 0{
//                    cell.inputTf1.text = tfOneDict.value ?? ""
//                }
                cell.inputTf1.text = tfOneDict.value ?? ""

                
                cell.inputTf2.placeholder = tfTwoDict.placeholder ?? ""
                cell.inputT2_type = tfTwoDict.inputType ?? ""
                if (tfTwoDict.inputType ?? "") == InputType.Dropdown{
                    cell.arrDropdown2 = tfTwoDict.dropdownArr ?? [Any]()
                    cell.pickerView.reloadAllComponents()
                }
//                if (tfTwoDict.value ?? "").count != 0{
//                    cell.inputTf2.text = tfTwoDict.value ?? ""
//                }
                cell.inputTf2.text = tfTwoDict.value ?? ""

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
extension ESASGraphViewController : UITextFieldDelegate{
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
                                     self.viewModel.getShiftDropdown(locationId: self.viewModel.locationID) { (result) in
                                        self.viewModel.isLoading = false
                                        if let res = result as? [Shift]{
                                            if !res.isEmpty{
                                                if let dictArr = self.arrInput[indexPath.row] as? [InputTextfieldModel]{
                                                    var copyDictArr = dictArr
                                                    if let dict = dictArr[1] as? InputTextfieldModel{
                                                        let copyDict = dict
                                                        copyDict.value =  res[0].shiftName ?? ""
                                                        copyDict.valueId = res[0].id ?? 0
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
                                        if let dict = dictArr[0] as? InputTextfieldModel{
                                            let copyDict = dict
                                            copyDict.value =  self.viewModel.dropdownUnit?[0].unitName ?? ""//res[0].shiftName ?? ""
                                            copyDict.valueId = self.viewModel.dropdownUnit?[0].id ?? 0
                                            copyDict.isValid = true
                                            copyDictArr[0] = copyDict
                                            self.arrInput[indexPath.row] = copyDictArr
                                            tfToUpdate.text = self.viewModel.dropdownUnit?[0].unitName ?? ""
                                            cell.arrDropdown1 = self.viewModel.dropdownUnit ?? [""]
                                            self.viewModel.selectedUnitID =  self.viewModel.dropdownUnit?[0].id ?? 0
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
        DispatchQueue.main.async {

        let indexTuple = self.getIndexAndSubIndexFromTag(textFieldTag: textField.tag)
        let index = indexTuple.0
        let dictIndex = indexTuple.1
        
        if textField.tag <= TagConstants.DoubleTF_FirstTextfield_Tag{
            if let dict = self.arrInput[index] as? InputTextfieldModel{
                dict.value = textField.text
                dict.valueId = textField.text
                dict.isValid = !(textField.text?.count == 0)
                self.arrInput[textField.tag] = dict
            }
            else{
                if let dictArr = self.arrInput[index] as? [InputTextfieldModel]{
                    
                    var copyArr = dictArr
                    let dict = copyArr[1]
                    if (dict.placeholder ?? "") == "Shift"{
                        
                        dict.value =  ""
                        dict.valueId = nil
                        dict.isValid = false
                        copyArr[1] = dict
                        self.arrInput[index] = copyArr
                        self.tblView.reloadData()
                        
                        self.viewModel.graphArray?.removeAll()
                        self.viewModel.titleArray.removeAll()
                        self.tabsView.tabCollection.reloadData()
                        self.graphView.reloadInputViews()

                    }
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
                    if (dict.inputType ?? "") == InputType.Text{
                        dict.value = textField.text ?? ""
                        dict.valueId = textField.text
                        dict.isValid = !(textField.text?.count == 0)
                        copyArr[dictIndex] = dict
                        self.arrInput[index] = copyArr
                    }
//                    let startDate = Date.startOfMonth(Date())
//                    let endDate = Date.endOfMonth(Date())
//                    let startDateStr = Utility.getStringFromDate(date: startDate(), dateFormat: DateFormats.YYYY_MM_DD)
//                    let endDateStr = Utility.getStringFromDate(date: endDate(), dateFormat: DateFormats.YYYY_MM_DD)
                    
                    if (dict.placeholder ?? "") == "Shift"{
                        self.locationID = ((AppInstance.shared.user?.staffLocation?[0])?.locationID ?? 0)
                        self.staffId = (copyArr[1].valueId ?? 0) as? Int
                        let params = [Key.Params.ESAS.Rating.locationId : "\((AppInstance.shared.user?.staffLocation?[0])?.locationID ?? 0)" , Key.Params.ESAS.Rating.shiftId : "\(copyArr[1].valueId ?? 0)", Key.Params.patientId : "\(self.patientHeaderInfo?.patientID ?? 0)",
                            "unitId" : "\(self.viewModel.selectedUnitID)",
                            "startDate" : self.startDateStr,
                            "endDate" : self.endDateStr]
                        self.viewModel.getESASGraphDetail(params: params)
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
extension ESASGraphViewController : DoubleInputCellDelegate{
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
        
        let isFirstTf = self.activeTextfieldTag < TagConstants.DoubleTF_SecondTextfield_Tag
        let dictIndex = isFirstTf ? 0 : 1
        
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
                self.viewModel.selectedUnitID = (valueId as? Int) ?? 0
                cell.inputTf1.text = (value as? String) ?? ""
            }else{
                cell.inputTf2.text = (value as? String) ?? ""
            }
        }
    }
}



//MARK:- TabCollectionViewDelegate
extension ESASGraphViewController : TabCollectionViewDelegate{
    func didSelectTabAtIndex(row: Int) {
        //debugPrint("Selected tab === \(row)")
        self.viewModel.selectedCategoryIndex = row
        self.viewModel.selectedCategory = self.viewModel.titleArray[row]
        if let arrGraphData = self.viewModel.getGraphDataForCategory(type: self.viewModel.selectedCategory){
            self.graphData = arrGraphData
            if self.isCategoryExists(type: self.viewModel.selectedCategory){
                self.removeExistingValues(type: self.viewModel.selectedCategory)
            }else{
                self.selectedGraphData.append(arrGraphData)
            }
            
            
            self.setupGraphView(graphDetailArr: arrGraphData)
        }
    }
    
    func removeExistingValues(type: String){
        var copyArray = self.selectedGraphData
        for (index,item) in self.selectedGraphData.enumerated() {
            if  (item[0].text ?? "") == type {
                copyArray.remove(at: index)
            }
        }
        self.selectedGraphData = copyArray
    }
    
    func isCategoryExists(type : String) -> Bool{
        for (index,item) in self.selectedGraphData.enumerated() {
            if (item[0].text ?? "") == type{
                return true
            }
        }
        return false
    }
}
