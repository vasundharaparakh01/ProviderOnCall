//
//  ForgotPasswordViewController.swift
//  AccessEMR
//
//  Created by Ratnesh Swarnkar on 2/26/20.
//  Copyright © 2020 smartData Enterprises (I) Ltd. All rights reserved.
//

import UIKit

class ForgotPasswordViewController: BaseViewController {
    
    @IBOutlet weak var emailTextField: InputTextField!
    
    lazy var viewModel: ForgotPasswordViewModel = {
        let obj = ForgotPasswordViewModel(with: UserService())
        self.baseViewModel = obj
        return obj
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.lineColor =  Color.Line
        emailTextField.errorMessage = ""
        // Do any additional setup after loading the view.
    }
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func submitAction(_ sender: UIButton) {
        let arr = viewModel.isValidnew(emails: self.emailTextField.text ?? "")
        
        for value in arr{
            //Validate textfields
            switch value.txtFieldType {
            case .email:
                emailTextField.validate = value.result
            default:
                break
            }
        }
        if arr.filter({$0.result.type == .valid}).count == 1{
            self.viewModel.forgotPassword(with: self.emailTextField.text ?? "")
        }
    }

}

extension ForgotPasswordViewController : UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if let tfToUpdate = textField as? InputTextField{
            tfToUpdate.lineColor =  Color.Line
            tfToUpdate.errorMessage = ""
        }
        
    }
}
