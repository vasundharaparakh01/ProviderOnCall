//
//  CellTrendGraph.swift
//  AccessEMR
//
//  Created by Sorabh Gupta on 12/21/20.
//  Copyright © 2020 smartData Enterprises (I) Ltd. All rights reserved.
//

import UIKit
import Charts

class CellTrendGraph: UITableViewCell {
    @IBOutlet weak var graphView: LMLineGraphView!
    @IBOutlet weak var lineChartView: LineChartView!
    @IBOutlet weak var lblGraphTitle: UILabel!
    @IBOutlet weak var lblBottemTitle: UILabel!
    @IBOutlet weak var lblPercentTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.lblPercentTitle.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2)
    }

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
