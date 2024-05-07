//
//  TitleDoubleInputCell.swift
//  AccessEMR
//
//  Created by Vasundhara Parakh on 3/16/20.
//  Copyright © 2020 smartData Enterprises (I) Ltd. All rights reserved.
//

import UIKit
protocol TitleDoubleInputCellDelegate {
    func selectedDateForDoubleInput(date : Date, textfieldTag : Int, isDateField : Bool)
    func selectedPickerValueForDoubleInput(value : Any, valueID : Any, textfieldTag : Int)

}

class TitleDoubleInputCell: UITableViewCell{
    var delegate: TitleDoubleInputCellDelegate?
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var inputTf1: InputTextField!
    @IBOutlet weak var inputTf2: InputTextField!
    var inputT1_type = ""
    var inputT2_type = ""
    var pickerView = UIPickerView()
    var arrDropdown1 = [Any]()
    var arrDropdown2 = [Any]()
    var datePicker = UIDatePicker()
    var isTfOne = false
    var isDateField = true

    override func awakeFromNib() {
        super.awakeFromNib()
        self.lblTitle.textColor = Color.DarkGray
        self.lblTitle.font = UIFont.PoppinsMedium(fontSize: 16)

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
            self.isTfOne = true
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
            self.isTfOne = false
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
        datePicker.addTarget(self, action: #selector(TitleDoubleInputCell.handleDatePicker), for: UIControl.Event.valueChanged)
        
    }
    
    @objc func  handleDatePicker(){
        debugPrint("DAte Selected === \(datePicker.date)")
        self.delegate?.selectedDateForDoubleInput(date: datePicker.date,textfieldTag: self.isTfOne ? self.inputTf1.tag : self.inputTf2.tag, isDateField : self.isDateField)
        
    }
}
extension TitleDoubleInputCell : UIPickerViewDelegate,UIPickerViewDataSource{
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
