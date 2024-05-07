//
//  ResidentDetailViewController.swift
//  AccessEMR
//
//  Created by Vasundhara Parakh on 2/25/20.
//  Copyright © 2020 smartData Enterprises (I) Ltd. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage

enum ResidentItems {
    static let Vitals = "Vitals"
    static let ADL = "ADL Tracking"
    static let Mood = "Mood & Behaviour Tracking"
    static let Nursing = "Nursing Care Flow Sheet"
    static let ESAS = "Symptom Tracker" //"Symptom Assessment System (SAS)"
    static let Assessments = "Assessments"
    static let TAR = "TAR"
    static let IncidentReport = "Incident Report"
    static let CarePlan = "Care Plan"
    static let Allergies = "Allergies"
    static let Diagnosis = "Diagnosis"
    static let Medication = "Medication"
 //   static let Labs = "Labs"
    static let FoodDiary = "Food Diary"
    static let InputOutPut = "Input-Output Chart"
}
class ResidentDetailViewController: BaseViewController {

    @IBOutlet weak var residentCardView: ResidentCardView!
    
    @IBOutlet weak var caregoalLbl: UILabel!
    @IBOutlet weak var statusLbl: UILabel!
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var goalInfoConstaint: NSLayoutConstraint!

    var items = [ResidentItems.Vitals, ResidentItems.ADL,ResidentItems.Mood,ResidentItems.Nursing,ResidentItems.InputOutPut, ResidentItems.ESAS, ResidentItems.Assessments,ResidentItems.TAR,ResidentItems.IncidentReport, ResidentItems.CarePlan,ResidentItems.Allergies, ResidentItems.Diagnosis, ResidentItems.Medication,  ResidentItems.FoodDiary]
    
    lazy var viewModel: ResidentDetailViewModel = {
        let obj = ResidentDetailViewModel(with: ResidentService())
        self.baseViewModel = obj
        return obj
    }()
    
    var patientId = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.title = "\(UserDefaults.getOrganisationTypeName()) Detail"
        self.addBackButton()
        self.setupClosures()
        tblView.register(UINib(nibName: ReuseIdentifier.ListTableViewCell, bundle: nil), forCellReuseIdentifier: ReuseIdentifier.ListTableViewCell)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.initialSetup()
    }
    
    func initialSetup(){
        self.viewModel.getResidentDetail(patientId: self.patientId)
        
        if UserDefaults.getOrganisationType() == OrganisationType.HomeCare{
            self.addrightBarButtonItem()
        }
        
    }
    func addrightBarButtonItem() {
        let addressButtonImage = UIImage.addressImage().withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        let rightBarButtonItem = UIBarButtonItem(image: addressButtonImage,
                                                 style: .plain,
                                                 target: self,
                                                 action: #selector(onRightBarButtonItemClicked(_ :)))
        navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    // MARK:
    @objc func onRightBarButtonItemClicked(_ sender: UIBarButtonItem) {
        
        let vc = DirectionMapViewController.instantiate(appStoryboard: Storyboard.Dashboard) as! DirectionMapViewController
        vc.hidesBottomBarWhenPushed = true
        
        if let basicInfo = self.viewModel.residentDetailHeader?.patientBasicHeaderInfo as? PatientBasicHeaderInfo{
            
            //Vancouver Lat long - Sushi Restaurant
            var DestinationLat : Double =  Double(basicInfo.latitude ?? "0.0") ?? 0.0 // 49.280046
            var DestinationLong : Double = Double(basicInfo.longitude ?? "0.0") ?? 0.0 // -123.124929

//            vc.DestinationLat =  21.14810075
//            vc.DestinationLong =  79.13182304

            vc.DestinationLat = DestinationLat
            vc.DestinationLong = DestinationLong
            vc.destinationAddress = basicInfo.address ?? ""
            vc.patientInfo = basicInfo
        }
        
        self.navigationController?.pushViewController(vc,animated:true)
        
            //self.viewModel.errorMessage = "Coming Soon"
    }
    
    func setupClosures() {
        self.viewModel.updateViewClosure = { [weak self] () in
            DispatchQueue.main.async {
                if let cardView = self?.residentCardView{
                    if let basicInfo = self?.viewModel.residentDetailHeader?.patientBasicHeaderInfo{
                        self?.updateResidentCardView(cardView: cardView, residentInfo: basicInfo)
                        self?.statusLbl.text = basicInfo.status ?? ConstantStrings.NA
                        self?.caregoalLbl.text = basicInfo.goalOfCare ?? ConstantStrings.GoalOfCare_NA 
                        self?.goalInfoConstaint.constant = (self?.caregoalLbl.intrinsicContentSize.width ?? 0) > Screen.width - 50 ? Screen.width - 65 : (self?.caregoalLbl.intrinsicContentSize.width ?? 0) + 15
                    }
                }
            }
        }
    }

    @IBAction func btnInfo_Action(_ sender: Any) {
        (sender as! UIButton).isSelected = !(sender as! UIButton).isSelected
        if let basicInfo = self.viewModel.residentDetailHeader?.patientBasicHeaderInfo{
            self.showTipView(textString: basicInfo.goalOfCareInfo ?? ConstantStrings.GoalOfCare_NA, senderBtn: sender as! UIButton)
        }
    }

}
//MARK:- UITableViewDataSource, UITableViewDelegate
extension ResidentDetailViewController:UITableViewDataSource, UITableViewDelegate {
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ReuseIdentifier.ListTableViewCell, for: indexPath as IndexPath) as! ListTableViewCell
        cell.titleLbl.text = items[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = items[indexPath.row]
        switch item {
        case ResidentItems.Vitals:
            let vc = VitalHistoryViewController.instantiate(appStoryboard: Storyboard.Dashboard) as! VitalHistoryViewController
            if let basicInfo = self.viewModel.residentDetailHeader?.patientBasicHeaderInfo{
                vc.patientHeaderInfo = basicInfo
            }
            self.navigationController?.pushViewController(vc,animated:true)
        case ResidentItems.ADL:
            let vc = ADLTrackingFormViewController.instantiate(appStoryboard: Storyboard.Forms) as! ADLTrackingFormViewController
            vc.patientId = self.patientId
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc,animated:true)
        case ResidentItems.Mood:
            let vc = MoodTrackingFormViewController.instantiate(appStoryboard: Storyboard.Forms) as! MoodTrackingFormViewController
            vc.patientId = self.patientId
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc,animated:true)
        case ResidentItems.Nursing:
            let vc = NursingCareFlowViewController.instantiate(appStoryboard: Storyboard.PointOfCare) as! NursingCareFlowViewController
            if let basicInfo = self.viewModel.residentDetailHeader?.patientBasicHeaderInfo{
                vc.patientHeaderInfo = basicInfo
            }
            AppInstance.shared.shouldUpdateDraftStatus = false
            self.navigationController?.pushViewController(vc,animated:true)
        case ResidentItems.ESAS:
            let vc = ESASListViewController.instantiate(appStoryboard: Storyboard.PointOfCare) as! ESASListViewController
            if let basicInfo = self.viewModel.residentDetailHeader?.patientBasicHeaderInfo{
                vc.patientHeaderInfo = basicInfo
            }
            self.navigationController?.pushViewController(vc,animated:true)
        case ResidentItems.Assessments:
            let vc = AssessmentViewController.instantiate(appStoryboard: Storyboard.Assessment) as! AssessmentViewController
            if let basicInfo = self.viewModel.residentDetailHeader?.patientBasicHeaderInfo{
                vc.patientHeaderInfo = basicInfo
            }
            self.navigationController?.pushViewController(vc,animated:true)
        case ResidentItems.TAR:
            //Utility.showAlertWithMessage(titleStr: Alert.Title.appName, messageStr: "Coming Soon", controller: self)
            
            let vc = TARListViewController.instantiate(appStoryboard: Storyboard.Dashboard) as! TARListViewController
            if let basicInfo = self.viewModel.residentDetailHeader?.patientBasicHeaderInfo{
                vc.patientHeaderInfo = basicInfo
            }
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc,animated:true)
        case ResidentItems.IncidentReport:
            //Utility.showAlertWithMessage(titleStr: Alert.Title.appName, messageStr: "Coming Soon", controller: self)
            
            let vc = IncidentReportViewController.instantiate(appStoryboard: Storyboard.Forms) as! IncidentReportViewController
            vc.patientId = self.viewModel.residentDetailHeader?.patientBasicHeaderInfo?.patientID ?? 0
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc,animated:true)

        case ResidentItems.Allergies:
            if let basicInfo = self.viewModel.residentDetailHeader?.patientBasicHeaderInfo{
                if !(basicInfo.isAllergy ?? true){
                    let vc = AllergyListViewController.instantiate(appStoryboard: Storyboard.Dashboard) as! AllergyListViewController
                    if let basicInfo = self.viewModel.residentDetailHeader?.patientBasicHeaderInfo{
                        vc.patientHeaderInfo = basicInfo
                    }
                    self.navigationController?.pushViewController(vc,animated:true)
                }else{
                    Utility.showAlertWithMessage(titleStr: Alert.Title.appName, messageStr: "There are no known allergies.", controller: self)
                }
            }
            
        case ResidentItems.Diagnosis:
            let vc = DiagnosisListViewController.instantiate(appStoryboard: Storyboard.Dashboard) as! DiagnosisListViewController
            if let basicInfo = self.viewModel.residentDetailHeader?.patientBasicHeaderInfo{
                vc.patientHeaderInfo = basicInfo
            }
            self.navigationController?.pushViewController(vc,animated:true)
            
            
        case ResidentItems.Medication:
            let vc = MedicationListViewController.instantiate(appStoryboard: Storyboard.Dashboard) as! MedicationListViewController
            if let basicInfo = self.viewModel.residentDetailHeader?.patientBasicHeaderInfo{
                vc.patientHeaderInfo = basicInfo
            }
            self.navigationController?.pushViewController(vc,animated:true)
        case ResidentItems.CarePlan:
            let vc = CarePlanViewController.instantiate(appStoryboard: Storyboard.CarePlan) as! CarePlanViewController
            if let basicInfo = self.viewModel.residentDetailHeader?.patientBasicHeaderInfo{
                vc.patientHeaderInfo = basicInfo
            }
            self.navigationController?.pushViewController(vc,animated:true)
            
            /*
             case ResidentItems.Labs:
             let vc = LabResultViewController.instantiate(appStoryboard: Storyboard.Dashboard) as! LabResultViewController
             if let basicInfo = self.viewModel.residentDetailHeader?.patientBasicHeaderInfo{
             vc.patientHeaderInfo = basicInfo
             }
             vc.hidesBottomBarWhenPushed = true
             self.navigationController?.pushViewController(vc,animated:true)
             
             */

             case ResidentItems.FoodDiary:
             let vc = FoodDiaryViewController.instantiate(appStoryboard: Storyboard.Dashboard) as! FoodDiaryViewController
             if let basicInfo = self.viewModel.residentDetailHeader?.patientBasicHeaderInfo{
             vc.patientHeaderInfo = basicInfo
             }
             self.navigationController?.pushViewController(vc,animated:true)
             
            case ResidentItems.InputOutPut:
            let vc = InputOutPutChartVC.instantiate(appStoryboard: Storyboard.PointOfCare) as! InputOutPutChartVC
            vc.patientId = self.viewModel.residentDetailHeader?.patientBasicHeaderInfo?.patientID ?? 0
            self.navigationController?.pushViewController(vc,animated:true)
        default:
            break
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Device.IS_IPAD ? 60 : 50
    }
}

