//
//  ESASListViewController.swift
//  AccessEMR
//
//  Created by Vasundhara Parakh on 3/24/20.
//  Copyright © 2020 smartData Enterprises (I) Ltd. All rights reserved.
//

import UIKit
enum ESASItems : Int{
    static let Rating = "Rating"
    static let Graph = "Graph"
    
    case RatingItem = 0
    case GraphItem

}
class ESASListViewController: BaseViewController {

    @IBOutlet weak var residentCardView: ResidentCardView!
    @IBOutlet weak var tblView: UITableView!
    
    var patientHeaderInfo : PatientBasicHeaderInfo?
    
    var items = [ESASItems.Rating,ESASItems.Graph]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.title = NavigationTitle.PointOfCareSections.ESAS
        self.addBackButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.initialSetup()
    }
    func initialSetup(){
        self.tblView.register(UINib(nibName: ReuseIdentifier.ListTableViewCell, bundle: nil), forCellReuseIdentifier: ReuseIdentifier.ListTableViewCell)

        //Update Resident Card View
        if let cardView = self.residentCardView{
            if let basicInfo = self.patientHeaderInfo{
                self.updateResidentCardView(cardView: cardView, residentInfo: basicInfo)
            }
        }
    }
}

extension ESASListViewController:UITableViewDataSource, UITableViewDelegate {
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ReuseIdentifier.ListTableViewCell, for: indexPath as IndexPath) as! ListTableViewCell
        cell.titleLbl.text = items[indexPath.row]
        cell.imgNext.isHidden = false
        cell.imgFill.isHidden = true
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        if indexPath.row == ESASItems.RatingItem.rawValue{
            let vc = ESASFormViewController.instantiate(appStoryboard: Storyboard.Forms) as! ESASFormViewController
            if let basicInfo = self.patientHeaderInfo{
                vc.patientHeaderInfo = basicInfo
            }
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc,animated:true)
        }else{
            let vc = ESASGraphViewController.instantiate(appStoryboard: Storyboard.Forms) as! ESASGraphViewController
            if let basicInfo = self.patientHeaderInfo{
                vc.patientHeaderInfo = basicInfo
            }
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc,animated:true)
        }
        
        /*
         let vc = NonSectionCarePlanViewController.instantiate(appStoryboard: Storyboard.CarePlan) as! NonSectionCarePlanViewController
         vc.pointOfCareItem = indexPath.row
         self.navigationController?.pushViewController(vc,animated:true)*/
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Device.IS_IPAD ? 60 : 50
    }
}

