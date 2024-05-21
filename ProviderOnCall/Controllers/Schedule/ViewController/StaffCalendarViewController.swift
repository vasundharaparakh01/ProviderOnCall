//
//  StaffCalendarViewController.swift

//
//  Created by Vasundhara Parakh on 5/18/20.
//  Copyright © 2020 smartData Enterprises (I) Ltd. All rights reserved.
//

import UIKit
import FSCalendar
import IQKeyboardManagerSwift

enum CalendarViewSections {
    static let Month = 0
    static let Week = 1
    static let Day = 2
}
class StaffCalendarViewController: BaseViewController {
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var calendarView: FSCalendar!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var tblAppointments: UITableView!
    @IBOutlet weak var tblDayView: UITableView!
    @IBOutlet weak var viewAppointment: UIView!
    @IBOutlet weak var lblDate: UILabel!
    
    var selectedViewType = CalendarViewSections.Month
    var selectedCalendarDate : Date?
    var arrInput = [Any]()
    lazy var viewModel: StaffCalendarViewModel = {
        let obj = StaffCalendarViewModel(with: VirtualConsultService())
        self.baseViewModel = obj
        return obj
    }()
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
    var hourLblArray = ["12 AM", "1 AM", "2 AM", "3 AM", "4 AM", "5 AM", "6 AM", "7 AM", "8 AM", "9 AM", "10 AM", "11 AM", "12 PM","1 PM","2 PM","3 PM","4 PM","5 PM","6 PM","7 PM","8 PM","9 PM","10 PM","11 PM",""]
    var slots = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.selectedCalendarDate = Date()
        self.initialSetup()
        self.addrightBarButtonItem()
        self.addBackButton()
        self.navigationItem.title = NavigationTitle.Schedule
        
        // Do any additional setup after loading the view.
    }
    func initialSetup(){
        self.tblDayView.isHidden = self.selectedViewType == CalendarViewSections.Month
        
        self.viewAppointment.isHidden = true
        self.setCalendarView()
        self.registerNIBs()
        self.setupClosures()
        self.viewModel.getScheduleMasters()
        
    }
    func registerNIBs(){
        self.tblView.register(UINib(nibName: ReuseIdentifier.DoubleInputCell, bundle: nil), forCellReuseIdentifier: ReuseIdentifier.DoubleInputCell)
        self.tblView.register(UINib(nibName: ReuseIdentifier.TextInputCell, bundle: nil), forCellReuseIdentifier: ReuseIdentifier.TextInputCell)
        
        self.tblView.register(UINib(nibName: ReuseIdentifier.PickerInputCell, bundle: nil), forCellReuseIdentifier: ReuseIdentifier.PickerInputCell)
        
        self.tblView.register(UINib(nibName: ReuseIdentifier.DateTimeInputCell, bundle: nil), forCellReuseIdentifier: ReuseIdentifier.DateTimeInputCell)
        
        self.tblView.register(UINib(nibName: ReuseIdentifier.NumberInputCell, bundle: nil), forCellReuseIdentifier: ReuseIdentifier.NumberInputCell)
        
        self.tblView.register(UINib(nibName: ReuseIdentifier.CheckmarkInputCell, bundle: nil), forCellReuseIdentifier: ReuseIdentifier.CheckmarkInputCell)
        
        
        
    }
    func addrightBarButtonItem() {
        let availabilityBtn : UIButton = UIButton.init(type: .custom)
        availabilityBtn.setImage(UIImage.availability(), for: .normal)
        availabilityBtn.addTarget(self, action: #selector(onRightBarButtonItemClicked(_ :)), for: .touchUpInside)
        availabilityBtn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        let addAvailabilityButton = UIBarButtonItem(customView: availabilityBtn)
        navigationItem.rightBarButtonItems = [addAvailabilityButton]
    }
    
    // MARK:
    @objc func onRightBarButtonItemClicked(_ sender: UIBarButtonItem) {
        if let vc = AvailabilityViewController.instantiate(appStoryboard: Storyboard.VirtualConsult) as? AvailabilityViewController{
            self.navigationController?.pushViewController(vc,animated:true)
        }
    }
    func setupClosures() {
        self.viewModel.updateViewClosure = { [weak self] () in
            DispatchQueue.main.async {
                self?.arrInput = self?.viewModel.getInputArray() ?? [""]
                self?.tblView.reloadData()
                self?.tblDayView.reloadData()
            }
        }
        
        self.viewModel.reloadListViewClosure = { [weak self] () in
            DispatchQueue.main.async {
                self?.tblAppointments.reloadData()
                if self?.selectedViewType == CalendarViewSections.Month{
                    
                    self?.lblDate.text = Utility.getStringFromDate(date: self?.selectedCalendarDate ?? Date(), dateFormat: DateFormats.mm_dd_yyyy)
                    self?.viewAppointment.isHidden = false
                }else{
                    self?.slots = self?.viewModel.appointmentList.compactMap({ (appointment) -> String? in
                        let startDate = Utility.convertServerDateToRequiredDate(dateStr: appointment.startDateTime ?? "", requiredDateformat: "HH:mm")
                        let endDate = Utility.convertServerDateToRequiredDate(dateStr: appointment.endDateTime ?? "", requiredDateformat: "HH:mm")
                        return startDate + "-" + endDate
                    }) ?? []
                    
                    self?.tblDayView.reloadData()
                }
            }
        }
        
        self.viewModel.updateViewForCalendarClosure = { [weak self] () in
            DispatchQueue.main.async {
                self?.calendarView.reloadInputViews()
                self?.calendarView.reloadData()
            }
        }
        
    }
    
    
    
    func setCalendarView(){
        self.calendarView.scope = self.selectedViewType == CalendarViewSections.Month ? FSCalendarScope.month : FSCalendarScope.week
        
        self.calendarView.backgroundColor = UIColor.white
        self.calendarView.appearance.headerTitleFont = UIFont.PoppinsRegular(fontSize: 20.0)
        self.calendarView.appearance.weekdayFont = UIFont.PoppinsRegular(fontSize: 14.0)
        self.calendarView.appearance.caseOptions = FSCalendarCaseOptions.weekdayUsesUpperCase
        //self.calendarView.select(self.calendarView.today)
        self.calendarView.setCurrentPage(self.calendarView.today ?? Date(), animated: false)
        
        self.calendarView.dataSource = self
        self.calendarView.delegate = self
        
        self.calendarView.select(self.selectedCalendarDate ?? Date())
        self.calendarView.placeholderType = .none
        
    }
    
    @IBAction func segmentedControl(sender: AnyObject) {
        self.selectedViewType = segmentedControl.selectedSegmentIndex
        switch segmentedControl.selectedSegmentIndex {
        case CalendarViewSections.Month:
            self.setCalendarView()
        case CalendarViewSections.Week:
            self.setCalendarView()
            self.slots = self.viewModel.appointmentList.compactMap({ (appointment) -> String? in
                let startDate = Utility.convertServerDateToRequiredDate(dateStr: appointment.startDateTime ?? "", requiredDateformat: "HH:mm")
                let endDate = Utility.convertServerDateToRequiredDate(dateStr: appointment.endDateTime ?? "", requiredDateformat: "HH:mm")
                return startDate + "-" + endDate
            }) ?? []
            
            self.tblDayView.reloadData()
        case CalendarViewSections.Day:
            print("Dp nothing")
        default:
            print("Do nothing")
        }
        self.tblDayView.isHidden = self.selectedViewType == CalendarViewSections.Month
        
    }
    @IBAction func btnCloseAppointment_clicked(_ sender: Any) {
        self.viewAppointment.isHidden = true
    }
    
    func loadAppointmentList(){
    }
}

//MARK: FSCalendarDataSource,FSCalendarDelegate
extension StaffCalendarViewController : FSCalendarDataSource,FSCalendarDelegate{
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        
        let dateArr = self.viewModel.calendarEventList.compactMap({Utility.convertServerDateToRequiredDate(dateStr: $0.startDateTime ?? "", requiredDateformat: DateFormats.YYYY_MM_DD)})
        let EnddateArr = self.viewModel.calendarEventList.compactMap({Utility.convertServerDateToRequiredDate(dateStr: $0.endDateTime ?? "", requiredDateformat: DateFormats.YYYY_MM_DD)})
        
        let allDates = dateArr + EnddateArr
        
        let dateOfEvent = Utility.getStringFromDate(date: date, dateFormat: DateFormats.YYYY_MM_DD)
        
        var count = 0
        for (_,item) in allDates.enumerated() {
            if item == dateOfEvent{
                count += 1
            }
        }
        return allDates.contains(dateOfEvent) ? count : 0
    }
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventDefaultColorsFor date: Date) -> [UIColor]? {
        
        return [Color.Red]
    }
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventColorFor date: Date) -> UIColor? {
        //Do some checks and return whatever color you want to.
        return  Color.Red
        
    }
    
    //Commented to display past appointments - 04/11/2019
    //Developer - Vasundhara parakh
    /*func minimumDate(for calendar: FSCalendar) -> Date {
     return Date()
     }*/
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        self.view.endEditing(true)
        self.selectedCalendarDate = date
        AppInstance.shared.selectedCalendarDate = date
        let dateArr = self.viewModel.calendarEventList.compactMap({Utility.convertServerDateToRequiredDate(dateStr: $0.startDateTime ?? "", requiredDateformat: DateFormats.YYYY_MM_DD)})
        let EnddateArr = self.viewModel.calendarEventList.compactMap({Utility.convertServerDateToRequiredDate(dateStr: $0.endDateTime ?? "", requiredDateformat: DateFormats.YYYY_MM_DD)})
        
        let allDates = dateArr + EnddateArr
        
        let dateOfEvent = Utility.getStringFromDate(date: date, dateFormat: DateFormats.YYYY_MM_DD)
        
        var itemForAppointment = [Appointments]()
        for (_,item) in self.viewModel.calendarEventList.enumerated() {
            let strt = Utility.convertServerDateToRequiredDate(dateStr: item.startDateTime ?? "", requiredDateformat: DateFormats.YYYY_MM_DD)
            
            let end = Utility.convertServerDateToRequiredDate(dateStr: item.endDateTime ?? "", requiredDateformat: DateFormats.YYYY_MM_DD)
            
            if dateOfEvent == strt || dateOfEvent == end{
                itemForAppointment.append(item)
            }
        }
        self.viewModel.appointmentList = itemForAppointment
        self.tblAppointments.reloadData()
        
        if self.selectedViewType == CalendarViewSections.Month{
            
            self.lblDate.text = Utility.getStringFromDate(date: self.selectedCalendarDate ?? Date(), dateFormat: DateFormats.mm_dd_yyyy)
            self.viewAppointment.isHidden = false
        }else{
            self.slots = self.viewModel.appointmentList.compactMap({ (appointment) -> String? in
                let startDate = Utility.convertServerDateToRequiredDate(dateStr: appointment.startDateTime ?? "", requiredDateformat: "HH:mm")
                let endDate = Utility.convertServerDateToRequiredDate(dateStr: appointment.endDateTime ?? "", requiredDateformat: "HH:mm")
                
                let startTime = Utility.getDateFromstring(dateStr: startDate, dateFormat: "HH:mm")
                let endTime = Utility.getDateFromstring(dateStr: endDate, dateFormat: "HH:mm")
                let startDateStr = Utility.convertServerDateToRequiredDate(dateStr: appointment.startDateTime ?? "", requiredDateformat: DateFormats.YYYY_MM_DD)
                let endDateStr = Utility.convertServerDateToRequiredDate(dateStr: appointment.endDateTime ?? "", requiredDateformat: DateFormats.YYYY_MM_DD)
                
                
                let selectedDateStr = Utility.getStringFromDate(date: self.selectedCalendarDate ?? Date(), dateFormat: DateFormats.YYYY_MM_DD)
                if startTime > endTime && startDateStr == selectedDateStr{
                    return startDate + "-" + "24:00"
                }else if (startTime > endTime && endDateStr == selectedDateStr){
                    return "00:00" + "-" + endDate
                }
                
                return startDate + "-" + endDate
            }) ?? []
            
            self.tblDayView.reloadData()
        }
        //self.viewModel.getPatientAppointmentList(startDate: date,endDate : date)
    }
    
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        return true
    }
    
}
//MARK:- UITableViewDelegate,UITableViewDataSource

extension StaffCalendarViewController : UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == self.tblView{
            return self.arrInput.count
        }else if ( tableView == self.tblDayView){
            return 1
        }else{
            if self.viewModel.numberOfRowsForAppointmentList() > 0{
                Utility.setEmptyTableFooter(tableView: tableView)
            }else{
                Utility.setTableFooterWithMessage(tableView: tableView, message: Alert.Message.noRecords)
            }
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        if ( tableView == self.tblDayView){
            return 60
        }
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.tblView{
            
            if let arr = (self.arrInput[section] as? [Any]){
                return arr.count
            }else{
                if let singleInput = self.arrInput[section] as? InputTextfieldModel{
                    return 1
                }
            }
        }else if ( tableView == self.tblDayView){
            return self.hourLblArray.count
        }else{
            return self.viewModel.numberOfRowsForAppointmentList()
        }
        return 0
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
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
        if tableView == self.tblView{
            
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
                        cell.inputTf.text = dict.value ?? ""
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
                        
                        //cell.inputTf1.isUserInteractionEnabled = false
                        //cell.inputTf2.isUserInteractionEnabled = false
                        
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
        }else if ( tableView == self.tblDayView){
            let cell = tableView.dequeueReusableCell(withIdentifier: ReuseIdentifier.DayCalendarCell, for: indexPath as IndexPath) as! DayCalendarCell
            
            cell.btnTop.isHidden = true
            cell.btnBottom.isHidden = true
            cell.btnTopStart.isHidden = true
            cell.btnBottomStart.isHidden = true
            
            //Eg : Slot : 03:00 AM - 5:00 AM
            for (index,slotsItem) in self.slots.enumerated() {
                
                cell.btnTop.tag = index
                cell.btnBottom.tag = index
                cell.btnTopStart.tag = index
                cell.btnBottomStart.tag = index
                
                cell.btnTop.addTarget(self, action: #selector(self.btnDayAppointment_clicked(_:)), for: .touchUpInside)
                cell.btnBottom.addTarget(self, action: #selector(self.btnDayAppointment_clicked(_:)), for: .touchUpInside)
                cell.btnTopStart.addTarget(self, action: #selector(self.btnDayAppointment_clicked(_:)), for: .touchUpInside)
                cell.btnBottomStart.addTarget(self, action: #selector(self.btnDayAppointment_clicked(_:)), for: .touchUpInside)
                
                let dateSlot = slotsItem.components(separatedBy: "-")
                let startDate = (dateSlot.first ?? "").components(separatedBy: ":")
                let endDate = (dateSlot.last ?? "").components(separatedBy: ":")
                
                let startHr : Int = Int(startDate.first ?? "0") ?? 0
                let endHr : Int = Int(endDate.first ?? "0") ?? 0
                
                let startMin : Int = Int(startDate.last ?? "0") ?? 0
                let endMin : Int = Int(endDate.last ?? "0") ?? 0
                
                if startHr == endHr {
                    if endMin > 50{
                        if indexPath.row == startHr + 1 {
                            cell.btnTop.isHidden = false
                            cell.btnTopStart.isHidden = true
                            cell.btnBottom.isHidden = true
                            cell.btnBottomStart.isHidden = true
                            cell.btnTopHeightConstraint.constant = CGFloat(endMin - 50)
                        }else if indexPath.row == startHr{
                            cell.btnTop.isHidden = true
                            cell.btnTopStart.isHidden = true
                            cell.btnBottom.isHidden = true
                            cell.btnBottomStart.isHidden = false
                            cell.btnBottomStartHeightConstraint.constant = CGFloat(50 - startMin)
                        }
                    }else {
                        if indexPath.row == startHr {
                            cell.btnTop.isHidden = true
                            cell.btnTopStart.isHidden = true
                            cell.btnBottom.isHidden = true
                            cell.btnBottomStart.isHidden = false
                            cell.btnBottomStartHeightConstraint.constant = CGFloat(50 - startMin)
                        }
                    }
                    
                }else if (startHr > endHr){
                    if indexPath.row >= startHr{
                        cell.btnTop.isHidden = false
                        //cell.btnBottom.isHidden = false
                        cell.btnBottomStart.isHidden = false
                        cell.btnBottomStartHeightConstraint.constant = CGFloat(50)
                        
                        //Setting Start Deivider
                        if startMin == 0 && indexPath.row == startHr{
                            cell.btnTop.isHidden = true
                        }else if (startMin <= 10 && indexPath.row == startHr){
                            cell.btnBottomStartHeightConstraint.constant = CGFloat(50 - startMin)
                            cell.btnBottomStart.isHidden = false
                            cell.btnBottom.isHidden = true
                            cell.btnTop.isHidden = true
                            cell.btnTopStart.isHidden = true
                        }else if startMin > 10 && startMin <= 50 && indexPath.row == startHr{
                            cell.btnBottomStartHeightConstraint.constant = CGFloat( 50 - startMin)
                            print("startHr equal indexpath === \(indexPath.row)")
                            
                            cell.btnBottomStart.isHidden = false
                            cell.btnBottom.isHidden = true
                            cell.btnTop.isHidden = true
                            cell.btnTopStart.isHidden = true
                        }else if(startMin > 50  ){
                            if indexPath.row == startHr{
                                cell.btnBottom.isHidden = true
                                cell.btnTop.isHidden = true
                                cell.btnBottomStart.isHidden = true
                                cell.btnTopStart.isHidden = true
                            }
                            
                            if indexPath.row == startHr + 1 {
                                cell.btnTop.isHidden = true
                                cell.btnBottom.isHidden = true
                                cell.btnBottomStart.isHidden = false
                                cell.btnTopStart.isHidden = false
                                cell.btnTopStartHeightConstraint.constant = CGFloat(startMin - 50)
                                print("startHr + 1 === \(indexPath.row)")
                            }
                        }
                        
                    }
                    else if indexPath.row <= endHr{
                        cell.btnTop.isHidden = false
                        cell.btnBottom.isHidden = true
                        cell.btnBottomStart.isHidden = false
                        cell.btnBottomStartHeightConstraint.constant = CGFloat(50)
                        
                        //Setting End Divider
                        if endMin == 0 {
                            if indexPath.row == endHr {
                                cell.btnBottom.isHidden = true
                            }
                        }else if( endMin <= 10 && indexPath.row == endHr){
                            cell.btnBottomHeightConstraint.constant = CGFloat(endMin)
                            cell.btnBottom.isHidden = false
                            cell.btnBottomStart.isHidden = true
                            cell.btnTopStart.isHidden = true
                            cell.btnTop.isHidden = false
                        }else if endMin > 10 && endMin <= 50 && indexPath.row == endHr {
                            cell.btnBottomHeightConstraint.constant = CGFloat(endMin)
                            cell.btnBottom.isHidden = false
                            cell.btnTop.isHidden = false
                            cell.btnBottomStart.isHidden = true
                            cell.btnTopStart.isHidden = true
                            
                        }else if(endMin > 50  ){
                            if indexPath.row == endHr{
                                cell.btnBottom.isHidden = false
                                cell.btnTop.isHidden = false
                                cell.btnBottomStart.isHidden = true
                                cell.btnTopStart.isHidden = true
                                
                            }
                            
                            if indexPath.row == endHr + 1 {
                                cell.btnTop.isHidden = false
                                cell.btnBottom.isHidden = true
                                cell.btnBottomStart.isHidden = true
                                cell.btnTopStart.isHidden = true
                                cell.btnTopHeightConstraint.constant = CGFloat(endMin - 50)
                            }
                            
                        }
                    }
                    //                    if indexPath.row <= endHr{
                    //                        cell.btnTop.isHidden = false
                    //                        cell.btnBottom.isHidden = false
                    //                        if indexPath.row == 0 {
                    //                            cell.btnTop.isHidden = true
                    //                        }
                    //
                    //                    }
                    //
                    //                    if indexPath.row == endHr {
                    //                        if endMin <= 50{
                    //                            cell.btnTop.isHidden = false
                    //                            cell.btnBottom.isHidden = false
                    //                            cell.btnBottomStart.isHidden = true
                    //                            cell.btnBottomHeightConstraint.constant = CGFloat(endMin)
                    //                        }
                    //                    }
                    
                    
                }else{
                    if indexPath.row >= startHr && indexPath.row <= endHr {
                        
                        
                        if indexPath.row == startHr{
                            cell.btnTop.isHidden = true
                        }else{
                            cell.btnTop.isHidden = false
                        }
                        cell.btnBottom.isHidden = false
                    }
                    
                    //Setting Start Deivider
                    if startMin == 0 && indexPath.row == startHr{
                        cell.btnTop.isHidden = true
                    }else if (startMin <= 10 && indexPath.row == startHr){
                        cell.btnBottomStartHeightConstraint.constant = CGFloat(50 - startMin)
                        cell.btnBottomStart.isHidden = false
                        cell.btnBottom.isHidden = true
                        cell.btnTop.isHidden = true
                        cell.btnTopStart.isHidden = true
                    }else if startMin > 10 && startMin <= 50 && indexPath.row == startHr{
                        cell.btnBottomStartHeightConstraint.constant = CGFloat( 50 - startMin)
                        cell.btnBottomStart.isHidden = false
                        cell.btnBottom.isHidden = true
                        cell.btnTop.isHidden = true
                        cell.btnTopStart.isHidden = true
                    }else if(startMin > 50  ){
                        if indexPath.row == startHr{
                            cell.btnBottom.isHidden = true
                            cell.btnTop.isHidden = true
                            cell.btnBottomStart.isHidden = true
                            cell.btnTopStart.isHidden = true
                        }
                        
                        if indexPath.row == startHr + 1 {
                            cell.btnTop.isHidden = true
                            cell.btnBottom.isHidden = true
                            cell.btnBottomStart.isHidden = false
                            cell.btnTopStart.isHidden = false
                            cell.btnTopStartHeightConstraint.constant = CGFloat(startMin - 50)
                            
                        }
                    }
                    
                    //Setting End Divider
                    if endMin == 0 {
                        if indexPath.row == endHr {
                            cell.btnBottom.isHidden = true
                        }
                    }else if( endMin <= 10 && indexPath.row == endHr){
                        cell.btnBottomHeightConstraint.constant = CGFloat(endMin)
                        cell.btnBottom.isHidden = false
                        cell.btnBottomStart.isHidden = true
                        cell.btnTopStart.isHidden = true
                        cell.btnTop.isHidden = false
                    }else if endMin > 10 && endMin <= 50 && indexPath.row == endHr {
                        cell.btnBottomHeightConstraint.constant = CGFloat(endMin)
                        cell.btnBottom.isHidden = false
                        cell.btnTop.isHidden = false
                        cell.btnBottomStart.isHidden = true
                        cell.btnTopStart.isHidden = true
                        
                    }else if(endMin > 50  ){
                        if indexPath.row == endHr{
                            cell.btnBottom.isHidden = false
                            cell.btnTop.isHidden = false
                            cell.btnBottomStart.isHidden = true
                            cell.btnTopStart.isHidden = true
                            
                        }
                        
                        if indexPath.row == endHr + 1 {
                            cell.btnTop.isHidden = false
                            cell.btnBottom.isHidden = true
                            cell.btnBottomStart.isHidden = true
                            cell.btnTopStart.isHidden = true
                            cell.btnTopHeightConstraint.constant = CGFloat(endMin - 50)
                        }
                        
                    }
                }
            }
            //Ends
            
            cell.lblHour.text = self.hourLblArray[indexPath.row]
            
            cell.selectionStyle = .none
            return cell
            
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: ReuseIdentifier.ScheduleAppointmentCell, for: indexPath as IndexPath) as! ScheduleAppointmentCell
            cell.appointment = self.viewModel.roomForIndexPathForAppointmentList(indexPath)
            return cell
        }
        return UITableViewCell()
    }
    
    @objc func btnDayAppointment_clicked(_ sender: UIButton){
        //        let objectSelected = self.viewModel.appointmentList[sender.tag]
        //        self.viewModel.appointmentList.removeAll()
        //        self.viewModel.appointmentList.append(objectSelected)
        self.viewAppointment.isHidden = false
        self.lblDate.text = Utility.getStringFromDate(date: self.selectedCalendarDate ?? Date(), dateFormat: DateFormats.mm_dd_yyyy)
        self.tblAppointments.reloadData()
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
            print("SELECTED \(values)")
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
                    let stringValue = valueArr.joined(separator: ", ")
                    let stringIds = valueIdsArr.joined(separator: ",")
                    
                    if (dict.placeholder ?? "") == ScheduleTitles.Resident{
                        self.selectedPatientIds = values
                        self.viewModel.selectedResidentIds = stringIds
                        
                    }else if (dict.placeholder ?? "") == ScheduleTitles.Staff{
                        self.selectedStaffIds = values
                        self.viewModel.selectedStaffIds = stringIds
                        
                    }
                    
                    dict.value = stringValue
                    dict.valueId = stringIds
                    dict.isValid = true
                    copyArr[indexPath.row] = dict
                    self.arrInput[indexPath.section] = copyArr
                    
                    if let cell = self.tblView.cellForRow(at: IndexPath(row: indexPath.row, section: indexPath.section )) as? TextInputCell{
                        cell.inputTf.text = stringValue
                    }
                }
            }
        }
    }
}
//MARK:- UITextFieldDelegate
extension StaffCalendarViewController : UITextFieldDelegate{
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
                                        self.viewModel.getStaffPatientDropdown(locationId: self.selectedLocationId, roleId: self.selectedRoleId, unitID: self.selectedUnitId) { (result) in
                                            self.viewModel.isLoading = false
                                            if let res = result as? PatientStaffMaster{
                                                self.residentDropdownArray = res.patients
                                                self.showMultiValuePicker(indexPath: indexPath,dropDownArray: self.residentDropdownArray ?? [""])
                                            }else{
                                                self.showMultiValuePicker(indexPath: indexPath,dropDownArray: [""])
                                            }
                                        }
                                    }else if (dict.placeholder == ScheduleTitles.Staff){
                                        self.viewModel.getStaffPatientDropdown(locationId: self.selectedLocationId, roleId: self.selectedRoleId, unitID: self.selectedUnitId) { (result) in
                                            self.viewModel.isLoading = false
                                            if let res = result as? PatientStaffMaster{
                                                self.staffDropdownArray = res.staff
                                                self.showMultiValuePicker(indexPath: indexPath,dropDownArray: self.staffDropdownArray ?? [""])
                                            }else{
                                                self.showMultiValuePicker(indexPath: indexPath,dropDownArray: [""])
                                            }
                                        }
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
                                        
                                        dict.value = dateStr
                                        dict.valueId = dateStr//Date()
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
                                        if self.checkStaffAvailability(date:  Date()) {
                                            
                                            let isDate = (dict.inputType ?? "") == InputType.Date
                                            let dateStr = Utility.getStringFromDate(date: Date(), dateFormat: isDate ? DateFormats.mm_dd_yyyy : DateFormats.hh_mm_a)
                                            
                                            dict.value = dateStr
                                            dict.valueId = dateStr//Date()
                                            dict.isValid = true
                                            copySubArray[reqdIndex] = dict
                                            copyArr[indexPath.row] = copySubArray
                                            self.arrInput[indexPath.section] = copyArr
                                            
                                            textField.text = dateStr
                                        }
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
                                                    self.viewModel.unitID = selectedValue.valueID as? Int ?? 0
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
                                            
                                            
                                            
                                        }else if (dict.placeholder == "Provider"){
                                            self.viewModel.getStaffPatientDropdown(locationId: self.selectedLocationId, roleId: self.selectedRoleId, unitID: self.selectedUnitId) { (result) in
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
                                        if (dict.placeholder == "Provider"){
                                            self.viewModel.getStaffPatientDropdown(locationId: self.selectedLocationId, roleId: self.selectedRoleId, unitID: self.selectedUnitId) { (result) in
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
                                        self.viewModel.getStaffPatientDropdown(locationId: self.selectedLocationId, roleId: self.selectedRoleId, unitID: self.selectedUnitId) { (result) in
                                            self.viewModel.isLoading = false
                                            if let res = result as? PatientStaffMaster{
                                                self.residentDropdownArray = res.patients
                                                self.showMultiValuePicker(indexPath: indexPath,dropDownArray: self.residentDropdownArray ?? [""])
                                            }else{
                                                self.showMultiValuePicker(indexPath: indexPath,dropDownArray: [""])
                                            }
                                        }
                                    }else if (dict.placeholder == ScheduleTitles.Staff){
                                        self.viewModel.getStaffPatientDropdown(locationId: self.selectedLocationId, roleId: self.selectedRoleId, unitID: self.selectedUnitId) { (result) in
                                            self.viewModel.isLoading = false
                                            if let res = result as? PatientStaffMaster{
                                                self.staffDropdownArray = res.staff
                                                self.showMultiValuePicker(indexPath: indexPath,dropDownArray: self.staffDropdownArray ?? [""])
                                            }else{
                                                self.showMultiValuePicker(indexPath: indexPath,dropDownArray: [""])
                                            }
                                        }                                        }
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
                                            /*
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
                                             if let dict = dictArr[2] as? InputTextfieldModel{
                                             dict.value = ""
                                             dict.valueId = 0
                                             dict.isValid = false
                                             copyArr[2] = dict
                                             self.arrInput[indexPath.section] = copyArr
                                             
                                             if let cellResident = self.tblView.cellForRow(at: IndexPath(row: 2, section: indexPath.section)) as? TextInputCell{
                                             cellResident.inputTf.text = ""
                                             }
                                             }
                                             }*/
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
                                        }
                                        
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        
        self.viewModel.getAllAppointmentList(startDate: Date(), endDate: Date(), shiftId: self.selectedShiftSchedule?.shiftMasterId ?? 0)
    }
    
    //Returns (Int,Int) -> (Index,SubIndex)
    func getIndexAndSubIndexFromTag(textFieldTag : Int) -> (Int,Int){
        var index = textFieldTag
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

//MARK:- DoubleInputCellDelegate
extension StaffCalendarViewController : DoubleInputCellDelegate{
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
        
        if let indexPath = self.tblView.indexPath(for: (self.activeTextfield?.superview?.superview as! DoubleInputCell)){//IndexPath(row: index, section: 0){
            
            if let dictArr = (self.arrInput[indexPath.section] as? [Any]){
                let copySectionArray = dictArr
                var copyArr = dictArr[indexPath.row] as! [InputTextfieldModel]
                let dict = copyArr[dictIndex]
                dict.value = (value as? String) ?? ""
                dict.valueId = valueId
                dict.isValid = true
                copyArr[dictIndex] = dict
                self.arrInput[index] = copyArr
                self.arrInput[indexPath.section] = copySectionArray
                
            }
            
            if let cell = self.tblView.cellForRow(at: indexPath) as? DoubleInputCell{
                if  dictIndex == 0{
                    if let dictArr = (self.arrInput[indexPath.section] as? [Any]){
                        var copyArr = dictArr[indexPath.row] as! [InputTextfieldModel]
                        let dict = copyArr[dictIndex]
                        if dict.placeholder == AddTaskTitles.unit{
                            
                            self.viewModel.unitID = (valueId as? Int) ?? 0
                            self.selectedUnitId = (valueId as? Int) ?? 0
                        }
                        
                        if dict.placeholder == AddTaskTitles.role{
                            self.selectedRoleId = (valueId as? Int) ?? 0
                        }
                        
                        
                        
                    }
                    
                    cell.inputTf1.text = (value as? String) ?? ""
                }else{
                    self.viewModel.selectedShiftId = (valueId as? Int) ?? 0
                    cell.inputTf2.text = (value as? String) ?? ""
                }
            }
        }
    }
}
//MARK:- PickerInputCellDelegate
extension StaffCalendarViewController : PickerInputCellDelegate{
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
                        
                        if (tempDict.placeholder ?? "") == "Provider"{
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
extension StaffCalendarViewController : DateTimeInputCellDelegate{
    func selectedDateForInput(date: Date, textfieldTag: Int, isDateField : Bool) {
        let dateStr = Utility.getStringFromDate(date: date, dateFormat: isDateField ? DateFormats.mm_dd_yyyy : DateFormats.hh_mm_a)
        debugPrint("Date = \(dateStr) --- Tf tag \(textfieldTag)")
        
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
                    dict.valueId = dateStr
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

class DayCalendarCell : UITableViewCell{
    @IBOutlet weak var lblHour: UILabel!
    @IBOutlet weak var btnTop: UIButton!
    @IBOutlet weak var btnTopStart: UIButton!
    @IBOutlet weak var btnBottomStart: UIButton!
    @IBOutlet weak var btnBottom: UIButton!
    @IBOutlet weak var btnTopHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var btnBottomHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var btnTopStartHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var btnBottomStartHeightConstraint: NSLayoutConstraint!
    
}
