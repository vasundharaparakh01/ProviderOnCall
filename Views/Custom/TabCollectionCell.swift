//
//  TabCollectionCell.swift
//  WoundCarePros
//
//  Created by Vasundhara Parakh on 7/11/19.
//  Copyright © 2019 Ratnesh Swarnkar. All rights reserved.
//

import UIKit

class TabCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var btnTab : UIButton!
    
//    override var isSelected: Bool {
//        didSet {
//            self.btnTab.backgroundColor = isSelected ? UIColor.appRedColor() : UIColor.appLightGreyColor()
//            self.btnTab.titleColor = isSelected ? UIColor.white : UIColor.appDarkGreyColor()
//        }
//    }

    override func awakeFromNib() {
        super.awakeFromNib()
        btnTab.isHighlighted = false
        // Initialization code
        
    }

    
    @IBAction func btnTab_action(_ sender: Any) {
    }
    
}
