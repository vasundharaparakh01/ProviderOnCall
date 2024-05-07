//
//  AddScheduleViewController.swift
//  AccessEMR
//
//  Created by Vasundhara Parakh on 5/15/20.
//  Copyright © 2020 smartData Enterprises (I) Ltd. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import FSCalendar
class AddScheduleViewController: BaseViewController {
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var viewAvailability: UIView!
    @IBOutlet weak var slotCollectionView: UICollectionView!
    @IBOutlet weak var lblAvailabilitySlot: UILabel!
    @IBOutlet weak var calendarView: FSCalendar!
    @IBOutlet weak var viewCalendar: UIView!
    @IBOutlet weak var lblAvailabilityDetail: UILabel!

    var isAvailable = false

    var arrInput = [Any]()

    var selectedLocationId = (AppInstance.shared.user?.staffLocation?[0])?.locationID ?? 0
    var selectedUnitId = 0
    var selectedRoleId = 0
    var activeTextfieldTag = 0
    var activeTextfield : InputTextField?
    var selectedPatientIds = [[String : String]]()
    var selectedStaffIds = [[String : String]]()
    var residentDropdownArray : [Patients]?
    var staffDropdownArray : [Staff]?
    var selectedShiftSchedule : ShiftSchedule?
    var isStaffScheduling = false
    var selectedDateString = ""
    var selectedCalendarDate : Date?

    var staffAvailabilitySchedule : StaffAvailabilitySlot?
    var filteredAppointmentList = [AvailabilityByDayName]()

    lazy var viewModel: AddScheduleViewModel = {
        let obj = AddScheduleViewModel(with: VirtualConsultService())
        self.baseViewModel = obj
        return obj
    }()
    var minTime : Date?
    var maxTime : Date?
    var isValidDateSelected = false
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialSetup()
        // Do any additional setup after loading the view.
    }
    func initialSetup(){
        self.viewAvailability.isHidden = true
        self.viewCalendar.isHidden = true

        self.addrightBarButtonItem()
        self.setCalendarView()
        self.registerNIBs()
        self.setupClosures()
        self.addBackButton()
        self.navigationItem.title = NavigationTitle.AddAppointment
        self.viewModel.getScheduleMasters()
        
    }
    func addrightBarButtonItem() {
        let rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target:  self, action: #selector(onRightBarButtonItemClicked(_ :)))
        rightBarButtonItem.tintColor = UIColor.white
        navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    func setCalendarView(){
            self.calendarView.scope =  FSCalendarScope.month 
            
            self.calendarView.backgroundColor = UIColor.white
            self.calendarView.appearance.headerTitleFont = UIFont.PoppinsRegular(fontSize: 20.0)
            self.calendarView.appearance.weekdayFont = UIFont.PoppinsRegular(fontSize: 14.0)
            self.calendarView.appearance.caseOptions = FSCalendarCaseOptions.weekdayUsesUpperCase
            //self.calendarView.select(self.calendarView.today)
            self.calendarView.setCurrentPage(self.calendarView.today ?? Date(), animated: false)
            
            self.calendarView.dataSource = self
            self.calendarView.delegate = self
        //self.calendarView.select(self.selectedCalendarDate ?? Date())
        self.calendarView.placeholderType = .none
        self.calendarView.reloadData()
    }
    // MARK:
    @objc func onRightBarButtonItemClicked(_ sender: UIBarButtonItem) {
        let callParticipantCount = self.selectedPatientIds.count + self.selectedStaffIds.count
        var errorMessage = ""
        var isValid = true
        let inputParams = self.createAPIParams()

        
        if callParticipantCount == 0 {
            isValid = false
            errorMessage = "There should be minimum 2 participants in virtual consult appointment. Please check selected provider(s) & \(UserDefaults.getOrganisationTypeName().lowercased())(s)."
        }
        if inputParams.1 { //All valid
            if isValid{
                self.viewModel.saveScheduleAppointment(params: inputParams.0)
            }else {
                self.viewModel.errorMessage = errorMessage
            }
        }else{
            self.viewModel.errorMessage = inputParams.2 //Error Message
        }
        
    }
    
    func createAPIParams() -> ([String : Any],Bool,String){
        var arrFinal = [Any]()
        var errorMessage = ""
        var isValid = true

        var valuesIdsArray = self.selectedPatientIds.compactMap { (entity) -> String? in
            return entity["value"]
        }
        if valuesIdsArray.isEmpty{
            valuesIdsArray = ["0"]
        }
        //for (_,patientId) in valuesIdsArray.enumerated() {
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
                        }else if let dict = dictObj as? InputTextfieldModel {
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
            
            
            paramDict[Key.Params.AddTask.PatientAppointmentId] = nil
            
            //paramDict[Key.Params.createVCSchedule.patientID] = (Int(patientId) ?? 0) == 0 ? nil : Int(patientId) ?? 0
            var staffIds =  self.selectedStaffIds.compactMap { (entity) -> [String : Any]? in
                
                let myString = entity["value"] ?? "0"
                return [Key.Params.createVCSchedule.staffId : Int(myString) ?? 0 ,
                        Key.Params.createVCSchedule.isDeleted : false, "isPrimaryStaff" : false]
                       }
            if paramDict[ScheduleTitles.PrimaryStaff] != nil{
                staffIds.append([Key.Params.createVCSchedule.staffId : (paramDict[ScheduleTitles.PrimaryStaff] as? Int) ?? 0 ,
                                 Key.Params.createVCSchedule.isDeleted : false, "isPrimaryStaff" : true])
            }
            paramDict[Key.Params.createVCSchedule.appointmentStaffs] = staffIds
            
            
            var patientIds =  self.selectedPatientIds.compactMap { (entity) -> [String : Any]? in
                let myString = entity["value"] ?? "0"
                return [Key.Params.patientId : Int(myString) ?? 0,
                        Key.Params.createVCSchedule.isDeleted : false]
                       }
            paramDict["appointmentPatientModels"] = patientIds
            
            paramDict[Key.Params.createVCSchedule.serviceLocationID] = self.viewModel.locationID
            paramDict[Key.Params.createVCSchedule.type] = "VideoCall"
            paramDict[Key.Params.createVCSchedule.taskStatusId] = 5
            let endTime = paramDict[Key.Params.createVCSchedule.endDateTime] != nil ? Utility.getStringFromDate(date: (paramDict[Key.Params.createVCSchedule.endDateTime] as? Date) ?? Date(), dateFormat: "HH:mm:ss") : ""
            let startTime = paramDict[Key.Params.createVCSchedule.startDateTime]  != nil ? Utility.getStringFromDate(date: (paramDict[Key.Params.createVCSchedule.startDateTime] as? Date) ?? Date(), dateFormat: "HH:mm:ss") : ""

//        let selectedDateFormatted = Utility.convertDateStringToOtherFormatString(dateString: self.selectedDateString, inputFormat: "MM/dd/yyyy", outputFormat: DateFormats.YYYY_MM_DD)
//
//            paramDict[Key.Params.createVCSchedule.startDateTime] = selectedDateFormatted + "T" + startTime + ".000Z"
//            paramDict[Key.Params.createVCSchedule.endDateTime] = selectedDateFormatted + "T" + endTime + ".000Z"
        
        paramDict[Key.Params.createVCSchedule.startDateTime] = self.selectedDateString + " " + startTime
        paramDict[Key.Params.createVCSchedule.endDateTime] = self.selectedDateString + " " + endTime

            let str = "0"
            paramDict[Key.Params.createVCSchedule.anoymousCallMemberModels] =
                [["emailId" : paramDict["emailId"], "id" : Int(str) ?? 0]]

            paramDict["emailId"] = nil
            paramDict[""] = nil
            
            let startDateOfappointment = Utility.getDateFromstring(dateStr: self.selectedDateString + " " + startTime, dateFormat: DateFormats.mm_dd_yyyy + " " + "HH:mm")
            let endDateOfappointment = Utility.getDateFromstring(dateStr: self.selectedDateString + " " + endTime, dateFormat: DateFormats.mm_dd_yyyy + " " + "HH:mm")

            if paramDict[ScheduleTitles.PrimaryStaff] == nil || (paramDict[Key.Params.createVCSchedule.appointmentStaffs] as? [[String : Any]])?.isEmpty ?? false{
                isValid = false
                errorMessage = "Please select \(UserDefaults.getOrganisationTypeName().lowercased())(s) & provider(s)."

            }
            else if self.selectedDateString.count == 0{
                isValid = false
                errorMessage = "Please select date"
            }
            else if startTime.count == 0 || endTime.count == 0{
                isValid = false
                errorMessage = "Please select start and end time."
            }
            else if startTime == endTime{
                isValid = false
                errorMessage = "Start time & End time cannot be same."
            }else if startDateOfappointment > endDateOfappointment{
                isValid = false
                errorMessage = "End time cannot be before start time."

            }
            
            paramDict[ScheduleTitles.PrimaryStaff] = nil

            arrFinal.append(paramDict)
       // }
        return ([Key.Params.AddTask.patientAppointmentModels : arrFinal],isValid,errorMessage)
        //return ([Key.Params.AddTask.patientAppointmentModels : arrFinal],isValid,errorMessage)
    }

    

    func registerNIBs(){
        self.tblView.register(UINib(nibName: ReuseIdentifier.DoubleInputCell, bundle: nil), forCellReuseIdentifier: ReuseIdentifier.DoubleInputCell)
        self.tblView.register(UINib(nibName: ReuseIdentifier.TextInputCell, bundle: nil), forCellReuseIdentifier: ReuseIdentifier.TextInputCell)
        
        self.tblView.register(UINib(nibName: ReuseIdentifier.PickerInputCell, bundle: nil), forCellReuseIdentifier: ReuseIdentifier.PickerInputCell)
        
        self.tblView.register(UINib(nibName: ReuseIdentifier.DateTimeInputCell, bundle: nil), forCellReuseIdentifier: ReuseIdentifier.DateTimeInputCell)
        
        self.tblView.register(UINib(nibName: ReuseIdentifier.NumberInputCell, bundle: nil), forCellReuseIdentifier: ReuseIdentifier.NumberInputCell)
        
        self.tblView.register(UINib(nibName: ReuseIdentifier.CheckmarkInputCell, bundle: nil), forCellReuseIdentifier: ReuseIdentifier.CheckmarkInputCell)


        
    }
    func setupClosures() {
        self.viewModel.updateViewClosure = { [weak self] () in
            DispatchQueue.main.async {
                if self?.isStaffScheduling ?? false{
                    self?.arrInput = self?.viewModel.getInputArray() ?? [""]
                }else{
                    self?.arrInput = self?.viewModel.getInputArrayForVitualSchedule() ?? [""]
                }
                self?.tblView.reloadData()
            }
        }
        
        self.viewModel.reloadListViewClosure = { [weak self] () in
            DispatchQueue.main.async {
            }
        }
        
        self.viewModel.updateViewForCalendarClosure = { [weak self] () in
            DispatchQueue.main.async {
                self?.calendarView.reloadInputViews()
                self?.calendarView.reloadData()
            }
        }
        
    }
    
    @IBAction func btnCloseAvailability_clicked(_ sender: Any) {
        self.viewAvailability.isHidden = true
        self.minTime = nil
        self.maxTime = nil
    }

    @IBAction func btnCloseCalendar_clicked(_ sender: Any) {
        self.viewCalendar.isHidden = true
    }

    @IBAction func btnConfirmDate_clicked(_ sender: Any) {
        if self.isValidDateSelected{
        self.viewCalendar.isHidden = true
        let indexPath = IndexPath(row: 4, section: 0)
        if let dictArr = (self.arrInput[indexPath.section] as? [Any])  {
            var copyArr = dictArr
            if let dict = copyArr[indexPath.row] as? InputTextfieldModel{
                
                let isDate = (dict.inputType ?? "") == InputType.Date
                if let selectedDate = self.selectedCalendarDate{
                    let dateStr = Utility.getStringFromDate(date: selectedDate, dateFormat:  DateFormats.mm_dd_yyyy )
                    self.selectedDateString = dateStr
                    dict.value = dateStr
                    dict.valueId = self.selectedDateString//dateStr//Date()
                    dict.isValid = true
                    copyArr[indexPath.row] = dict
                    self.arrInput[indexPath.section] = copyArr
                    
                    //Update Time textfield to blank
                    if let dictArr = (self.arrInput[indexPath.section] as? [Any]){
                        
                        if let arrSub = dictArr[5] as? [InputTextfieldModel]{
                            if let cell = self.tblView.cellForRow(at: IndexPath(row: 5, section: indexPath.section)) as? DoubleInputCell{
                                
                                var copySubArray = arrSub
                                let dict2 = arrSub[1]
                                dict2.value = ""
                                dict2.valueId = nil
                                dict2.isValid = false
                                
                                let dict1 = arrSub[0]
                                dict1.value = ""
                                dict1.valueId = nil
                                dict1.isValid = false
                                
                                copySubArray[0] = dict1
                                copySubArray[1] = dict2
                                copyArr[5] = copySubArray
                                self.arrInput[indexPath.section] = copyArr
                                cell.inputTf1.text = ""
                                cell.inputTf2.text = ""
                            }
                        }
                    }
                    
                    
                    self.tblView.reloadData()
                    
                    
                    
                    
                }
            }
        }
        }else{
            self.viewModel.errorMessage = "Please select available date."
        }
    }
}

//MARK: FSCalendarDataSource,FSCalendarDelegate
extension AddScheduleViewController : FSCalendarDataSource,FSCalendarDelegate{
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        //if date >= Date(){
        //print("\(date.timeIntervalSinceNow.sign == FloatingPointSign.minus) ==== \(date)")
        if date.timeIntervalSinceNow.sign == FloatingPointSign.minus{
            return 0
        }
            let dateArr = self.viewModel.availabilityList.compactMap({ Utility.convertServerDateToRequiredDate(dateStr: $0.date ?? "", requiredDateformat: DateFormats.YYYY_MM_DD)})
            //let EnddateArr = self.viewModel.availabilityList.compactMap({Utility.convertServerDateToRequiredDate(dateStr: $0.endTime ?? "", requiredDateformat: DateFormats.YYYY_MM_DD)})
            
            let allDates = dateArr //+ EnddateArr
            
            let dateOfEvent = Utility.getStringFromDate(date: date, dateFormat: DateFormats.YYYY_MM_DD)
            
            var count = 0
            for (_,item) in dateArr.enumerated() {
                if item == dateOfEvent{
                    count += 1
                }
            }
            return allDates.contains(dateOfEvent) ? 1 : 0
//        }
//        return 0
        //return 0
        
    }
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventDefaultColorsFor date: Date) -> [UIColor]? {
        
        return  [Color.Red]
    }
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventColorFor date: Date) -> UIColor? {
         //Do some checks and return whatever color you want to.
        return   Color.Red 

    }

    //Commented to display past appointments - 04/11/2019
    //Developer - Vasundhara parakh
    func minimumDate(for calendar: FSCalendar) -> Date {
        return Date()
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        self.filteredAppointmentList.removeAll()
        self.view.endEditing(true)
        
        let dateArr = self.viewModel.availabilityList.compactMap({Utility.convertServerDateToRequiredDate(dateStr: $0.date ?? "", requiredDateformat: DateFormats.YYYY_MM_DD)})
        let dateOfEvent = Utility.getStringFromDate(date: date, dateFormat: DateFormats.YYYY_MM_DD)
        
        
        for (_,item) in self.viewModel.availabilityList.enumerated() {
            let itemDate = Utility.convertServerDateToRequiredDate(dateStr: item.date ?? "", requiredDateformat: DateFormats.YYYY_MM_DD)
            if itemDate == dateOfEvent{
                self.filteredAppointmentList.append(item)
            }
        }
        if !self.filteredAppointmentList.isEmpty{
            let startTime = Utility.convertServerDateToRequiredDate(dateStr: self.filteredAppointmentList.first?.startTime ?? "", requiredDateformat: DateFormats.hh_mm_a)
            let endTime = Utility.convertServerDateToRequiredDate(dateStr: self.filteredAppointmentList.first?.endTime ?? "", requiredDateformat: DateFormats.hh_mm_a)

            self.minTime = Utility.getDateFromstring(dateStr: (self.filteredAppointmentList.first?.startTime ?? "").replacingOccurrences(of: "T", with: " "), dateFormat: "YYYY-MM-dd HH:mm:ss")
            self.maxTime = Utility.getDateFromstring(dateStr: (self.filteredAppointmentList.first?.endTime ?? "").replacingOccurrences(of: "T", with: " "), dateFormat: "YYYY-MM-dd HH:mm:ss")
            
            let unAvailableStartTime = Utility.convertServerDateToRequiredDate(dateStr: self.filteredAppointmentList.last?.startTime ?? "", requiredDateformat: DateFormats.hh_mm_a)
            let unAvailableEndTime = Utility.convertServerDateToRequiredDate(dateStr: self.filteredAppointmentList.last?.endTime ?? "", requiredDateformat: DateFormats.hh_mm_a)

            var available = "Available : " + startTime + " - " + endTime
            if self.filteredAppointmentList.count > 1 && !(self.filteredAppointmentList.last?.isAvailable ?? true) {
                var unavailable = "\n" + "Unavailable between " + unAvailableStartTime + " - " + unAvailableEndTime
                available.append(unavailable)
            }
            self.lblAvailabilityDetail.numberOfLines = 0
            self.lblAvailabilityDetail.lineBreakMode = .byWordWrapping
            self.lblAvailabilityDetail.text = available
            self.isValidDateSelected = true
            self.selectedCalendarDate = date

        }else{
            self.lblAvailabilityDetail.text = "No availability found."
            self.isValidDateSelected = false

        }
        //self.tblView.reloadData()
        //self.viewModel.getPatientAppointmentList(startDate: date,endDate : date)
    }
    
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        return true
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        
        self.lblAvailabilityDetail.text = ""
        self.filteredAppointmentList.removeAll()
        self.tblView.reloadData()
        
        let startDate = calendar.currentPage.startOfMonth()
        let endDate = calendar.currentPage.endOfMonth()
        
        let startDateStr = Utility.getStringFromDate(date: startDate, dateFormat: DateFormats.YYYY_MM_DD)
        let endDateStr = Utility.getStringFromDate(date: endDate, dateFormat: DateFormats.YYYY_MM_DD)

        self.viewModel.getAvailabilityList(fromDate: startDateStr, toDate: endDateStr, shiftId: self.viewModel.selectedShiftId, staffId: self.viewModel.selectedStaffId)
    }
    
    
    
}
//MARK:- UITableViewDelegate,UITableViewDataSource

extension AddScheduleViewController : UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.arrInput.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let arr = (self.arrInput[indexPath.section] as? [Any]){
            let inputDict = arr[indexPath.row]
        if let dict = inputDict as? InputTextfieldModel {
            if (dict.inputType ?? "") == InputType.Checkmark{
                return 50
            }
            }
        }
        return UITableView.automaticDimension
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
            
            let btnAvailability = UIButton(type: .custom)
            btnAvailability.frame = CGRect(x: Screen.width - 175, y: 3 , width: 160, height: cell.frame.size.height - 6 )
            btnAvailability.setTitle("Check Availability", for: .normal)
            btnAvailability.setTitleColor(.white, for: .normal)
            btnAvailability.backgroundColor = self.isAvailable ? Color.Blue : Color.Red
            btnAvailability.cornerRadius = (cell.frame.size.height - 6)/2
            btnAvailability.titleLabel?.font = UIFont.PoppinsMedium(fontSize: 15)
            btnAvailability.addTarget(self, action: #selector(self.btnAvailability_clicked(button:)), for: .touchUpInside)
            btnAvailability.tag = indexPath.row + 1000
            cell.contentView.addSubview(btnAvailability)
            
            btnAvailability.isHidden =  !((dict.placeholder ?? "") == "")
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
    @objc func  btnAvailability_clicked(button : UIButton) {
        self.view.endEditing(true)
        //if let days = self.selectedShiftSchedule{
        self.viewAvailability.isHidden = !self.showAvailabilityView()
            //self.tblAvailability.reloadData()
//            print("available=== \(self.getAvailabilityData())")
//        }else{
//            self.viewModel.errorMessage = "No availability data found."
//        }
    }
    
    func showAvailabilityView() -> Bool{
        if let availability = self.staffAvailabilitySchedule{
            let startSlot = Utility.convertServerDateToRequiredDate(dateStr: availability.availabilityByDayName?.startTime ?? "", requiredDateformat: DateFormats.hh_mm_a)
            let endSlot = Utility.convertServerDateToRequiredDate(dateStr: availability.availabilityByDayName?.endTime ?? "", requiredDateformat: DateFormats.hh_mm_a)
            self.lblAvailabilitySlot.text = startSlot + " - " + endSlot
            return true
        }else{
            self.viewModel.errorMessage = "No availability found."
            return false
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func updateTextfieldAppearance(inputTf : InputTextField, dict : InputTextfieldModel){
        inputTf.lineColor =  Color.Line
        inputTf.errorMessage = ""
    }
    
    func showMultiValuePicker(indexPath : IndexPath,dropDownArray : [Any]){
        
        
        var pickerData : [[String:String]] = [[String:String]]()
        
        for (index,item) in dropDownArray.enumerated() {
            if let itemTaskType = item as? MasterTaskType{
                pickerData.append(["value":"\(itemTaskType.id ?? 0)","display":itemTaskType.taskType ?? ""])
            }
            
            if let itemResident = item as? Patients{
                pickerData.append(["value":"\(itemResident.id ?? 0)","display":itemResident.value ?? ""])
            }
            
            if let itemStaff = item as? Staff{
                pickerData.append(["value":"\(itemStaff.id ?? 0)","display":itemStaff.value ?? ""])
            }
        }
        
        var valuesIdsArray = [String]()
        if let dictArr = (self.arrInput[indexPath.section] as? [Any]){
            var copyArr = dictArr
            if let dict = dictArr[indexPath.row] as? InputTextfieldModel{
                
                if (dict.placeholder ?? "") == ScheduleTitles.Resident{
                    valuesIdsArray = self.selectedPatientIds.compactMap { (entity) -> String? in
                        return entity["value"]
                    }
                }else{
                    valuesIdsArray = self.selectedStaffIds.compactMap { (entity) -> String? in
                        return entity["value"]
                    }
                }}
        }

        MultiPickerDialog().show(title: "Select",doneButtonTitle:"Done", cancelButtonTitle:"Cancel" ,options: pickerData, selected:  valuesIdsArray) {
            values -> Void in
            let valueArr = values.compactMap { (entity) -> String? in
                return entity["display"]
            }
            let valueIdsArr = values.compactMap { (entity) -> String? in
                return entity["value"]
            }

            //Update Resident name textfield to blank
            if let dictArr = (self.arrInput[indexPath.section] as? [Any]){
                var copyArr = dictArr
                if let dict = dictArr[indexPath.row] as? InputTextfieldModel{
                    if (dict.placeholder ?? "") == ScheduleTitles.Resident{
                        self.selectedPatientIds = values
                    }else if (dict.placeholder ?? "") == ScheduleTitles.Staff{
                        
                        self.selectedStaffIds = values
                    }
                    
                    let uniqueStaffIds = Array(Set(self.selectedStaffIds))
                    let uniqueStaffvalueArr = uniqueStaffIds.compactMap { (entity) -> String? in
                        return entity["display"]
                    }
                    let uniqueIdsvalueArr = uniqueStaffIds.compactMap { (entity) -> String? in
                        return entity["value"]
                    }
                    var finalString = ""
                    if (dict.placeholder ?? "") == ScheduleTitles.Resident{
                        let stringValue = valueArr.joined(separator: ", ")
                        let stringIds = valueIdsArr.joined(separator: ",")
                        
                        self.viewModel.selectedResidentIds = stringIds

                        dict.value = stringValue
                        dict.valueId = stringIds
                        finalString = stringValue
                    }else{

                        let stringValue = uniqueStaffvalueArr.joined(separator: ", ")
                        let stringIds = uniqueIdsvalueArr.joined(separator: ",")
                        
                        self.viewModel.selectedStaffIds = stringIds

                        dict.value = stringValue
                        dict.valueId = stringIds
                        finalString = stringValue

                    }
                    dict.isValid = true
                    copyArr[indexPath.row] = dict
                    self.arrInput[indexPath.section] = copyArr

                    if let cell = self.tblView.cellForRow(at: IndexPath(row: indexPath.row, section: indexPath.section )) as? TextInputCell{
                        cell.inputTf.text = finalString
                    }
                    
                    print("SELECTED Staff & Resident Count \(self.selectedStaffIds.count + self.selectedPatientIds.count)")

                }
            }
        }
    }
}
//MARK:- UITextFieldDelegate
extension AddScheduleViewController : UITextFieldDelegate{
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
                                if let dictArr = (self.arrInput[indexPath.section] as? [Any])  {
                                    if let dict = dictArr[indexPath.row] as? InputTextfieldModel{
                                        if dict.placeholder == AddTaskTitles.selectTaskType {
                                            self.showMultiValuePicker(indexPath: indexPath,dropDownArray: dict.dropdownArr ?? [""])
                                        }else if (dict.placeholder == ScheduleTitles.Resident){
                                            self.viewModel.getStaffPatientDropdown(locationId: self.selectedLocationId, roleId: self.selectedRoleId, unitID: self.selectedUnitId, shiftId: nil) { (result) in
                                            self.viewModel.isLoading = false
                                            if let res = result as? PatientStaffMaster{
                                                self.residentDropdownArray = res.patients
                                                self.showMultiValuePicker(indexPath: indexPath,dropDownArray: self.residentDropdownArray ?? [""])
                                            }else{
                                                self.showMultiValuePicker(indexPath: indexPath,dropDownArray: [""])
                                                }
                                            }
                                        }else if (dict.placeholder == ScheduleTitles.Staff){
                                            self.viewModel.getStaffPatientDropdown(locationId: self.selectedLocationId, roleId: self.selectedRoleId, unitID: self.selectedUnitId, shiftId: nil) { (result) in
                                            self.viewModel.isLoading = false
                                            if let res = result as? PatientStaffMaster{
                                                self.staffDropdownArray = res.staff
                                                self.showMultiValuePicker(indexPath: indexPath,dropDownArray: self.staffDropdownArray ?? [""])
                                            }else{
                                                self.showMultiValuePicker(indexPath: indexPath,dropDownArray: [""])
                                                }
                                            }
                                        }else if (dict.placeholder == ScheduleTitles.SelectDate){
                                            textField.resignFirstResponder()
                                            self.viewCalendar.isHidden = false
                                            
                                            let startDate = self.calendarView.currentPage.startOfMonth()
                                            let endDate = self.calendarView.currentPage.endOfMonth()
                                            
                                            let startDateStr = Utility.getStringFromDate(date: startDate, dateFormat: DateFormats.YYYY_MM_DD)
                                            let endDateStr = Utility.getStringFromDate(date: endDate, dateFormat: DateFormats.YYYY_MM_DD)
                                            
                                            self.viewModel.getAvailabilityList(fromDate: startDateStr, toDate: endDateStr, shiftId: self.selectedShiftSchedule?.shiftMasterId ?? 0, staffId: self.viewModel.selectedStaffId)
                                            
                                        }
                                    }
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
                                        cell.datePicker1.minimumDate = self.minTime
                                        cell.datePicker1.maximumDate = self.maxTime

                                        cell.datePicker2.minimumDate = self.minTime
                                        cell.datePicker2.maximumDate = self.maxTime

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
                                       if dict.placeholder == AddTaskTitles.role{
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
                                                self.selectedRoleId = selectedValue.valueID as! Int
                                            }
                                            
                                        }
                                       }else if dict.placeholder == AddTaskTitles.unit{
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
                                                self.selectedUnitId = selectedValue.valueID as? Int ?? 0
                                                self.viewModel.unitID = selectedValue.valueID as! Int
                                            }
                                            
                                        }
                                       }
                                       else if dict.placeholder == AddTaskTitles.shift{

                                                                            
                                                                            self.viewModel.getShiftDropdown(unitID: self.selectedUnitId) { (result) in
                                                                                self.viewModel.isLoading = false
                                                                                if let res = result as? [Shift]{
                                                                                    self.viewModel.dropdownShift = res
                                                                                    if let dict1 = arrSub[reqdIndex] as? InputTextfieldModel{
                                                                                        dict1.dropdownArr = res
                                                                                        copySubArray[reqdIndex] = dict
                                                                                        copyArr[indexPath.row] = copySubArray
                                                                                        self.arrInput[indexPath.section] = copyArr
                                                                                        if let cell = self.tblView.cellForRow(at: indexPath) as? DoubleInputCell{
                                                                                            cell.arrDropdown2 = res
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
                                                                                                self.viewModel.selectedShiftId = (selectedValue.valueID as? Int) ?? 0
                                                                                            }
                                                                                        
                                                                                        }
                                                                                    }
                                                                                }
                                                                            }
                                                                       

                                                                        
                                       }else if (dict.placeholder == ScheduleTitles.PrimaryStaff){
                                        self.viewModel.getStaffPatientDropdown(locationId: self.selectedLocationId, roleId: self.selectedRoleId, unitID: self.selectedUnitId, shiftId: nil) { (result) in
                                                self.viewModel.isLoading = false
                                                if let res = result as? PatientStaffMaster{
                                                    self.residentDropdownArray = res.patients

                                                    if let dict1 = arrSub[reqdIndex] as? InputTextfieldModel{
                                                        dict1.dropdownArr = res.staff
                                                        copySubArray[reqdIndex] = dict
                                                        copyArr[indexPath.row] = copySubArray
                                                        self.arrInput[indexPath.section] = copyArr
                                                        if let cell = self.tblView.cellForRow(at: indexPath) as? DoubleInputCell{
                                                            cell.arrDropdown2 = res.staff ?? [""]
                                                            
                                                            cell.pickerView.reloadAllComponents()
                                                            
                                                            if let arr = dict.dropdownArr as? [Staff]{
                                                                cell.pickerView.selectRow(0, inComponent: 0, animated: false)

                                                                let selectedValue = Utility.getSelectedValue(arrDropdown: arr,row: 0)

                                                                dict.value = selectedValue.value
                                                                dict.valueId = selectedValue.valueID
                                                            dict.isValid = true
                                                            copySubArray[reqdIndex] = dict
                                                            copyArr[indexPath.row] = copySubArray
                                                            self.arrInput[indexPath.section] = copyArr
                                                            textField.text = selectedValue.value
                                                            self.viewModel.selectedStaffId = (selectedValue.valueID as? Int) ?? 0
                                                            }
                                                        
                                                        }
                                                    }
                                                }else{
                                                    if let cell = self.tblView.cellForRow(at: indexPath) as? DoubleInputCell{
                                                    cell.arrDropdown2 = [""]; cell.pickerView.reloadAllComponents()
                                                    }
                                                }
                                            }
                                        }else{
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
                                        if (dict.placeholder == ScheduleTitles.PrimaryStaff){
                                            self.viewModel.getStaffPatientDropdown(locationId: self.selectedLocationId, roleId: self.selectedRoleId, unitID: self.selectedUnitId, shiftId: self.viewModel.selectedShiftId) { (result) in
                                                self.viewModel.isLoading = false
                                                if let res = result as? PatientStaffMaster{
                                                    self.residentDropdownArray = res.patients

                                                        dict.dropdownArr = res.staff
                                                        copyArr[indexPath.row] = dict
                                                        self.arrInput[indexPath.section] = copyArr
                                                        if let cell = self.tblView.cellForRow(at: indexPath) as? PickerInputCell{
                                                            cell.arrDropdown = res.staff ?? [""]
                                                            
                                                            cell.pickerView.reloadAllComponents()
                                                            
                                                            if let arr = dict.dropdownArr as? [Staff]{
                                                                cell.pickerView.selectRow(0, inComponent: 0, animated: false)

                                                                let selectedValue = Utility.getSelectedValue(arrDropdown: arr,row: 0)

                                                                dict.value = selectedValue.value
                                                                dict.valueId = selectedValue.valueID
                                                            dict.isValid = true
                                                            copyArr[indexPath.row] = dict
                                                            self.arrInput[indexPath.section] = copyArr
                                                            textField.text = selectedValue.value
                                                                self.viewModel.selectedStaffId = (selectedValue.valueID as? Int) ?? 0
                                                            }
                                                        
                                                        }
                                                    }
                                                }
                                        }else{
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
                                        if dict.placeholder == AddTaskTitles.selectTaskType {
                                            self.showMultiValuePicker(indexPath: indexPath,dropDownArray: dict.dropdownArr ?? [""])
                                        }else if (dict.placeholder == ScheduleTitles.Resident){
                                            self.viewModel.getStaffPatientDropdown(locationId: self.selectedLocationId, roleId: self.selectedRoleId, unitID: self.selectedUnitId, shiftId: nil) { (result) in
                                            self.viewModel.isLoading = false
                                            if let res = result as? PatientStaffMaster{
                                                self.residentDropdownArray = res.patients
                                                self.showMultiValuePicker(indexPath: indexPath,dropDownArray: self.residentDropdownArray ?? [""])
                                            }else{
                                                self.showMultiValuePicker(indexPath: indexPath,dropDownArray: [""])
                                                }
                                            }
                                        }else if (dict.placeholder == ScheduleTitles.Staff){
                                            self.viewModel.getStaffPatientDropdown(locationId: self.selectedLocationId, roleId: self.selectedRoleId, unitID: self.selectedUnitId, shiftId: nil) { (result) in
                                            self.viewModel.isLoading = false
                                            if let res = result as? PatientStaffMaster{
                                                self.staffDropdownArray = res.staff
                                                self.showMultiValuePicker(indexPath: indexPath,dropDownArray: self.staffDropdownArray ?? [""])
                                            }else{
                                                self.showMultiValuePicker(indexPath: indexPath,dropDownArray: [""])
                                                }
                                            }
                                        }else if (dict.placeholder == ScheduleTitles.SelectDate){
                                            textField.resignFirstResponder()
                                            self.viewCalendar.isHidden = false
                                        }
                                    }
                                }
                            }
                        }
                    }

                        
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
                                    
                                    if (dict.placeholder ?? "") == ScheduleTitles.SelectDate{
                                        self.getStaffAvailability(indexPath: indexPath)
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
                                                if dict.placeholder == AddTaskTitles.unit{
                                                    let dict1 = arrSub[reqdIndex + 1]
                                                    dict1.value = ""
                                                    dict1.valueId = 0
                                                    dict1.isValid = false
                                                    copySubArray[reqdIndex + 1] = dict1
                                                    copyArr[indexPath.row] = copySubArray
                                                    self.arrInput[indexPath.section] = copyArr
                                                    cell.inputTf2.text = ""
                                                    
                                                    //Update Staff textfield to blank
                                                    if let arrSub = dictArr[indexPath.row + 1] as? [InputTextfieldModel]{
                                                        if let cell = self.tblView.cellForRow(at: IndexPath(row: indexPath.row + 1, section: indexPath.section)) as? DoubleInputCell{
                                                            let reqdIndex = 1
                                                            var copySubArray = arrSub
                                                            let dict2 = arrSub[reqdIndex]
                                                            dict2.value = ""
                                                            dict2.valueId = 0
                                                            dict2.isValid = false
                                                            
                                                            copySubArray[reqdIndex] = dict2
                                                            copyArr[indexPath.row + 1] = copySubArray
                                                            self.arrInput[indexPath.section] = copyArr
                                                            cell.inputTf2.text = ""

                                                        }
                                                    }
                                                    
                                                    //Update Resident name textfield to blank
                                                    if let dictArr = (self.arrInput[indexPath.section] as? [Any]){
                                                        var copyArr = dictArr
                                                        if let dict = dictArr[3] as? InputTextfieldModel{
                                                            dict.value = ""
                                                            dict.valueId = 0
                                                            dict.isValid = false
                                                            copyArr[3] = dict
                                                            self.arrInput[indexPath.section] = copyArr
                                                            self.selectedPatientIds.removeAll()
                                                            if let cellResident = self.tblView.cellForRow(at: IndexPath(row: 3, section: indexPath.section)) as? TextInputCell{
                                                                cellResident.inputTf.text = ""
                                                            }
                                                        }
                                                    }
                                                    
                                                    //Update Other Providers name textfield to blank
                                                    if let dictArr = (self.arrInput[indexPath.section] as? [Any]){
                                                        var copyArr = dictArr
                                                        if let dict = dictArr[2] as? InputTextfieldModel{
                                                            dict.value = ""
                                                            dict.valueId = 0
                                                            dict.isValid = false
                                                            copyArr[2] = dict
                                                            self.arrInput[indexPath.section] = copyArr
                                                            self.selectedStaffIds.removeAll()
                                                            if let cellResident = self.tblView.cellForRow(at: IndexPath(row: 2, section: indexPath.section)) as? TextInputCell{
                                                                cellResident.inputTf.text = ""
                                                            }
                                                        }
                                                    }
                                                    
                                                    //Update Primary Providers name textfield to blank
                                                    if let dictArr = (self.arrInput[indexPath.section] as? [Any]){
                                                        var copyArr = dictArr
                                                        if let dict = dictArr[1] as? InputTextfieldModel{
                                                            dict.value = ""
                                                            dict.valueId = 0
                                                            dict.isValid = false
                                                            copyArr[1] = dict
                                                            self.arrInput[indexPath.section] = copyArr
                                                            
                                                            if let cellResident = self.tblView.cellForRow(at: IndexPath(row: 1, section: indexPath.section)) as? PickerInputCell{
                                                                cellResident.inputTf.text = ""
                                                            }
                                                        }
                                                    }
                                                    
                                                    //Update Date textfield to blank
                                                    if let dictArr = (self.arrInput[indexPath.section] as? [Any]){
                                                        var copyArr = dictArr
                                                        if let dict = dictArr[4] as? InputTextfieldModel{
                                                            dict.value = ""
                                                            dict.valueId = nil
                                                            dict.isValid = false
                                                            copyArr[4] = dict
                                                            self.arrInput[indexPath.section] = copyArr
                                                            self.selectedCalendarDate = nil
                                                            self.selectedDateString = ""
                                                            if let cellDate = self.tblView.cellForRow(at: IndexPath(row: 4, section: indexPath.section)) as? TextInputCell{
                                                                cellDate.inputTf.text = ""
                                                            }
                                                        }
                                                    }
                                                    
                                                    //Update Time textfield to blank
                                                    if let dictArr = (self.arrInput[indexPath.section] as? [Any]){
                                                        
                                                        if let arrSub = dictArr[5] as? [InputTextfieldModel]{
                                                            if let cell = self.tblView.cellForRow(at: IndexPath(row: 5, section: indexPath.section)) as? DoubleInputCell{
                                                                
                                                                var copySubArray = arrSub
                                                                let dict2 = arrSub[1]
                                                                dict2.value = ""
                                                                dict2.valueId = nil
                                                                dict2.isValid = false
                                                                
                                                                let dict1 = arrSub[0]
                                                                dict1.value = ""
                                                                dict1.valueId = nil
                                                                dict1.isValid = false
                                                                
                                                                copySubArray[0] = dict1
                                                                copySubArray[1] = dict2
                                                                copyArr[5] = copySubArray
                                                                self.arrInput[indexPath.section] = copyArr
                                                                cell.inputTf1.text = ""
                                                                cell.inputTf2.text = ""
                                                            }
                                                        }
                                                    }
                                                    
                                                }else if (dict.placeholder == AddTaskTitles.role){
                                                    let dict1 = arrSub[reqdIndex + 1]
                                                    dict1.value = ""
                                                    dict1.valueId = 0
                                                    dict1.isValid = false
                                                    copySubArray[reqdIndex + 1] = dict1
                                                    copyArr[indexPath.row] = copySubArray
                                                    self.arrInput[indexPath.section] = copyArr
                                                    cell.inputTf2.text = ""
                                                    
                                                    //Update Resident name textfield to blank
                                                    if let dictArr = (self.arrInput[indexPath.section + 1] as? [Any]){
                                                        var copyArr = dictArr
                                                        if let dict = dictArr[0] as? InputTextfieldModel{
                                                            dict.value = ""
                                                            dict.valueId = 0
                                                            dict.isValid = false
                                                            copyArr[0] = dict
                                                            self.arrInput[indexPath.section + 1] = copyArr
                                                            
                                                            if let cellResident = self.tblView.cellForRow(at: IndexPath(row: 0, section: indexPath.section + 1)) as? TextInputCell{
                                                                cellResident.inputTf.text = ""
                                                            }
                                                        }
                                                    }
                                                }else if (dict.placeholder == AddTaskTitles.shift){
                                                    self.viewModel.getShiftScheduleByShiftID(shiftId: (dict.valueId as? Int) ?? 0 ) { (result) in
                                                        self.viewModel.isLoading = false
                                                        if let res = result as? ShiftSchedule{
                                                            self.selectedShiftSchedule = res
                                                        }else{
                                                            self.selectedShiftSchedule = nil
                                                        }
                                                    }
                                                    
                                                    let startDate = self.calendarView.currentPage.startOfMonth()
                                                    let endDate = self.calendarView.currentPage.endOfMonth()
                                                    
                                                    let startDateStr = Utility.getStringFromDate(date: startDate, dateFormat: DateFormats.YYYY_MM_DD)
                                                    let endDateStr = Utility.getStringFromDate(date: endDate, dateFormat: DateFormats.YYYY_MM_DD)

                                                    self.viewModel.getAvailabilityList(fromDate: startDateStr, toDate: endDateStr, shiftId: (dict.valueId as? Int) ?? 0, staffId: self.viewModel.selectedStaffId)

                                                }
                                                    
                                            }
                                      }
                                    }
                                }
                            }
                        }
                    }
                }
    }
    func getStaffAvailability(indexPath : IndexPath){
        DispatchQueue.main.async {
            
            self.viewModel.getStaffAvailability(type: self.isStaffScheduling ? "StaffScheduling" : "VideoCall" ,shiftId: self.selectedShiftSchedule?.shiftMasterId ?? 0, date: self.selectedDateString) { (availability) in
                if let staffavailability = availability as? StaffAvailabilitySlot{
                    self.staffAvailabilitySchedule = staffavailability
                    if self.isStaffScheduling{
                        if let appontments = staffavailability.wccApointmentList {
                            self.isAvailable = appontments.isEmpty
                            if let cell = self.tblView.cellForRow(at: IndexPath(row: indexPath.row + 1, section: indexPath.section)) as? CheckmarkInputCell{
                                let btnAvailability = cell.contentView.viewWithTag(indexPath.row + 1 + 1000)
                                btnAvailability?.backgroundColor = self.isAvailable ? Color.Blue : Color.Red
                                self.tblView.reloadRows(at: [IndexPath(row: indexPath.row + 1, section: indexPath.section)], with: .none)
                            }

                        }else{
                            self.isAvailable = true
                            if let cell = self.tblView.cellForRow(at: IndexPath(row: indexPath.row + 1, section: indexPath.section)) as? CheckmarkInputCell{
                                let btnAvailability = cell.contentView.viewWithTag(indexPath.row + 1 + 1000)
                                btnAvailability?.backgroundColor = self.isAvailable ? Color.Blue : Color.Red
                                self.tblView.reloadRows(at: [IndexPath(row: indexPath.row + 1, section: indexPath.section)], with: .none)
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
        /*
        var index = 0//textFieldTag
        var dictIndex = 0

        if index < TagConstants.DoubleTF_FirstTextfield_Tag{
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
        print("index=== \(index), dictIndex = \(dictIndex)")
        
        return (index,dictIndex)*/
    }
    
    func getIndexForMultipleTf(textFieldTag : Int) -> Int{
            var index = textFieldTag
            var dictIndex = 0
        if let cell = self.activeTextfield?.superview?.superview as? DoubleInputCell{
            if let indexPath = self.tblView.indexPath(for: cell){
                index = indexPath.section
                dictIndex = indexPath.row
            }
        }
        /*
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
            }*/
            return dictIndex
        }
}

//MARK:- DoubleInputCellDelegate
extension AddScheduleViewController : DoubleInputCellDelegate{
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
                    if dict.placeholder == AddTaskTitles.unit{
                        
                        self.viewModel.unitID = (valueId as? Int) ?? 0
                        self.selectedUnitId = (valueId as? Int) ?? 0
                    }
                    
                    if dict.placeholder == AddTaskTitles.role{
                        self.selectedRoleId = (valueId as? Int) ?? 0
                    }
                    
                    if dict.placeholder == AddTaskTitles.shift{
                        self.viewModel.selectedShiftId = (valueId as? Int) ?? 0
                    }

                }

                cell.inputTf1.text = (value as? String) ?? ""
            }else{
                if let dictArr = (self.arrInput[indexPath.section] as? [Any]){
                    let copyArr = dictArr[indexPath.row] as! [InputTextfieldModel]
                    let dict = copyArr[isFirstTfActive ? 0 : 1]
                    if dict.placeholder == AddTaskTitles.shift{
                        self.viewModel.selectedShiftId = (valueId as? Int) ?? 0
                    }
                }
                cell.inputTf2.text = (value as? String) ?? ""
            }
        }
        }
    }
}
//MARK:- PickerInputCellDelegate
extension AddScheduleViewController : PickerInputCellDelegate{
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
                        
                        if (tempDict.placeholder ?? "") == ScheduleTitles.PrimaryStaff{
                            self.viewModel.selectedStaffId = (valueID as? Int) ?? 0
                        }
                    }
                }
            }
        }
        
        /*
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
        }*/
    }
    
}

//MARK:- DateTimeInputCellDelegate
extension AddScheduleViewController : DateTimeInputCellDelegate{
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

//MARK:- UICollectionViewDelegate & UICollectionViewDataSource
extension AddScheduleViewController : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReuseIdentifier.AppointmentSlotCell, for: indexPath) as! AppointmentSlotCell
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
         
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return  CGSize(width: 150, height: 50)
    }
    
    
}

class AppointmentSlotCell : UICollectionViewCell{
        @IBOutlet weak var lblSlot: UILabel!

        override init(frame: CGRect) {
               super.init(frame: frame)

        }
        
        required init?(coder: NSCoder) {
            super.init(coder: coder)
        }
}
