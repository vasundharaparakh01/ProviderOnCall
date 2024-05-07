//
//  CellINputOutPut.swift
//  AccessEMR
//
//  Created by Sorabh Gupta on 12/17/20.
//  Copyright © 2020 smartData Enterprises (I) Ltd. All rights reserved.
//

import UIKit

class CellINputOutPut: UITableViewCell {
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblIntack: UILabel!
    @IBOutlet weak var lblML: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
