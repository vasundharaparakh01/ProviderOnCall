//
//  CarePlanViewController.swift
//  AccessEMR
//
//  Created by Vasundhara Parakh on 2/28/20.
//  Copyright © 2020 smartData Enterprises (I) Ltd. All rights reserved.
//

import UIKit
enum CarePlanItems : Int {
    static let Communication = "Communication"
    static let Routine = "Routine"
    static let ConginitiveStatus = "Conginitive Status"
    static let Behaviours = "Behaviours"
    static let Safety = "Safety"
    static let Nutrition = "Nutrition & Hydration"
    static let Bathing = "Bathing"
    static let Dressing = "Dressing"
    static let Hygiene = "Hygiene"
    static let Skin = "Skin"
    static let Mobility = "Mobility"
    static let Transfer = "Transfer"
    static let Toileting = "Toileting"
    static let BladderContinenece = "Bladder Continenece"
    static let BowelContinenece = "Bowel Continenece"
    
    case CommunicationItem = 0
    case RoutineItem
    case ConginitiveStatusItem
    case BehavioursItem
    case SafetyItem
    case NutritionItem
    case BathingItem
    case DressingItem
    case HygieneItem
    case SkinItem
    case MobilityItem
    case TransferItem
    case ToiletingItem
    case BladderContineneceItem
    case BowelContineneceItem
    
}

class CarePlanViewController: BaseViewController {

    @IBOutlet weak var residentCardView: ResidentCardView!
    @IBOutlet weak var tblView: UITableView!
    
    var patientHeaderInfo : PatientBasicHeaderInfo?
    
    var items = [CarePlanItems.Communication,CarePlanItems.Routine,CarePlanItems.ConginitiveStatus,CarePlanItems.Behaviours,CarePlanItems.Safety,CarePlanItems.Nutrition,CarePlanItems.Bathing,CarePlanItems.Dressing,CarePlanItems.Hygiene,CarePlanItems.Skin,CarePlanItems.Mobility,CarePlanItems.Transfer,CarePlanItems.Toileting,CarePlanItems.BladderContinenece,CarePlanItems.BowelContinenece]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.title = NavigationTitle.CarePlan
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

extension CarePlanViewController:UITableViewDataSource, UITableViewDelegate {
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ReuseIdentifier.ListTableViewCell, for: indexPath as IndexPath) as! ListTableViewCell
        cell.titleLbl.text = items[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case CarePlanItems.CommunicationItem.rawValue,CarePlanItems.RoutineItem.rawValue:
            let vc = SectionCarePlanViewController.instantiate(appStoryboard: Storyboard.CarePlan) as! SectionCarePlanViewController
            if let basicInfo = self.patientHeaderInfo{
                vc.patientHeaderInfo = basicInfo
            }
            vc.carePlanItem = indexPath.row
            self.navigationController?.pushViewController(vc,animated:true)
        default:
            let vc = NonSectionCarePlanViewController.instantiate(appStoryboard: Storyboard.CarePlan) as! NonSectionCarePlanViewController
            if let basicInfo = self.patientHeaderInfo{
                vc.patientHeaderInfo = basicInfo
            }
            vc.carePlanItem = indexPath.row
            self.navigationController?.pushViewController(vc,animated:true)
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Device.IS_IPAD ? 60 : 50
    }
}
