//
//  TNCDetailPopup.swift
//  appName
//
//  Created by Vasundhara Parakh on 6/5/20.
//  Copyright © 2020 smartData Enterprises (I) Ltd. All rights reserved.
//

import UIKit
protocol TNCDetailPopupDelegate {
    func btnLeft_Action(forView : TNCDetailPopup)
    func btnRight_Action(forView : TNCDetailPopup)
    func btnClose_Action(forView : TNCDetailPopup)

}

class TNCDetailPopup:UIView {

    var delegate: TNCDetailPopupDelegate?
    
    @IBOutlet weak var btnLeft: UIButton!
    @IBOutlet weak var btnRight: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSubtitle: UILabel!
    @IBOutlet weak var btnTnc: UIButton!
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var lblTNC: UILabel!
    @IBOutlet weak var textviewDetail: UITextView!

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
    @IBAction func btnClose_Action(_ sender: Any) {
        self.delegate?.btnClose_Action(forView: self)
    }

    //MARK:---Functions-----
    func initialSetup(){
        self.lblSubtitle.numberOfLines = 0
        self.lblSubtitle.textAlignment = .center
        self.lblSubtitle.lineBreakMode = .byWordWrapping
        self.backgroundColor = Color.transparentBackground
        self.lblTitle.text = Alert.Title.tnc
    }
}
