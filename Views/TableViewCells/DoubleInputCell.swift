//
//  DoubleInputCell.swift
//  appName
//
//  Created by Vasundhara Parakh on 2/20/20.
//  Copyright © 2020 smartData Enterprises (I) Ltd. All rights reserved.
//

import UIKit
protocol DoubleInputCellDelegate {
    func selectedDateForDoubleInput(date : Date, textfieldTag : Int, isDateField : Bool)
    func selectedPickerValueForDoubleInput(value : Any, valueID : Any, textfieldTag : Int)

}
class DoubleInputCell: UITableViewCell{
    var delegate: DoubleInputCellDelegate?
    @IBOutlet weak var inputTf1: InputTextField!
    @IBOutlet weak var inputTf2: InputTextField!
    var inputT1_type = ""
    var inputT2_type = ""
    var pickerView = UIPickerView()
    var arrDropdown1 = [Any]()
    var arrDropdown2 = [Any]()
    var datePicker1 = UIDatePicker()
    var datePicker2 = UIDatePicker()
    var isTfOne = false
    var isDateField1 = true
    var isDateField2 = true

    override func awakeFromNib() {
        super.awakeFromNib()
        self.isDateField1 = inputT1_type == InputType.Date ? true : false
        self.isDateField2 = inputT2_type == InputType.Date ? true : false
        
        switch inputT1_type {
        case InputType.Text:
            inputTf1.inputView = nil
            inputTf1.keyboardType = .default
        case InputType.Number:
            inputTf1.inputView = nil
            inputTf1.keyboardType = .numberPad
        case InputType.Time:
            inputTf1.inputView = self.datePicker1
            self.isTfOne = true
            self.setupDatePicker1(isDate: false)
        case InputType.Date:
            inputTf1.inputView = self.datePicker1
            self.isTfOne = true
            self.setupDatePicker1(isDate: true)
        case InputType.Dropdown:
            self.isTfOne = true
            inputTf1.inputView = self.pickerView
            self.pickerView.backgroundColor = UIColor.white
            self.pickerView.delegate = self
            self.pickerView.dataSource = self
        case InputType.Decimal:
            inputTf1.inputView = nil
            inputTf1.keyboardType = .decimalPad
        default:
            inputTf1.inputView = nil
            return inputTf1.keyboardType = .default
        }
        
        
        switch inputT2_type {
        case InputType.Text:
            inputTf2.inputView = nil
            inputTf2.keyboardType = .default
        case InputType.Number:
            inputTf2.inputView = nil
            inputTf2.keyboardType = .numberPad
        case InputType.Time:
            inputTf2.inputView = self.datePicker2
            self.isTfOne = false
            self.setupDatePicker2(isDate: false)
        case InputType.Date:
            inputTf2.inputView = self.datePicker2
            self.isTfOne = false
            self.setupDatePicker2(isDate: true)
        case InputType.Dropdown:
            self.isTfOne = false
            inputTf2.inputView = self.pickerView
            self.pickerView.backgroundColor = UIColor.white
            self.pickerView.delegate = self
            self.pickerView.dataSource = self
        case InputType.Decimal:
            inputTf2.inputView = nil
            inputTf2.keyboardType = .decimalPad
        default:
            inputTf2.inputView = nil
            return inputTf2.keyboardType = .default
        }
        
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setupDatePicker1(isDate : Bool){
        datePicker1.datePickerMode = isDate ? UIDatePicker.Mode.date : UIDatePicker.Mode.time
        datePicker1.addTarget(self, action: #selector(DoubleInputCell.handleDatePicker1), for: UIControl.Event.valueChanged)
        
    }
    func setupDatePicker2(isDate : Bool){
        datePicker2.datePickerMode = isDate ? UIDatePicker.Mode.date : UIDatePicker.Mode.time
        datePicker2.addTarget(self, action: #selector(DoubleInputCell.handleDatePicker2), for: UIControl.Event.valueChanged)
        
    }

    @objc func  handleDatePicker1(){
        debugPrint("DAte Selected === \(datePicker1.date)")
        self.delegate?.selectedDateForDoubleInput(date: datePicker1.date,textfieldTag:  self.inputTf1.tag, isDateField : self.isDateField1 )
        
    }
    @objc func  handleDatePicker2(){
        debugPrint("DAte Selected === \(datePicker2.date)")
        self.delegate?.selectedDateForDoubleInput(date: datePicker2.date,textfieldTag: self.inputTf2.tag, isDateField :  self.isDateField2)
        
    }

}
extension DoubleInputCell : UIPickerViewDelegate,UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        let isFirst = AppInstance.shared.activeTextfieldIndex < TagConstants.DoubleTF_SecondTextfield_Tag

        return isFirst ? self.arrDropdown1.count : self.arrDropdown2.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let isFirst = AppInstance.shared.activeTextfieldIndex < TagConstants.DoubleTF_SecondTextfield_Tag
        return Utility.getSelectedValue(arrDropdown: isFirst ? self.arrDropdown1 : self.arrDropdown2,row: row).value
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let isFirst = AppInstance.shared.activeTextfieldIndex < TagConstants.DoubleTF_SecondTextfield_Tag

        let selectedValue = Utility.getSelectedValue(arrDropdown: isFirst ? self.arrDropdown1 : self.arrDropdown2,row: row)
        self.delegate?.selectedPickerValueForDoubleInput(value: selectedValue.value, valueID : selectedValue.valueID, textfieldTag: isFirst ? self.inputTf1.tag : self.inputTf2.tag)
    }
    
    
    
}


/*{
    var delegate: DoubleInputCellDelegate?
    
    @IBOutlet weak var inputTf1: InputTextField!
    @IBOutlet weak var inputTf2: InputTextField!
    var inputT1_type = ""
    var inputT2_type = ""
    var pickerView = UIPickerView()
    var arrDropdown = [Any]()
    var datePicker = UIDatePicker()
    var isTfOne = false
    var isDateField = true

    override func awakeFromNib() {
        super.awakeFromNib()
        
        switch inputT1_type {
        case InputType.Text:
            inputTf1.keyboardType = .default
        case InputType.Number:
            inputTf1.keyboardType = .numberPad
        case InputType.Date,InputType.Time:
            inputTf1.inputView = self.datePicker
            self.isTfOne = true
            self.setupDatePicker()
        case InputType.Dropdown:
            inputTf1.inputView = self.pickerView
            self.pickerView.backgroundColor = UIColor.white
            self.pickerView.delegate = self
            self.pickerView.dataSource = self
        case InputType.Decimal:
            inputTf1.keyboardType = .decimalPad
        default:
            return inputTf1.keyboardType = .default
        }
        
        
        switch inputT2_type {
        case InputType.Text:
            inputTf2.keyboardType = .default
        case InputType.Number:
            inputTf2.keyboardType = .numberPad
        case InputType.Date,InputType.Time:
            inputTf2.inputView = self.datePicker
            self.isTfOne = false
            self.setupDatePicker()
        case InputType.Dropdown:
            inputTf2.inputView = self.pickerView
            self.pickerView.backgroundColor = UIColor.white
            self.pickerView.delegate = self
            self.pickerView.dataSource = self
        case InputType.Decimal:
            inputTf2.keyboardType = .decimalPad
        default:
            return inputTf2.keyboardType = .default
        }
        
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setupDatePicker(){
        datePicker.datePickerMode = self.isDateField ? UIDatePicker.Mode.date : UIDatePicker.Mode.time
        datePicker.addTarget(self, action: #selector(DoubleInputCell.handleDatePicker), for: UIControl.Event.valueChanged)
        
    }
    
    @objc func  handleDatePicker(){
        debugPrint("DAte Selected === \(datePicker.date)")
        self.delegate?.selectedDateForDoubleInput(date: datePicker.date,textfieldTag: self.isTfOne ? self.inputTf1.tag : self.inputTf2.tag, isDateField : self.isDateField)
        
    }
}
extension DoubleInputCell : UIPickerViewDelegate,UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return arrDropdown.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
       return Utility.getSelectedValue(arrDropdown: self.arrDropdown,row: row).value
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedValue = Utility.getSelectedValue(arrDropdown: self.arrDropdown,row: row)
        self.delegate?.selectedPickerValueForDoubleInput(value: selectedValue.value, valueID : selectedValue.valueID, textfieldTag: self.isTfOne ? self.inputTf1.tag : self.inputTf2.tag)
    }
    
    
    
}*/
