//
//  Extension+UIAlertController.swift
//  AccessEMR
//
//  Created by Vasundhara Parakh on 2/25/20.
//  Copyright © 2020 smartData Enterprises (I) Ltd. All rights reserved.
//

import UIKit

public typealias BlankBlock = ()-> Void

open class AlertButton: Any{
    fileprivate(set) var style = UIAlertAction.Style.default
    fileprivate(set) var title = Alert.ButtonTitle.ok
    fileprivate(set) var buttonAction: BlankBlock? = nil
    
    init(style: UIAlertAction.Style = .default, title: String = Alert.ButtonTitle.ok, buttonAction: BlankBlock? = nil) {
        self.style = style
        self.title = title
        self.buttonAction = buttonAction
    }
}

extension UIAlertController{
    
    public typealias ButtonAction = (_ clickedIndex: Int)-> Void
    
    func showOkAlert(type: UIAlertAction.Style = .default,title: String? = Alert.Title.appName, message: String?, animatedly: Bool = true,presntationCompletionHandler: BlankBlock? = nil, buttonActions: ButtonAction? = nil)-> UIAlertController{
        return alertWithActions(type: type, title: title, message: message, buttonTitles: [Alert.ButtonTitle.ok], animatedly: animatedly, presntationCompletionHandler: presntationCompletionHandler, buttonActions: buttonActions)
    }
    
    func showOkAlertWithPop(type: UIAlertAction.Style = .default,title: String? = Alert.Title.appName, message: String?, animatedly: Bool = true,presntationCompletionHandler: BlankBlock? = nil, buttonActions: ButtonAction? = nil)-> UIAlertController{
        return self.alertWithActions(type: type, title: title, message: message, buttonTitles: [Alert.ButtonTitle.ok], animatedly: animatedly, presntationCompletionHandler: presntationCompletionHandler, buttonActions: { (index) in
            switch index{
            case 0:
                UIApplication.topViewController()?.navigationController?.popViewController(animated: true)
            default:
                break
            }
        })
    }
    
    func alertWithActions(type: UIAlertAction.Style = .default,title: String? = Alert.Title.appName, message: String?, buttonTitles:[String], animatedly: Bool = true,presntationCompletionHandler: BlankBlock? = nil, buttonActions: ButtonAction? = nil)-> UIAlertController{
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        var alertButtons = [AlertButton]()
        for title in buttonTitles{
            alertButtons.append(AlertButton(style: type, title: title))
        }
        for (index,button) in alertButtons.enumerated(){
            let alertAction = UIAlertAction(title: button.title, style: button.style) { (action) in
                if let actions = buttonActions{
                    actions(index)
                }
                
            }
            alert.addAction(alertAction)
        }
        DispatchQueue.main.async {
            UIApplication.topViewController()?.present(alert, animated: animatedly, completion: presntationCompletionHandler)
        }
        return alert
    }
}
