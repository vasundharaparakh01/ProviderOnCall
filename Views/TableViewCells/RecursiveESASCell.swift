//
//  RecursiveESASCell.swift
//  AccessEMR
//
//  Created by Vasundhara Parakh on 3/24/20.
//  Copyright © 2020 smartData Enterprises (I) Ltd. All rights reserved.
//

import UIKit
import StepSlider
class RecursiveESASCell: UITableViewCell {
    @IBOutlet weak var slider: StepSlider!
    @IBOutlet weak var inputTf1: InputTextField!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var lblSliderValue: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.slider.maxCount = 10
        slider.labelFont = UIFont.PoppinsRegular(fontSize: 14)
        slider.labelColor = Color.DarkGray
        slider.adjustLabel = true
        slider.trackHeight = 1.0
        slider.sliderCircleColor = Color.Blue
        slider.tintColor = Color.Blue
        slider.trackColor = Color.LightGray
        slider.trackCircleRadius = 5.0
        slider.sliderCircleRadius = 10.0
        slider.isDotsInteractionEnabled = true
        slider.labels = ["","","","","","","","","","",""]

        lblSliderValue.font =  Device.IS_IPAD ? UIFont.PoppinsMedium(fontSize: 19) : UIFont.PoppinsMedium(fontSize: 17)
        lblSliderValue.textColor = Color.DarkGray
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
