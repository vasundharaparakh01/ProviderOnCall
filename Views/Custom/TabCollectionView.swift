//
//  TabCollectionView.swift
//  WoundCarePros
//
//  Created by Vasundhara Parakh on 7/9/19.
//  Copyright © 2019 Ratnesh Swarnkar. All rights reserved.
//

import UIKit
protocol TabCollectionViewDelegate {
    func didSelectTabAtIndex(row : Int)
}

@IBDesignable class TabCollectionView: UIView, NibLoadable{
    var delegate: TabCollectionViewDelegate?

    @IBOutlet weak var tabCollection: UICollectionView!
    
    var dataSourceArray = [String]()
    var colorArray = [UIColor]()
    var view = UIView()
    var selectedTabIndex = 0
    var isAppointmentTab = false
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        setupFromNib()

    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupFromNib()

        // fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let nibName = UINib(nibName: "TabCollectionCell", bundle:nil)
        self.tabCollection.register(nibName, forCellWithReuseIdentifier: ReuseIdentifier.TabCollectionCell)

    }

}
//MARK:- UICollectionViewDelegate & UICollectionViewDataSource
extension TabCollectionView : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataSourceArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReuseIdentifier.TabCollectionCell, for: indexPath) as! TabCollectionCell
        

        cell.btnTab.tag = indexPath.row
            //debugPrint("Selected Index === Tab == \(self.selectedTabIndex)")
        //cell.isSelected = (indexPath.row == selectedTabIndex)
        //cell.btnTab.setTitle(self.dataSourceArray[indexPath.row], for: .normal)
        cell.btnTab.backgroundColor = self.colorArray[indexPath.row]
        cell.btnTab.setTitleColor(UIColor.white, for: .normal)

        UIView.performWithoutAnimation {

            cell.btnTab.setTitle(self.dataSourceArray[indexPath.row], for: .normal)
            cell.btnTab.setTitle(self.dataSourceArray[indexPath.row], for: .highlighted)
            cell.btnTab.setTitle(self.dataSourceArray[indexPath.row], for: .selected)

        }
            cell.btnTab.addTarget(self, action: #selector(self.btnTab_Action(_:)), for: .touchUpInside)
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
         
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return  CGSize(width: collectionView.frame.size.width/4 - 10, height: 40)
    }
    
    @IBAction func btnTab_Action(_ sender: UIButton) {
        selectedTabIndex = sender.tag
        UIView.performWithoutAnimation {
            self.tabCollection.reloadData()
        }
        self.delegate?.didSelectTabAtIndex(row: selectedTabIndex)
    }

    
}
