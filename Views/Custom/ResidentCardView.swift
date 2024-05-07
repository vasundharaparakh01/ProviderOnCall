//
//  ResidentCardView.swift
//  AccessEMR
//
//  Created by Vasundhara Parakh on 2/25/20.
//  Copyright © 2020 smartData Enterprises (I) Ltd. All rights reserved.
//

import UIKit

class ResidentCardView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var residentProfileImageView: UIImageView!
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var patientIdLbl: UILabel!
    @IBOutlet weak var genderLbl: UILabel!
    @IBOutlet weak var ageLbl: UILabel!
    @IBOutlet weak var phcLbl: UILabel!
    @IBOutlet weak var roomNoLbl: UILabel!
    @IBOutlet weak var roomTitleLbl: UILabel!

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.commonInit()
    }
    
    func commonInit() {
        Bundle.main.loadNibNamed("ResidentCardView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.residentProfileImageView.roundedCorner()
        self.backgroundColor = .white
        
        self.roomTitleLbl.text = (UserDefaults.getOrganisationType() == OrganisationType.HomeCare || UserDefaults.getOrganisationType() == OrganisationType.Clinic) ? "Address :" : "Room :"
        
        residentProfileImageView.addFullScreenView()
        
    }
    
}
