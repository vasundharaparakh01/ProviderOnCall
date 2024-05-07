//
//  TextViewInputCell.swift
//  AccessEMR
//
//  Created by Vasundhara Parakh on 5/25/20.
//  Copyright © 2020 smartData Enterprises (I) Ltd. All rights reserved.
//

import UIKit
import UIFloatLabelTextView
class TextViewInputCell: UITableViewCell {
    @IBOutlet weak var inputTextView: UIFloatLabelTextView!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.inputTextView.tintColor = Color.Blue
        self.inputTextView.textColor = Color.Blue
        self.inputTextView.floatLabelActiveColor = Color.DarkGray;
        self.inputTextView.floatLabelPassiveColor = Color.DarkGray;
        self.inputTextView.textAlignment = .left;
        self.inputTextView.layer.borderColor = Color.Line.cgColor
        self.inputTextView.floatLabelFont = Device.IS_IPAD ? UIFont.PoppinsMedium(fontSize: 16) : UIFont.PoppinsMedium(fontSize: 14)
        self.inputTextView.font = Device.IS_IPAD ? UIFont.PoppinsRegular(fontSize: 18) : UIFont.PoppinsRegular(fontSize: 16)
        self.inputTextView.floatLabel.font = Device.IS_IPAD ? UIFont.PoppinsMedium(fontSize: 16) : UIFont.PoppinsMedium(fontSize: 14)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
