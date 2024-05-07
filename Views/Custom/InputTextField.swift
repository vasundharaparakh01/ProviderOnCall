//
//  InputTextField.swift
//  AccessEMR
//
//  Created by Vasundhara Parakh on 2/25/20.
//  Copyright © 2020 smartData Enterprises (I) Ltd. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class InputTextField: SkyFloatingLabelTextField {
    
    var message: String?
    var validate: (type: ValidationType?,message: String? ){
        didSet{
            switch validate.type {
            case .defaultType, .none:
                self.borderColor = Color.Line
                self.rightView?.isHidden = true
            case .valid:
                self.lineColor = Color.Line
                self.rightView?.isHidden = true
            case .invalid:
                self.lineColor = .red
                self.rightView?.isHidden = false
                self.message = validate.message
                self.errorMessage = validate.message
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
         self.setup()
    }
    func setup()  {
        
         self.tintColor = Color.DarkGray//Color.LightGray // the color of the blinking cursor
         
         self.textColor = Color.Blue
        self.placeholderFont = Device.IS_IPAD ? Font.Regular.of(size: 18) : Font.Regular.of(size: 16)
        self.font = Device.IS_IPAD ? Font.Regular.of(size: 18) : Font.Regular.of(size: 16)

         // title
        self.titleFont  = Device.IS_IPAD ? Font.Medium.of(size: 16) : Font.Medium.of(size: 14)
         self.titleColor = Color.DarkGray//Color.LightGray
         self.selectedTitleColor = Color.DarkGray//Color.LightGray
        
         // Line
         self.lineColor = Color.Line
         self.selectedLineColor = Color.Line
         
         self.lineHeight = 1.0
         self.errorMessage = ""
         self.titleFormatter = { $0 } // Remove upprecase
    }
}
