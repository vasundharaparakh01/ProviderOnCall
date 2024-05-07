//
//  NursingCareFlowViewController.swift
//  AccessEMR
//
//  Created by Vasundhara Parakh on 2/28/20.
//  Copyright © 2020 smartData Enterprises (I) Ltd. All rights reserved.
//

import UIKit
enum NursingCareFlowItems : Int {
    static let Safety = "Safety & Security"
    static let PersonalHygeiene = "Personal Hygeiene"
    static let Activity = "Activity & Exercise"
    static let Sleep = "Sleep, Rest & Comfort"
    static let Nutrition = "Nutrition, Hydration & Elimination"

    case SafetyItem = 0
    case PersonalHygeieneItem
    case ActivityItem
    case SleepItem
    case NutritionItem
}

enum DraftStatusAPI{
    static let ToDo = "ToDo"
    static let InProgress = "InProgress"
    static let Completed = "Completed"
}

import StepSlider
class NursingCareFlowViewController: BaseViewController {
    @IBOutlet weak var slider: StepSlider!

    @IBOutlet weak var residentCardView: ResidentCardView!
    @IBOutlet weak var tblView: UITableView!
    var boolForSave: Bool = false
    var patientHeaderInfo : PatientBasicHeaderInfo?
    var draftStatus : DraftStatus?
    var items = [NursingCareFlowItems.Safety,NursingCareFlowItems.PersonalHygeiene,NursingCareFlowItems.Activity,NursingCareFlowItems.Sleep,NursingCareFlowItems.Nutrition]
    var isSavedCompletely = false
    
    lazy var viewModel: NursingCareViewModel = {
        let obj = NursingCareViewModel(with: PointOfCareService(),section: 0)
        self.baseViewModel = obj
        return obj
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.title = NavigationTitle.NursingCareFlow
        self.addBackButton()
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            self.getDraftStatus()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.initialSetup()
    }
    
    override func onLeftBarButtonClicked(_ sender: UIBarButtonItem) {
        if self.isSavedCompletely{
            self.navigationController?.popViewController(animated: true)
        }else{
            UIAlertController.showAlert(title: Alert.Title.appName, message: Alert.Message.discardFullNCFForm, preferredStyle: .alert, sender: nil , target: self, actions:.Discard,.Continue) { (AlertAction) in
                switch AlertAction {
                case .Discard:
                    AppInstance.shared.draftStatus = nil
                    self.navigationController?.popViewController(animated: true)
                default:
                    break
                }
            }
        }
    }
    
    func initialSetup(){
        self.addrightBarButtonItem()

        self.tblView.register(UINib(nibName: ReuseIdentifier.ListTableViewCell, bundle: nil), forCellReuseIdentifier: ReuseIdentifier.ListTableViewCell)

        //Update Resident Card View
        if let cardView = self.residentCardView{
            if let basicInfo = self.patientHeaderInfo{
                self.updateResidentCardView(cardView: cardView, residentInfo: basicInfo)
            }
        }
        
        self.slider.maxCount = 5
        slider.labelFont = UIFont.PoppinsRegular(fontSize: 14)
        slider.labelColor = Color.DarkGray
        slider.adjustLabel = true
        slider.trackHeight = 1.0
        slider.sliderCircleColor = Color.Blue
        slider.tintColor = Color.Blue
        slider.trackColor = Color.LightGray
        slider.trackCircleRadius = 7.0
        slider.sliderCircleRadius = 7.0
        slider.isDotsInteractionEnabled = true
        slider.labels = ["","","","",""]
        self.slider.sliderCircleColor = Color.LightGray

        self.updateSlider()
        

    }
    func addrightBarButtonItem() {
        let rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target:  self, action: #selector(onRightBarButtonItemClicked(_ :)))
        rightBarButtonItem.tintColor = UIColor.white
        navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    // MARK:
    @objc func onRightBarButtonItemClicked(_ sender: UIBarButtonItem) {
        var sliderStatusVal = 0
        if self.draftStatus?.safetySecurityDraftStatus == DraftStatusAPI.Completed{
            sliderStatusVal += 1
        }
        
        if self.draftStatus?.personalHygieneDraftStatus == DraftStatusAPI.Completed{
            sliderStatusVal += 1
        }
        
        if self.draftStatus?.activityExcerciseDraftStatus == DraftStatusAPI.Completed{
            sliderStatusVal += 1
        }
        
        if self.draftStatus?.nutritionHydrationDraftStatus == DraftStatusAPI.Completed{
            sliderStatusVal += 1
        }
        
        if self.draftStatus?.sleepRestDraftStatus == DraftStatusAPI.Completed{
            sliderStatusVal += 1
        }
         if UserDefaults.getPatientStatus() != "Active" && boolForSave == true{
            if let safetyParam = AppInstance.shared.safetyNCFParams{
            self.saveNursingCare(apiName: APITargetPoint.save_NCF_Safety, params: safetyParam) { (success) in
                if let isSuccess = success as? Bool{
                    if isSuccess{
                        self.isSavedCompletely = true
                      UIAlertController.showAlert(title: Alert.Title.appName, message: Alert.Message.formSavedSuccessfully)
                    }
                }
            }
            }
        }
       else if sliderStatusVal == 5{
            //TODO: Call all save apis
            self.viewModel.isLoading = true
            if let safetyParam = AppInstance.shared.safetyNCFParams{
                if let hygieneParam = AppInstance.shared.hygieneNCFParams{
                    if let activityParam = AppInstance.shared.activityNCFParams{
                        if let sleepParam = AppInstance.shared.sleepNCFParams{
                            if let nutritionParam = AppInstance.shared.nutritionNCFParams{
                                
                                //Save Safety
                                self.saveNursingCare(apiName: APITargetPoint.save_NCF_Safety, params: safetyParam) { (success) in
                                    if let isSuccess = success as? Bool{
                                        if isSuccess{
                                            
                                            //Save Hygiene
                                            self.saveNursingCare(apiName: APITargetPoint.save_NCF_PersonalHygiene, params: hygieneParam) { (success) in
                                                if let isSuccess = success as? Bool{
                                                    if isSuccess{
                                                        
                                                        //Save Activity
                                                        self.saveNursingCare(apiName: APITargetPoint.save_NCF_Activity, params: activityParam) { (success) in
                                                            if let isSuccess = success as? Bool{
                                                                if isSuccess{
                                                                    
                                                                    //Save Sleep
                                                                    self.saveNursingCare(apiName: APITargetPoint.save_NCF_Sleep, params: sleepParam) { (success) in
                                                                        if let isSuccess = success as? Bool{
                                                                            if isSuccess{
                                                                                
                                                                                //Save Nutrition
                                                                                self.saveNursingCare(apiName: APITargetPoint.save_NCF_Nutrition, params: nutritionParam) { (success) in
                                                                                    if let isSuccess = success as? Bool{
                                                                                        if isSuccess{
                                                                                            UIAlertController.showAlert(title: Alert.Title.appName, message: Alert.Message.formSavedSuccessfully)
                                                                                            self.isSavedCompletely = true
                                                                                            self.draftStatus?.safetySecurityDraftStatus =  DraftStatusAPI.ToDo
                                                                                            self.draftStatus?.personalHygieneDraftStatus =  DraftStatusAPI.ToDo
                                                                                            self.draftStatus?.activityExcerciseDraftStatus =  DraftStatusAPI.ToDo
                                                                                            self.draftStatus?.sleepRestDraftStatus =  DraftStatusAPI.ToDo
                                                                                        }
                                                                                        self.draftStatus?.nutritionHydrationDraftStatus =  DraftStatusAPI.ToDo
                                                                                        
                                                                                        self.updateSlider()
                                                                                        self.tblView.reloadData()
                                                                                        self.viewModel.isLoading = false
                                                                                        return
}
                                                                                }
                                                                            }
                                                                        }
                                                                    }
                                                                }
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }

        }else{
            self.viewModel.isLoading = false

            UIAlertController.showAlert(title: Alert.Title.appName, message: "Please complete all the forms to save Nursing Care Flow.")
        }
        /*
         self.view.endEditing(true)
        
        //======= for Validation
        self.isValidating = true
        self.tblView.reloadData()
        //======= Ends
        
        let inputParams = self.createAPIParams(isDraft: false, moodID: 0)
        //Change for removing Notes as mandatory
        var copyParams = inputParams
        if inputParams[Key.Params.ADLTracking.notes] == nil{
            copyParams[Key.Params.ADLTracking.notes] = " "
        }

        var apiName = ""
        var paramsCountLimit = 0
        var idToUpdate = 0

        switch selectedSection {
        case NursingSections.Safety.rawValue:
            paramsCountLimit = 11
            idToUpdate = self.viewModel.safetySecurityDetail?.id ?? 0
            apiName = APITargetPoint.save_NCF_Safety
        case NursingSections.PersonalHygiene.rawValue:
            paramsCountLimit = ((inputParams[Key.Params.NursingCareFlow.PersonalHygiene.bathId] as? Int) ?? 0) == 116 ? 11 : 8
            idToUpdate = self.viewModel.personalHygieneDetail?.id ?? 0
            apiName = APITargetPoint.save_NCF_PersonalHygiene
        case NursingSections.Activity.rawValue:
            paramsCountLimit = 13
            idToUpdate = self.viewModel.activityDetail?.id ?? 0
            apiName = APITargetPoint.save_NCF_Activity
        case NursingSections.Sleep.rawValue:
            idToUpdate = self.viewModel.sleepRestDetail?.id ?? 0
            paramsCountLimit = 9
            if inputParams[Key.Params.NursingCareFlow.Sleep.sleepAtTime] == nil{
                copyParams[Key.Params.NursingCareFlow.Sleep.sleepAtTime] = " "
            }
            if inputParams[Key.Params.NursingCareFlow.Sleep.awakeAtTime] == nil{
                copyParams[Key.Params.NursingCareFlow.Sleep.awakeAtTime] = " "
            }

            apiName = APITargetPoint.save_NCF_Sleep
        default:
            print("Do nothing")
        }
        if selectedSection == NursingSections.Safety.rawValue{
            if copyParams.keys.count >= 11{
                self.viewModel.saveNursingCare(apiName: apiName, params: self.createAPIParams(isDraft: false, moodID: idToUpdate))
                AppInstance.shared.shouldUpdateDraftStatus = true

            }else{
                self.viewModel.errorMessage = "Please fill missing inputs."
            }
        }else{
            if copyParams.keys.count == paramsCountLimit{
                self.viewModel.saveNursingCare(apiName: apiName, params: self.createAPIParams(isDraft: false, moodID: idToUpdate))
                AppInstance.shared.shouldUpdateDraftStatus = true

            }else{
                self.viewModel.errorMessage = "Please fill missing inputs."
            }
        }*/
    }

    func saveNursingCare(apiName:String, params : [String: Any],completion:@escaping (Any?) -> Void){
        
        PointOfCareService().saveNursingCareFlow(apiName: apiName, params: params)  { (result) in
            if let res = result as? String{
                //self.errorMessage = res
                completion(false)
            }else{
                //self.isSuccess = true
                //self.alertMessage = Alert.Message.formSavedSuccessfully
                completion(true)
            }
        }
    }
    func getDraftStatus(){
        PointOfCareService().getDraftStatus(with: self.patientHeaderInfo?.patientID ?? 0) { (draftStatus) in
                if let status = draftStatus as? DraftStatus{
                    self.draftStatus = status
//                    self.draftStatusArr = [self.draftStatus?.safetySecurityIsDraft ?? false,
//                                           self.draftStatus?.personalHygieneIsDraft ?? false,
//                                           self.draftStatus?.activityExcerciseIsDraft ?? false,
//                                           self.draftStatus?.sleepRestIsDraft ?? false,
//                                           self.draftStatus?.nutritionHydrationIsDraft ?? false]
                    
//                    let filterfilled = self.draftStatusArr.compactMap { (isDraft) -> Bool? in
//                        return isDraft == true ?  isDraft : nil
//                    }
//                    self.slider.setIndex(UInt((5 - filterfilled.count - 1) ?? 0), animated: false)
                    self.updateSlider()
                    
                    AppInstance.shared.draftStatus = self.draftStatus
                }
            self.tblView.reloadData()

        }
    }
    
    func updateSlider(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            
            var sliderStatusVal = 0
            if self.draftStatus?.safetySecurityDraftStatus == DraftStatusAPI.Completed{
                sliderStatusVal += 1
            }
            
            if self.draftStatus?.personalHygieneDraftStatus == DraftStatusAPI.Completed{
                sliderStatusVal += 1
            }
            
            if self.draftStatus?.activityExcerciseDraftStatus == DraftStatusAPI.Completed{
                sliderStatusVal += 1
            }
            
            if self.draftStatus?.nutritionHydrationDraftStatus == DraftStatusAPI.Completed{
                sliderStatusVal += 1
            }
            
            if self.draftStatus?.sleepRestDraftStatus == DraftStatusAPI.Completed{
                sliderStatusVal += 1
            }
            
            if sliderStatusVal > 0{
                self.slider.sliderCircleColor = Color.Blue
                self.slider.setIndex(UInt(sliderStatusVal - 1), animated: false)
            }else{
                self.slider.sliderCircleColor = Color.LightGray
            }
        }
    }
}

extension NursingCareFlowViewController:UITableViewDataSource, UITableViewDelegate {
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ReuseIdentifier.ListTableViewCell, for: indexPath as IndexPath) as! ListTableViewCell
        cell.titleLbl.text = items[indexPath.row]
        cell.imgNext.isHidden = true
        cell.imgFill.isHidden = false
        var isDraft = ""
        
        switch indexPath.row {
        case 0:
            isDraft = self.draftStatus?.safetySecurityDraftStatus ?? ""
        case 1:
                isDraft = self.draftStatus?.personalHygieneDraftStatus ?? ""
            case 2:
                isDraft = self.draftStatus?.activityExcerciseDraftStatus ?? ""
            case 3:
                isDraft = self.draftStatus?.sleepRestDraftStatus ?? ""
            case 4:
                isDraft = self.draftStatus?.nutritionHydrationDraftStatus ?? ""

        default:
            isDraft = ""
        }
        print("Index --- \(indexPath.row) --- isDraft == \(isDraft)")
        if isDraft == DraftStatusAPI.ToDo{
            cell.imgFill.isHidden = true
        }else if isDraft == DraftStatusAPI.InProgress{
            cell.imgFill.image = UIImage.formIncomplete()
        }else
        {
            cell.imgFill.image =  UIImage.formFilled()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        if self.isSavedCompletely{
            UIAlertController.showAlert(title: Alert.Title.appName, message: "Nursing Care Flow forms have already been submitted.")
            return
        }
        if indexPath.row == NursingCareFlowItems.NutritionItem.rawValue{
            let vc = NCFNutritionViewController.instantiate(appStoryboard: Storyboard.Forms) as! NCFNutritionViewController
            if let basicInfo = self.patientHeaderInfo{
                vc.patientId = basicInfo.patientID ?? 0
            }
            vc.selectedSection = indexPath.row
            vc.hidesBottomBarWhenPushed = true
            vc.delegate = self
            self.navigationController?.pushViewController(vc,animated:true)
        }else{
            let vc = NursingCareFormViewController.instantiate(appStoryboard: Storyboard.Forms) as! NursingCareFormViewController
            if let basicInfo = self.patientHeaderInfo{
                vc.patientId = basicInfo.patientID ?? 0
            }
            vc.delegateBool = self
            vc.selectedSection = indexPath.row
            vc.hidesBottomBarWhenPushed = true
            vc.delegate = self
            self.navigationController?.pushViewController(vc,animated:true)
        }
        
        
//         let vc = NonSectionCarePlanViewController.instantiate(appStoryboard: Storyboard.CarePlan) as! NonSectionCarePlanViewController
//         vc.pointOfCareItem = indexPath.row
//         self.navigationController?.pushViewController(vc,animated:true)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Device.IS_IPAD ? 60 : 50
    }
    
    
}

extension NursingCareFlowViewController : NutritionFormDelegate{
    func didFinishNutritionForm(isDraft: Bool, selectedSection: Int) {
        self.draftStatus = AppInstance.shared.draftStatus
        if isDraft{
            self.draftStatus?.nutritionHydrationDraftStatus =  DraftStatusAPI.InProgress
        }else{
            self.draftStatus?.nutritionHydrationDraftStatus = AppInstance.shared.nutritionNCFParams != nil ? DraftStatusAPI.Completed : DraftStatusAPI.ToDo
        }
        
        self.updateSlider()

        self.tblView.reloadData()
    }
}
extension NursingCareFlowViewController : NursingCareFormDelegate{
    
    func didFinishForm(isDraft: Bool, selectedSection: Int) {
        self.draftStatus = AppInstance.shared.draftStatus

        if isDraft{
            switch selectedSection{
            case NursingSections.Safety.rawValue:
                self.draftStatus?.safetySecurityDraftStatus =  DraftStatusAPI.InProgress
            case NursingSections.PersonalHygiene.rawValue:
                self.draftStatus?.personalHygieneDraftStatus =  DraftStatusAPI.InProgress
            case NursingSections.Activity.rawValue:
                self.draftStatus?.activityExcerciseDraftStatus =  DraftStatusAPI.InProgress
            case NursingSections.Sleep.rawValue:
                self.draftStatus?.sleepRestDraftStatus =  DraftStatusAPI.InProgress
            default:
                print("Do nothing")
            }
        }else{
            switch selectedSection{
            case NursingSections.Safety.rawValue:
                self.draftStatus?.safetySecurityDraftStatus = AppInstance.shared.safetyNCFParams != nil ? DraftStatusAPI.Completed : DraftStatusAPI.ToDo
            case NursingSections.PersonalHygiene.rawValue:
                self.draftStatus?.personalHygieneDraftStatus = AppInstance.shared.hygieneNCFParams != nil ? DraftStatusAPI.Completed : DraftStatusAPI.ToDo
            case NursingSections.Activity.rawValue:
                self.draftStatus?.activityExcerciseDraftStatus = AppInstance.shared.activityNCFParams != nil ? DraftStatusAPI.Completed : DraftStatusAPI.ToDo
            case NursingSections.Sleep.rawValue:
                self.draftStatus?.sleepRestDraftStatus = AppInstance.shared.sleepNCFParams != nil ? DraftStatusAPI.Completed : DraftStatusAPI.ToDo
            default:
                print("Do nothing")
            }

        }
        
        self.updateSlider()

        self.tblView.reloadData()
        

    }
}
                           
extension NursingCareFlowViewController : SaftyandsecurityCheck{
    func boolCheck(boolValue: Bool) {
        boolForSave = boolValue
    }
    
    
}
