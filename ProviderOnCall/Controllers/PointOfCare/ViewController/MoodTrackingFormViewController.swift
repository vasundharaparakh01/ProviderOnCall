//
//  MoodTrackingFormViewController.swift
//  appName
//
//  Created by Vasundhara Parakh on 3/14/20.
//  Copyright © 2020 smartData Enterprises (I) Ltd. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
class MoodTrackingFormViewController: BaseViewController {
    @IBOutlet weak var tblView: UITableView!
    lazy var viewModel: MoodTrackingViewModel = {
        let obj = MoodTrackingViewModel(with: PointOfCareService())
        self.baseViewModel = obj
        return obj
    }()
    var arrInput = [Any]()
    var activeTextfieldTag = 0
    var isReadyToSave = false
    var isValidating = false
    var patientId = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerNIBs()
        self.initialSetup()
        self.setupClosures()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        IQKeyboardManager.shared.previousNextDisplayMode = .alwaysHide

    }
    func initialSetup(){
        //Setup navigation bar
        self.navigationItem.title = NavigationTitle.PointOfCareSections.MoodTracking
        self.addBackButton()
        self.addrightBarButtonItem()
        self.viewModel.getMoodAndBehaviourDetail(patientId: self.patientId) { (result) in
                    self.viewModel.getMoodMasterData()
        }
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        IQKeyboardManager.shared.previousNextDisplayMode = .Default
    }

    
    func registerNIBs(){
        self.tblView.register(UINib(nibName: ReuseIdentifier.TitlePickerInputCell, bundle: nil), forCellReuseIdentifier: ReuseIdentifier.TitlePickerInputCell)

    }
    func setupClosures() {
        self.viewModel.updateViewClosure = { [weak self] () in
            DispatchQueue.main.async {
                self?.arrInput = self?.getInputArray() ?? [""]
                self?.tblView.reloadData()
            }
        }
        
    }
    
    func addrightBarButtonItem() {
        let rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target:  self, action: #selector(onRightBarButtonItemClicked(_ :)))
        rightBarButtonItem.tintColor = UIColor.white
        navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    // MARK:
    @objc func onRightBarButtonItemClicked(_ sender: UIBarButtonItem) {
        self.view.endEditing(true)
        
        //======= for Validation
        self.isValidating = true
        self.tblView.reloadData()
        //======= Ends
        
        let inputParams = self.createAPIParams(isDraft: false, moodID: self.viewModel.moodBeahviour?.id ?? 0)
        if inputParams.keys.count == 24{
            self.viewModel.saveMoodAndBehavior(params: self.createAPIParams(isDraft: false, moodID: self.viewModel.moodBeahviour?.id ?? 0))
        }else{
            self.viewModel.errorMessage = "Please fill missing inputs."
        }
       //self.viewModel.saveVitals(params: createAPIParams())
       // print("API Input Params = \(createAPIParams(isDraft: false,moodID: 0))")
    }
    @IBAction func saveAsDraftBtn_clicked(_ sender: Any) {
        self.viewModel.saveMoodAndBehavior(params: self.createAPIParams(isDraft: true, moodID: self.viewModel.moodBeahviour?.id ?? 0))
    }
    
    @IBAction func resetBtn_clicked(_ sender: Any) {
        UIAlertController.showAlert(title: Alert.Title.appName, message: Alert.Message.reset, preferredStyle: .alert, sender: nil , target: self, actions:.Yes,.No) { (AlertAction) in
            switch AlertAction {
            case .Yes:
                self.resetCall()
                //======= for turning off Validation
                self.isValidating = false
                //======= Ends

            self.viewModel.moodBeahviour = nil
              self.arrInput = self.getInputArray()
              self.tblView.reloadData()
              self.tblView.scrollRectToVisible(CGRect.zero, animated: true)
            default:
                break
            }
        }
    }
    func resetCall(){
        
        if (self.viewModel.moodBeahviour?.id == 0 || self.viewModel.moodBeahviour?.id == nil) {}else{
            self.viewModel.deleteMood(apiName: APITargetPoint.PointOfCare_MoodAndBehaviorById_Discard, params: ["Id" : "\(self.viewModel.moodBeahviour?.id ?? 0)"])
        }
    }

    func getInputArray() -> [Any]{
        let makesNegativeStatement = self.viewModel.getDropdownName(id: self.viewModel.moodBeahviour?.makeNegativeStatementId ?? 0, dropdown: self.viewModel.dropDownforFieldType(type: MoodType.MBTT_Makes_Negative_Statement) ?? [""])
        let reptitiveQuestion = self.viewModel.getDropdownName(id: self.viewModel.moodBeahviour?.repetativeQuestionId ?? 0, dropdown: self.viewModel.dropDownforFieldType(type: MoodType.MBTT_Repetitive_Questions) ?? [""])
        let repetativeVerbilization = self.viewModel.getDropdownName(id: self.viewModel.moodBeahviour?.repetativeVerbilizationId ?? 0, dropdown: self.viewModel.dropDownforFieldType(type: MoodType.MBTT_Repetitive_Verbalizations) ?? [""])
        let persistentAnger = self.viewModel.getDropdownName(id: self.viewModel.moodBeahviour?.persistAngerId ?? 0, dropdown: self.viewModel.dropDownforFieldType(type: MoodType.MBTT_Persistent_Anger_With_Self_Or_Others) ?? [""])
        let expressFear = self.viewModel.getDropdownName(id: self.viewModel.moodBeahviour?.expressUnrealisticFearId ?? 0, dropdown: self.viewModel.dropDownforFieldType(type: MoodType.MBTT_Expresses_Unrealistic_Fears) ?? [""])
        let recuurentStatement = self.viewModel.getDropdownName(id: self.viewModel.moodBeahviour?.makeRecurrentStatementId ?? 0, dropdown: self.viewModel.dropDownforFieldType(type: MoodType.MBTT_Makes_Recurrent_Statement) ?? [""])
        let fequentlycompainaboutHealth = self.viewModel.getDropdownName(id: self.viewModel.moodBeahviour?.frequentlyComplainAboutHealthId ?? 0, dropdown: self.viewModel.dropDownforFieldType(type: MoodType.MBTT_Frequently_Complain_About_Health) ?? [""])
        let anxiousComplaint = self.viewModel.getDropdownName(id: self.viewModel.moodBeahviour?.anxiousComplaintsId ?? 0, dropdown: self.viewModel.dropDownforFieldType(type: MoodType.MBTT_Anxious_Complaints) ?? [""])
        let facialExpression = self.viewModel.getDropdownName(id: self.viewModel.moodBeahviour?.facialExpressionsId ?? 0, dropdown: self.viewModel.dropDownforFieldType(type: MoodType.MBTT_Sad_Pained_Worried_Facial_Expressions) ?? [""])
        let cryingTearfulness = self.viewModel.getDropdownName(id: self.viewModel.moodBeahviour?.cryingOrTearfulnessId ?? 0, dropdown: self.viewModel.dropDownforFieldType(type: MoodType.MBTT_Crying_Tearfulness) ?? [""])
        let physicalMovement = self.viewModel.getDropdownName(id: self.viewModel.moodBeahviour?.repetitivePhysicalMovementId ?? 0, dropdown: self.viewModel.dropDownforFieldType(type: MoodType.MBTT_Repetitive_Physical_Movement) ?? [""])
        let withdrawnDisinterest = self.viewModel.getDropdownName(id: self.viewModel.moodBeahviour?.withdrawnOrdisinterestedInSurroundingsId ?? 0, dropdown: self.viewModel.dropDownforFieldType(type: MoodType.MBTT_Withdrawn_Disinterested_In_Surroundings) ?? [""])
        let decreasedSocailInteraction = self.viewModel.getDropdownName(id: self.viewModel.moodBeahviour?.decreasedSocialInteractionId ?? 0, dropdown: self.viewModel.dropDownforFieldType(type: MoodType.MBTT_Decreased_Social_Interaction) ?? [""])
        let wanderWithNoPurpose = self.viewModel.getDropdownName(id: self.viewModel.moodBeahviour?.wandersWithNoRationalPurposeId ?? 0, dropdown: self.viewModel.dropDownforFieldType(type: MoodType.MBTT_Wanders_With_No_Rational_Purpose_And_No_Regard_To_Self_Or_Others_Safety) ?? [""])
        let screamsThreatens = self.viewModel.getDropdownName(id: self.viewModel.moodBeahviour?.screamsOrThreatensCursesId ?? 0, dropdown: self.viewModel.dropDownforFieldType(type: MoodType.MBTT_Screams_Threatens_Curses) ?? [""])
        let hitOrShove = self.viewModel.getDropdownName(id: self.viewModel.moodBeahviour?.hitsOrShovesOrScratchesId ?? 0, dropdown: self.viewModel.dropDownforFieldType(type: MoodType.MBTT_Hits_Shoves_Scratches) ?? [""])
        let sociallyInappropriate = self.viewModel.getDropdownName(id: self.viewModel.moodBeahviour?.sociallyInappropriateId ?? 0, dropdown: self.viewModel.dropDownforFieldType(type: MoodType.MBTT_Socially_Inappropriate_Or_Disruptive_Behaviors) ?? [""])
        let resistCare = self.viewModel.getDropdownName(id: self.viewModel.moodBeahviour?.resistCareId ?? 0, dropdown: self.viewModel.dropDownforFieldType(type: MoodType.MBTT_Resist_Care) ?? [""])
        let ratingPain = self.viewModel.getDropdownName(id: self.viewModel.moodBeahviour?.ratingOfPainRating ?? 0, dropdown: self.viewModel.dropDownforFieldType(type: MoodType.MBTT_Rating_Of_Pain_Itching_Discomfort_Using) ?? [""])
        let sleptorDozedOff = self.viewModel.getDropdownName(id: self.viewModel.moodBeahviour?.sleptOrDozedMoreThanOneHourThisShiftId ?? 0, dropdown: self.viewModel.dropDownforFieldType(type: MoodType.MBTT_Slept_Or_Dozed_More_Than_One_Hour_This_Shift) ?? [""])
        let spentLeisureTime = self.viewModel.getDropdownName(id: self.viewModel.moodBeahviour?.spentTimeInLeisureActivitiesPursuitOwnInterestId ?? 0, dropdown: self.viewModel.dropDownforFieldType(type: MoodType.MBTT_Spent_Time_In_Leisure_Activities_Pursuit_Own_Interest) ?? [""])

        return [
            InputTextfieldModel(value: makesNegativeStatement, placeholder: MoodTrackingTitles.MakeNegativeStatement, apiKey: Key.Params.MoodTracking.makeNegativeStatementId, valueId: self.viewModel.moodBeahviour?.makeNegativeStatementId ?? nil, inputType: InputType.Dropdown, dropdownArr:self.viewModel.dropDownforFieldType(type: MoodType.MBTT_Makes_Negative_Statement) ?? [""],isValid: makesNegativeStatement.count != 0, errorMessage: ""),
        
            InputTextfieldModel(value: reptitiveQuestion, placeholder: MoodTrackingTitles.RepetativeQuestion, apiKey: Key.Params.MoodTracking.repetativeQuestionId, valueId: self.viewModel.moodBeahviour?.repetativeQuestionId ?? nil, inputType: InputType.Dropdown, dropdownArr:self.viewModel.dropDownforFieldType(type: MoodType.MBTT_Repetitive_Questions) ?? [""],isValid: reptitiveQuestion.count != 0, errorMessage: ""),
        
            InputTextfieldModel(value: repetativeVerbilization, placeholder: MoodTrackingTitles.RepetativeVerbilization, apiKey: Key.Params.MoodTracking.repetativeVerbilizationId, valueId: self.viewModel.moodBeahviour?.repetativeVerbilizationId ?? nil, inputType: InputType.Dropdown, dropdownArr:self.viewModel.dropDownforFieldType(type: MoodType.MBTT_Repetitive_Verbalizations) ?? [""],isValid: repetativeVerbilization.count != 0, errorMessage: ""),
            
            InputTextfieldModel(value: persistentAnger, placeholder: MoodTrackingTitles.PersistentAnger, apiKey: Key.Params.MoodTracking.persistAngerId, valueId: self.viewModel.moodBeahviour?.persistAngerId ?? nil, inputType: InputType.Dropdown, dropdownArr:self.viewModel.dropDownforFieldType(type: MoodType.MBTT_Persistent_Anger_With_Self_Or_Others) ?? [""],isValid: persistentAnger.count != 0, errorMessage: ""),

            InputTextfieldModel(value: expressFear, placeholder: MoodTrackingTitles.ExpressUnrealisticFear, apiKey: Key.Params.MoodTracking.expressUnrealisticFearId, valueId: self.viewModel.moodBeahviour?.expressUnrealisticFearId ?? nil, inputType: InputType.Dropdown, dropdownArr:self.viewModel.dropDownforFieldType(type: MoodType.MBTT_Expresses_Unrealistic_Fears) ?? [""],isValid: expressFear.count != 0, errorMessage: ""),
            
            InputTextfieldModel(value: recuurentStatement, placeholder: MoodTrackingTitles.MakeRecurrentStatement, apiKey: Key.Params.MoodTracking.makeRecurrentStatementId, valueId: self.viewModel.moodBeahviour?.makeRecurrentStatementId ?? nil, inputType: InputType.Dropdown, dropdownArr:self.viewModel.dropDownforFieldType(type: MoodType.MBTT_Makes_Recurrent_Statement) ?? [""],isValid: recuurentStatement.count != 0, errorMessage: ""),
            
            InputTextfieldModel(value: fequentlycompainaboutHealth, placeholder: MoodTrackingTitles.FrequentlyComplainAboutHealth, apiKey: Key.Params.MoodTracking.frequentlyComplainAboutHealthId, valueId: self.viewModel.moodBeahviour?.frequentlyComplainAboutHealthId ?? nil, inputType: InputType.Dropdown, dropdownArr:self.viewModel.dropDownforFieldType(type: MoodType.MBTT_Frequently_Complain_About_Health) ?? [""],isValid: fequentlycompainaboutHealth.count != 0, errorMessage: ""),
            
            InputTextfieldModel(value: anxiousComplaint, placeholder: MoodTrackingTitles.AnxiousComplaints, apiKey: Key.Params.MoodTracking.anxiousComplaintsId, valueId: self.viewModel.moodBeahviour?.anxiousComplaintsId ?? nil, inputType: InputType.Dropdown, dropdownArr:self.viewModel.dropDownforFieldType(type: MoodType.MBTT_Anxious_Complaints) ?? [""],isValid: anxiousComplaint.count != 0, errorMessage: ""),
            
            InputTextfieldModel(value: facialExpression, placeholder: MoodTrackingTitles.FacialExpression, apiKey:Key.Params.MoodTracking.facialExpressionsId, valueId: self.viewModel.moodBeahviour?.facialExpressionsId ?? nil, inputType: InputType.Dropdown, dropdownArr:self.viewModel.dropDownforFieldType(type: MoodType.MBTT_Sad_Pained_Worried_Facial_Expressions) ?? [""],isValid: facialExpression.count != 0, errorMessage: ""),
            
            InputTextfieldModel(value: cryingTearfulness, placeholder: MoodTrackingTitles.CryingOrTearfulness, apiKey: Key.Params.MoodTracking.cryingOrTearfulnessId, valueId: self.viewModel.moodBeahviour?.cryingOrTearfulnessId ?? nil, inputType: InputType.Dropdown, dropdownArr:self.viewModel.dropDownforFieldType(type: MoodType.MBTT_Crying_Tearfulness) ?? [""],isValid: cryingTearfulness.count != 0, errorMessage: ""),
            
            InputTextfieldModel(value: physicalMovement, placeholder: MoodTrackingTitles.RepetitivePhysicalMovement, apiKey: Key.Params.MoodTracking.repetitivePhysicalMovementId, valueId: self.viewModel.moodBeahviour?.repetitivePhysicalMovementId ?? nil, inputType: InputType.Dropdown, dropdownArr:self.viewModel.dropDownforFieldType(type: MoodType.MBTT_Repetitive_Physical_Movement) ?? [""],isValid: physicalMovement.count != 0, errorMessage: ""),
            
            InputTextfieldModel(value: withdrawnDisinterest, placeholder: MoodTrackingTitles.WithdrawnOrdisinterestedInSurroundings, apiKey: Key.Params.MoodTracking.withdrawnOrdisinterestedInSurroundingsId, valueId: self.viewModel.moodBeahviour?.withdrawnOrdisinterestedInSurroundingsId ?? nil, inputType: InputType.Dropdown, dropdownArr:self.viewModel.dropDownforFieldType(type: MoodType.MBTT_Withdrawn_Disinterested_In_Surroundings) ?? [""],isValid: withdrawnDisinterest.count != 0, errorMessage: ""),
            
            InputTextfieldModel(value: decreasedSocailInteraction, placeholder: MoodTrackingTitles.DecreasedSocialInteraction, apiKey: Key.Params.MoodTracking.decreasedSocialInteractionId, valueId: self.viewModel.moodBeahviour?.decreasedSocialInteractionId ?? nil, inputType: InputType.Dropdown, dropdownArr:self.viewModel.dropDownforFieldType(type: MoodType.MBTT_Decreased_Social_Interaction) ?? [""],isValid: decreasedSocailInteraction.count != 0, errorMessage: ""),
            
            InputTextfieldModel(value: wanderWithNoPurpose, placeholder: MoodTrackingTitles.WandersWithNoRationalPurpose, apiKey: Key.Params.MoodTracking.wandersWithNoRationalPurposeId, valueId: self.viewModel.moodBeahviour?.wandersWithNoRationalPurposeId ?? nil, inputType: InputType.Dropdown, dropdownArr:self.viewModel.dropDownforFieldType(type: MoodType.MBTT_Wanders_With_No_Rational_Purpose_And_No_Regard_To_Self_Or_Others_Safety) ?? [""],isValid: wanderWithNoPurpose.count != 0, errorMessage: ""),
            
            InputTextfieldModel(value: screamsThreatens, placeholder: MoodTrackingTitles.ScreamsOrThreatensCurses, apiKey: Key.Params.MoodTracking.screamsOrThreatensCursesId, valueId: self.viewModel.moodBeahviour?.screamsOrThreatensCursesId ?? nil, inputType: InputType.Dropdown, dropdownArr:self.viewModel.dropDownforFieldType(type: MoodType.MBTT_Screams_Threatens_Curses) ?? [""],isValid: screamsThreatens.count != 0, errorMessage: ""),
            
            InputTextfieldModel(value: hitOrShove, placeholder: MoodTrackingTitles.HitsOrShovesOrScratches, apiKey: Key.Params.MoodTracking.hitsOrShovesOrScratchesId, valueId: self.viewModel.moodBeahviour?.hitsOrShovesOrScratchesId ?? nil, inputType: InputType.Dropdown, dropdownArr:self.viewModel.dropDownforFieldType(type: MoodType.MBTT_Hits_Shoves_Scratches) ?? [""],isValid: hitOrShove.count != 0, errorMessage: ""),
            
            InputTextfieldModel(value: sociallyInappropriate, placeholder: MoodTrackingTitles.SociallyInappropriate, apiKey: Key.Params.MoodTracking.sociallyInappropriateId, valueId: self.viewModel.moodBeahviour?.sociallyInappropriateId ?? nil, inputType: InputType.Dropdown, dropdownArr:self.viewModel.dropDownforFieldType(type: MoodType.MBTT_Socially_Inappropriate_Or_Disruptive_Behaviors) ?? [""],isValid: sociallyInappropriate.count != 0, errorMessage: ""),
            
            InputTextfieldModel(value: resistCare, placeholder: MoodTrackingTitles.ResistCare, apiKey: Key.Params.MoodTracking.resistCareId, valueId: self.viewModel.moodBeahviour?.resistCareId ?? nil, inputType: InputType.Dropdown, dropdownArr:self.viewModel.dropDownforFieldType(type: MoodType.MBTT_Resist_Care) ?? [""],isValid: resistCare.count != 0, errorMessage: ""),
            
            InputTextfieldModel(value: ratingPain, placeholder: MoodTrackingTitles.RatingOfPain, apiKey: Key.Params.MoodTracking.ratingOfPainRating, valueId: self.viewModel.moodBeahviour?.ratingOfPainRating ?? nil, inputType: InputType.Dropdown, dropdownArr:self.viewModel.dropDownforFieldType(type: MoodType.MBTT_Rating_Of_Pain_Itching_Discomfort_Using) ?? [""],isValid: ratingPain.count != 0, errorMessage: ""),
            
            InputTextfieldModel(value: sleptorDozedOff, placeholder: MoodTrackingTitles.SleptOrDozedMoreThanOneHourThisShift, apiKey: Key.Params.MoodTracking.sleptOrDozedMoreThanOneHourThisShiftId, valueId: self.viewModel.moodBeahviour?.sleptOrDozedMoreThanOneHourThisShiftId ?? nil, inputType: InputType.Dropdown, dropdownArr:self.viewModel.dropDownforFieldType(type: MoodType.MBTT_Slept_Or_Dozed_More_Than_One_Hour_This_Shift) ?? [""],isValid: sleptorDozedOff.count != 0, errorMessage: ""),
            
            InputTextfieldModel(value: spentLeisureTime, placeholder: MoodTrackingTitles.SpentTimeInLeisureActivitiesPursuitOwnInterest, apiKey: Key.Params.MoodTracking.spentTimeInLeisureActivitiesPursuitOwnInterestId, valueId: self.viewModel.moodBeahviour?.spentTimeInLeisureActivitiesPursuitOwnInterestId ?? nil, inputType: InputType.Dropdown, dropdownArr:self.viewModel.dropDownforFieldType(type: MoodType.MBTT_Spent_Time_In_Leisure_Activities_Pursuit_Own_Interest) ?? [""],isValid: spentLeisureTime.count != 0, errorMessage: ""),
        ]
        
    }
    
    func createAPIParams(isDraft : Bool, moodID: Int) -> [String : Any]{
        var keyIdTupleArray = self.arrInput.compactMap { (arrObj) -> ( String , Any?) in
            if let dict = arrObj as? InputTextfieldModel{
                return ((dict.apiKey ?? "") , (dict.valueId ?? ""))
            }
            if let dictArr = arrObj as? [InputTextfieldModel]{
                let firstObj = dictArr[0]
                

                return ((firstObj.apiKey ?? "") , (firstObj.valueId ?? ""))
            }
            return ("","")
        }
        let keyIdTupleArray2 = self.arrInput.compactMap { (arrObj) -> ( String , Any?) in
            if let dictArr = arrObj as? [InputTextfieldModel]{
                let secondtObj = dictArr[1]
                return ((secondtObj.apiKey ?? "") , (secondtObj.valueId ?? ""))
            }
            return ("","")
        }
        
        var paramDict : [String : Any] = [:]
        keyIdTupleArray += keyIdTupleArray2
        for (_,(key,value)) in keyIdTupleArray.enumerated() {
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

        return paramDict
    }

}
//MARK:- UITableViewDelegate,UITableViewDataSource

extension MoodTrackingFormViewController : UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrInput.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let inputDict = self.arrInput[indexPath.row]
        if let dict = inputDict as? InputTextfieldModel {
            let inputType = dict.inputType
            switch inputType {
            case InputType.Dropdown:
                let cell = tableView.dequeueReusableCell(withIdentifier: ReuseIdentifier.TitlePickerInputCell, for: indexPath as IndexPath) as! TitlePickerInputCell
                cell.inputTf.tag = indexPath.row
                cell.inputTf.delegate = self
                self.updateTextfieldAppearance(inputTf: cell.inputTf, dict: dict)
                cell.lblTitle.text =  dict.placeholder ?? ""
                cell.inputTf.title = ""
                cell.inputTf.placeholder = dict.placeholder ?? ""
                print("Input text === \(dict.value ?? "")")
                cell.inputTf.text = dict.value ?? ""
                cell.arrDropdown = dict.dropdownArr ?? [Any]()
                cell.pickerView.reloadAllComponents()
                cell.selectionStyle = .none
                cell.delegate = self
                return cell
            default:
                return UITableViewCell()
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
    
    @objc func  addButton_clicked(button : UIButton) {
        
        if self.canAddRecursiveCell(inputArr: self.arrInput){
            let arr =  [InputTextfieldModel(value: "", placeholder: "BP Systolic", apiKey: "bpSystolic", valueId: nil, inputType: InputType.Decimal, dropdownArr: nil,isValid: false, errorMessage: ""),
                        InputTextfieldModel(value: "", placeholder: "BP Diastolic", apiKey: "bpDiastolic", valueId: nil, inputType: InputType.Decimal, dropdownArr: nil,isValid: false, errorMessage: ""),
                        InputTextfieldModel(value: "", placeholder: "Position", apiKey: "position", valueId: nil, inputType: InputType.Dropdown, dropdownArr: ["1","2"],isValid: false, errorMessage: "")]
            self.arrInput.insert(arr, at: button.tag + 1)
            self.tblView.reloadData()
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
extension MoodTrackingFormViewController : UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if self.isValidating {
            self.isValidating = false
            self.tblView.reloadData()
        }
        
        self.activeTextfieldTag = textField.tag
        //Set defualt/selected value on textfield tap
            if let tfToUpdate = textField as? InputTextField{
                 tfToUpdate.lineColor =  Color.Line
                tfToUpdate.errorMessage = ""

                DispatchQueue.main.async {
                    if tfToUpdate.text?.count == 0{
                        let index = self.getIndexAndSubIndexFromTag(textFieldTag: self.activeTextfieldTag).0
                        let dictIndex = self.getIndexAndSubIndexFromTag(textFieldTag: self.activeTextfieldTag).1

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
                        }
                        }

                        
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
                if let cell = self.tblView.cellForRow(at: IndexPath(row: tagTf, section: 0)){
                    if cell.isKind(of: DoubleInputCell.self){
                        (cell as! DoubleInputCell).inputTf2.becomeFirstResponder()
                    }
                }
            }else{
                let tagTf = textField.tag >= TagConstants.DoubleTF_SecondTextfield_Tag ? textField.tag - TagConstants.DoubleTF_SecondTextfield_Tag : textField.tag
            if let cell = self.tblView.cellForRow(at: IndexPath(row: tagTf + 1, section: 0)){
                if cell.isKind(of: TitlePickerInputCell.self){
                    (cell as! TitlePickerInputCell).inputTf.becomeFirstResponder()
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
                if let cell = self.tblView.cellForRow(at: IndexPath(row: textField.tag - TagConstants.DoubleTF_FirstTextfield_Tag, section: 0)){
                    if cell.isKind(of: DoubleInputCell.self){
                        (cell as! DoubleInputCell).inputTf2.becomeFirstResponder()
                    }
                }
            }else{
                let tagTf = textField.tag >= TagConstants.DoubleTF_SecondTextfield_Tag ? textField.tag - TagConstants.DoubleTF_SecondTextfield_Tag : textField.tag
            if let cell = self.tblView.cellForRow(at: IndexPath(row: tagTf + 1, section: 0)){
                if cell.isKind(of: TitlePickerInputCell.self){
                    (cell as! TitlePickerInputCell).inputTf.becomeFirstResponder()
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
        let index = indexTuple.0
        let dictIndex = indexTuple.1
        
        if textField.tag < TagConstants.DoubleTF_FirstTextfield_Tag{
            if let dict = self.arrInput[index] as? InputTextfieldModel{
                if dict.inputType == InputType.Dropdown {

                }else{
                    dict.value = textField.text
                    dict.valueId = textField.text
                    dict.isValid = !(textField.text?.count == 0)
                    self.arrInput[textField.tag] = dict
                }
            }
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
                }
            }
        }
    }
    
    //Returns (Int,Int) -> (Index,SubIndex)
    func getIndexAndSubIndexFromTag(textFieldTag : Int) -> (Int,Int){
        var index = textFieldTag
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
            let isFirstTf = index - TagConstants.DoubleTF_FirstTextfield_Tag > 0 && index - TagConstants.DoubleTF_FirstTextfield_Tag < TagConstants.DoubleTF_FirstTextfield_Tag
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
        return (index,dictIndex)
    }
}


//MARK:- TitlePickerInputCellDelegate
extension MoodTrackingFormViewController : TitlePickerInputCellDelegate{
    func selectedTitlePickerValueForInput(value: Any, valueID : Any, textfieldTag: Int) {
        debugPrint("value = \(value) --- Tf tag \(textfieldTag)")
        
        let index = self.activeTextfieldTag
        let indexPath = IndexPath(row: index, section: 0)

        if let dict = self.arrInput[index] as? InputTextfieldModel{
            let copyDict = dict
            copyDict.value = (value as? String) ?? ""
            copyDict.valueId = valueID
            copyDict.isValid = true
            self.arrInput[index] = copyDict
        }
        
        if let cell = self.tblView.cellForRow(at: indexPath) as? TitlePickerInputCell{
            cell.inputTf.text = (value as? String) ?? ""
        }
    }
    
}


