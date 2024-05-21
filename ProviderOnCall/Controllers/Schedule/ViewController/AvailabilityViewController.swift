//
//  AvailabilityViewController.swift

//
//  Created by Vasundhara Parakh on 5/18/20.
//  Copyright © 2020 smartData Enterprises (I) Ltd. All rights reserved.
//

import UIKit
import FSCalendar

class AvailabilityViewController: BaseViewController {
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var calendarView: FSCalendar!
    @IBOutlet weak var tfShift: InputTextField!
    @IBOutlet weak var tfUnit: InputTextField!

    var selectedCalendarDate : Date?
    var pickerView = UIPickerView()
    var pickerView2 = UIPickerView()

    var arrDropdown = [Any]()
    var arrDropdownUnit = [Any]()

    var selectedShiftId = 0
    var selectedUnitId = 0

    var filteredAppointmentList = [AvailabilityByDayName]()
    lazy var viewModel: AvailabilityViewModel = {
        let obj = AvailabilityViewModel(with: VirtualConsultService())
        self.baseViewModel = obj
        return obj
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        //self.selectedCalendarDate = Date()
        self.initialSetup()
        self.addBackButton()
        self.navigationItem.title = NavigationTitle.Availability

        // Do any additional setup after loading the view.
    }
    
    func initialSetup(){
        self.tblView.register(UINib(nibName: ReuseIdentifier.ListTableViewCell, bundle: nil), forCellReuseIdentifier: ReuseIdentifier.ListTableViewCell)

        self.setCalendarView()
        self.setupClosures()
        self.tfShift.inputView = self.pickerView2
        self.tfUnit.inputView = self.pickerView

        self.pickerView.backgroundColor = UIColor.white
        self.pickerView.delegate = self
        self.pickerView.dataSource = self

        self.pickerView2.backgroundColor = UIColor.white
        self.pickerView2.delegate = self
        self.pickerView2.dataSource = self

    }

    func setupClosures() {
        /*
        self.viewModel.reloadListViewClosure = { [weak self] () in
            DispatchQueue.main.async {
            }
        }
        */
        self.viewModel.updateViewForCalendarClosure = { [weak self] () in
            DispatchQueue.main.async {
                self?.calendarView.reloadInputViews()
                self?.calendarView.reloadData()
            }
        }
        
    }
    


    func setCalendarView(){
        self.calendarView.scope = FSCalendarScope.month 
            
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
    }
    
    @IBAction func btnSetAvailability_clicked(_ sender: Any) {
        if let vc = SetAvailabilityViewController.instantiate(appStoryboard: Storyboard.VirtualConsult) as? SetAvailabilityViewController{
            vc.selectedShiftId = self.selectedShiftId
            if self.selectedShiftId == 0 {
                self.viewModel.errorMessage = "Please select unit & shift"
            }else{
                self.navigationController?.pushViewController(vc,animated:true)
            }
        }
    }

}
//MARK: FSCalendarDataSource,FSCalendarDelegate
extension AvailabilityViewController : FSCalendarDataSource,FSCalendarDelegate{
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        
        let dateArr = self.viewModel.availabilityList.compactMap({Utility.convertServerDateToRequiredDate(dateStr: $0.date ?? "", requiredDateformat: DateFormats.YYYY_MM_DD)})
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
        self.filteredAppointmentList.removeAll()
        self.view.endEditing(true)
        self.selectedCalendarDate = date
        
        let dateArr = self.viewModel.availabilityList.compactMap({Utility.convertServerDateToRequiredDate(dateStr: $0.date ?? "", requiredDateformat: DateFormats.YYYY_MM_DD)})
        let dateOfEvent = Utility.getStringFromDate(date: date, dateFormat: DateFormats.YYYY_MM_DD)
        
        
        for (_,item) in self.viewModel.availabilityList.enumerated() {
            let itemDate = Utility.convertServerDateToRequiredDate(dateStr: item.date ?? "", requiredDateformat: DateFormats.YYYY_MM_DD)
            if itemDate == dateOfEvent{
                self.filteredAppointmentList.append(item)
            }
        }
        self.tblView.reloadData()
        //self.viewModel.getPatientAppointmentList(startDate: date,endDate : date)
    }
    
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        return true
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        self.filteredAppointmentList.removeAll()
        self.tblView.reloadData()
        
        let startDate = calendar.currentPage.startOfMonth()
        let endDate = calendar.currentPage.endOfMonth()
        
        let startDateStr = Utility.getStringFromDate(date: startDate, dateFormat: DateFormats.YYYY_MM_DD)
        let endDateStr = Utility.getStringFromDate(date: endDate, dateFormat: DateFormats.YYYY_MM_DD)

        self.viewModel.getAvailabilityList(fromDate: startDateStr, toDate: endDateStr, shiftId: self.selectedShiftId)
    }
    
    
    
}
extension AvailabilityViewController:UITableViewDataSource, UITableViewDelegate {
   
    func numberOfSections(in tableView: UITableView) -> Int {
        if self.filteredAppointmentList.count > 0{
            Utility.setEmptyTableFooter(tableView: tableView)
        }else{
            Utility.setTableFooterWithMessage(tableView: tableView, message: Alert.Message.noRecords)
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filteredAppointmentList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ReuseIdentifier.ListTableViewCell, for: indexPath as IndexPath) as! ListTableViewCell
        
        let startTime = Utility.convertServerDateToRequiredDate(dateStr: self.filteredAppointmentList[indexPath.row].startTime ?? "", requiredDateformat: DateFormats.hh_mm_a)
        
        let endTime = Utility.convertServerDateToRequiredDate(dateStr: self.filteredAppointmentList[indexPath.row].endTime ?? "", requiredDateformat: DateFormats.hh_mm_a)

        if !(self.filteredAppointmentList[indexPath.row].isAvailable ?? true){
            cell.viewContent.backgroundColor = Color.Red
            cell.titleLbl.text = startTime + " - " + endTime + " (Unavailable)"
        }else{
            cell.viewContent.backgroundColor = Color.Blue
            cell.titleLbl.text = startTime + " - " + endTime

        }
        
        //cell.titleLbl.text = startTime + " - " + endTime
        cell.imgNext.isHidden = true
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Device.IS_IPAD ? 60 : 50
    }

}

//MARK:- UITextFieldDelegate
extension AvailabilityViewController : UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == tfUnit{
            self.viewModel.getUnitDropdown { (result) in
                if let dropdown = result as? [UnitMaster]{
                    self.arrDropdownUnit = dropdown
                    self.pickerView.reloadAllComponents()
                    textField.text = dropdown.isEmpty ? "" : dropdown.first?.unitName ?? ""
                    self.selectedUnitId = dropdown.isEmpty ? 0 : dropdown.first?.id ?? 0
                }
            }
        }else{
            self.viewModel.getShiftDropdown(unitID: self.selectedUnitId) { (result) in
                if let dropdown = result as? [Shift]{
                    self.arrDropdown = dropdown
                    self.pickerView2.reloadAllComponents()
                    textField.text = dropdown.isEmpty ? "" : dropdown.first?.shiftName ?? ""
                    self.selectedShiftId = dropdown.isEmpty ? 0 : dropdown.first?.id ?? 0
                }
            }
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        let startDate = self.calendarView.currentPage.startOfMonth()
        let endDate = self.calendarView.currentPage.endOfMonth()
        
        let startDateStr = Utility.getStringFromDate(date: startDate, dateFormat: DateFormats.YYYY_MM_DD)
        let endDateStr = Utility.getStringFromDate(date: endDate, dateFormat: DateFormats.YYYY_MM_DD)

        self.viewModel.getAvailabilityList(fromDate: startDateStr, toDate: endDateStr, shiftId: self.selectedShiftId)

    }
}
extension AvailabilityViewController : UIPickerViewDelegate,UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == self.pickerView{
            return self.arrDropdownUnit.count
        }
        return self.arrDropdown.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == self.pickerView{
            return Utility.getSelectedValue(arrDropdown: self.arrDropdownUnit,row: row).value
        }
        return Utility.getSelectedValue(arrDropdown: self.arrDropdown,row: row).value
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == self.pickerView{
            let selectedValue = Utility.getSelectedValue(arrDropdown: self.arrDropdownUnit,row: row)
            selectedUnitId = (selectedValue.valueID as? Int) ?? 0
            self.tfUnit.text = selectedValue.value
        }else{
            let selectedValue = Utility.getSelectedValue(arrDropdown: self.arrDropdown,row: row)
            selectedShiftId = (selectedValue.valueID as? Int) ?? 0
            self.tfShift.text = selectedValue.value
        }
    }
    
}
