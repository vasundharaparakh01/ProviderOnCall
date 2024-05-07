//
//  FontExtension.swift
//  WoundCarePros
//
//  Created by Vasundhara Parakh on 7/1/19.
//  Copyright © 2019 Ratnesh Swarnkar. All rights reserved.
//

import UIKit

@objc extension UIFont {
    
    //MARK:- Poppins SemiBold
    class func PoppinsSemiBold(fontSize : CGFloat) -> UIFont{
        return UIFont(name: "Poppins-SemiBold", size: fontSize)!
    }
    //MARK:- Poppins Regular
    class func PoppinsRegular(fontSize : CGFloat) -> UIFont{
        return UIFont(name: "Poppins-Regular", size: fontSize)!
    }
    //MARK:- Poppins Medium
    class func PoppinsMedium(fontSize : CGFloat) -> UIFont{
        return UIFont(name: "Poppins-Medium", size: fontSize)!
    }
    //MARK:- Poppins Italics
    class func PoppinsItalic(fontSize : CGFloat) -> UIFont{
        return UIFont(name: "Poppins-Italic", size: fontSize)!
    }

}
