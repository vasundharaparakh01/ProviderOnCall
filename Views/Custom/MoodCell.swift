//
//  MoodCell.swift
//  AccessEMR
//
//  Created by Vasundhara Parakh on 3/12/20.
//  Copyright © 2020 smartData Enterprises (I) Ltd. All rights reserved.
//

import UIKit

class MoodCell: UITableViewCell {
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblValue: UILabel!
    @IBOutlet weak var borderView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.lblTitle.font = UIFont.PoppinsMedium(fontSize: 15)
        self.lblValue.font = UIFont.PoppinsRegular(fontSize: 15)

        self.lblTitle.textColor = Color.Blue
        self.lblValue.textColor = Color.DarkGray
        
        self.borderView.borderColor = Color.Line
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
