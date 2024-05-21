//
//  ADLTrackingViewController.swift
//  appName
//
//  Created by Vasundhara Parakh on 2/28/20.
//  Copyright © 2020 smartData Enterprises (I) Ltd. All rights reserved.
//

import UIKit
enum ADLItems : Int{
    static let Mobility = "Mobility"
    static let Transfer = "Transfer"
    static let Dressing = "Dressing"
    static let EatingAndDrinking = "Eating & Drinking"
    static let Toileting = "Toileting"
    static let PersonalHygeine = "Personal Hygeine"
    static let Bathing = "Bathing"
    static let Continence = "Continence"
    static let Notes = "Notes"

    case MobilityItem = 0
    case TransferItem
    case DressingItem
    case EatingAndDrinkingItem
    case ToiletingItem
    case PersonalHygeineItem
    case BathingItem
    case ContinenceItem
    case NotesItem
}

class ADLTrackingViewController: BaseViewController {

    @IBOutlet weak var residentCardView: ResidentCardView!
    @IBOutlet weak var tblView: UITableView!
    
    var patientHeaderInfo : PatientBasicHeaderInfo?
    
    var items = [ADLItems.Mobility,ADLItems.Transfer,ADLItems.Dressing,ADLItems.EatingAndDrinking,ADLItems.Toileting,ADLItems.PersonalHygeine,ADLItems.Bathing,ADLItems.Continence,ADLItems.Notes]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.title = NavigationTitle.ADLTracking
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

extension ADLTrackingViewController:UITableViewDataSource, UITableViewDelegate {
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ReuseIdentifier.ListTableViewCell, for: indexPath as IndexPath) as! ListTableViewCell
        cell.titleLbl.text = items[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        if indexPath.row < 5{
        let vc = ADLTrackingListViewController.instantiate(appStoryboard: Storyboard.PointOfCare) as! ADLTrackingListViewController
        if let basicInfo = self.patientHeaderInfo{
            vc.patientHeaderInfo = basicInfo
        }
        vc.pointOfCareItem = indexPath.row
        self.navigationController?.pushViewController(vc,animated:true)
        }

    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Device.IS_IPAD ? 60 : 50
    }
}
