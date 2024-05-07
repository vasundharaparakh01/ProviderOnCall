//
//  PointOfCareViewController.swift
//  AccessEMR
//
//  Created by Vasundhara Parakh on 2/28/20.
//  Copyright © 2020 smartData Enterprises (I) Ltd. All rights reserved.
//

import UIKit
enum PointOfCareItems {
    static let ADL = "ADL Tracking"
    static let Mood = "Mood & Behaviour Tracking"
    static let Nursing = "Nursing Care Flow Sheet"
    static let ESAS = "ESAS"
}

class PointOfCareViewController: BaseViewController {

    @IBOutlet weak var residentCardView: ResidentCardView!
    @IBOutlet weak var tblView: UITableView!
    
    var patientHeaderInfo : PatientBasicHeaderInfo?
    
    var items = [PointOfCareItems.ADL,PointOfCareItems.Mood,PointOfCareItems.Nursing,PointOfCareItems.ESAS]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.title = NavigationTitle.PointOfCare
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

extension PointOfCareViewController:UITableViewDataSource, UITableViewDelegate {
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ReuseIdentifier.ListTableViewCell, for: indexPath as IndexPath) as! ListTableViewCell
        cell.titleLbl.text = items[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        let item = items[indexPath.row]
        switch item {
        case PointOfCareItems.ADL:
            let vc = ADLTrackingViewController.instantiate(appStoryboard: Storyboard.PointOfCare) as! ADLTrackingViewController
            if let basicInfo = self.patientHeaderInfo{
                vc.patientHeaderInfo = basicInfo
            }
            self.navigationController?.pushViewController(vc,animated:true)
//        case PointOfCareItems.Mood:
//            let vc = MoodTrackingViewController.instantiate(appStoryboard: Storyboard.PointOfCare) as! MoodTrackingViewController
//            if let basicInfo = self.patientHeaderInfo{
//                vc.patientHeaderInfo = basicInfo
//            }
//            self.navigationController?.pushViewController(vc,animated:true)
//        case PointOfCareItems.Nursing:
//            let vc = NursingCareFlowViewController.instantiate(appStoryboard: Storyboard.PointOfCare) as! NursingCareFlowViewController
//            if let basicInfo = self.patientHeaderInfo{
//                vc.patientHeaderInfo = basicInfo
//            }
//            self.navigationController?.pushViewController(vc,animated:true)
//
        default:
            break
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Device.IS_IPAD ? 60 : 50
    }
}
