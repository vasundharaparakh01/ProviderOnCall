//
//  LogoutView.swift
//  WoundCarePros
//
//  Created by Vasundhara Parakh on 7/19/19.
//  Copyright © 2019 Ratnesh Swarnkar. All rights reserved.
//

import UIKit
protocol LogoutViewDelegate {
    func cancelLogout()
    func logout()
}

class LogoutView: UIView {

    var delegate: LogoutViewDelegate?
    
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnLogout: UIButton!
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
    @IBAction func btnLogout_action(_ sender: Any) {
        self.delegate?.logout()
    }
    @IBAction func btnCancel_Action(_ sender: Any) {
        self.delegate?.cancelLogout()
    }

    //MARK:---Functions-----
    func initialSetup(){
        self.lblSubtitle.numberOfLines = 0
        self.lblSubtitle.textAlignment = .center
        self.lblSubtitle.lineBreakMode = .byWordWrapping
        
        self.backgroundColor = Color.transparentBackground
        self.lblTitle.text = Alert.Title.appName
        self.lblSubtitle.text = Alert.Message.logout
        self.btnCancel.setTitle(Alert.ButtonTitle.cancel, for: .normal)
        self.btnLogout.setTitle(Alert.ButtonTitle.logout, for: .normal)
        
        //self.btnLogout.titleLabel?.font = UIFont.PoppinsSemiBold(fontSize: 14.0)
        //self.btnCancel.titleLabel?.font = UIFont.PoppinsSemiBold(fontSize: 14.0)

    }
    
   
}
