//
//  DateTimeInputCell.swift
//  appName
//
//  Created by Vasundhara Parakh on 2/19/20.
//  Copyright © 2020 smartData Enterprises (I) Ltd. All rights reserved.
//

import UIKit
protocol DateTimeInputCellDelegate {
    func selectedDateForInput(date : Date, textfieldTag : Int, isDateField : Bool)
}

class DateTimeInputCell: UITableViewCell {
    var delegate: DateTimeInputCellDelegate?

    @IBOutlet weak var inputTf: InputTextField!
    var datePicker = UIDatePicker()
    var isDateField = true
    override func awakeFromNib() {
        super.awakeFromNib()
        inputTf.inputView = self.datePicker
        self.setupDatePicker()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupDatePicker(){
        datePicker.datePickerMode = self.isDateField ? UIDatePicker.Mode.date : UIDatePicker.Mode.time
        datePicker.addTarget(self, action: #selector(DateTimeInputCell.handleDatePicker), for: UIControl.Event.valueChanged)
    }
    
    @objc func  handleDatePicker(){
           debugPrint("Date Selected === \(datePicker.date)")
        self.delegate?.selectedDateForInput(date: datePicker.date,textfieldTag: self.tag,isDateField: self.isDateField)
    }
}
