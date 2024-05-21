//
//  CustomAlertView.swift
//  appName
//
//  Created by Vasundhara Parakh on 4/7/20.
//  Copyright © 2020 smartData Enterprises (I) Ltd. All rights reserved.
//

import UIKit
protocol CustomAlertViewDelegate {
    func btnLeft_Action(forView : CustomAlertView)
    func btnRight_Action(forView : CustomAlertView)
}

class CustomAlertView:UIView {

    var delegate: CustomAlertViewDelegate?
    
    @IBOutlet weak var btnCrosh: UIButton!
    @IBOutlet weak var btnLeft: UIButton!
    @IBOutlet weak var btnRight: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSubtitle: UILabel!
    
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        // fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initialSetup()
        
    }
    
    //MARK:---IBActions-----
    @IBAction func btnRight_action(_ sender: Any) {
        self.delegate?.btnRight_Action(forView: self)
    }
    @IBAction func btnLeft_Action(_ sender: Any) {
        self.delegate?.btnLeft_Action(forView: self)
    }
    @IBAction func btnCrosAction(_ sender: Any) {
       // self.dismiss(animated: true, completion: nil)
    }

    //MARK:---Functions-----
    func initialSetup(){
        self.lblSubtitle.numberOfLines = 0
        self.lblSubtitle.textAlignment = .center
        self.lblSubtitle.lineBreakMode = .byWordWrapping
        
        self.backgroundColor = Color.transparentBackground
        self.lblTitle.text = Alert.Title.appName
        
        //self.btnLogout.titleLabel?.font = UIFont.PoppinsSemiBold(fontSize: 14.0)
        //self.btnCancel.titleLabel?.font = UIFont.PoppinsSemiBold(fontSize: 14.0)

    }
    
   
}
