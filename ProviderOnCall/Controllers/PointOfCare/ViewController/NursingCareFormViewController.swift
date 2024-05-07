//
//  NursingCareFormViewController.swift
//  AccessEMR
//
//  Created by Vasundhara Parakh on 3/16/20.
//  Copyright © 2020 smartData Enterprises (I) Ltd. All rights reserved.
//

protocol NursingCareFormDelegate {
    func didFinishForm(isDraft : Bool, selectedSection: Int)
}

import UIKit
import IQKeyboardManagerSwift
protocol SaftyandsecurityCheck {
    func boolCheck(boolValue : Bool)
}

class NursingCareFormViewController: BaseViewController {
    var delegate: NursingCareFormDelegate?
    
    @IBOutlet weak var tblView: UITableView!
    var delegateBool : SaftyandsecurityCheck?
    var arrInput = [Any]()
    var activeTextfieldTag = 0
    var isReadyToSave = false
    var isValidating = false
    var patientId = 0
    var activeTextfield : InputTextField?
    var selectedSection = 0
    var checkActiveStatus:String = ""
    var discardBool : Bool = false
    
    lazy var viewModel: NursingCareViewModel = {
        let obj = NursingCareViewModel(with: PointOfCareService(),section: self.selectedSection)
        self.baseViewModel = obj
        return obj
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerNIBs()
        self.initialSetup()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        IQKeyboardManager.shared.previousNextDisplayMode = .alwaysHide
        
    }
    //    override func onLeftBarButtonClicked(_ sender: UIBarButtonItem) {
    //        self.view.endEditing(true)
    //        self.backAPICall()
    //    }
    func backAPICall(){
        var apiName = ""
        var idToUpdate = 0
        var countCheck = 0
        switch selectedSection {
        case NursingSections.Safety.rawValue:
            idToUpdate = self.viewModel.safetySecurityDetail?.id ?? 0
            apiName = APITargetPoint.save_NCF_Safety
            SharedAccessEMR.sharedInstance.patientActiveStatus = ""
            countCheck = 4
        case NursingSections.PersonalHygiene.rawValue:
            idToUpdate = self.viewModel.personalHygieneDetail?.id ?? 0
            apiName = APITargetPoint.save_NCF_PersonalHygiene
            countCheck = 3
        case NursingSections.Activity.rawValue:
            idToUpdate = self.viewModel.activityDetail?.id ?? 0
            apiName = APITargetPoint.save_NCF_Activity
            countCheck = 3
        case NursingSections.Sleep.rawValue:
            idToUpdate = self.viewModel.sleepRestDetail?.id ?? 0
            apiName = APITargetPoint.save_NCF_Sleep
            countCheck = 3
        default:
            print("Do nothing")
        }
        
        let holdP =  self.createAPIParams(isDraft: false, moodID: idToUpdate)
        
        switch selectedSection {
        case NursingSections.Safety.rawValue:
            if countCheck == holdP.count{
                self.navigationController?.popViewController(animated: true)
                return
            }else{
                
            }
            
        case NursingSections.PersonalHygiene.rawValue:
            if countCheck == holdP.count{
                self.navigationController?.popViewController(animated: true)
                return
            }else{
                
            }
        case NursingSections.Activity.rawValue:
            if countCheck == holdP.count{
                self.navigationController?.popViewController(animated: true)
                return
            }else{
                
            }
        case NursingSections.Sleep.rawValue:
            if countCheck == holdP.count{
                self.navigationController?.popViewController(animated: true)
                return
            }else{
                
            }
        default:
            print("Do nothing")
        }
        self.delegate?.didFinishForm(isDraft: false, selectedSection: self.selectedSection)
        self.viewModel.saveNursingCare(apiName: apiName, params: self.createAPIParams(isDraft: false, moodID: idToUpdate))
        viewModel.redirectControllerClosure = { [weak self] () in
            DispatchQueue.main.async {
                self?.navigationController?.popViewController(animated: true)
            }
        }
        AppInstance.shared.shouldUpdateDraftStatus = false
    }
    func initialSetup(){
        //Setup navigation bar
        var titleHeader = ""
        switch selectedSection {
        case NursingSections.Safety.rawValue:
            titleHeader = NursingHeadingTitles.Safety
        case NursingSections.PersonalHygiene.rawValue:
            self.checkActiveInactive()
            titleHeader = NursingHeadingTitles.PersonalHygiene
        case NursingSections.Activity.rawValue:
            self.checkActiveInactive()
            titleHeader = NursingHeadingTitles.Activity
        case NursingSections.Sleep.rawValue:
            self.checkActiveInactive()
            titleHeader = NursingHeadingTitles.Sleep
        default:
            print("Do nothing")
        }
        
        self.navigationItem.title = titleHeader
        self.addBackButton()
        //self.addrightBarButtonItem()
        self.setupClosures()
        
        switch selectedSection {
        case NursingSections.Safety.rawValue:
            self.viewModel.getSafetySecurityDetail(patientId: self.patientId) { (result) in
                self.viewModel.getNursingCareMasterData()
                
            }
        case NursingSections.PersonalHygiene.rawValue:
            self.viewModel.getPersonalHygieneDetail(patientId: self.patientId) { (result) in
                self.viewModel.getNursingCareMasterData()
            }
        case NursingSections.Activity.rawValue:
            self.viewModel.getActivityDetail(patientId: self.patientId) { (result) in
                self.viewModel.getNursingCareMasterData()
            }
        case NursingSections.Sleep.rawValue:
            self.viewModel.getSleepRestDetail(patientId: self.patientId) { (result) in
                self.viewModel.getNursingCareMasterData()
            }
        default:
            print("Do nothing")
        }
        
        
        
    }
    func checkActiveInactive(){
        if UserDefaults.getPatientStatus() == "Active"{
            self.tblView.isUserInteractionEnabled = true
        }else{
            self.checkAlertSTATUS()
            self.tblView.isUserInteractionEnabled = false
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        IQKeyboardManager.shared.previousNextDisplayMode = .Default
        
        switch selectedSection {
        case NursingSections.Safety.rawValue:
            if self.discardBool == false{
                if let arrInput = self.arrInput[0] as? [Any]{
                    if let dictArr = arrInput as? [Any]{
                        let copyArr = dictArr
                        if let dict = copyArr[0] as? InputTextfieldModel{
                            if ((dict.inputType ?? "") == InputType.Dropdown){
                                if ((dict.placeholder ?? "") == NursingTitles.Safety.ResidentStatus){
                                    checkActiveStatus = dict.value ?? ""
                                    UserDefaults.setPatientStatus(token: checkActiveStatus)
                                }
                            }
                        }
                    }
                }
                
            }
        default:
            print("Do nothing")
        }
        
    }
    
    override func onLeftBarButtonClicked(_ sender: UIBarButtonItem) {
        self.view.endEditing(true)
        
        UIAlertController.showAlert(title: Alert.Title.appName, message: Alert.Message.discard, preferredStyle: .alert, sender: nil , target: self, actions:.Discard,.Continue) { (AlertAction) in
            switch AlertAction {
            case .Continue:
                
                switch self.selectedSection {
                case NursingSections.Safety.rawValue:
                    if self.backStatusCheck() == true{
                        self.prepareDataForAPI()
                    }else{
                        var idToUpdate = 0
                        idToUpdate = self.viewModel.safetySecurityDetail?.id ?? 0
                        AppInstance.shared.safetyNCFParams = self.createAPIParams(isDraft: false, moodID: idToUpdate)
                        self.navigationController?.popViewController(animated: true)
                    }
                    
                case NursingSections.PersonalHygiene.rawValue:
                    self.prepareDataForAPI()
                case NursingSections.Activity.rawValue:
                    self.prepareDataForAPI()
                case NursingSections.Sleep.rawValue:
                    self.prepareDataForAPI()
                default:
                    print("Do nothing")
                }
            case .Discard:
                self.discardBool = true
                self.navigationController?.popViewController(animated: true)
            default:
                break
            }
        }
    }
    func backStatusCheck()-> Bool{
        if checkActiveStatus.count >= 1{
            if checkActiveStatus == "Active"{
                return true
            }else{
                delegateBool?.boolCheck(boolValue: true)
                return false
            }
        }else{
            if UserDefaults.getPatientStatus() == "Active"{
                return true
            }else{
                return false
            }
        }
        
    }
    func registerNIBs(){
        self.tblView.register(UINib(nibName: ReuseIdentifier.DoubleInputCell, bundle: nil), forCellReuseIdentifier: ReuseIdentifier.DoubleInputCell)
        self.tblView.register(UINib(nibName: ReuseIdentifier.TextInputCell, bundle: nil), forCellReuseIdentifier: ReuseIdentifier.TextInputCell)
        self.tblView.register(UINib(nibName: ReuseIdentifier.DateTimeInputCell, bundle: nil), forCellReuseIdentifier: ReuseIdentifier.DateTimeInputCell)
        self.tblView.register(UINib(nibName: ReuseIdentifier.PickerInputCell, bundle: nil), forCellReuseIdentifier: ReuseIdentifier.PickerInputCell)
        self.tblView.register(UINib(nibName: ReuseIdentifier.TitleCell, bundle: nil), forCellReuseIdentifier: ReuseIdentifier.TitleCell)
        
    }
    func setupClosures() {
        self.viewModel.updateViewClosure = { [weak self] () in
            DispatchQueue.main.async {
                self?.arrInput = self?.viewModel.getInputArray() ?? [""]
                if self?.selectedSection == NursingSections.Safety.rawValue{
                    //Set Fall fields if Fall is "YES"
                    self?.getArrayIndexFromTitle(title: NursingTitles.Safety.Fall, completion: { (rowOfFall) in
                        if ((self?.viewModel.safetySecurityDetail?.fallId ?? 0) == 116){ //116 is "Yes"
                            var copyArr = self?.arrInput[0] as! [Any]
                            copyArr.insert(self?.viewModel.getFallTimeInput(), at: rowOfFall + 1)
                            copyArr.insert(self?.viewModel.getFallTypeInput(), at: rowOfFall + 2)
                            self?.arrInput[0] = copyArr
                        }
                    })
                    
                    //Set PressureUlcer fields if PressureUlcer is not "None"
                    self?.getArrayIndexFromTitle(title: NursingTitles.Safety.PressureUlcer, completion: { (rowOfUlcer) in
                        if ((self?.viewModel.safetySecurityDetail?.pressureUlcer ?? 0) != 149 && (self?.viewModel.safetySecurityDetail?.pressureUlcer ?? 0) != 0){ //149 is "None"
                            var copyArr = self?.arrInput[0] as! [Any]
                            if let bodySiteArray = self?.viewModel.safetySecurityDetail?.bodySiteGet {
                                for (_,bodySite) in bodySiteArray.enumerated(){
                                    copyArr.insert(self?.viewModel.getBodySiteInput(bodySite: bodySite), at: rowOfUlcer + 1)
                                }
                            }
                            self?.arrInput[0] = copyArr
                        }
                    })
                    
                    //Set Behaviour fields if Behaviour is "YES"
                    self?.getArrayIndexFromTitle(title: NursingTitles.Safety.Behaviour, completion: { (rowOfBheaviour) in
                        if ((self?.viewModel.safetySecurityDetail?.behaviourId ?? 0) == 116){ //116 is "Yes"
                            var copyArr = self?.arrInput[0] as! [Any]
                            copyArr.insert(self?.viewModel.getBeahviourTypeInput(), at: rowOfBheaviour + 1)
                            copyArr.insert(self?.viewModel.getBehaviourTimeInput(), at: rowOfBheaviour + 2)
                            self?.arrInput[0] = copyArr
                        }
                    })
                    
                }else if self?.selectedSection == NursingSections.PersonalHygiene.rawValue{
                    //Set bath fields if bath is "YES"
                    self?.getArrayIndexFromTitle(title: NursingTitles.PersonalHygiene.Bath, completion: { (rowOfBath) in
                        if ((self?.viewModel.personalHygieneDetail?.bathId ?? 0) == 116){ //116 is "Yes"
                            var copyArr = self?.arrInput[0] as! [Any]
                            copyArr.insert(self?.viewModel.getBathType(), at: rowOfBath + 1)
                            copyArr.insert(self?.viewModel.getBathTemperature(), at: rowOfBath + 2)
                            self?.arrInput[0] = copyArr
                        }
                    })
                    
                }
                
                self?.tblView.reloadData()
            }
        }
        
    }
    func getArrayIndexFromTitle(title : String,completion:@escaping (Int) -> Void){
        var row = 0
        if let arr =  self.arrInput as? [Any]{
            if let copy = arr [0] as? [Any]{
                for (index,item) in copy.enumerated() {
                    if let dict = item as? InputTextfieldModel{
                        if (dict.placeholder ?? "") == title {
                            row = index
                        }
                    }
                }
            }
        }
        completion(row)
    }
    func addrightBarButtonItem() {
        let rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target:  self, action: #selector(onRightBarButtonItemClicked(_ :)))
        rightBarButtonItem.tintColor = UIColor.white
        navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    // MARK:
    func prepareDataForAPI(){
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
            AppInstance.shared.safetyNCFParams = self.createAPIParams(isDraft: false, moodID: idToUpdate)
            
        case NursingSections.PersonalHygiene.rawValue:
            paramsCountLimit = ((inputParams[Key.Params.NursingCareFlow.PersonalHygiene.bathId] as? Int) ?? 0) == 116 ? 11 : 8
            idToUpdate = self.viewModel.personalHygieneDetail?.id ?? 0
            apiName = APITargetPoint.save_NCF_PersonalHygiene
            AppInstance.shared.hygieneNCFParams = self.createAPIParams(isDraft: false, moodID: idToUpdate)
            
        case NursingSections.Activity.rawValue:
            paramsCountLimit = 13
            idToUpdate = self.viewModel.activityDetail?.id ?? 0
            apiName = APITargetPoint.save_NCF_Activity
            AppInstance.shared.activityNCFParams = self.createAPIParams(isDraft: false, moodID: idToUpdate)
            
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
            AppInstance.shared.sleepNCFParams = self.createAPIParams(isDraft: false, moodID: idToUpdate)
        default:
            print("Do nothing")
        }
        if selectedSection == NursingSections.Safety.rawValue{
            if copyParams.keys.count >= 11{
                self.delegate?.didFinishForm(isDraft: false, selectedSection: self.selectedSection)
                self.navigationController?.popViewController(animated: true)
                AppInstance.shared.shouldUpdateDraftStatus = true
                
            }else{
                self.viewModel.errorMessage = "Please fill missing inputs."
            }
        }else{
            if copyParams.keys.count == paramsCountLimit{
                self.delegate?.didFinishForm(isDraft: false, selectedSection: self.selectedSection)
                
                self.navigationController?.popViewController(animated: true)
                AppInstance.shared.shouldUpdateDraftStatus = true
                
            }else{
                self.viewModel.errorMessage = "Please fill missing inputs."
            }
        }
    }
    @objc func onRightBarButtonItemClicked(_ sender: UIBarButtonItem) {
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
        }
    }
    @IBAction func saveAsDraftBtn_clicked(_ sender: Any) {
        var apiName = ""
        var idToUpdate = 0
        switch selectedSection {
        case NursingSections.Safety.rawValue:
            idToUpdate = self.viewModel.safetySecurityDetail?.id ?? 0
            self.getSaftySecurityData()
            apiName = APITargetPoint.save_NCF_Safety
            SharedAccessEMR.sharedInstance.patientActiveStatus = ""
        case NursingSections.PersonalHygiene.rawValue:
            idToUpdate = self.viewModel.personalHygieneDetail?.id ?? 0
            apiName = APITargetPoint.save_NCF_PersonalHygiene
        case NursingSections.Activity.rawValue:
            idToUpdate = self.viewModel.activityDetail?.id ?? 0
            apiName = APITargetPoint.save_NCF_Activity
        case NursingSections.Sleep.rawValue:
            idToUpdate = self.viewModel.sleepRestDetail?.id ?? 0
            apiName = APITargetPoint.save_NCF_Sleep
        default:
            print("Do nothing")
        }
        self.delegate?.didFinishForm(isDraft: true, selectedSection: self.selectedSection)
        
        self.viewModel.saveNursingCare(apiName: apiName, params: self.createAPIParams(isDraft: true, moodID: idToUpdate))
        AppInstance.shared.shouldUpdateDraftStatus = true
    }
    
    @IBAction func resetBtn_clicked(_ sender: Any) {
        
        UIAlertController.showAlert(title: Alert.Title.appName, message: Alert.Message.reset, preferredStyle: .alert, sender: nil , target: self, actions:.Yes,.No) { (AlertAction) in
            switch AlertAction {
            case .Yes:
                //======= for turning off Validation
                self.isValidating = false
                //======= Ends
                self.resetAPICall()
                self.viewModel.personalHygieneDetail = nil
                self.viewModel.safetySecurityDetail = nil
                self.viewModel.sleepRestDetail = nil
                self.viewModel.activityDetail = nil
                self.arrInput = self.viewModel.getInputArray()
                self.tblView.reloadData()
                self.tblView.scrollRectToVisible(CGRect.zero, animated: true)
                
            default:
                break
            }
        }
        
    }
    func resetAPICall(){
        var apiName = ""
        var idToUpdate = 0
        switch selectedSection {
            
        case NursingSections.Safety.rawValue:
            idToUpdate = self.viewModel.safetySecurityDetail?.id ?? 0
            apiName = APITargetPoint.SafetyAndSecurity_Discard
            
        case NursingSections.PersonalHygiene.rawValue:
            idToUpdate = self.viewModel.personalHygieneDetail?.id ?? 0
            apiName = APITargetPoint.PersonalHygiene_Discard
            
        case NursingSections.Activity.rawValue:
            idToUpdate = self.viewModel.activityDetail?.id ?? 0
            apiName = APITargetPoint.ActivityExercise_Discard
            
        case NursingSections.Sleep.rawValue:
            idToUpdate = self.viewModel.sleepRestDetail?.id ?? 0
            apiName = APITargetPoint.SleepRestAndComfort_Discard
            
        default:
            print("Do nothing")
        }
        if idToUpdate == 0{
            
        }else{
            self.viewModel.deleteNursingCare(apiName: apiName, params: ["Id" : "\(idToUpdate)"])
        }
        
    }
    
    func createAPIParams(isDraft : Bool, moodID: Int) -> [String : Any]{
        var keyMainArray = [( String , Any?)]()
        for (_,arrObj) in self.arrInput.enumerated() {
            if let dict = arrObj as? InputTextfieldModel{
                keyMainArray.append(((dict.apiKey ?? "") , (dict.valueId ?? "")))
            }
            if let dictArr = arrObj as? [Any]{
                for (_,dictObj) in dictArr.enumerated() {
                    if let dict = dictObj as? [InputTextfieldModel]{
                        let firstObj = dict[0]
                        let secondObj = dict[1]
                        keyMainArray.append(((firstObj.apiKey ?? "") , (firstObj.valueId ?? "")))
                        keyMainArray.append( ((secondObj.apiKey ?? "") , (secondObj.valueId ?? "")))
                    }else if let dict = dictObj as? InputTextfieldModel{
                        keyMainArray.append(((dict.apiKey ?? "") , (dict.valueId ?? "")))
                    }
                    
                }
            }
        }
        var paramDict : [String : Any] = [:]
        keyMainArray += keyMainArray
        for (_,(key,value)) in keyMainArray.enumerated() {
            if let val  = value as? String{
                if val != ""{
                    paramDict[key] = value
                }
            }else if let val  = value as? Int{
                if val != 0{
                    paramDict[key] = value
                }
            }else{
                paramDict[key] = value
            }
        }
        paramDict[Key.Params.patientId] = self.patientId
        paramDict[Key.Params.id] = moodID
        paramDict[Key.Params.isDraft] = isDraft
        if self.selectedSection == NursingSections.Safety.rawValue{
            paramDict[Key.Params.NursingCareFlow.Safety.behaviorTypes] = [[Key.Params.NursingCareFlow.Safety.behaviourId : paramDict[Key.Params.NursingCareFlow.Safety.behaviourTypeId] as? Int ?? 0]]
        }
        
        return paramDict
    }
    
}
//MARK:- UITableViewDelegate,UITableViewDataSource

extension NursingCareFormViewController : UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.arrInput.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let arr = (self.arrInput[indexPath.section] as? [Any]){
            let inputDict = arr[indexPath.row]
            //self.arrInput[indexPath.row]
            if let dict = inputDict as? InputTextfieldModel {
                if  dict.inputType  == InputType.Title{
                    return Device.IS_IPAD ? 40 : 30//UITableView.automaticDimension
                }
            }
        }
        return Device.IS_IPAD ? 80 : 60//UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let arr = (self.arrInput[section] as? [Any]){
            return arr.count
        }else{
            if let singleInput = self.arrInput[section] as? InputTextfieldModel{
                return 1
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
        // return 40
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 40))
        headerView.backgroundColor = UIColor.white
        
        let lblSection = UILabel(frame: CGRect(x: 15, y: 0, width: tableView.frame.size.width - 20, height: 40))
        lblSection.textColor = Color.Blue
        lblSection.text =  self.viewModel.titleForHeader(section: section)
        lblSection.font = UIFont.PoppinsMedium(fontSize: 18)
        headerView.addSubview(lblSection)
        
        
        //headerView.borderWidth = 1.0
        //headerView.borderColor = Color.Line
        
        return headerView
    }
    func getUserInteractionForCell()-> Bool{
        if checkActiveStatus.count >= 1{
            if checkActiveStatus == "Active"{
                return true
            }else{
                return false
            }
        }else{
            if UserDefaults.getPatientStatus() == "Active"{
                return true
            }else{
                return false
            }
        }
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        if let arr = (self.arrInput[indexPath.section] as? [Any]){
            let inputDict = arr[indexPath.row]
            //self.arrInput[indexPath.row]
            if let dict = inputDict as? InputTextfieldModel {
                let inputType = dict.inputType
                switch inputType {
                case InputType.Title:
                    let cell = tableView.dequeueReusableCell(withIdentifier: ReuseIdentifier.TitleCell, for: indexPath as IndexPath) as! TitleCell
                    if getUserInteractionForCell(){
                        cell.isUserInteractionEnabled = true
                    }else{
                        cell.isUserInteractionEnabled = false
                    }
                    cell.lblTitle.text = dict.placeholder ?? ""
                    cell.btnAdd.isHidden = true
                    cell.selectionStyle = .none
                    return cell
                    
                case InputType.Text:
                    let cell = tableView.dequeueReusableCell(withIdentifier: ReuseIdentifier.TextInputCell, for: indexPath as IndexPath) as! TextInputCell
                    if getUserInteractionForCell(){
                        cell.isUserInteractionEnabled = true
                    }else{
                        cell.isUserInteractionEnabled = false
                    }
                    cell.inputTf.tag = indexPath.row
                    cell.inputTf.placeholder = dict.placeholder ?? ""
                    self.updateTextfieldAppearance(inputTf: cell.inputTf, dict: dict)
                    
                    cell.inputTf.delegate = self
                    cell.inputTf.text = dict.value ?? ""
                    cell.selectionStyle = .none
                    return cell
                case InputType.Dropdown:
                    let cell = tableView.dequeueReusableCell(withIdentifier: ReuseIdentifier.PickerInputCell, for: indexPath as IndexPath) as! PickerInputCell
                    
                    if getUserInteractionForCell(){
                        cell.isUserInteractionEnabled = true
                    }else{
                        if ((dict.placeholder ?? "") == NursingTitles.Safety.ResidentStatus){
                            cell.isUserInteractionEnabled = true
                        }else{
                            cell.isUserInteractionEnabled = false
                        }
                    }
                    cell.inputTf.tag = indexPath.row
                    cell.inputTf.delegate = self
                    self.updateTextfieldAppearance(inputTf: cell.inputTf, dict: dict)
                    //cell.lblTitle.text =  dict.placeholder ?? ""
                    //cell.inputTf.title = ""
                    cell.inputTf.placeholder = dict.placeholder ?? ""
                    print("Input text === \(dict.value ?? "")")
                    cell.inputTf.text = dict.value ?? ""
                    cell.arrDropdown = dict.dropdownArr ?? [Any]()
                    cell.pickerView.reloadAllComponents()
                    cell.selectionStyle = .none
                    cell.delegate = self
                    return cell
                    
                case InputType.Time:
                    let cell = tableView.dequeueReusableCell(withIdentifier: ReuseIdentifier.DateTimeInputCell, for: indexPath as IndexPath) as! DateTimeInputCell
                    if getUserInteractionForCell(){
                        cell.isUserInteractionEnabled = true
                    }else{
                        cell.isUserInteractionEnabled = false
                    }
                    cell.inputTf.tag = indexPath.row
                    cell.isDateField = false
                    cell.inputTf.delegate = self
                    cell.delegate = self
                    cell.inputTf.placeholder = dict.placeholder ?? ""
                    cell.setupDatePicker()
                    //                if (dict.value ?? "").count != 0{
                    //                    cell.inputTf.text = dict.value ?? ""
                    //                }
                    cell.inputTf.text = dict.value ?? ""
                    cell.selectionStyle = .none
                    return cell
                default:
                    return UITableViewCell()
                }
            }else{
                if let dictArr = inputDict as? [InputTextfieldModel] , dictArr.count == 2{
                    let cell = tableView.dequeueReusableCell(withIdentifier: ReuseIdentifier.DoubleInputCell, for: indexPath as IndexPath) as! DoubleInputCell
                    if getUserInteractionForCell(){
                        cell.isUserInteractionEnabled = true
                    }else{
                        cell.isUserInteractionEnabled = false
                    }
                    let tfOneDict = dictArr[0]
                    let tfTwoDict = dictArr[1]
                    
                    self.updateTextfieldAppearance(inputTf: cell.inputTf1, dict: tfOneDict)
                    self.updateTextfieldAppearance(inputTf: cell.inputTf2, dict: tfTwoDict)
                    
                    cell.inputTf1.tag = indexPath.row + TagConstants.DoubleTF_FirstTextfield_Tag
                    cell.inputTf2.tag = indexPath.row + TagConstants.DoubleTF_SecondTextfield_Tag
                    cell.inputTf1.delegate = self
                    cell.inputTf2.delegate = self
                    //cell.lblTitle.text = tfOneDict.placeholder ?? ""
                    cell.inputTf1.placeholder = tfOneDict.placeholder ?? ""
                    cell.inputT1_type = tfOneDict.inputType ?? ""
                    if (tfOneDict.inputType ?? "") == InputType.Dropdown{
                        cell.arrDropdown1 = tfOneDict.dropdownArr ?? [Any]()
                        cell.pickerView.reloadAllComponents()
                    }
                    if (tfOneDict.value ?? "").count != 0{
                        cell.inputTf1.text = tfOneDict.value ?? ""
                    }else{
                        cell.inputTf1.text = ""
                    }
                    
                    cell.inputTf2.placeholder = tfTwoDict.placeholder ?? ""
                    cell.inputT2_type = tfTwoDict.inputType ?? ""
                    if (tfTwoDict.inputType ?? "") == InputType.Dropdown{
                        cell.arrDropdown2 = tfTwoDict.dropdownArr ?? [Any]()
                        cell.pickerView.reloadAllComponents()
                    }
                    if (tfTwoDict.value ?? "").count != 0{
                        cell.inputTf2.text = tfTwoDict.value ?? ""
                    }else{
                        cell.inputTf2.text = ""
                    }
                    
                    cell.awakeFromNib()
                    
                    
                    cell.inputTf1.tag = indexPath.row + TagConstants.DoubleTF_FirstTextfield_Tag
                    cell.inputTf2.tag = indexPath.row + TagConstants.DoubleTF_SecondTextfield_Tag
                    cell.delegate = self
                    cell.selectionStyle = .none
                    return cell
                }
            }
        }else{
            if let dict = self.arrInput[indexPath.section] as? InputTextfieldModel {
                let inputType = dict.inputType
                switch inputType {
                case InputType.Text:
                    let cell = tableView.dequeueReusableCell(withIdentifier: ReuseIdentifier.TextInputCell, for: indexPath as IndexPath) as! TextInputCell
                    if getUserInteractionForCell(){
                        cell.isUserInteractionEnabled = true
                    }else{
                        cell.isUserInteractionEnabled = false
                    }
                    cell.inputTf.tag = indexPath.row
                    cell.inputTf.placeholder = dict.placeholder ?? ""
                    self.updateTextfieldAppearance(inputTf: cell.inputTf, dict: dict)
                    
                    cell.inputTf.delegate = self
                    cell.selectionStyle = .none
                    return cell
                default:
                    return UITableViewCell()
                }
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func updateTextfieldAppearance(inputTf : InputTextField, dict : InputTextfieldModel){
        if self.isValidating{
            inputTf.lineColor = (dict.isValid ?? false) ? Color.Line : Color.Error
            inputTf.errorMessage = (dict.isValid ?? false) ? "" : (dict.errorMessage ?? "")
        }else{
            inputTf.lineColor =  Color.Line
            inputTf.errorMessage = ""
        }
    }
    
    
    @objc func deleteButton_clicked(button : UIButton) {
        if self.canDeleteRecursiveCell(inputArr: self.arrInput){
            self.arrInput.remove(at: button.tag)
            self.tblView.reloadData()
        }
    }
    
    func canDeleteRecursiveCell(inputArr : [Any]) -> Bool{
        let arrWithRecursive = inputArr.compactMap { (item) -> Any? in
            if let dict = item as?  [InputTextfieldModel]{
                return dict.count == 3 ? dict : nil
            }
            return nil
        }
        return arrWithRecursive.count == 1 ? false : true
    }
    
    func canAddRecursiveCell(inputArr : [Any]) -> Bool{
        let arrWithRecursive = inputArr.compactMap { (item) -> Any? in
            if let dict = item as?  [InputTextfieldModel]{
                return dict.count == 3 ? dict : nil
            }
            return nil
        }
        return arrWithRecursive.count == 3 ? false : true
    }
}
//MARK:- UITextFieldDelegate
extension NursingCareFormViewController : UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if self.isValidating {
            self.isValidating = false
            self.tblView.reloadData()
        }
        if let activeTf = textField as? InputTextField{
            self.activeTextfield = activeTf
        }
        AppInstance.shared.activeTextfieldIndex = textField.tag
        self.activeTextfieldTag = textField.tag
        //Set defualt/selected value on textfield tap
        if let tfToUpdate = textField as? InputTextField{
            tfToUpdate.lineColor =  Color.Line
            tfToUpdate.errorMessage = ""
            
            DispatchQueue.main.async {
                if tfToUpdate.text?.count == 0{
                    
                    //let index = self.getIndexAndSubIndexFromTag(textFieldTag: self.activeTextfieldTag).0
                    //let dictIndex = self.getIndexAndSubIndexFromTag(textFieldTag: self.activeTextfieldTag).1
                    
                    if let cell = textField.superview?.superview as? PickerInputCell{
                        if let indexPath = self.tblView.indexPath(for: (cell)) {
                            if let arrInput = self.arrInput[indexPath.section] as? [Any]{
                                if let dictArr = arrInput[indexPath.row] as? [InputTextfieldModel]{
                                    
                                    var copyArr = dictArr
                                    let dict = copyArr[indexPath.row]
                                    if ((dict.inputType ?? "") == InputType.Dropdown){
                                        if let cell = self.tblView.cellForRow(at: indexPath) as? PickerInputCell{
                                            cell.pickerView.reloadAllComponents()
                                        }
                                        
                                        if let arr = dict.dropdownArr as? [Any]{
                                            let selectedValue = Utility.getSelectedValue(arrDropdown: arr,row: 0)
                                            
                                            dict.value = selectedValue.value
                                            dict.valueId = selectedValue.valueID
                                            dict.isValid = true
                                            copyArr[indexPath.row] = dict
                                            self.arrInput[indexPath.section] = copyArr
                                            textField.text = selectedValue.value
                                            
                                            
                                        }
                                    }
                                }else if let dict = arrInput[indexPath.row] as? InputTextfieldModel{
                                    var copyArr = arrInput
                                    
                                    if ((dict.inputType ?? "") == InputType.Dropdown){
                                        if let cell = self.tblView.cellForRow(at: indexPath) as? PickerInputCell{
                                            cell.pickerView.reloadAllComponents()
                                        }
                                        
                                        if let arr = dict.dropdownArr as? [Any]{
                                            let selectedValue = Utility.getSelectedValue(arrDropdown: arr,row: 0)
                                            
                                            dict.value = selectedValue.value
                                            dict.valueId = selectedValue.valueID
                                            dict.isValid = true
                                            copyArr[indexPath.row] = dict
                                            self.arrInput[indexPath.section] = copyArr
                                            textField.text = selectedValue.value
                                            
                                            
                                        }
                                    }
                                    
                                }
                            }else{
                                if let dictArr = (self.arrInput[indexPath.section] as? [Any]){
                                    var copyArr = dictArr
                                    if let dict = dictArr[indexPath.row] as? InputTextfieldModel{
                                        if ((dict.inputType ?? "") == InputType.Dropdown){
                                            if let cell = self.tblView.cellForRow(at: indexPath) as? PickerInputCell{
                                                cell.pickerView.reloadAllComponents()
                                            }
                                            
                                            if let arr = dict.dropdownArr as? [Any]{
                                                let selectedValue = Utility.getSelectedValue(arrDropdown: arr,row: 0)
                                                
                                                dict.value = selectedValue.value
                                                dict.valueId = selectedValue.valueID
                                                dict.isValid = true
                                                copyArr[indexPath.row] = dict
                                                self.arrInput[indexPath.section] = copyArr
                                                textField.text = selectedValue.value
                                            }
                                        }
                                        
                                    }
                                }
                            }
                        }
                    }else if let cell = textField.superview?.superview as? DateTimeInputCell{
                        if let indexPath = self.tblView.indexPath(for: (cell)) {
                            if let dictArr = (self.arrInput[indexPath.section] as! [Any]) as? [InputTextfieldModel]{
                                
                                var copyArr = dictArr
                                let dict = copyArr[indexPath.row]
                                
                                if ((dict.inputType ?? "") == InputType.Time){
                                    let isDate = (dict.inputType ?? "") == InputType.Date
                                    let dateStr = Utility.getStringFromDate(date: Date(), dateFormat: isDate ? DateFormats.mm_dd_yyyy : DateFormats.hh_mm_a)
                                    
                                    dict.value = dateStr
                                    dict.valueId = dateStr
                                    dict.isValid = true
                                    copyArr[indexPath.row] = dict
                                    self.arrInput[indexPath.section] = copyArr
                                    textField.text = dateStr
                                }
                            }
                        }
                    }else if let cell = textField.superview?.superview as? DoubleInputCell{
                        if let indexPath = self.tblView.indexPath(for: (cell)) {
                            if let dictArr = (self.arrInput[indexPath.section] as! [Any]) as? [InputTextfieldModel]{
                                
                                var copyArr = dictArr
                                let dict = copyArr[indexPath.row]
                                if ((dict.inputType ?? "") == InputType.Dropdown){
                                    if let cell = self.tblView.cellForRow(at: indexPath) as? DoubleInputCell{
                                        cell.pickerView.reloadAllComponents()
                                    }
                                    
                                    if let arr = dict.dropdownArr as? [Any]{
                                        let selectedValue = Utility.getSelectedValue(arrDropdown: arr,row: 0)
                                        
                                        dict.value = selectedValue.value
                                        dict.valueId = selectedValue.valueID
                                        dict.isValid = true
                                        copyArr[indexPath.row] = dict
                                        self.arrInput[indexPath.section] = copyArr
                                        textField.text = selectedValue.value
                                    }
                                }
                            }else{
                                if let dictArr = (self.arrInput[indexPath.section] as? [Any]){
                                    var copyArr = dictArr
                                    if let dict = dictArr[indexPath.row] as? InputTextfieldModel{
                                        if ((dict.inputType ?? "") == InputType.Dropdown){
                                            if let cell = self.tblView.cellForRow(at: indexPath) as? PickerInputCell{
                                                cell.pickerView.reloadAllComponents()
                                            }
                                            
                                            if let arr = dict.dropdownArr as? [Any]{
                                                let selectedValue = Utility.getSelectedValue(arrDropdown: arr,row: 0)
                                                
                                                dict.value = selectedValue.value
                                                dict.valueId = selectedValue.valueID
                                                dict.isValid = true
                                                copyArr[indexPath.row] = dict
                                                self.arrInput[indexPath.section] = copyArr
                                                textField.text = selectedValue.value
                                            }
                                        }
                                        
                                    }else if let arrSub = dictArr[indexPath.row] as? [InputTextfieldModel]{
                                        var copySubArray = arrSub
                                        let reqdIndex = textField.tag < TagConstants.DoubleTF_SecondTextfield_Tag ? 0 : 1
                                        let dict = arrSub[reqdIndex]
                                        if ((dict.inputType ?? "") == InputType.Dropdown){
                                            if let cell = self.tblView.cellForRow(at: indexPath) as? DoubleInputCell{
                                                cell.pickerView.reloadAllComponents()
                                            }
                                            
                                            if let arr = dict.dropdownArr as? [Any]{
                                                let selectedValue = Utility.getSelectedValue(arrDropdown: arr,row: 0)
                                                
                                                dict.value = selectedValue.value
                                                dict.valueId = selectedValue.valueID
                                                dict.isValid = true
                                                copySubArray[reqdIndex] = dict
                                                copyArr[indexPath.row] = copySubArray
                                                self.arrInput[indexPath.section] = copyArr
                                                textField.text = selectedValue.value
                                            }
                                        }
                                        
                                    }
                                }
                            }
                        }
                    }
                }
                
                /*
                 
                 if tfToUpdate.text?.count == 0{
                 let index = self.getIndexAndSubIndexFromTag(textFieldTag: self.activeTextfieldTag).0
                 let dictIndex = self.getIndexAndSubIndexFromTag(textFieldTag: self.activeTextfieldTag).1
                 if let cell = textField.superview?.superview as? DoubleInputCell{
                 if let indexPath = self.tblView.indexPath(for: (cell)) {
                 if let dictArr = (self.arrInput[indexPath.section] as! [Any]) as? [InputTextfieldModel]{
                 var copyArr = dictArr
                 let dict = copyArr[dictIndex]
                 
                 if ((dict.inputType ?? "") == InputType.Dropdown){
                 if let cell = self.tblView.cellForRow(at: indexPath) as? DoubleInputCell{
                 cell.pickerView.reloadAllComponents()
                 }
                 
                 if let arr = dict.dropdownArr as? [Any]{
                 let selectedValue = Utility.getSelectedValue(arrDropdown: arr,row: 0)
                 
                 dict.value = selectedValue.value
                 dict.valueId = selectedValue.valueID
                 dict.isValid = true
                 copyArr[dictIndex] = dict
                 self.arrInput[index] = copyArr
                 textField.text = selectedValue.value
                 }
                 
                 //                                    let tempDict = inputDict
                 //                                    if let arr = tempDict.dropdownArr as? [Any]{
                 //                                        let selectedValue = Utility.getSelectedValue(arrDropdown: arr,row: 0)
                 //                                        tempDict.value = selectedValue.value
                 //                                        tempDict.valueId = selectedValue.valueID
                 //                                        tempDict.isValid = true
                 //                                        self.arrInput[self.activeTextfieldTag] = tempDict
                 //                                        textField.text = selectedValue.value
                 //                                    }
                 
                 }
                 }else{
                 var copyMainArray = self.arrInput
                 var copySubArray = self.arrInput[indexPath.section] as! [Any]
                 if let dictArr = (self.arrInput[indexPath.section] as! [Any])[indexPath.row] as? [InputTextfieldModel]{
                 var copyArr = dictArr
                 let dict = copyArr[dictIndex]
                 if (dict.inputType ?? "") == InputType.Date || (dict.inputType ?? "") == InputType.Time{
                 let isDate = (dict.inputType ?? "") == InputType.Date
                 let dateStr = Utility.getStringFromDate(date: Date(), dateFormat: isDate ? DateFormats.mm_dd_yyyy : DateFormats.hh_mm_a)
                 
                 dict.value = dateStr
                 dict.valueId = Date()
                 dict.isValid = true
                 copyArr[dictIndex] = dict
                 //self.arrInput[index] = copyArr
                 
                 copySubArray[indexPath.row] = copyArr
                 copyMainArray[indexPath.section] = copySubArray
                 self.arrInput = copyMainArray
                 
                 textField.text = dateStr
                 }else if ((dict.inputType ?? "") == InputType.Dropdown){
                 if let arr = dict.dropdownArr as? [Any]{
                 let selectedValue = Utility.getSelectedValue(arrDropdown: arr,row: 0)
                 
                 dict.value = selectedValue.value
                 dict.valueId = selectedValue.valueID
                 dict.isValid = true
                 copyArr[dictIndex] = dict
                 //self.arrInput[index] = copyArr
                 copySubArray[indexPath.row] = copyArr
                 copyMainArray[indexPath.section] = copySubArray
                 self.arrInput = copyMainArray
                 
                 textField.text = selectedValue.value
                 }
                 }else{
                 dict.value = textField.text
                 dict.valueId = textField.text
                 dict.isValid = true
                 copyArr[dictIndex] = dict
                 self.arrInput[index] = copyArr
                 
                 }
                 }
                 }
                 }
                 }else{
                 
                 if let inputDict = self.arrInput[index] as? InputTextfieldModel{
                 if ((inputDict.inputType ?? "") == InputType.Dropdown){
                 let tempDict = inputDict
                 if let arr = tempDict.dropdownArr as? [Any]{
                 let selectedValue = Utility.getSelectedValue(arrDropdown: arr,row: 0)
                 tempDict.value = selectedValue.value
                 tempDict.valueId = selectedValue.valueID
                 tempDict.isValid = true
                 self.arrInput[self.activeTextfieldTag] = tempDict
                 textField.text = selectedValue.value
                 }
                 
                 }
                 }else{
                 if let dictArr = self.arrInput[index] as? [InputTextfieldModel]{
                 var copyArr = dictArr
                 let dict = copyArr[dictIndex]
                 if (dict.inputType ?? "") == InputType.Date || (dict.inputType ?? "") == InputType.Time{
                 let isDate = (dict.inputType ?? "") == InputType.Date
                 let dateStr = Utility.getStringFromDate(date: Date(), dateFormat: isDate ? DateFormats.mm_dd_yyyy : DateFormats.hh_mm_a)
                 
                 dict.value = dateStr
                 dict.valueId = Date()
                 dict.isValid = true
                 copyArr[dictIndex] = dict
                 self.arrInput[index] = copyArr
                 textField.text = dateStr
                 }else if ((dict.inputType ?? "") == InputType.Dropdown){
                 if let arr = dict.dropdownArr as? [Any]{
                 let selectedValue = Utility.getSelectedValue(arrDropdown: arr,row: 0)
                 
                 dict.value = selectedValue.value
                 dict.valueId = selectedValue.valueID
                 dict.isValid = true
                 copyArr[dictIndex] = dict
                 self.arrInput[index] = copyArr
                 textField.text = selectedValue.value
                 }
                 }else{
                 dict.value = textField.text
                 dict.valueId = textField.text
                 dict.isValid = true
                 copyArr[dictIndex] = dict
                 self.arrInput[index] = copyArr
                 
                 }
                 }
                 }
                 }
                 }else{
                 if let cell = textField.superview?.superview as? DoubleInputCell{
                 cell.pickerView.reloadAllComponents()
                 }
                 }
                 */
                
            }
            //                    else{
            //                        self.updateTextfieldAndPickerForRow(row:  self.getSelectedValueIndex(valueTitle: tfToUpdate.text!, textfieldTag: textField.tag), tfToUpdate: textField as! InputTextField)
            //                    }
        }
    }
    
    func updateTextfieldAndPickerForRow(row: Int, tfToUpdate : InputTextField){
        
        
    }
    
    func getSelectedValueIndex(valueTitle : String, textfieldTag : Int) -> Int{
        //let dict = self.arrInput[textfieldTag]
        return 0
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Here Set The Next return field
        if textField.tag == self.arrInput.count - 1{
            textField.resignFirstResponder()
            return true
        }
        DispatchQueue.main.async {
            if  textField.tag - TagConstants.DoubleTF_FirstTextfield_Tag > 0 && textField.tag - TagConstants.DoubleTF_FirstTextfield_Tag < TagConstants.DoubleTF_FirstTextfield_Tag{
                let tagTf =  textField.tag - TagConstants.DoubleTF_FirstTextfield_Tag
                var indeXPath = IndexPath(row: tagTf, section: 0)
                if let indexPath = self.tblView.indexPath(for: (self.activeTextfield?.superview?.superview as! DoubleInputCell)){
                    indeXPath = indexPath
                }
                if let cell = self.tblView.cellForRow(at: indeXPath){
                    if cell.isKind(of: DoubleInputCell.self){
                        (cell as! DoubleInputCell).inputTf2.becomeFirstResponder()
                    }
                }
            }else{
                let tagTf = textField.tag >= TagConstants.DoubleTF_SecondTextfield_Tag ? textField.tag - TagConstants.DoubleTF_SecondTextfield_Tag : textField.tag
                var indeXPath = IndexPath(row: tagTf, section: 0)
                if let indexPath = self.tblView.indexPath(for: (self.activeTextfield?.superview?.superview as! DoubleInputCell)){
                    indeXPath = indexPath
                }
                
                if let cell = self.tblView.cellForRow(at: indeXPath){
                    if cell.isKind(of: PickerInputCell.self){
                        (cell as! PickerInputCell).inputTf.becomeFirstResponder()
                    }
                    else {
                        textField.resignFirstResponder()
                    }
                }
            }
        }
        return true
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        // Here Set The Next return field
        if textField.tag == self.arrInput.count - 1{
            IQKeyboardManager.shared.toolbarDoneBarButtonItemText = ButtonTitles.done
            textField.keyboardToolbar.doneBarButton.setTarget(self, action: #selector(doneAction(textField:)))
            
        }else{
            IQKeyboardManager.shared.toolbarDoneBarButtonItemText = ButtonTitles.next
            textField.keyboardToolbar.doneBarButton.setTarget(self, action: #selector(nextAction(textField:)))
            
        }
        return true
    }
    @objc func doneAction(textField:UITextField){
        self.tableReloadSaftySecurityData()
        if textField.tag == self.arrInput.count - 1{
            textField.resignFirstResponder()
        }
    }
    
    @objc func nextAction(textField:UITextField){
        if textField.tag == self.arrInput.count - 1{
            textField.resignFirstResponder()
        }
        DispatchQueue.main.async {
            if  textField.tag - TagConstants.DoubleTF_FirstTextfield_Tag > 0 && textField.tag - TagConstants.DoubleTF_FirstTextfield_Tag < TagConstants.DoubleTF_FirstTextfield_Tag{
                var indeXPath = IndexPath(row: textField.tag - TagConstants.DoubleTF_FirstTextfield_Tag, section: 0)
                if let indexPath = self.tblView.indexPath(for: (self.activeTextfield?.superview?.superview as! DoubleInputCell)){
                    indeXPath = indexPath
                }
                
                
                if let cell = self.tblView.cellForRow(at: indeXPath){
                    if cell.isKind(of: DoubleInputCell.self){
                        (cell as! DoubleInputCell).inputTf2.becomeFirstResponder()
                    }
                }
            }else{
                let tagTf = textField.tag >= TagConstants.DoubleTF_SecondTextfield_Tag ? textField.tag - TagConstants.DoubleTF_SecondTextfield_Tag : textField.tag
                var indeXPath = IndexPath(row: tagTf + 1, section: 0)
                
                if let cell = self.activeTextfield?.superview?.superview as? DoubleInputCell{
                    if let indexPath = self.tblView.indexPath(for:cell){
                        indeXPath = indexPath
                    }
                }
                
                if let cell = self.activeTextfield?.superview?.superview as? PickerInputCell{
                    if let indexPath = self.tblView.indexPath(for:cell){
                        indeXPath = IndexPath(row: indexPath.row + 1, section: indexPath.section)
                    }
                }
                
                if let cell = self.tblView.cellForRow(at: indeXPath ){
                    if cell.isKind(of: PickerInputCell.self){
                        (cell as! PickerInputCell).inputTf.becomeFirstResponder()
                    }
                    else {
                        textField.resignFirstResponder()
                    }
                }
            }
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        let indexTuple = self.getIndexAndSubIndexFromTag(textFieldTag: textField.tag)
        var index = indexTuple.0
        let dictIndex = indexTuple.1
        
        if textField.tag < TagConstants.DoubleTF_FirstTextfield_Tag{
            if let cell = self.activeTextfield?.superview?.superview as? TextInputCell{
                if let indexPath = self.tblView.indexPath(for: (cell)){
                    index = indexPath.section
                }
            }
            
            if let cell = textField.superview?.superview as? PickerInputCell{
                if let indexPath = self.tblView.indexPath(for: (cell)) {
                    if let arrInput = self.arrInput[indexPath.section] as? [Any]{
                        if let dictArr = arrInput as? [Any]{
                            var copyArr = dictArr
                            if let dict = copyArr[indexPath.row] as? InputTextfieldModel{
                                if ((dict.inputType ?? "") == InputType.Dropdown){
                                    if ((dict.placeholder ?? "") == NursingTitles.Safety.Fall){
                                        if ((dict.valueId as? Int) ?? 0 == 116){ //116 is "Yes"
                                            let containsFallFields = dictArr.compactMap { (entity) -> InputTextfieldModel? in
                                                if let ent = entity as? InputTextfieldModel{
                                                    return (ent.placeholder ?? "") == NursingTitles.Safety.TimeOfFall ? ent : nil
                                                }
                                                return nil
                                            }
                                            if containsFallFields.count == 0{
                                                copyArr.insert(self.viewModel.getFallTimeInput(), at: indexPath.row + 1)
                                                copyArr.insert(self.viewModel.getFallTypeInput(), at: indexPath.row + 2)
                                                self.arrInput[indexPath.section] = copyArr
                                                self.tblView.reloadData()
                                            }
                                        }else{
                                            for (index,object) in copyArr.enumerated(){
                                                if let ent = object as? InputTextfieldModel{
                                                    
                                                    if (ent.placeholder ?? "") == NursingTitles.Safety.FallType{
                                                        copyArr.remove(at: index)
                                                    }
                                                }
                                            }
                                            for (index,object) in copyArr.enumerated(){
                                                if let ent = object as? InputTextfieldModel{
                                                    
                                                    if (ent.placeholder ?? "") == NursingTitles.Safety.TimeOfFall{
                                                        copyArr.remove(at: index)
                                                    }
                                                }
                                            }
                                            self.arrInput[indexPath.section] = copyArr
                                            self.tblView.reloadData()
                                        }
                                    }
                                    
                                    if ((dict.placeholder ?? "") == NursingTitles.Safety.Behaviour){
                                        if ((dict.valueId as? Int) ?? 0 == 116){ //116 is "Yes"
                                            let containsFallFields = dictArr.compactMap { (entity) -> InputTextfieldModel? in
                                                if let ent = entity as? InputTextfieldModel{
                                                    
                                                    return (ent.placeholder ?? "") == NursingTitles.Safety.BehaviourType ? ent : nil
                                                }
                                                return nil
                                                
                                            }
                                            if containsFallFields.count == 0{
                                                copyArr.insert(self.viewModel.getBeahviourTypeInput(), at: indexPath.row + 1)
                                                copyArr.insert(self.viewModel.getBehaviourTimeInput(), at: indexPath.row + 2)
                                                self.arrInput[indexPath.section] = copyArr
                                                self.tblView.reloadData()
                                            }
                                        }else{
                                            for (index,object) in copyArr.enumerated(){
                                                if let ent = object as? InputTextfieldModel{
                                                    
                                                    if (ent.placeholder ?? "") == NursingTitles.Safety.BehaviourType{
                                                        copyArr.remove(at: index)
                                                    }
                                                }
                                            }
                                            for (index,object) in copyArr.enumerated(){
                                                if let ent = object as? InputTextfieldModel{
                                                    
                                                    if (ent.placeholder ?? "") == NursingTitles.Safety.BehaviourTime{
                                                        copyArr.remove(at: index)
                                                    }
                                                }
                                            }
                                            self.arrInput[indexPath.section] = copyArr
                                            self.tblView.reloadData()
                                        }
                                    }
                                    
                                    if ((dict.placeholder ?? "") == NursingTitles.Safety.PressureUlcer){
                                        if ((dict.valueId as? Int) ?? 0 != 149){ //149 is "None"
                                            let containsFallFields = dictArr.compactMap { (entity) -> InputTextfieldModel? in
                                                if let ent = entity as? InputTextfieldModel{
                                                    return (ent.placeholder ?? "") == NursingTitles.Safety.BodySite ? ent : nil
                                                }
                                                return nil
                                                
                                            }
                                            if containsFallFields.count == 0{
                                                copyArr.insert(self.viewModel.getBodySiteInput(bodySite: nil), at: indexPath.row + 1)
                                                self.arrInput[indexPath.section] = copyArr
                                                self.tblView.reloadData()
                                            }
                                        }else{
                                            for (index,object) in copyArr.enumerated(){
                                                if let ent = object as? InputTextfieldModel{
                                                    
                                                    if (ent.placeholder ?? "") == NursingTitles.Safety.BodySite{
                                                        copyArr.remove(at: index)
                                                    }
                                                }
                                            }
                                            self.arrInput[indexPath.section] = copyArr
                                            self.tblView.reloadData()
                                        }
                                    }
                                    if ((dict.placeholder ?? "") == NursingTitles.PersonalHygiene.Bath){
                                        if ((dict.valueId as? Int) ?? 0 == 116){ //116 is "Yes"
                                            let containsFallFields = dictArr.compactMap { (entity) -> InputTextfieldModel? in
                                                if let ent = entity as? InputTextfieldModel{
                                                    
                                                    return (ent.placeholder ?? "") == NursingTitles.PersonalHygiene.BathType ? ent : nil
                                                }
                                                return nil
                                                
                                            }
                                            if containsFallFields.count == 0{
                                                copyArr.insert(self.viewModel.getBathType(), at: indexPath.row + 1)
                                                copyArr.insert(self.viewModel.getBathTemperature(), at: indexPath.row + 2)
                                                self.arrInput[indexPath.section] = copyArr
                                                self.tblView.reloadData()
                                            }
                                        }else{
                                            for (index,object) in copyArr.enumerated(){
                                                if let ent = object as? InputTextfieldModel{
                                                    if (ent.placeholder ?? "") == NursingTitles.PersonalHygiene.BathType{
                                                        copyArr.remove(at: index)
                                                    }
                                                }
                                            }
                                            for (index,object) in copyArr.enumerated(){
                                                if let doubleTectfield = object as? [InputTextfieldModel]{
                                                    copyArr.remove(at: index)
                                                }
                                            }
                                            self.arrInput[indexPath.section] = copyArr
                                            self.tblView.reloadData()
                                        }
                                    }
                                    
                                }
                            }else{
                                if let dict = copyArr[indexPath.row] as? InputTextfieldModel{
                                    dict.value = textField.text
                                    dict.valueId = textField.text
                                    dict.isValid = !(textField.text?.count == 0)
                                    self.arrInput[index] = dict
                                }
                            }
                        }
                    }
                }
            }else if let cell = textField.superview?.superview as? TextInputCell{
                if let indexPath = self.tblView.indexPath(for: (cell)) {
                    if let dictArr = (self.arrInput[indexPath.section] as? [Any]){
                        var copyArr = dictArr
                        if let dict = dictArr[indexPath.row] as? InputTextfieldModel{
                            if ((dict.inputType ?? "") == InputType.Text) || ((dict.inputType ?? "") == InputType.Number) || ((dict.inputType ?? "") == InputType.Decimal){
                                dict.value = textField.text ?? ""
                                dict.valueId = textField.text ?? ""
                                dict.isValid = true
                                copyArr[indexPath.row] = dict
                                self.arrInput[indexPath.section] = copyArr
                            }
                        }
                    }
                }
            }
            //            if let dict = self.arrInput[index] as? InputTextfieldModel{
            //                if dict.inputType == InputType.Dropdown {
            //
            //                }else{
            //                    dict.value = textField.text
            //                    dict.valueId = textField.text
            //                    dict.isValid = !(textField.text?.count == 0)
            //                    self.arrInput[index] = dict
            //                }
            //            }else {
            //
            //            }
        }else if textField.tag >= TagConstants.RecursiveTF_FirstTextfield_Tag{
            
            
            if let dict = self.arrInput[index] as? InputTextfieldModel{
                if dict.inputType == InputType.Dropdown {
                    
                }else{
                    dict.value = textField.text
                    dict.valueId = textField.text
                    dict.isValid = !(textField.text?.count == 0)
                    self.arrInput[textField.tag] = dict
                }
                
            }else{
                
                if let dictArr = self.arrInput[index] as? [InputTextfieldModel]{
                    var copyArr = dictArr
                    let dict = copyArr[dictIndex]
                    if dict.inputType == InputType.Dropdown {
                    }else{
                        dict.value = textField.text ?? ""
                        dict.valueId = textField.text
                        dict.isValid = !(textField.text?.count == 0)
                        copyArr[dictIndex] = dict
                        self.arrInput[index] = copyArr
                        
                    }
                }
            }
            
        }else{
            
            
            if let dict = self.arrInput[index] as? InputTextfieldModel{
                if dict.inputType == InputType.Dropdown {
                }else{
                    dict.value = textField.text
                    dict.valueId = textField.text
                    dict.isValid = !(textField.text?.count == 0)
                    self.arrInput[textField.tag] = dict
                }
            }else{
                
                if let dictArr = self.arrInput[index] as? [InputTextfieldModel]{
                    var copyArr = dictArr
                    let dict = copyArr[dictIndex]
                    if dict.inputType == InputType.Dropdown {
                        
                    }else{
                        dict.value = textField.text ?? ""
                        dict.valueId = textField.text
                        dict.isValid = !(textField.text?.count == 0)
                        copyArr[dictIndex] = dict
                        self.arrInput[index] = copyArr
                        
                    }
                }else if let arrInput = self.arrInput[index] as? [Any]{
                    if let cell = textField.superview?.superview as? DoubleInputCell{
                        if let indexPath = self.tblView.indexPath(for: (cell)) {
                            if let dictArr = (self.arrInput[indexPath.section] as? [Any]){
                                var copyArr = dictArr
                                if let arrSub = dictArr[indexPath.row] as? [InputTextfieldModel]{
                                    let reqdIndex = self.activeTextfieldTag < TagConstants.DoubleTF_SecondTextfield_Tag ? 0 : 1
                                    var copySubArray = arrSub
                                    let dict = arrSub[reqdIndex]
                                    if ((dict.inputType ?? "") == InputType.Text) || ((dict.inputType ?? "") == InputType.Number) || ((dict.inputType ?? "") == InputType.Decimal){
                                        dict.value = textField.text ?? ""
                                        dict.valueId = textField.text ?? ""
                                        dict.isValid = true
                                        copySubArray[reqdIndex] = dict
                                        copyArr[indexPath.row] = copySubArray
                                        self.arrInput[indexPath.section] = copyArr
                                    }
                                    44                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    //Returns (Int,Int) -> (Index,SubIndex)
    func getIndexAndSubIndexFromTag(textFieldTag : Int) -> (Int,Int){
        var index = textFieldTag
        var dictIndex = 0
        if let cell = self.activeTextfield?.superview?.superview as? PickerInputCell{
            if let indexPath = self.tblView.indexPath(for: cell){
                index = indexPath.section
                dictIndex = indexPath.row
            }
        }
        
        if let cell = self.activeTextfield?.superview?.superview as? TitlePickerInputCell{
            if let indexPath = self.tblView.indexPath(for: cell){
                index = indexPath.section
                dictIndex = indexPath.row
            }
        }
        
        if let cell = self.activeTextfield?.superview?.superview as? TextInputCell{
            if let indexPath = self.tblView.indexPath(for: cell){
                index = indexPath.section
                dictIndex = indexPath.row
            }
        }
        
        if let cell = self.activeTextfield?.superview?.superview as? DoubleInputCell{
            if let indexPath = self.tblView.indexPath(for: cell){
                index = indexPath.section
                dictIndex = indexPath.row
            }
        }
        
        
        /*
         if index < TagConstants.DoubleTF_FirstTextfield_Tag{
         }else if textFieldTag >= TagConstants.RecursiveTF_FirstTextfield_Tag{
         let isFirstTf = index - TagConstants.RecursiveTF_FirstTextfield_Tag > 0 && index - TagConstants.RecursiveTF_FirstTextfield_Tag < TagConstants.DoubleTF_FirstTextfield_Tag
         let isSecondTf = index >= TagConstants.RecursiveTF_SecondTextfield_Tag && index < TagConstants.RecursiveTF_ThirdTextfield_Tag
         
         if  isFirstTf{
         index = index - TagConstants.RecursiveTF_FirstTextfield_Tag
         }else if isSecondTf {
         index = index - TagConstants.RecursiveTF_SecondTextfield_Tag
         }else{
         index = index - TagConstants.RecursiveTF_ThirdTextfield_Tag
         }
         
         if let dict = self.arrInput[index] as? InputTextfieldModel{
         }else{
         if  isFirstTf{
         dictIndex = 0
         }else if isSecondTf {
         dictIndex = 1
         }else{
         dictIndex = 2
         }
         }
         }else{
         let isFirstTf = index - TagConstants.DoubleTF_FirstTextfield_Tag >= 0 && index - TagConstants.DoubleTF_FirstTextfield_Tag < TagConstants.DoubleTF_FirstTextfield_Tag
         let isSecondTf = index >= TagConstants.DoubleTF_SecondTextfield_Tag
         
         if  isFirstTf{
         index = index - TagConstants.DoubleTF_FirstTextfield_Tag
         }else if isSecondTf {
         index = index - TagConstants.DoubleTF_SecondTextfield_Tag
         }
         
         if let dict = self.arrInput[index] as? InputTextfieldModel{
         }else{
         if  isFirstTf{
         dictIndex = 0
         }else if isSecondTf {
         dictIndex = 1
         }
         }
         }*/
        
        return (index,dictIndex)
    }
    func getSaftySecurityData(){
        if let arrInput = self.arrInput[0] as? [Any]{
            if let dictArr = arrInput as? [Any]{
                let copyArr = dictArr
                if let dict = copyArr[0] as? InputTextfieldModel{
                    if ((dict.inputType ?? "") == InputType.Dropdown){
                        if ((dict.placeholder ?? "") == NursingTitles.Safety.ResidentStatus){
                            UserDefaults.setPatientStatus(token: dict.value ?? "")
                        }
                    }
                }
            }
        }
    }
    func tableReloadSaftySecurityData(){
        if let arrInput = self.arrInput[0] as? [Any]{
            if let dictArr = arrInput as? [Any]{
                let copyArr = dictArr
                if let dict = copyArr[0] as? InputTextfieldModel{
                    if ((dict.inputType ?? "") == InputType.Dropdown){
                        if ((dict.placeholder ?? "") == NursingTitles.Safety.ResidentStatus){
                            checkActiveStatus = dict.value ?? ""
                            tblView.reloadData()
                        }
                    }
                }
            }
        }
    }
    func checkAlertSTATUS(){
        switch selectedSection {
        case NursingSections.Safety.rawValue: break
            
        case NursingSections.PersonalHygiene.rawValue:
            
            viewModel.errorMessage = "\(UserDefaults.getOrganisationTypeName()) Status should be Active to fill this form."
        case NursingSections.Activity.rawValue:
            viewModel.errorMessage = "\(UserDefaults.getOrganisationTypeName()) Status should be Active to fill this form."
        case NursingSections.Sleep.rawValue:
            viewModel.errorMessage = "\(UserDefaults.getOrganisationTypeName()) Status should be Active to fill this form."
        default:
            print("Do nothing")
        }
        
    }
    
    func getIndexForMultipleTf(textFieldTag : Int) -> Int{
        var index = 0
        var dictIndex = 0
        if index < TagConstants.DoubleTF_FirstTextfield_Tag{
        }else if textFieldTag >= TagConstants.RecursiveTF_FirstTextfield_Tag{
            let isFirstTf = index - TagConstants.RecursiveTF_FirstTextfield_Tag > 0 && index - TagConstants.RecursiveTF_FirstTextfield_Tag < TagConstants.DoubleTF_FirstTextfield_Tag
            let isSecondTf = index >= TagConstants.RecursiveTF_SecondTextfield_Tag && index < TagConstants.RecursiveTF_ThirdTextfield_Tag
            
            if  isFirstTf{
                index = index - TagConstants.RecursiveTF_FirstTextfield_Tag
            }else if isSecondTf {
                index = index - TagConstants.RecursiveTF_SecondTextfield_Tag
            }else{
                index = index - TagConstants.RecursiveTF_ThirdTextfield_Tag
            }
            
            if let dict = self.arrInput[index] as? InputTextfieldModel{
            }else{
                if  isFirstTf{
                    dictIndex = 0
                }else if isSecondTf {
                    dictIndex = 1
                }else{
                    dictIndex = 2
                }
            }
        }else{
            let isFirstTf = index - TagConstants.DoubleTF_FirstTextfield_Tag >= 0 && index - TagConstants.DoubleTF_FirstTextfield_Tag < TagConstants.DoubleTF_FirstTextfield_Tag
            let isSecondTf = index >= TagConstants.DoubleTF_SecondTextfield_Tag
            
            if  isFirstTf{
                index = index - TagConstants.DoubleTF_FirstTextfield_Tag
            }else if isSecondTf {
                index = index - TagConstants.DoubleTF_SecondTextfield_Tag
            }
            
            if let dict = self.arrInput[index] as? InputTextfieldModel{
            }else{
                if  isFirstTf{
                    dictIndex = 0
                }else if isSecondTf {
                    dictIndex = 1
                }
            }
        }
        return dictIndex
    }
}


//MARK:- PickerInputCellDelegate
extension NursingCareFormViewController : PickerInputCellDelegate{
    func selectedPickerValueForInput(value: Any, valueID: Any, textfieldTag: Int) {
        debugPrint("value = \(value) --- Tf tag \(textfieldTag)")
        
        let index = self.activeTextfieldTag
        let indexPath = IndexPath(row: index, section: 0)
        if let indexPath = self.tblView.indexPath(for: (self.activeTextfield?.superview?.superview as! PickerInputCell)){
            if let dictArr = (self.arrInput[indexPath.section] as? [Any]){
                var copyArr = dictArr
                if let dict = dictArr[indexPath.row] as? InputTextfieldModel{
                    let copyDict = dict
                    copyDict.value = (value as? String) ?? ""
                    copyDict.valueId = valueID
                    copyDict.isValid = true
                    copyArr[indexPath.row] = copyDict
                    self.arrInput[indexPath.section] = copyArr
                    if ((dict.placeholder ?? "") == NursingTitles.Safety.ResidentStatus){
                    checkActiveStatus = (value as? String) ?? ""
                    }
                }
            }
        }
        /*
         if let dict = self.arrInput[index] as? InputTextfieldModel{
         let copyDict = dict
         copyDict.value = (value as? String) ?? ""
         copyDict.valueId = valueID
         copyDict.isValid = true
         self.arrInput[index] = copyDict
         }*/
        
        if let cell = self.tblView.cellForRow(at: indexPath) as? PickerInputCell{
            cell.inputTf.text = (value as? String) ?? ""
        }
    }
    
}

//MARK:- DoubleInputCellDelegate
extension NursingCareFormViewController : DoubleInputCellDelegate{
    func selectedDateForDoubleInput(date : Date, textfieldTag : Int, isDateField : Bool){
        let dateStr = Utility.getStringFromDate(date: date, dateFormat: isDateField ? DateFormats.mm_dd_yyyy : DateFormats.hh_mm_a)
        
        self.setSelectedValueInTextfield(value: dateStr, valueId: date, index: self.activeTextfieldTag)
    }
    
    func selectedPickerValueForDoubleInput(value : Any, valueID : Any, textfieldTag : Int)
    {
        
        self.setSelectedValueInTextfield(value: value, valueId: valueID, index: self.activeTextfieldTag)
    }
    
    func setSelectedValueInTextfield(value : Any , valueId : Any, index : Int){
        let indexTuple = self.getIndexAndSubIndexFromTag(textFieldTag: self.activeTextfieldTag)
        let index = indexTuple.0
        var dictIndex = indexTuple.1
        
        let isFirstTf = index - TagConstants.DoubleTF_FirstTextfield_Tag >= 0 && index - TagConstants.DoubleTF_FirstTextfield_Tag < TagConstants.DoubleTF_FirstTextfield_Tag
        dictIndex = self.getIndexForMultipleTf(textFieldTag: self.activeTextfieldTag)
        if let indexPath = self.tblView.indexPath(for: (self.activeTextfield?.superview?.superview as! DoubleInputCell)){//IndexPath(row: index, section: 0){
            
            if let dictArr = (self.arrInput[indexPath.section] as! [Any]) as? [InputTextfieldModel]{
                var copyArr = dictArr
                let dict = copyArr[dictIndex]
                dict.value = (value as? String) ?? ""
                dict.valueId = valueId
                dict.isValid = true
                copyArr[dictIndex] = dict
                self.arrInput[index] = copyArr
            }
            let reqdIndex = self.activeTextfieldTag < TagConstants.DoubleTF_SecondTextfield_Tag ? 0 : 1
            
            if let dictArr = (self.arrInput[indexPath.section] as? [Any]){
                var copyArr = dictArr
                if let arrSub = dictArr[indexPath.row] as? [InputTextfieldModel]{
                    var copySubArray = arrSub
                    let dict = arrSub[reqdIndex]
                    if ((dict.inputType ?? "") == InputType.Dropdown){
                        if let arr = dict.dropdownArr as? [Any]{
                            
                            dict.value = (value as? String) ?? ""
                            dict.valueId = valueId
                            dict.isValid = true
                            copySubArray[reqdIndex] = dict
                            copyArr[indexPath.row] = copySubArray
                            self.arrInput[indexPath.section] = copyArr
                        }
                    }
                    
                }
            }
            
            if let cell = self.tblView.cellForRow(at: indexPath) as? DoubleInputCell{
                if  dictIndex == reqdIndex{
                    cell.inputTf1.text = (value as? String) ?? ""
                }else{
                    cell.inputTf2.text = (value as? String) ?? ""
                }
            }
        }
    }
}

//MARK:- DateTimeInputCellDelegate
extension NursingCareFormViewController : DateTimeInputCellDelegate{
    func selectedDateForInput(date: Date, textfieldTag: Int, isDateField : Bool) {
        let dateStr = Utility.getStringFromDate(date: date, dateFormat: isDateField ? DateFormats.mm_dd_yyyy : DateFormats.hh_mm_a)
        debugPrint("Date = \(dateStr) --- Tf tag \(textfieldTag)")
        
        if let cell = self.activeTextfield?.superview?.superview as? DateTimeInputCell{
            if let indexPath = self.tblView.indexPath(for: (cell)) {
                if let dictArr = (self.arrInput[indexPath.section] as! [Any]) as? [InputTextfieldModel]{
                    
                    var copyArr = dictArr
                    let dict = copyArr[indexPath.row]
                    
                    if ((dict.inputType ?? "") == InputType.Time){
                        dict.value = dateStr
                        dict.valueId = dateStr
                        dict.isValid = true
                        copyArr[indexPath.row] = dict
                        self.arrInput[indexPath.section] = copyArr
                        cell.inputTf.text = dateStr
                    }
                }
            }
        }
        
        /*
         let index = self.activeTextfieldTag
         let indexPath = IndexPath(row: index, section: 0)
         
         if let dict = self.arrInput[index] as? InputTextfieldModel{
         let copyDict = dict
         copyDict.value = dateStr
         copyDict.valueId = date
         copyDict.isValid = true
         self.arrInput[index] = copyDict
         }
         
         if let cell = self.tblView.cellForRow(at: indexPath) as? DateTimeInputCell{
         cell.inputTf.text = dateStr
         }*/
    }
}
