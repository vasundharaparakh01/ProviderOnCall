//
//  NumberInputCell.swift
//  AccessEMR
//
//  Created by Vasundhara Parakh on 2/19/20.
//  Copyright © 2020 smartData Enterprises (I) Ltd. All rights reserved.
//

import UIKit

class NumberInputCell: UITableViewCell {
    @IBOutlet weak var inputTf: InputTextField!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}