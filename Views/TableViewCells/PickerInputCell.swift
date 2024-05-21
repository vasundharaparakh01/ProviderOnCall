//
//  PickerInputCell.swift
//  appName
//
//  Created by Vasundhara Parakh on 2/19/20.
//  Copyright © 2020 smartData Enterprises (I) Ltd. All rights reserved.
//

import UIKit
protocol PickerInputCellDelegate {
    func selectedPickerValueForInput(value : Any, valueID : Any, textfieldTag : Int)
}


class PickerInputCell: UITableViewCell {
    var delegate: PickerInputCellDelegate?

    @IBOutlet weak var inputTf: InputTextField!
    var pickerView = UIPickerView()
    var arrDropdown = [Any]()
    override func awakeFromNib() {
        super.awakeFromNib()
        inputTf.rightView = UIImageView(image: UIImage.dropdownTextfieldRightImage())
        inputTf.inputView = self.pickerView
        
        self.pickerView.backgroundColor = UIColor.white
        self.pickerView.delegate = self
        self.pickerView.dataSource = self

        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
extension PickerInputCell : UIPickerViewDelegate,UIPickerViewDataSource{
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
        self.delegate?.selectedPickerValueForInput(value: selectedValue.value, valueID : selectedValue.valueID, textfieldTag: self.inputTf.tag)
    }
    
    
    
}
