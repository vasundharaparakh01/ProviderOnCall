//
//  NonSectionCarePlanViewController.swift

//
//  Created by Vasundhara Parakh on 3/11/20.
//  Copyright © 2020 smartData Enterprises (I) Ltd. All rights reserved.
//

import UIKit

class NonSectionCarePlanViewController : BaseViewController{

    @IBOutlet weak var residentCardView: ResidentCardView!
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblAddedBy: UILabel!

    var patientHeaderInfo : PatientBasicHeaderInfo?
    
    lazy var viewModel: NonSectionCarePlanViewModel = {
        let obj = NonSectionCarePlanViewModel(with: CarePlanService())
        self.baseViewModel = obj
        return obj
    }()
    
    var carePlanItem  = 0
    var pointOfCareItem  = -1

    var arrDatasource = [ListingSectionModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        var viewTitle = ""
        switch self.carePlanItem {
        case CarePlanItems.ConginitiveStatusItem.rawValue:
            viewTitle = NavigationTitle.CarePlanSections.ConginitiveStatus
        case CarePlanItems.BehavioursItem.rawValue:
            viewTitle = NavigationTitle.CarePlanSections.Behaviour
        case CarePlanItems.SafetyItem.rawValue:
            viewTitle = NavigationTitle.CarePlanSections.Safety
        case CarePlanItems.NutritionItem.rawValue:
            viewTitle = NavigationTitle.CarePlanSections.Nutrition
        case CarePlanItems.BathingItem.rawValue:
            viewTitle = NavigationTitle.CarePlanSections.Bathing
        case CarePlanItems.DressingItem.rawValue:
            viewTitle = NavigationTitle.CarePlanSections.Dressing
        case CarePlanItems.HygieneItem.rawValue:
            viewTitle = NavigationTitle.CarePlanSections.Hygiene
        case CarePlanItems.SkinItem.rawValue:
            viewTitle = NavigationTitle.CarePlanSections.Skin
        case CarePlanItems.MobilityItem.rawValue:
            viewTitle = NavigationTitle.CarePlanSections.Mobility
        case CarePlanItems.TransferItem.rawValue:
            viewTitle = NavigationTitle.CarePlanSections.Transfer
        case CarePlanItems.ToiletingItem.rawValue:
            viewTitle = NavigationTitle.CarePlanSections.Toileting
        case CarePlanItems.BladderContineneceItem.rawValue:
            viewTitle = NavigationTitle.CarePlanSections.BladderContinence
        case CarePlanItems.BowelContineneceItem.rawValue:
            viewTitle = NavigationTitle.CarePlanSections.BowelContinence
        default:
            viewTitle = ""
        }
        
        if pointOfCareItem > -1 {
            switch self.pointOfCareItem {
            case NursingCareFlowItems.SafetyItem.rawValue:
                viewTitle = NursingCareFlowItems.Safety
            case NursingCareFlowItems.PersonalHygeieneItem.rawValue:
                viewTitle = NursingCareFlowItems.PersonalHygeiene
            case NursingCareFlowItems.ActivityItem.rawValue:
                viewTitle = NursingCareFlowItems.Activity
            case NursingCareFlowItems.SleepItem.rawValue:
                viewTitle = NursingCareFlowItems.Sleep
            case NursingCareFlowItems.NutritionItem.rawValue:
                viewTitle = NursingCareFlowItems.Nutrition
            default:
                viewTitle = ""
            }
        }
        
        self.navigationItem.title = viewTitle
        self.addBackButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.initialSetup()
    }
    func initialSetup(){
        self.tblView.register(UINib(nibName: ReuseIdentifier.ListCell, bundle: nil), forCellReuseIdentifier: ReuseIdentifier.ListCell)

        //Update Resident Card View
        if let cardView = self.residentCardView{
            if let basicInfo = self.patientHeaderInfo{
                self.updateResidentCardView(cardView: cardView, residentInfo: basicInfo)
            }
        }
        self.lblDate.text = ConstantStrings.NA
        self.lblAddedBy.text = "Added by : \(ConstantStrings.NA)"

        self.setupClosures()
        if pointOfCareItem > -1 {
            self.viewModel.getPointOfCareDetails(nursingItem: self.pointOfCareItem, patientId: self.patientHeaderInfo?.patientID ?? 0)
        }else{
            self.viewModel.getCarePlanDetails(carePlanItem: self.carePlanItem, patientId: self.patientHeaderInfo?.patientID ?? 0)
        }
        
    }
    
    func setupClosures() {
        self.viewModel.reloadListViewClosure = { [weak self] () in
            DispatchQueue.main.async {
                self?.lblDate.text = Utility.convertServerDateToRequiredDate(dateStr: self?.viewModel.dateOfPlan ?? "", requiredDateformat: DateFormats.mm_dd_yyyy)
                self?.lblTime.text = Utility.convertServerDateToRequiredDate(dateStr: self?.viewModel.dateOfPlan ?? "", requiredDateformat: DateFormats.hh_mm_a)
                self?.lblAddedBy.text = "Added by : " + (self?.viewModel.planAddedBy ?? "")

                self?.tblView.reloadData()
            }
        }
    }

}

extension NonSectionCarePlanViewController:UITableViewDataSource, UITableViewDelegate {
   
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.numberOfRows(section: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ReuseIdentifier.ListCell, for: indexPath as IndexPath) as! ListCell
        
        let list = self.viewModel.roomForIndexPath(indexPath)
        cell.lblTitle.text = (list?.title ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        cell.lblValue.text = (list?.value ?? ConstantStrings.NA).trimmingCharacters(in: .whitespacesAndNewlines)
        
        cell.lblSeperator.isHidden = indexPath.row != self.viewModel.numberOfRows(section: indexPath.section)-1
        
        cell.lblDivider.isHidden = list?.value == ""
        
        cell.lblSingleTitle.text = list?.title ?? ""
        cell.lblSingleTitle.isHidden = !cell.lblDivider.isHidden
        cell.lblTitle.isHidden = cell.lblDivider.isHidden
        cell.lblValue.isHidden = cell.lblDivider.isHidden
        
        cell.lblSingleTitle.font = cell.lblDivider.isHidden ? Font.Medium.of(size: 16) :  Font.Medium.of(size: 14)
        cell.lblSingleTitle.textColor = cell.lblDivider.isHidden ? Color.Blue : Color.DarkGray

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    

}
