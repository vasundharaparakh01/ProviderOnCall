//
//  ActionButton.swift
//  appName
//
//  Created by Vasundhara Parakh on 2/25/20.
//  Copyright © 2020 smartData Enterprises (I) Ltd. All rights reserved.
//

import UIKit

class ActionButton: UIButton {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    override func draw(_ rect: CGRect) {
        // Drawing code
        clipsToBounds = true
        layer.masksToBounds = true
        layer.cornerRadius = frame.height/2
        //layer.borderWidth = 1
//        layer.borderColor = UIColor(red: 23.0/255.0, green: 230.0/255.0, blue: 209.0/255.0, alpha: 1.0).cgColor
//        titleLabel?.font = UIFont(name: "Lato-Regular", size: 12)
//        setTitleColor(UIColor.init(red: 31.0/255.0, green: 31.0/255.0, blue: 33.0/255.0, alpha: 1.0), for: .normal)

    }
}
