//
//  ListCell.swift
//  AccessEMR
//
//  Created by Vasundhara Parakh on 3/6/20.
//  Copyright © 2020 smartData Enterprises (I) Ltd. All rights reserved.
//

import UIKit

class ListCell: UITableViewCell {
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblValue: UILabel!
    @IBOutlet weak var lblSeperator: UILabel!
    @IBOutlet weak var lblDivider: UILabel!
    @IBOutlet weak var lblSeperatorTop: UILabel!
    @IBOutlet weak var lblDividerLeft: UILabel!
    @IBOutlet weak var lblDividerRight: UILabel!
    @IBOutlet weak var lblSingleTitle: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.lblSeperator.backgroundColor = Color.Line
        self.lblDivider.backgroundColor = Color.Line
        self.lblSeperatorTop.backgroundColor = Color.Line
        self.lblDividerLeft.backgroundColor = Color.Line
        self.lblDividerRight.backgroundColor = Color.Line

        self.lblSingleTitle.textColor = self.lblTitle.textColor
        self.lblSingleTitle.font = self.lblTitle.font
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
