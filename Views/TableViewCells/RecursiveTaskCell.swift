//
//  RecursiveTaskCell.swift
//  appName
//
//  Created by Vasundhara Parakh on 4/24/20.
//  Copyright © 2020 smartData Enterprises (I) Ltd. All rights reserved.
//

import UIKit
protocol RecursiveTaskCellDelegate {
    func selectedDateForRecursiveInput(date : Date, textfieldTag : Int, isDateField : Bool)
    func selectedPickerValueForRecursiveInput(value : Any, valueID : Any, textfieldTag : Int)

}

class RecursiveTaskCell: UITableViewCell {
    var delegate: RecursiveTaskCellDelegate?
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var inputTf1: InputTextField!
    @IBOutlet weak var inputTf2: InputTextField!
    @IBOutlet weak var inputTf3: InputTextField!
    
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var btnAdd: UIButton!
    
    @IBOutlet weak var heightInputTf3: NSLayoutConstraint!
    
    var inputT1_type = ""
    var inputT2_type = ""
    var inputT3_type = ""
    
    var pickerView = UIPickerView()
    var arrDropdown1 = [Any]()
    var arrDropdown2 = [Any]()
    var arrDropdown3 = [Any]()
    
    var datePicker = UIDatePicker()
    var isDateField1 = true
    var isDateField2 = true
    var isDateField3 = true
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        switch inputT1_type {
        case InputType.Text:
            inputTf1.inputView = nil
            inputTf1.keyboardType = .default
        case InputType.Number:
            inputTf1.inputView = nil
            inputTf1.keyboardType = .numberPad
        case InputType.Date,InputType.Time:
            inputTf1.inputView = nil
            self.datePicker.tag = inputTf1.tag
            inputTf1.inputView = self.datePicker
            self.setupDatePicker()
        case InputType.Dropdown:
            inputTf1.inputView = self.pickerView
            self.pickerView.tag = inputTf1.tag
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
        case InputType.Date,InputType.Time:
            inputTf2.inputView = nil
            self.datePicker.tag = inputTf2.tag
            inputTf2.inputView = self.datePicker
            self.setupDatePicker()
        case InputType.Dropdown:
            
            inputTf2.inputView = self.pickerView
            self.pickerView.tag = inputTf2.tag
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
        
        switch inputT3_type {
        case InputType.Text:
            inputTf3.inputView = nil
            inputTf3.keyboardType = .default
        case InputType.Number:
            inputTf3.inputView = nil
            inputTf3.keyboardType = .numberPad
        case InputType.Date,InputType.Time:
            inputTf3.inputView = nil
            self.datePicker.tag = inputTf3.tag
            inputTf3.inputView = self.datePicker
            self.setupDatePicker()
        case InputType.Dropdown:
            inputTf3.inputView = self.pickerView
            self.pickerView.tag = inputTf3.tag
            self.pickerView.backgroundColor = UIColor.white
            self.pickerView.delegate = self
            self.pickerView.dataSource = self
        case InputType.Decimal:
            inputTf3.inputView = nil
            inputTf3.keyboardType = .decimalPad
        default:
            inputTf3.inputView = nil
            return inputTf3.keyboardType = .default
        }
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setupDatePicker(){
        var shouldShowDate = true
        let dictIndex = self.getIndexForMultipleTf(textFieldTag: AppInstance.shared.activeTextfieldIndex)
        switch dictIndex {
        case 0:
            shouldShowDate = self.isDateField1
        case 1:
            shouldShowDate = self.isDateField2
        case 2:
            shouldShowDate = self.isDateField3
        default:
            shouldShowDate = true
        }
        datePicker.datePickerMode = shouldShowDate ? UIDatePicker.Mode.date : UIDatePicker.Mode.time
        datePicker.addTarget(self, action: #selector(RecursiveBPCell.handleDatePicker), for: UIControl.Event.valueChanged)
        
    }
    
    @objc func  handleDatePicker(){
        var shouldShowDate = true
        let dictIndex = self.getIndexForMultipleTf(textFieldTag: AppInstance.shared.activeTextfieldIndex)
        switch dictIndex {
        case 0:
            shouldShowDate = self.isDateField1
        case 1:
            shouldShowDate = self.isDateField2
        case 2:
            shouldShowDate = self.isDateField3
        default:
            shouldShowDate = true
        }
        debugPrint("DAte Selected === \(datePicker.date)")
        self.delegate?.selectedDateForRecursiveInput(date: datePicker.date, textfieldTag: self.datePicker.tag , isDateField : shouldShowDate)
        //self.delegate?.select(date: datePicker.date,textfieldTag: self.isTfOne ? self.inputTf1.tag : self.inputTf2.tag)
        
    }
}
extension RecursiveTaskCell : UIPickerViewDelegate,UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        var arrDropdown = arrDropdown1
        let dictIndex = self.getIndexForMultipleTf(textFieldTag: AppInstance.shared.activeTextfieldIndex)
        switch dictIndex {
        case 0:
            arrDropdown = arrDropdown1
        case 1:
            arrDropdown = arrDropdown2
        case 2:
            arrDropdown = arrDropdown3
        default:
            arrDropdown = [Any]()
        }
        return arrDropdown.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        var arrDropdown = arrDropdown1
        let dictIndex = self.getIndexForMultipleTf(textFieldTag: AppInstance.shared.activeTextfieldIndex)
        switch dictIndex {
        case 0:
            arrDropdown = arrDropdown1
        case 1:
            arrDropdown = arrDropdown2
        case 2:
            arrDropdown = arrDropdown3
        default:
            arrDropdown = [Any]()
        }

       return Utility.getSelectedValue(arrDropdown: arrDropdown,row: row).value
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        var arrDropdown = arrDropdown1
        let dictIndex = self.getIndexForMultipleTf(textFieldTag: AppInstance.shared.activeTextfieldIndex)
        switch dictIndex {
        case 0:
            arrDropdown = arrDropdown1
        case 1:
            arrDropdown = arrDropdown2
        case 2:
            arrDropdown = arrDropdown3
        default:
            arrDropdown = [Any]()
        }

        let selectedValue = Utility.getSelectedValue(arrDropdown: arrDropdown,row: row)
        self.delegate?.selectedPickerValueForRecursiveInput(value: selectedValue.value, valueID: selectedValue.valueID, textfieldTag: self.pickerView.tag)

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
            
                if  isFirstTf{
                    dictIndex = 0
                }else if isSecondTf {
                    dictIndex = 1
                }else{
                    dictIndex = 2
                }
            }
            return dictIndex
        }
    
}
