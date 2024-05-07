//
//  RecursiveSingleInputCell.swift
//  AccessEMR
//
//  Created by Vasundhara Parakh on 5/25/20.
//  Copyright © 2020 smartData Enterprises (I) Ltd. All rights reserved.
//

import UIKit
protocol RecursiveSingleInputCellDelegate {
    func selectedDateForRecursiveInput(date : Date, textfieldTag : Int, isDateField : Bool)
    func selectedPickerValueForRecursiveInput(value : Any, valueID : Any, textfieldTag : Int)

}

class RecursiveSingleInputCell: UITableViewCell {
    var delegate: RecursiveSingleInputCellDelegate?

    @IBOutlet weak var inputTf: InputTextField!
    
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var btnAdd: UIButton!
    
    var pickerView = UIPickerView()
    var arrDropdown = [Any]()
    
    var datePicker = UIDatePicker()
    var isDateField = true

    var inputType = ""
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        switch inputType {
        case InputType.Text:
            inputTf.inputView = nil
            inputTf.keyboardType = .default
        case InputType.Number:
            inputTf.inputView = nil
            inputTf.keyboardType = .numberPad
        case InputType.Date,InputType.Time:
            inputTf.inputView = nil
            self.datePicker.tag = inputTf.tag
            inputTf.inputView = self.datePicker
            self.setupDatePicker()
        case InputType.Dropdown:
            inputTf.inputView = self.pickerView
            self.pickerView.tag = inputTf.tag
            self.pickerView.backgroundColor = UIColor.white
            self.pickerView.delegate = self
            self.pickerView.dataSource = self
        case InputType.Decimal:
            inputTf.inputView = nil
            inputTf.keyboardType = .decimalPad
        default:
            inputTf.inputView = nil
            inputTf.keyboardType = .default
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupDatePicker(){
        datePicker.datePickerMode = self.isDateField ? UIDatePicker.Mode.date : UIDatePicker.Mode.time
        datePicker.addTarget(self, action: #selector(RecursiveBPCell.handleDatePicker), for: UIControl.Event.valueChanged)
        
    }
    
    @objc func  handleDatePicker(){

        self.delegate?.selectedDateForRecursiveInput(date: datePicker.date, textfieldTag: self.datePicker.tag , isDateField : self.isDateField)
        //self.delegate?.select(date: datePicker.date,textfieldTag: self.isTfOne ? self.inputTf1.tag : self.inputTf2.tag)
        
    }

}
extension RecursiveSingleInputCell : UIPickerViewDelegate,UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return arrDropdown.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
       return Utility.getSelectedValue(arrDropdown: arrDropdown,row: row).value
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {

        let selectedValue = Utility.getSelectedValue(arrDropdown: arrDropdown,row: row)
        self.delegate?.selectedPickerValueForRecursiveInput(value: selectedValue.value, valueID: selectedValue.valueID, textfieldTag: self.pickerView.tag)

    }
    
    
}
