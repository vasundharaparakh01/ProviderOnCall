//
//  ForgotPasswordViewModel.swift
//  AccessEMR
//
//  Created by Vasundhara Parakh on 2/26/20.
//  Copyright © 2020 smartData Enterprises (I) Ltd. All rights reserved.
//

import UIKit

class ForgotPasswordViewModel: BaseViewModel {
    // MARK: - Parameters
    private(set) var service:UserService

    // MARK: - Constructor
    init(with service:UserService) {
        self.service = service
    }
    
    // MARK: Validation Methods
    func isValidnew(emails:String)-> [(result: (type:ValidationType,message:String?),txtFieldType: TextfieldTypes)] {
        var arr = [(result: (type:ValidationType,message:String?),txtFieldType: TextfieldTypes)]()
        arr.append((self.validate(value: emails,type: InputTypes.username, errorMessage: AlertMessage.usernameInvalid, inValidMessage: AlertMessage.usernameInvalid),.email))
        return arr
    }

    func isValid(email: String?) -> (isValid: Bool, error: String?) {

        guard let email = email, !email.isEmpty else {
            return (false, InputTextfieldMessage.ErrorMessages.emailMissing)
        }

        return (true, nil)
    }
    // MARK: - Network calls
    func forgotPassword(with email: String?) {
        self.isLoading = true
        let validationTuple = isValid(email: email)
        guard validationTuple.isValid else {
            self.errorMessage = validationTuple.error
            return
        }
        service.forgotPassword(with: email ?? "") { (result) in
            self.isLoading = false
            self.alertMessage = (result as? String) ?? ""
        }
    }
}
