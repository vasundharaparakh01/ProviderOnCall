//
//  Validator.swift
//  AccessEMR
//
//  Created by Vasundhara Parakh on 2/25/20.
//  Copyright © 2020 smartData Enterprises (I) Ltd. All rights reserved.
//

import Foundation

enum Validator {
   
    case email(_ value:String)
    case phone(_ value:String)
   
    var validate:Bool {
        
        switch self {
        
        case .email(let value):
            let stricterFilterString : String = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
            let emailTest : NSPredicate = NSPredicate(format: "SELF MATCHES %@", stricterFilterString)
            return emailTest.evaluate(with: value)
            
        case .phone(let value):
            let stricterFilterString : String = "^\\d{3}-\\d{3}-\\d{4}$"
            let emailTest : NSPredicate = NSPredicate(format: "SELF MATCHES %@", stricterFilterString)
            return emailTest.evaluate(with: value)        
        }
        
    }
}
