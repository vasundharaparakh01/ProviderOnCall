//
//  SliderCell.swift
//  appName
//
//  Created by Vasundhara Parakh on 3/23/20.
//  Copyright © 2020 smartData Enterprises (I) Ltd. All rights reserved.
//

import UIKit
import StepSlider
class SliderCell: UITableViewCell {
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblValue: UILabel!
    @IBOutlet weak var lblMinRange: UILabel!
    @IBOutlet weak var lblMaxRange: UILabel!
    @IBOutlet weak var slider: StepSlider!

    override func awakeFromNib() {
        super.awakeFromNib()
        lblTitle.textColor = Color.Blue
        
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
        
        lblMinRange.font = Device.IS_IPAD ? UIFont.PoppinsRegular(fontSize: 17) : UIFont.PoppinsRegular(fontSize: 14)
        lblMinRange.textColor = Color.DarkGray
        
        lblMaxRange.font = Device.IS_IPAD ? UIFont.PoppinsRegular(fontSize: 17) : UIFont.PoppinsRegular(fontSize: 14)
        lblMaxRange.textColor = Color.DarkGray

        lblValue.font =  Device.IS_IPAD ? UIFont.PoppinsMedium(fontSize: 19 ) : UIFont.PoppinsMedium(fontSize: 17)

        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
