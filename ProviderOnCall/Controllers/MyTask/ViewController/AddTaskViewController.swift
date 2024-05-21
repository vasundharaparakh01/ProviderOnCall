//
//  AddTaskViewController.swift
//  appName
//
//  Created by Vasundhara Parakh on 4/7/20.
//  Copyright © 2020 smartData Enterprises (I) Ltd. All rights reserved.
//

//SHNP9099956571

import UIKit
import IQKeyboardManagerSwift
import OpalImagePicker
import Photos
import MobileCoreServices
import PDFKit
import FSCalendar

class AddTaskViewController: BaseViewController {
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var tblAvailability: UITableView!
    var docFileName = ""
    var rightBarButtonItem = UIBarButtonItem()
    @IBOutlet weak var btnShowImages : UIButton!
    @IBOutlet weak var viewImages : UIView!
    @IBOutlet weak var viewAvailability : UIView!
    @IBOutlet weak var calendarView: FSCalendar!
    @IBOutlet weak var viewCalendar: UIView!
    @IBOutlet weak var lblAvailabilityDetail: UILabel!
    var isStartDateSelected = false
    lazy var viewModel: AddTaskViewModel = {
        let obj = AddTaskViewModel(with: TaskService())
        self.baseViewModel = obj
        return obj
    }()
    var arrInput = [Any]()
    var activeTextfieldTag = 0
    var isReadyToSave = false
    var isValidating = false
    var patientId = 0
    var activeTextfield : InputTextField?
    var isDateValid = false
    let maxImagesCount = 10
    @IBOutlet weak var imagesCollectionView: UICollectionView!
    var imagesArray : [(image:Any,date:Date)] = []
    var selectedLocationId = 0
    var selectedUnitId = 0
    var selectedRoleId = 0
    var residentDropdownArray : [Patients]?
    var selectedTaskIds = [[String : String]]()
    var selectedPatientIds = [[String : String]]()
    var selectedShiftSchedule : ShiftSchedule?
    var selectedStartDate : Date?
    var selectedEndDate : Date?
    var selectedCalendarDate : Date?
    var filteredAppointmentList = [AvailabilityByDayName]()
    var selectedDateString = ""
    var selectedStaffId = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerNIBs()
        self.initialSetup()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        IQKeyboardManager.shared.previousNextDisplayMode = .alwaysHide
        
    }
    func initialSetup(){
        //Setup navigation bar
        self.navigationItem.title = NavigationTitle.AddTask
        self.addBackButton()
        self.addrightBarButtonItem()
        self.setupClosures()
        self.setCalendarView()
        self.viewModel.getTaskMasters()
        self.viewImages.isHidden = true
        self.btnShowImages.isHidden = true
        self.viewAvailability.isHidden = true
        self.viewCalendar.isHidden = true

    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        IQKeyboardManager.shared.previousNextDisplayMode = .Default
    }
    
    
    func registerNIBs(){
        self.tblView.register(UINib(nibName: ReuseIdentifier.DoubleInputCell, bundle: nil), forCellReuseIdentifier: ReuseIdentifier.DoubleInputCell)
        self.tblView.register(UINib(nibName: ReuseIdentifier.TextInputCell, bundle: nil), forCellReuseIdentifier: ReuseIdentifier.TextInputCell)
        
        self.tblView.register(UINib(nibName: ReuseIdentifier.PickerInputCell, bundle: nil), forCellReuseIdentifier: ReuseIdentifier.PickerInputCell)
        
        self.tblView.register(UINib(nibName: ReuseIdentifier.DateTimeInputCell, bundle: nil), forCellReuseIdentifier: ReuseIdentifier.DateTimeInputCell)
        
        self.tblView.register(UINib(nibName: ReuseIdentifier.NumberInputCell, bundle: nil), forCellReuseIdentifier: ReuseIdentifier.NumberInputCell)
        
        self.tblView.register(UINib(nibName: ReuseIdentifier.CheckmarkInputCell, bundle: nil), forCellReuseIdentifier: ReuseIdentifier.CheckmarkInputCell)

        self.tblAvailability.register(UINib(nibName: ReuseIdentifier.ListCell, bundle: nil), forCellReuseIdentifier: ReuseIdentifier.ListCell)

        
    }
    func setupClosures() {
        self.viewModel.updateViewClosure = { [weak self] () in
            DispatchQueue.main.async {
                self?.arrInput = self?.viewModel.getInputArray() ?? [""]
                self?.tblView.reloadData()
            }
        }
        
        self.viewModel.updateViewForCalendarClosure = { [weak self] () in
            DispatchQueue.main.async {
                self?.calendarView.reloadInputViews()
                self?.calendarView.reloadData()
            }
        }
    }
    func setCalendarView(){
            self.calendarView.scope =  FSCalendarScope.month
            
            self.calendarView.backgroundColor = UIColor.white
            self.calendarView.appearance.headerTitleFont = UIFont.PoppinsRegular(fontSize: 20.0)
            self.calendarView.appearance.weekdayFont = UIFont.PoppinsRegular(fontSize: 14.0)
            self.calendarView.appearance.caseOptions = FSCalendarCaseOptions.weekdayUsesUpperCase
            //self.calendarView.select(self.calendarView.today)
            self.calendarView.setCurrentPage(self.calendarView.today ?? Date(), animated: false)
            
            self.calendarView.dataSource = self
            self.calendarView.delegate = self
            
        //self.calendarView.select(self.selectedCalendarDate ?? Date())
        self.calendarView.placeholderType = .none

    }

    func addrightBarButtonItem() {
        rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target:  self, action: #selector(onRightBarButtonItemClicked(_ :)))
        rightBarButtonItem.tintColor = UIColor.white
        navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    // MARK:
    @objc func onRightBarButtonItemClicked(_ sender: UIBarButtonItem) {
        self.view.endEditing(true)
        //======= for Validation
        self.isValidating = true
        
        //======= Ends
        
        let inputParams = self.createAPIParams()
        
        if self.selectedStartDate ?? Date()  > self.selectedEndDate ?? Date(){
            self.viewModel.errorMessage = "End date cannot be before start date."
            self.tblView.reloadData()
            return
        }
       
        for (key, value1) in inputParams {
            print(key, value1)
            let holdH = value1 as! Array<Any>
            if (holdH[0] as AnyObject).count >= 12{
            self.viewModel.saveTask(params: inputParams)
            }else{
                self.tblView.reloadData()
                self.viewModel.errorMessage = "Please fill missing inputs."
            }
        }

    }

    
    func createAPIParams() -> [String : Any]{
        navigationItem.rightBarButtonItem = nil
        var arrFinal = [Any]()
        let valuesIdsArray = self.selectedPatientIds.compactMap { (entity) -> String? in
            return entity["value"]
        }
        
        var disc : [String : Any] = [:]
        let apiImagesArray = self.imagesArray.compactMap { (tuple) -> [String : Any]? in
                       var base64String = ""

                       if let asset = tuple.image as? PHAsset{
                                       let extensionVal = URL(fileURLWithPath: asset.value(forKey: "filename") as! String).pathExtension
                                       asset.image(completionHandler: { (doc) in
                                           base64String = self.convertImageToBase64(image: doc) + ":" + "\"\(extensionVal.lowercased())\""//doc.convertToBase64String()
                                       })
                                   }else if let docImage = tuple.image as? UIImage{
                                      base64String = self.convertImageToBase64(image: docImage) + ":" + "\"\("png")\""
                           //self.convertImageToBase64(image: docImage)
                                   }else{
                           
                                       let dataDoc =  tuple.image as! Data
                                       let pdfstring:String = dataDoc.base64EncodedString(options: .endLineWithLineFeed)

                                           var correctstr = pdfstring.replacingOccurrences(of: "\\n", with: "")
                                           
                                           correctstr = correctstr.replacingOccurrences(of: "\\r", with: "")
                                           correctstr = correctstr.replacingOccurrences(of: "\\", with: "")
                                           correctstr = String(correctstr.filter { !" \n\t\r".contains($0) })
                                           correctstr = correctstr.components(separatedBy: .whitespacesAndNewlines).joined()
                                       let extensionVal = self.docFileName.components(separatedBy: ".").last ?? ""
                                       
                                           base64String = correctstr + ":" + "\"\(extensionVal.lowercased())\""
                                       }
                       disc["0"] = base64String
                       return [Key.Params.AddTask.base64 : disc, Key.Params.AddTask.key : "STAFF"]
                   }
        
        if valuesIdsArray.count != 0{
        for (_,patientId) in valuesIdsArray.enumerated() {
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
                        }else if let dict = dictObj as? InputTextfieldModel {
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
            
            //Add appointment tasks
            let apiArrTask = self.selectedTaskIds.compactMap { (entity) -> [String:Any]? in
                return [Key.Params.AddTask.TaskTypeID : entity["value"] ?? "", Key.Params.AddTask.IsDeleted : 0]
            }
            paramDict[Key.Params.AddTask.taskTypeId] = apiArrTask
            
            let apiArrPatients = self.selectedTaskIds.compactMap { (entity) -> [String:Any]? in
                return [Key.Params.AddTask.TaskTypeID : entity["value"] ?? "", Key.Params.AddTask.IsDeleted : 0]
            }
            
            paramDict[Key.Params.AddTask.taskTypeId] = apiArrTask.count == 0 ? nil : apiArrTask
            paramDict[Key.Params.AddTask.AppointmentTasks] = apiArrTask.count == 0 ? nil : apiArrTask
            //Ends
            
            //Add Images
//            let apiImagesArray = self.imagesArray.compactMap { (tuple) -> [String : Any]? in
//                var base64String = ""
//
//                if let asset = tuple.image as? PHAsset{
//                                let extensionVal = URL(fileURLWithPath: asset.value(forKey: "filename") as! String).pathExtension
//                                asset.image(completionHandler: { (doc) in
//                                    base64String = self.convertImageToBase64(image: doc) + ":" + "\"\(extensionVal.lowercased())\""//doc.convertToBase64String()
//                                })
//                            }else if let docImage = tuple.image as? UIImage{
//                               base64String = self.convertImageToBase64(image: docImage) + ":" + "\"\("png")\""
//                    //self.convertImageToBase64(image: docImage)
//                            }else{
//
//                                let dataDoc =  tuple.image as! Data
//                                let pdfstring:String = dataDoc.base64EncodedString(options: .endLineWithLineFeed)
//
//                                    var correctstr = pdfstring.replacingOccurrences(of: "\\n", with: "")
//
//                                    correctstr = correctstr.replacingOccurrences(of: "\\r", with: "")
//                                    correctstr = correctstr.replacingOccurrences(of: "\\", with: "")
//                                    correctstr = String(correctstr.filter { !" \n\t\r".contains($0) })
//                                    correctstr = correctstr.components(separatedBy: .whitespacesAndNewlines).joined()
//                                let extensionVal = self.docFileName.components(separatedBy: ".").last ?? ""
//
//                                    base64String = correctstr + ":" + "\"\(extensionVal.lowercased())\""
//                                }
//                var disc : [String : Any] = [:]
//                disc["0"] = base64String
//                return [Key.Params.AddTask.base64 : disc, Key.Params.AddTask.key : "STAFF"]
//                return nil
//            }

            for dict in apiImagesArray{
                print(dict)
                paramDict[Key.Params.AddTask.taskDocumentModel] = apiImagesArray.count == 0 ? nil : dict
            }
            
            //Ends
            
            
            //Remove extra tasktypeid
            paramDict[Key.Params.AddTask.TaskType] = "Task"
            paramDict[Key.Params.AddTask.TaskTypeID] = nil
            
            if let startDate = self.selectedStartDate{
                paramDict[Key.Params.AddTask.StartDateTime] = Utility.getStringFromDate(date: startDate, dateFormat: "yyyy-MM-dd") + "T00:00:00.000Z"
                paramDict[Key.Params.AddTask.EndDateTime] = Utility.getStringFromDate(date: startDate, dateFormat: "yyyy-MM-dd") + "T00:00:00.000Z"
                paramDict[Key.Params.AddTask.DueDate] = Utility.getStringFromDate(date: startDate, dateFormat: "yyyy-MM-dd") + "T00:00:00.000Z"
            }
            if let endDate = self.selectedEndDate{
                paramDict[Key.Params.AddTask.EndDateTime] = Utility.getStringFromDate(date: endDate, dateFormat: "yyyy-MM-dd") + "T00:00:00.000Z"
                paramDict[Key.Params.AddTask.DueDate] = Utility.getStringFromDate(date: endDate, dateFormat: "yyyy-MM-dd") + "T00:00:00.000Z"
            }

            paramDict[Key.Params.AddTask.PatientAppointmentId] = 0
            paramDict[Key.Params.AddTask.PatientID] = Int(patientId) ?? 0
            

            paramDict[Key.Params.AddTask.AppointmentStaffs] = [[Key.Params.AddTask.StaffId : paramDict[Key.Params.AddTask.AppointmentStaffs], Key.Params.AddTask.IsDeleted : 0]]
            
            paramDict[Key.Params.AddTask.locationId] = (AppInstance.shared.user?.staffLocation?[0])?.locationID ?? 0
            paramDict[Key.Params.AddTask.ServiceLocationID] = (AppInstance.shared.user?.staffLocation?[0])?.locationID ?? 0

            
            arrFinal.append(paramDict)
        }
        }else{
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
                        }else if let dict = dictObj as? InputTextfieldModel {
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
            
            //Add appointment tasks
            let apiArrTask = self.selectedTaskIds.compactMap { (entity) -> [String:Any]? in
                return [Key.Params.AddTask.TaskTypeID : entity["value"] ?? "", Key.Params.AddTask.IsDeleted : 0]
            }
            paramDict[Key.Params.AddTask.taskTypeId] = apiArrTask
            
            let apiArrPatients = self.selectedTaskIds.compactMap { (entity) -> [String:Any]? in
                return [Key.Params.AddTask.TaskTypeID : entity["value"] ?? "", Key.Params.AddTask.IsDeleted : 0]
            }
            
            paramDict[Key.Params.AddTask.taskTypeId] = apiArrTask.count == 0 ? nil : apiArrTask
            paramDict[Key.Params.AddTask.AppointmentTasks] = apiArrTask.count == 0 ? nil : apiArrTask
           
            for dict in apiImagesArray{
                print(dict)
                paramDict[Key.Params.AddTask.taskDocumentModel] = apiImagesArray.count == 0 ? nil : dict
            }

            paramDict[Key.Params.AddTask.TaskType] = "Task"
            paramDict[Key.Params.AddTask.TaskTypeID] = nil
            
            if let startDate = self.selectedStartDate{
                paramDict[Key.Params.AddTask.StartDateTime] = Utility.getStringFromDate(date: startDate, dateFormat: "yyyy-MM-dd") + "T00:00:00.000Z"
                paramDict[Key.Params.AddTask.EndDateTime] = Utility.getStringFromDate(date: startDate, dateFormat: "yyyy-MM-dd") + "T00:00:00.000Z"
                paramDict[Key.Params.AddTask.DueDate] = Utility.getStringFromDate(date: startDate, dateFormat: "yyyy-MM-dd") + "T00:00:00.000Z"
            }
            if let endDate = self.selectedEndDate{
                paramDict[Key.Params.AddTask.EndDateTime] = Utility.getStringFromDate(date: endDate, dateFormat: "yyyy-MM-dd") + "T00:00:00.000Z"
                paramDict[Key.Params.AddTask.DueDate] = Utility.getStringFromDate(date: endDate, dateFormat: "yyyy-MM-dd") + "T00:00:00.000Z"
            }

            paramDict[Key.Params.AddTask.PatientAppointmentId] = 0
            //paramDict[Key.Params.AddTask.PatientID] = Int(patientId) ?? 0
            

            paramDict[Key.Params.AddTask.AppointmentStaffs] = [[Key.Params.AddTask.StaffId : paramDict[Key.Params.AddTask.AppointmentStaffs], Key.Params.AddTask.IsDeleted : 0]]
            
            paramDict[Key.Params.AddTask.locationId] = (AppInstance.shared.user?.staffLocation?[0])?.locationID ?? 0
            paramDict[Key.Params.AddTask.ServiceLocationID] = (AppInstance.shared.user?.staffLocation?[0])?.locationID ?? 0

            
            arrFinal.append(paramDict)
        }
        navigationItem.rightBarButtonItem = rightBarButtonItem
        return [Key.Params.AddTask.patientAppointmentModels : arrFinal]
    }
    
    func convertImageToBase64(image : UIImage) -> String{
        let compressData = image.jpegData(compressionQuality: 1.0) //max value is 1.0 and minimum is 0.0
        let compressedImage = UIImage(data: compressData!)
        guard let imageBase64 = compressData?.base64EncodedString(options: .lineLength64Characters) else { return "" }
        
        var correctstr = imageBase64.replacingOccurrences(of: "\\n", with: "")
        
        correctstr = imageBase64.replacingOccurrences(of: "\\r", with: "")
        correctstr = imageBase64.replacingOccurrences(of: "\\", with: "")
        
        correctstr = String(correctstr.filter { !" \n\t\r".contains($0) })
        correctstr = correctstr.components(separatedBy: .whitespacesAndNewlines).joined()
        return correctstr
    }
    @IBAction func btnShowImage_clicked(_ sender: Any) {
        self.viewImages.isHidden = false
        self.imagesCollectionView.reloadData()
    }
    @IBAction func btnHideImage_clicked(_ sender: Any) {
        self.viewImages.isHidden = true
    }
    @IBAction func btnHideSchedule_clicked(_ sender: Any) {
        self.viewAvailability.isHidden = true
    }
    @IBAction func btnAttachImage_clicked(_ sender: Any) {
        if self.imagesArray.count < self.maxImagesCount
        {
            // create an actionSheet
            let actionSheetController: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            // create an action
            
            let firstAction: UIAlertAction = UIAlertAction(title: "Capture Image", style: .default) { action -> Void in
                self.openCamera()
            }
            let secondAction: UIAlertAction = UIAlertAction(title: "Select image from Photos", style: .default) { action -> Void in
                self.openImagePicker()
            }
            let thirdAction: UIAlertAction = UIAlertAction(title: "Select document(s)", style: .default) { action -> Void in
                self.openDocumentPicker()
            }

            let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .destructive) { action -> Void in }
            // add actions
            actionSheetController.addAction(firstAction)
            actionSheetController.addAction(secondAction)
            actionSheetController.addAction(thirdAction)
            actionSheetController.addAction(cancelAction)
            actionSheetController.view.tintColor = Color.DarkGray
            if Device.IS_IPAD{
                addActionSheetForiPad(actionSheet: actionSheetController)
            }else{
                actionSheetController.popoverPresentationController?.sourceView = self.view // works for both iPhone & iPad
            }
            present(actionSheetController, animated: true) {
                //debugPrint("option menu presented")
            }
        }else{
            self.viewModel.errorMessage =  Alert.Message.maxAttachmentLimitReached
        }
    }
    
    func openImagePicker(){
        let imagePicker = OpalImagePickerController()
        //Limit maximum allowed selections to 5
        imagePicker.maximumSelectionsAllowed = maxImagesCount - self.imagesArray.count
        //Only allow image media type assets
        imagePicker.allowedMediaTypes = Set([PHAssetMediaType.image])
        //Change default localized strings displayed to the user
        let configuration = OpalImagePickerConfiguration()
        configuration.maximumSelectionsAllowedMessage = Alert.Message.maxAttachmentLimitReached
        imagePicker.configuration = configuration
        
        presentOpalImagePickerController(imagePicker, animated: true,
                                         select: { (assets) in
                                            //Select Assets
                                            
                                            imagePicker.dismiss(animated: true) {
                                                for (_,asset) in assets.enumerated(){
                                                    self.imagesArray.append((asset,asset.creationDate ?? Date()))
                                                }
                                                self.imagesCollectionView.reloadData()
                                                self.btnShowImages.isHidden = self.imagesArray.isEmpty

                                            }
        }, cancel: {
            //Cancel
            imagePicker.dismiss(animated: true, completion: nil)
        })
    }
    
    func openCamera(){
        let imgPicker = UIImagePickerController()
        imgPicker.delegate = self
        imgPicker.sourceType = .camera
        imgPicker.allowsEditing = false
        imgPicker.showsCameraControls = true
        self.present(imgPicker, animated: true, completion: nil)
    }
    func openDocumentPicker(){
        let documentPickerController = UIDocumentPickerViewController(documentTypes: [String(kUTTypePDF), String(kUTTypeImage), String(kUTTypeText), String(kUTTypeRTF), String(kUTTypeSpreadsheet),"com.microsoft.word.doc","org.openxmlformats.wordprocessingml.document"], in: .import)
        documentPickerController.delegate = self
        self.present(documentPickerController, animated: true, completion: nil)
    }
    
    @IBAction func btnCloseCalendar_clicked(_ sender: Any) {
        self.viewCalendar.isHidden = true
    }
    
    @IBAction func btnConfirmDate_clicked(_ sender: Any) {
        let isFirstTf = self.activeTextfield?.tag ?? 0 >= TagConstants.DoubleTF_FirstTextfield_Tag && self.activeTextfield?.tag ?? 0 < TagConstants.DoubleTF_SecondTextfield_Tag
        if isFirstTf && !self.isDateValid{
            self.viewModel.errorMessage = "Please select available date."
            return
        }
        
        self.viewCalendar.isHidden = true
        if let selectedDate = self.selectedCalendarDate{
            let dateStr = Utility.getStringFromDate(date: selectedDate, dateFormat:  DateFormats.mm_dd_yyyy )
            
            let indexTuple = self.getIndexAndSubIndexFromTag(textFieldTag: self.activeTextfieldTag)
            let index = indexTuple.0
            let dictIndex = self.getIndexForMultipleTf(textFieldTag: self.activeTextfieldTag)
            
            let isFirstTf = self.isStartDateSelected
            
            if let indexPath = self.tblView.indexPath(for: (self.activeTextfield?.superview?.superview as! DoubleInputCell)){//IndexPath(row: index, section: 0){

                if let dictArr = (self.arrInput[indexPath.section] as? [Any]){
                    var copySectionArray = dictArr
                    var copyArr = dictArr[indexPath.row] as! [InputTextfieldModel]
                    let dict = copyArr[dictIndex]
                    dict.value = dateStr
                    dict.valueId = dateStr
                    dict.isValid = true
                    copyArr[dictIndex] = dict
                    copySectionArray[indexPath.row] = copyArr
                    self.arrInput[indexPath.section] = copySectionArray
                    if (dict.placeholder ?? "") == AddTaskTitles.startDue{
                       
                       
                        if let endDate = self.selectedEndDate{
                            if self.selectedCalendarDate ??  Date() > endDate{
                                self.viewModel.errorMessage = "End date cannot be before start date."
                                return
                            }
                        }
                        self.selectedStartDate = self.selectedCalendarDate
                        
                       // self.selectedEndDate = self.selectedCalendarDate
                    }else{
                        
                        if let startDate = self.selectedStartDate{
                            if startDate  > self.selectedCalendarDate ?? Date(){
                                self.viewModel.errorMessage = "End date cannot be before start date."
                                return
                            }
                        }
                        self.selectedEndDate = self.selectedCalendarDate
                    }
                    
                }
                
                if let cell = self.tblView.cellForRow(at: indexPath) as? DoubleInputCell{
                    if  dictIndex == 0{
                        
                        cell.inputTf1.text = dateStr
                    }else{
                        cell.inputTf2.text = dateStr
                    }
                }
            }
        }
        
    }

}
//MARK:- UIDocumentMenuDelegate, UIDocumentPickerDelegate
extension AddTaskViewController : UIDocumentMenuDelegate, UIDocumentPickerDelegate,UINavigationControllerDelegate {

    func documentMenu(_ documentMenu: UIDocumentMenuViewController, didPickDocumentPicker documentPicker: UIDocumentPickerViewController) {
        documentPicker.delegate = self
        self.present(documentPicker, animated: true, completion: nil)
    }

    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        
        debugPrint(url)
        do {
            self.imagesArray.append((try Data(contentsOf: url),Date()))
            self.imagesCollectionView.reloadData()
            self.btnShowImages.isHidden = self.imagesArray.isEmpty
            self.docFileName = url.lastPathComponent
        } catch {
            debugPrint("no data")
        }

        /*
        self.attachmentArray.append(url)
        self.attachmentCollectionView.reloadData()
        debugPrint("url = \(url)")
        */
    }

    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
}

//MARK:- UIImagePickerControllerDelegate
extension AddTaskViewController : UIImagePickerControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey :
        Any]) {
       if let img = info[UIImagePickerController.InfoKey.originalImage] as?
            UIImage {
            self.imagesArray.append((img,Date()))
            self.imagesCollectionView.reloadData()
        self.btnShowImages.isHidden = self.imagesArray.isEmpty

            self.dismiss(animated: true, completion: nil)
        } else {
            print("error")
        }
    }
}

//MARK: FSCalendarDataSource,FSCalendarDelegate
extension AddTaskViewController : FSCalendarDataSource,FSCalendarDelegate{
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        if date.timeIntervalSinceNow.sign == FloatingPointSign.minus{
            return 0
        }
        if self.isStartDateSelected {//date > Date() && self.isStartDateSelected{
            let dateArr = self.viewModel.availabilityList.compactMap({Utility.convertServerDateToRequiredDate(dateStr: $0.date ?? "", requiredDateformat: DateFormats.YYYY_MM_DD)})
            //let EnddateArr = self.viewModel.availabilityList.compactMap({Utility.convertServerDateToRequiredDate(dateStr: $0.endTime ?? "", requiredDateformat: DateFormats.YYYY_MM_DD)})
            
            let allDates = dateArr //+ EnddateArr
            
            let dateOfEvent = Utility.getStringFromDate(date: date, dateFormat: DateFormats.YYYY_MM_DD)
            
            var count = 0
            for (_,item) in dateArr.enumerated() {
                if item == dateOfEvent{
                    count += 1
                }
            }
            return allDates.contains(dateOfEvent) ? 1 : 0
        }
        return 0
        //return 0
        
    }
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventDefaultColorsFor date: Date) -> [UIColor]? {
        
        return [Color.Red]
    }
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventColorFor date: Date) -> UIColor? {
         //Do some checks and return whatever color you want to.
        return  Color.Red

    }

    //Commented to display past appointments - 04/11/2019
    //Developer - Vasundhara parakh
    func minimumDate(for calendar: FSCalendar) -> Date {
        let indexTuple = self.getIndexAndSubIndexFromTag(textFieldTag: self.activeTextfieldTag)
        let index = indexTuple.0
        let dictIndex = self.getIndexForMultipleTf(textFieldTag: self.activeTextfieldTag)
        
        let isFirstTf = index - TagConstants.DoubleTF_FirstTextfield_Tag >= 0 && index - TagConstants.DoubleTF_FirstTextfield_Tag < TagConstants.DoubleTF_FirstTextfield_Tag

        return Date()
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        self.filteredAppointmentList.removeAll()
        self.view.endEditing(true)
        self.selectedCalendarDate = date
        
        _ = self.viewModel.availabilityList.compactMap({Utility.convertServerDateToRequiredDate(dateStr: $0.date ?? "", requiredDateformat: DateFormats.YYYY_MM_DD)})
        let dateOfEvent = Utility.getStringFromDate(date: date, dateFormat: DateFormats.YYYY_MM_DD)
        
        
        for (_,item) in self.viewModel.availabilityList.enumerated() {
            let itemDate = Utility.convertServerDateToRequiredDate(dateStr: item.date ?? "", requiredDateformat: DateFormats.YYYY_MM_DD)
            if itemDate == dateOfEvent{
                self.filteredAppointmentList.append(item)
            }
        }
        if !self.filteredAppointmentList.isEmpty{
            let startTime = Utility.convertServerDateToRequiredDate(dateStr: self.filteredAppointmentList.first?.startTime ?? "", requiredDateformat: DateFormats.hh_mm_a)
            let endTime = Utility.convertServerDateToRequiredDate(dateStr: self.filteredAppointmentList.first?.endTime ?? "", requiredDateformat: DateFormats.hh_mm_a)

            let unAvailableStartTime = Utility.convertServerDateToRequiredDate(dateStr: self.filteredAppointmentList.last?.startTime ?? "", requiredDateformat: DateFormats.hh_mm_a)
            let unAvailableEndTime = Utility.convertServerDateToRequiredDate(dateStr: self.filteredAppointmentList.last?.endTime ?? "", requiredDateformat: DateFormats.hh_mm_a)

            var available = "Available : " + startTime + " - " + endTime
            if self.filteredAppointmentList.count > 1 && !(self.filteredAppointmentList.last?.isAvailable ?? true) {
                let unavailable = "\n" + "Unavailable between " + unAvailableStartTime + " - " + unAvailableEndTime
                available.append(unavailable)
            }
            self.lblAvailabilityDetail.numberOfLines = 0
            self.lblAvailabilityDetail.lineBreakMode = .byWordWrapping
            self.lblAvailabilityDetail.text = available
            self.isDateValid = true
        }else{
            self.lblAvailabilityDetail.text = "No availability found."
            self.isDateValid = false


        }
        //self.tblView.reloadData()
        //self.viewModel.getPatientAppointmentList(startDate: date,endDate : date)
    }
    
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        return true
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        
        self.lblAvailabilityDetail.text = ""
        self.filteredAppointmentList.removeAll()
        self.tblView.reloadData()
        
        let startDate = calendar.currentPage.startOfMonth()
        let endDate = calendar.currentPage.endOfMonth()
        
        let startDateStr = Utility.getStringFromDate(date: startDate, dateFormat: DateFormats.YYYY_MM_DD)
        let endDateStr = Utility.getStringFromDate(date: endDate, dateFormat: DateFormats.YYYY_MM_DD)

        self.viewModel.getAvailabilityList(fromDate: startDateStr, toDate: endDateStr, shiftId: self.selectedShiftSchedule?.shiftMasterId ?? 0,staffId: self.selectedStaffId)
    }
    
    
    
}

//MARK:- UITableViewDelegate,UITableViewDataSource

extension AddTaskViewController : UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == self.tblView{
            return self.arrInput.count
        }else{
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.tblView{
        if let arr = (self.arrInput[section] as? [Any]){
            return arr.count
        }else{
            if self.arrInput[section] is InputTextfieldModel{
                return 1
            }
        }
        }else{
            return self.getAvailabilityData().count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView == self.tblView{
            if section == 0 {
                return 0
            }
            return 40
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 40))
        headerView.backgroundColor = UIColor.white
        
        let lblSection = UILabel(frame: CGRect(x: 15, y: 10, width: tableView.frame.size.width - 20, height: 30))
        lblSection.textColor = Color.Blue
        lblSection.text =  self.viewModel.titleForHeader(section: section)
        lblSection.font = UIFont.PoppinsMedium(fontSize: 18)
        headerView.addSubview(lblSection)
        

        //headerView.borderWidth = 1.0
        //headerView.borderColor = Color.Line
        
        return headerView
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.tblView{
        
        if let arr = (self.arrInput[indexPath.section] as? [Any]){
            let inputDict = arr[indexPath.row]
        //self.arrInput[indexPath.row]
        if let dict = inputDict as? InputTextfieldModel {
            let inputType = dict.inputType
            switch inputType {
            case InputType.Text:
                let cell = tableView.dequeueReusableCell(withIdentifier: ReuseIdentifier.TextInputCell, for: indexPath as IndexPath) as! TextInputCell
                cell.inputTf.tag = indexPath.row
                cell.inputTf.placeholder = dict.placeholder ?? ""
                self.updateTextfieldAppearance(inputTf: cell.inputTf, dict: dict)
                cell.inputTf.delegate = self
                cell.selectionStyle = .none
                return cell
            case InputType.Checkmark:
                let cell = tableView.dequeueReusableCell(withIdentifier: ReuseIdentifier.CheckmarkInputCell, for: indexPath as IndexPath) as! CheckmarkInputCell
                cell.lblTitle.text = dict.placeholder ?? ""
                cell.btnCheck.tag = indexPath.row
                cell.btnCheck.setImage(((dict.valueId as? Bool) ?? false) ? UIImage.filledCircle() : UIImage.unfilledCircle() , for: .normal)
                cell.btnCheck.addTarget(self, action: #selector(self.btnCheck_clicked(button:)), for: .touchUpInside)
                cell.selectionStyle = .none
                return cell
            case InputType.Number:
            let cell = tableView.dequeueReusableCell(withIdentifier: ReuseIdentifier.NumberInputCell, for: indexPath as IndexPath) as! NumberInputCell
            cell.inputTf.tag = indexPath.row
            let placeholder =  dict.placeholder ?? ""
            cell.inputTf.placeholder = placeholder
            self.updateTextfieldAppearance(inputTf: cell.inputTf, dict: dict)
            cell.inputTf.text = dict.value ?? ""
            cell.inputTf.delegate = self
            cell.selectionStyle = .none
            return cell
            case InputType.Date:
                let cell = tableView.dequeueReusableCell(withIdentifier: ReuseIdentifier.DateTimeInputCell, for: indexPath as IndexPath) as! DateTimeInputCell
                cell.inputTf.tag = indexPath.row
                cell.isDateField = true
                cell.inputTf.delegate = self
                cell.delegate = self
                cell.inputTf.placeholder = dict.placeholder ?? ""
                cell.datePicker.maximumDate = Date()
                cell.setupDatePicker()
                if (dict.value ?? "").count != 0{
                    cell.inputTf.text = dict.value ?? ""
                }
                
                cell.selectionStyle = .none
                self.updateTextfieldAppearance(inputTf: cell.inputTf, dict: dict)

                return cell
            case InputType.Dropdown:
                let cell = tableView.dequeueReusableCell(withIdentifier: ReuseIdentifier.PickerInputCell, for: indexPath as IndexPath) as! PickerInputCell
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
            default:
                return UITableViewCell()
            }
        }else{
            if let dictArr = inputDict as? [InputTextfieldModel] , dictArr.count == 2{
                let cell = tableView.dequeueReusableCell(withIdentifier: ReuseIdentifier.DoubleInputCell, for: indexPath as IndexPath) as! DoubleInputCell
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
                
                if indexPath.section == ADLSections.Continenece.rawValue{
                    cell.inputTf1.placeholder = ADLTrackingTitles.Bladder
                    cell.inputTf2.placeholder = ADLTrackingTitles.Bowel
                    //cell.lblTitle.text = ADLTrackingHeaders.Continenece
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
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: ReuseIdentifier.ListCell, for: indexPath as IndexPath) as! ListCell
            
            let arr = self.getAvailabilityData()
            cell.lblTitle.textColor = Color.Blue
            
            if let valArr = arr[indexPath.row].first?.value as? [Days]{
                
                cell.lblTitle.text = Utility.convertServerDateToRequiredDate(dateStr: valArr[0].startTime ?? "", requiredDateformat: DateFormats.ee)  + ", " + Utility.convertServerDateToRequiredDate(dateStr: valArr[0].startTime ?? "", requiredDateformat: DateFormats.mm_dd_yyyy)

                var strTime = ""
                for (_,day) in valArr.enumerated() {
                    if strTime.count != 0 {
                        strTime.append("\n")
                    }
                    strTime.append(Utility.convertServerDateToRequiredDate(dateStr: day.startTime ?? "", requiredDateformat: DateFormats.hh_mm_a) + " - " + Utility.convertServerDateToRequiredDate(dateStr: day.endTime ?? "", requiredDateformat: DateFormats.hh_mm_a))
                }
                cell.lblValue.text = strTime

            }
                
            cell.lblSeperator.isHidden = indexPath.row != arr.count - 1
            cell.lblDivider.isHidden = false

            /*
            if let scheduleDays = self.selectedShiftSchedule?.days as? [Days]{
                let day = scheduleDays[indexPath.row]
                cell.lblTitle.text = Utility.convertServerDateToRequiredDate(dateStr: day.startTime ?? "", requiredDateformat: DateFormats.ee)  + ", " + Utility.convertServerDateToRequiredDate(dateStr: day.startTime ?? "", requiredDateformat: DateFormats.mm_dd_yyyy)
                cell.lblTitle.textColor = Color.Blue
                
                cell.lblValue.text = Utility.convertServerDateToRequiredDate(dateStr: day.startTime ?? "", requiredDateformat: DateFormats.hh_mm_a) + " - " + Utility.convertServerDateToRequiredDate(dateStr: day.endTime ?? "", requiredDateformat: DateFormats.hh_mm_a)
                cell.lblSeperator.isHidden = indexPath.row != scheduleDays.count - 1
                cell.lblDivider.isHidden = false
            }*/

            cell.selectionStyle = .none
            return cell
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
    
    @objc func  btnAvailability_clicked(button : UIButton) {
        self.view.endEditing(true)
        if let days = self.selectedShiftSchedule{
            self.viewAvailability.isHidden = false
            self.tblAvailability.reloadData()
            print("available=== \(self.getAvailabilityData())")
        }else{
            self.viewModel.errorMessage = "No availability data found. Please ensure that you have selected assigned to."
        }
    }
    
    @objc func  btnCheck_clicked(button : UIButton) {
        if let cell = button.superview?.superview as? CheckmarkInputCell{
            if let indexPath = self.tblView.indexPath(for: cell){
                if let dictArr = (self.arrInput[indexPath.section] as? [Any])  {
                    var copyArr = dictArr
                    if let dict = copyArr[indexPath.row] as? InputTextfieldModel{
                        dict.value = ""
                        dict.valueId = !((dict.valueId as? Bool) ?? false)
                        dict.isValid = true
                        copyArr[indexPath.row] = dict
                        self.arrInput[indexPath.section] = copyArr
                        cell.btnCheck.setImage(((dict.valueId as? Bool) ?? false) ? UIImage.filledCircle() : UIImage.unfilledCircle() , for: .normal)
                    }
                }

            }
        }
    }
    
    func prepareDataForAvailability() -> [[String:Any]]{
        var arrFinalAvailability = [[String:Any]]()
        if let days = self.selectedShiftSchedule?.days{
            for (_,mainItem) in days.enumerated() {
                var subArray = [Days]()
                for (_,item) in days.enumerated() {
                    let mainStr = Utility.convertServerDateToRequiredDate(dateStr: mainItem.startTime ?? "", requiredDateformat: DateFormats.mm_dd_yyyy)
                    let subString = Utility.convertServerDateToRequiredDate(dateStr: item.startTime ?? "", requiredDateformat: DateFormats.mm_dd_yyyy)
                    if mainStr == subString{
                        subArray.append(item)
                    }
                }
                let date =  Utility.convertServerDateToRequiredDate(dateStr: mainItem.startTime ?? "", requiredDateformat: DateFormats.mm_dd_yyyy)
                arrFinalAvailability.append([date : subArray ])
            }
        }
        return arrFinalAvailability
    }
    
    func getAvailabilityData() -> [[String:Any]]{
        var finalArray = [[String:Any]]()
        if let days = self.selectedShiftSchedule?.days{
            let keysArray = days.compactMap({Utility.convertServerDateToRequiredDate(dateStr: $0.startTime ?? "", requiredDateformat: DateFormats.mm_dd_yyyy)})
            let finalKeys = self.removeDuplicates(from: keysArray)

            let arrAvaialbility = self.prepareDataForAvailability()

            for (_,keyName) in finalKeys.enumerated() {
                for (_,item) in arrAvaialbility.enumerated() {
                    if  keyName == item.first!.key {
                        finalArray.append(item)
                    }
                }
            }

        }
        
        return  self.removeDuplicatesDict(from: finalArray)
    }
    func removeDuplicates(from items: [String]) -> [String] {
        let uniqueItems = NSOrderedSet(array: items)
        return (uniqueItems.array as? [String]) ?? []
    }
    
    func removeDuplicatesDict(from items: [[String : Any]]) -> [[String : Any]] {
        let uniqueItems = NSOrderedSet(array: items)
        return (uniqueItems.array as? [[String : Any]]) ?? []
    }
    
    func showMultiValuePicker(indexPath : IndexPath,dropDownArray : [Any]){
        
        
        var pickerData : [[String:String]] = [[String:String]]()
        
        for (_,item) in dropDownArray.enumerated() {
            if let itemTaskType = item as? MasterTaskType{
                pickerData.append(["value":"\(itemTaskType.id ?? 0)","display":itemTaskType.taskType ?? ""])
            }
            
            if let itemResident = item as? Patients{
                pickerData.append(["value":"\(itemResident.id ?? 0)","display":itemResident.value ?? ""])
            }
        }
        
        var valuesIdsArray = [String]()
        
        if indexPath.section == 0 {
            valuesIdsArray = self.selectedTaskIds.compactMap { (entity) -> String? in
                return entity["value"]
            }

        }else{
            valuesIdsArray = self.selectedPatientIds.compactMap { (entity) -> String? in
                return entity["value"]
            }

        }
        

        MultiPickerDialog().show(title: "Select",doneButtonTitle:"Done", cancelButtonTitle:"Cancel" ,options: pickerData, selected:  valuesIdsArray) {
            values -> Void in
            print("SELECTED \(values)")
            let valueArr = values.compactMap { (entity) -> String? in
                return entity["display"]
            }
            let valueIdsArr = values.compactMap { (entity) -> String? in
                return entity["value"]
            }

            //Update Resident name textfield to blank
            if let dictArr = (self.arrInput[indexPath.section] as? [Any]){
                var copyArr = dictArr
                if let dict = dictArr[indexPath.row] as? InputTextfieldModel{
                    if (dict.placeholder ?? "") == AddTaskTitles.selectTaskType{
                        self.selectedTaskIds = values
                    }else{
                        self.selectedPatientIds = values
                    }
                    let stringValue = valueArr.joined(separator: ", ")
                    let stringIds = valueIdsArr.joined(separator: ",")
                    dict.value = stringValue
                    dict.valueId = stringIds
                    dict.isValid = true
                    copyArr[indexPath.row] = dict
                    self.arrInput[indexPath.section] = copyArr
                    
                    if let cell = self.tblView.cellForRow(at: IndexPath(row: indexPath.row, section: indexPath.section )) as? TextInputCell{
                        cell.inputTf.text = stringValue
                    }
                }
            }
        }
    }
}
//MARK:- UITextFieldDelegate
extension AddTaskViewController : UITextFieldDelegate{
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
                        let index = self.getIndexAndSubIndexFromTag(textFieldTag: self.activeTextfieldTag).0
                        let dictIndex = self.getIndexForMultipleTf(textFieldTag: self.activeTextfieldTag)//self.getIndexAndSubIndexFromTag(textFieldTag: self.activeTextfieldTag).1
                        if let _ = textField.superview?.superview as? NumberInputCell{
                        }else if let cell = textField.superview?.superview as? TextInputCell{
                            if let indexPath = self.tblView.indexPath(for: (cell)) {
                                if let dictArr = (self.arrInput[indexPath.section] as? [Any])  {
                                    if let dict = dictArr[indexPath.row] as? InputTextfieldModel{
                                        if dict.placeholder == AddTaskTitles.selectTaskType {
                                            self.showMultiValuePicker(indexPath: indexPath,dropDownArray: dict.dropdownArr ?? [""])
                                        }else if (dict.placeholder == AddTaskTitles.residentName){
                                            self.viewModel.getStaffPatientDropdown(locationId: self.selectedLocationId, roleId: self.selectedRoleId, unitID: self.selectedUnitId, shiftId: self.selectedShiftSchedule?.shiftMasterId ?? 0) { (result) in
                                            self.viewModel.isLoading = false
                                            if let res = result as? PatientStaffMaster{
                                                self.residentDropdownArray = res.patients
                                                self.showMultiValuePicker(indexPath: indexPath,dropDownArray: self.residentDropdownArray ?? [""])
                                            }else{
                                                self.showMultiValuePicker(indexPath: indexPath,dropDownArray: [""])
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        else if let cell = textField.superview?.superview as? DateTimeInputCell{
                            if let indexPath = self.tblView.indexPath(for: (cell)) {
                                if let dictArr = (self.arrInput[indexPath.section] as? [Any])  {
                                    var copyArr = dictArr
                                    if let dict = copyArr[indexPath.row] as? InputTextfieldModel{
                                        if((dict.inputType ?? "") == InputType.Date || (dict.inputType ?? "") == InputType.Time)
                                        {
                                                
                                                let isDate = (dict.inputType ?? "") == InputType.Date
                                                let dateStr = Utility.getStringFromDate(date: Date(), dateFormat: isDate ? DateFormats.mm_dd_yyyy : DateFormats.hh_mm_a)
                                                
                                                dict.value = dateStr
                                                dict.valueId = dateStr//Date()
                                                dict.isValid = true
                                                copyArr[indexPath.row] = dict
                                                self.arrInput[indexPath.section] = copyArr
                                                
                                                textField.text = dateStr
                                                
                                        }
                                    }
                                }
                            }
                        }
                        else if let cell = textField.superview?.superview as? DoubleInputCell{
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
                                        
                                        if (dict.placeholder == AddTaskTitles.startDue || dict.placeholder == AddTaskTitles.dueDate){
                                            textField.resignFirstResponder()
                                            self.isStartDateSelected = dict.placeholder == AddTaskTitles.startDue
                                            self.viewCalendar.isHidden = false
                                            let startDate = self.calendarView.currentPage.startOfMonth()
                                            let endDate = self.calendarView.currentPage.endOfMonth()
                                            
                                            let startDateStr = Utility.getStringFromDate(date: startDate, dateFormat: DateFormats.YYYY_MM_DD)
                                            let endDateStr = Utility.getStringFromDate(date: endDate, dateFormat: DateFormats.YYYY_MM_DD)

                                            self.viewModel.getAvailabilityList(fromDate: startDateStr, toDate: endDateStr, shiftId: self.selectedShiftSchedule?.shiftMasterId ?? 0,staffId: self.selectedStaffId)

                                        }
                                        
                                    }else if((dict.inputType ?? "") == InputType.Date || (dict.inputType ?? "") == InputType.Time)
                                    {
                                        if self.checkStaffAvailability(date:  Date()) {

                                        let isDate = (dict.inputType ?? "") == InputType.Date
                                        let dateStr = Utility.getStringFromDate(date: Date(), dateFormat: isDate ? DateFormats.mm_dd_yyyy : DateFormats.hh_mm_a)

                                        dict.value = dateStr
                                        dict.valueId = dateStr//Date()
                                        dict.isValid = true
                                         copySubArray[reqdIndex] = dict
                                         copyArr[indexPath.row] = copySubArray
                                         self.arrInput[indexPath.section] = copyArr

                                        textField.text = dateStr
                                            if (dict.placeholder ?? "") == AddTaskTitles.startDue{
                                                self.selectedStartDate = Date()
                                            }else{
                                                self.selectedEndDate = Date()
                                            }

                                        }
                                    }else if ((dict.inputType ?? "") == InputType.Dropdown){
                                       if dict.placeholder == AddTaskTitles.role{
                                        if let cell = self.tblView.cellForRow(at: indexPath) as? DoubleInputCell{
                                            cell.pickerView.reloadAllComponents()
                                            
                                            if let arr = dict.dropdownArr as? [Any]{
                                                cell.pickerView.selectRow(0, inComponent: 0, animated: false)
                                                
                                                let selectedValue = Utility.getSelectedValue(arrDropdown: arr,row: 0)
                                                
                                                dict.value = selectedValue.value
                                                dict.valueId = selectedValue.valueID
                                                dict.isValid = true
                                                copySubArray[reqdIndex] = dict
                                                copyArr[indexPath.row] = copySubArray
                                                self.arrInput[indexPath.section] = copyArr
                                                textField.text = selectedValue.value
                                                self.selectedRoleId = selectedValue.valueID as! Int
                                            }
                                            
                                        }
                                       }else if dict.placeholder == AddTaskTitles.unit{
                                        if let cell = self.tblView.cellForRow(at: indexPath) as? DoubleInputCell{
                                            cell.pickerView.reloadAllComponents()
                                            
                                            if let arr = dict.dropdownArr{
                                                cell.pickerView.selectRow(0, inComponent: 0, animated: false)
                                                
                                                let selectedValue = Utility.getSelectedValue(arrDropdown: arr,row: 0)
                                                
                                                dict.value = selectedValue.value
                                                dict.valueId = selectedValue.valueID
                                                dict.isValid = true
                                                copySubArray[reqdIndex] = dict
                                                copyArr[indexPath.row] = copySubArray
                                                self.arrInput[indexPath.section] = copyArr
                                                textField.text = selectedValue.value
                                                self.selectedUnitId = selectedValue.valueID as! Int
                                                self.viewModel.unitID = selectedValue.valueID as! Int
                                            }
                                            
                                        }
                                       }
                                       else if dict.placeholder == AddTaskTitles.shift{

                                                                            
                                                                            self.viewModel.getShiftDropdown(unitID: self.selectedUnitId) { (result) in
                                                                                self.viewModel.isLoading = false
                                                                                if let res = result as? [Shift]{
                                                                                    self.viewModel.dropdownShift = res
                                                                                    if let dict1 = arrSub[reqdIndex] as? InputTextfieldModel{
                                                                                        dict1.dropdownArr = res
                                                                                        copySubArray[reqdIndex] = dict
                                                                                        copyArr[indexPath.row] = copySubArray
                                                                                        self.arrInput[indexPath.section] = copyArr
                                                                                        if let cell = self.tblView.cellForRow(at: indexPath) as? DoubleInputCell{
                                                                                            cell.arrDropdown2 = res
                                                                                            cell.pickerView.reloadAllComponents()
                                                                                            
                                                                                            if let arr = dict.dropdownArr as? [Any]{
                                                                                                cell.pickerView.selectRow(0, inComponent: 0, animated: false)

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
                                                                       

                                                                        
                                        }else if (dict.placeholder == AddTaskTitles.assignedto){
                                        self.viewModel.getStaffPatientDropdown(locationId: self.selectedLocationId, roleId: self.selectedRoleId, unitID: self.selectedUnitId, shiftId: self.selectedShiftSchedule?.shiftMasterId ?? 0) { (result) in
                                                self.viewModel.isLoading = false
                                                if let res = result as? PatientStaffMaster{
                                                    self.residentDropdownArray = res.patients

                                                    if let dict1 = arrSub[reqdIndex] as? InputTextfieldModel{
                                                        dict1.dropdownArr = res.staff
                                                        copySubArray[reqdIndex] = dict
                                                        copyArr[indexPath.row] = copySubArray
                                                        self.arrInput[indexPath.section] = copyArr
                                                        if let cell = self.tblView.cellForRow(at: indexPath) as? PickerInputCell{
                                                            cell.arrDropdown = res.staff ?? [""]
                                                            
                                                            cell.pickerView.reloadAllComponents()
                                                            
                                                            if let arr = dict.dropdownArr as? [Staff]{
                                                                cell.pickerView.selectRow(0, inComponent: 0, animated: false)

                                                                let selectedValue = Utility.getSelectedValue(arrDropdown: arr,row: 0)

                                                                dict.value = selectedValue.value
                                                                dict.valueId = selectedValue.valueID
                                                            dict.isValid = true
                                                            copySubArray[reqdIndex] = dict
                                                            copyArr[indexPath.row] = copySubArray
                                                            self.arrInput[indexPath.section] = copyArr
                                                            textField.text = selectedValue.value
                                                                self.selectedStaffId = (selectedValue.valueID as? Int) ?? 0
                                                            }
                                                        
                                                        }
                                                    }
                                                }else{
                                                    if let cell = self.tblView.cellForRow(at: indexPath) as? DoubleInputCell{
                                                    cell.arrDropdown2 = [""]; cell.pickerView.reloadAllComponents()
                                                    }
                                                }
                                            }
                                        }else{
                                                                            if let cell = self.tblView.cellForRow(at: indexPath) as? DoubleInputCell{
                                                                                cell.pickerView.reloadAllComponents()
                                                                                
                                                                                if let arr = dict.dropdownArr{
                                                                                    cell.pickerView.selectRow(0, inComponent: 0, animated: false)

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
                       
                        }else if let cell = textField.superview?.superview as? PickerInputCell{
                        if let indexPath = self.tblView.indexPath(for: (cell)) {
                            if let dictArr = (self.arrInput[indexPath.section] as? [Any])  {
                                var copyArr = dictArr
                                if let dict = copyArr[indexPath.row] as? InputTextfieldModel{
                                    if ((dict.inputType ?? "") == InputType.Dropdown){
                                        if (dict.placeholder == AddTaskTitles.assignedto){
                                            self.viewModel.getStaffPatientDropdown(locationId: self.selectedLocationId, roleId: self.selectedRoleId, unitID: self.selectedUnitId,shiftId: self.selectedShiftSchedule?.shiftMasterId ?? 0) { (result) in
                                                self.viewModel.isLoading = false
                                                if let res = result as? PatientStaffMaster{
                                                    self.residentDropdownArray = res.patients
                                                    
                                                        let tempDict = dict
                                                        tempDict.dropdownArr = res.staff
                                                        let selectedValue = Utility.getSelectedValue(arrDropdown: res.staff ?? [""],row: 0)
                                                        tempDict.value = selectedValue.value
                                                        tempDict.valueId = selectedValue.valueID
                                                        tempDict.isValid = true
                                                        copyArr[indexPath.row] = tempDict
                                                        self.arrInput[indexPath.section] = copyArr
                                                        textField.text = selectedValue.value
                                                    cell.arrDropdown = res.staff ?? [""]
                                                    self.selectedStaffId = selectedValue.valueID as? Int ?? 0
                                                    cell.pickerView.reloadAllComponents()
                                                }else{
                                                    if let cell = self.tblView.cellForRow(at: indexPath) as? DoubleInputCell{
                                                        cell.arrDropdown2 = [""]; cell.pickerView.reloadAllComponents()
                                                    }
                                                }
                                            }
                                        }else{
                                            let tempDict = dict
                                            if let arr = tempDict.dropdownArr as? [Any]{
                                                cell.pickerView.selectRow(0, inComponent: 0, animated: false)
                                                
                                                let selectedValue = Utility.getSelectedValue(arrDropdown: arr,row: 0)
                                                tempDict.value = selectedValue.value
                                                tempDict.valueId = selectedValue.valueID
                                                tempDict.isValid = true
                                                copyArr[indexPath.row] = tempDict
                                                self.arrInput[indexPath.section] = copyArr
                                                textField.text = selectedValue.value
                                                cell.pickerView.reloadAllComponents()

                                                
                                            }
                                        }
                                    }else if ((dict.inputType ?? "") == InputType.Text || (dict.inputType ?? "") == InputType.Number){
                                        let tempDict = dict

                                        tempDict.value = textField.text
                                        tempDict.valueId = textField.text
                                        tempDict.isValid = true
                                        copyArr[indexPath.row] = tempDict
                                        self.arrInput[indexPath.section] = copyArr
                                    }
                                    
                                }
                            }
                        }
                        }
                        else{

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
                                    dict.valueId = dateStr//Date()
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
                            }else{
                                if let dict = self.arrInput[index] as? InputTextfieldModel{
                                    
//                                    if ((dict.inputType ?? "") == InputType.Text || (dict.inputType ?? "") == InputType.Number){
//                                        dict.value = textField.text
//                                        dict.valueId = textField.text
//                                        dict.isValid = true
//                                        copyArr[dictIndex] = dict
//                                        self.arrInput[index] = copyArr
//
//                                    }
                                }
                            }
                        }
                        }
                    }else{
                        if let cell = textField.superview?.superview as? DoubleInputCell{
                            cell.pickerView.reloadAllComponents()
                            if let indexPath = self.tblView.indexPath(for: (cell)) {
                                if let dictArr = (self.arrInput[indexPath.section] as? [Any]){
                                    var copyArr = dictArr
                                    
                                    if let arr = dictArr[indexPath.row] as? [InputTextfieldModel] {
                                        let reqdIndex = self.activeTextfieldTag < TagConstants.DoubleTF_SecondTextfield_Tag ? 0 : 1
                                        
                                        if let dict = arr[reqdIndex] as? InputTextfieldModel{
                                            if (dict.placeholder == AddTaskTitles.startDue || dict.placeholder == AddTaskTitles.dueDate){
                                                textField.resignFirstResponder()
                                                self.viewCalendar.isHidden = false
                                                self.isStartDateSelected = dict.placeholder == AddTaskTitles.startDue
                                                let startDate = self.calendarView.currentPage.startOfMonth()
                                                let endDate = self.calendarView.currentPage.endOfMonth()
                                                
                                                let startDateStr = Utility.getStringFromDate(date: startDate, dateFormat: DateFormats.YYYY_MM_DD)
                                                let endDateStr = Utility.getStringFromDate(date: endDate, dateFormat: DateFormats.YYYY_MM_DD)
                                                
                                                self.viewModel.getAvailabilityList(fromDate: startDateStr, toDate: endDateStr, shiftId: self.selectedShiftSchedule?.shiftMasterId ?? 0,staffId: self.selectedStaffId)
                                                
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        if let cell = textField.superview?.superview as? TextInputCell{
                            if let indexPath = self.tblView.indexPath(for: (cell)) {
                                if let dictArr = (self.arrInput[indexPath.section] as? [Any])  {
                                    if let dict = dictArr[indexPath.row] as? InputTextfieldModel{
                                        if dict.placeholder == AddTaskTitles.selectTaskType {
                                            self.showMultiValuePicker(indexPath: indexPath,dropDownArray: dict.dropdownArr ?? [""])
                                        }else if (dict.placeholder == AddTaskTitles.residentName){
                                            self.viewModel.getStaffPatientDropdown(locationId: self.selectedLocationId, roleId: self.selectedRoleId, unitID: self.selectedUnitId, shiftId: self.selectedShiftSchedule?.shiftMasterId ?? 0) { (result) in
                                            self.viewModel.isLoading = false
                                            if let res = result as? PatientStaffMaster{
                                                self.residentDropdownArray = res.patients
                                                self.showMultiValuePicker(indexPath: indexPath,dropDownArray: self.residentDropdownArray ?? [""])
                                            }else{
                                                self.showMultiValuePicker(indexPath: indexPath,dropDownArray: [""])
                                                }
                                            }
                                        }
                                    }
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
        textField.resignFirstResponder()
        return true
/*
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
        return true*/
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        // Here Set The Next return field
        IQKeyboardManager.shared.toolbarDoneBarButtonItemText = ButtonTitles.done
        textField.keyboardToolbar.doneBarButton.setTarget(self, action: #selector(doneAction(textField:)))

        /*
        if textField.tag == self.arrInput.count - 1{
            IQKeyboardManager.shared.toolbarDoneBarButtonItemText = ButtonTitles.done
            textField.keyboardToolbar.doneBarButton.setTarget(self, action: #selector(doneAction(textField:)))
            
        }else{
            IQKeyboardManager.shared.toolbarDoneBarButtonItemText = ButtonTitles.next
            textField.keyboardToolbar.doneBarButton.setTarget(self, action: #selector(nextAction(textField:)))
            
        }*/
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
                                if let dictArr = arrInput as? [InputTextfieldModel]{
                                    var copyArr = dictArr
                                    let dict = copyArr[indexPath.row]
                                    if ((dict.inputType ?? "") == InputType.Dropdown){
                                    }else{
                                        dict.value = textField.text
                                        dict.valueId = textField.text
                                        dict.isValid = !(textField.text?.count == 0)
                                        self.arrInput[index] = dict
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
                    }else if let cell = textField.superview?.superview as? NumberInputCell{
                        if let indexPath = self.tblView.indexPath(for: (cell)) {
                            if let dictArr = (self.arrInput[indexPath.section] as? [Any]){
                                var copyArr = dictArr
                                if let dict = dictArr[indexPath.row] as? InputTextfieldModel{
                                    if  ((dict.inputType ?? "") == InputType.Number) || ((dict.inputType ?? "") == InputType.Decimal){
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
                        
                        if let arrInput = self.arrInput[index] as? [Any]{
                            if let cell = textField.superview?.superview as? DoubleInputCell{
                                print("Comes in did end")
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
                                            }else{
                                                if dict.placeholder == AddTaskTitles.unit{
                                                    let dict1 = arrSub[reqdIndex + 1]
                                                    dict1.value = ""
                                                    dict1.valueId = 0
                                                    dict1.isValid = false
                                                    copySubArray[reqdIndex + 1] = dict1
                                                    copyArr[indexPath.row] = copySubArray
                                                    self.arrInput[indexPath.section] = copyArr
                                                    cell.inputTf2.text = ""
                                                    
                                                    //Update Staff textfield to blank
                                                    if let arrSub = dictArr[indexPath.row + 1] as? [InputTextfieldModel]{
                                                        if let cell = self.tblView.cellForRow(at: IndexPath(row: indexPath.row + 1, section: indexPath.section)) as? DoubleInputCell{
                                                            let reqdIndex = 1
                                                            var copySubArray = arrSub
                                                            let dict2 = arrSub[reqdIndex]
                                                            dict2.value = ""
                                                            dict2.valueId = 0
                                                            dict2.isValid = false
                                                            
                                                            copySubArray[reqdIndex] = dict2
                                                            copyArr[indexPath.row + 1] = copySubArray
                                                            self.arrInput[indexPath.section] = copyArr
                                                            cell.inputTf2.text = ""

                                                        }
                                                    }
                                                    
                                                    //Update Resident name textfield to blank
                                                    if let dictArr = (self.arrInput[indexPath.section + 1] as? [Any]){
                                                        var copyArr = dictArr
                                                        if let dict = dictArr[0] as? InputTextfieldModel{
                                                            dict.value = ""
                                                            dict.valueId = 0
                                                            dict.isValid = false
                                                            copyArr[0] = dict
                                                            self.arrInput[indexPath.section + 1] = copyArr
                                                            
                                                            if let cellResident = self.tblView.cellForRow(at: IndexPath(row: 0, section: indexPath.section + 1)) as? TextInputCell{
                                                                cellResident.inputTf.text = ""
                                                            }
                                                        }
                                                    }
                                                }else if (dict.placeholder == AddTaskTitles.role){
                                                    let dict1 = arrSub[reqdIndex + 1]
                                                    dict1.value = ""
                                                    dict1.valueId = 0
                                                    dict1.isValid = false
                                                    copySubArray[reqdIndex + 1] = dict1
                                                    copyArr[indexPath.row] = copySubArray
                                                    self.arrInput[indexPath.section] = copyArr
                                                    cell.inputTf2.text = ""
                                                    
                                                    //Update Resident name textfield to blank
                                                    if let dictArr = (self.arrInput[indexPath.section + 1] as? [Any]){
                                                        var copyArr = dictArr
                                                        if let dict = dictArr[0] as? InputTextfieldModel{
                                                            dict.value = ""
                                                            dict.valueId = 0
                                                            dict.isValid = false
                                                            copyArr[0] = dict
                                                            self.arrInput[indexPath.section + 1] = copyArr
                                                            
                                                            if let cellResident = self.tblView.cellForRow(at: IndexPath(row: 0, section: indexPath.section + 1)) as? TextInputCell{
                                                                cellResident.inputTf.text = ""
                                                            }
                                                        }
                                                    }
                                                }else if (dict.placeholder == AddTaskTitles.shift){
                                                    self.viewModel.getShiftScheduleByShiftID(shiftId: (dict.valueId as? Int) ?? 0 ) { (result) in
                                                        self.viewModel.isLoading = false
                                                        if let res = result as? ShiftSchedule{
                                                            self.selectedShiftSchedule = res
                                                        }else{
                                                            self.selectedShiftSchedule = nil
                                                        }
                                                        
                                                        //Update Assigned To textfield to blank
                                                        if let dictArr = (self.arrInput[indexPath.section] as? [Any]){
                                                            var copyArr = dictArr
                                                            if let dict = dictArr[indexPath.row + 1] as? InputTextfieldModel{
                                                                dict.value = ""
                                                                dict.valueId = 0
                                                                dict.isValid = false
                                                                copyArr[indexPath.row + 1] = dict
                                                                self.arrInput[indexPath.section] = copyArr
                                                                
                                                                if let cellAssignedto = self.tblView.cellForRow(at: IndexPath(row: indexPath.row + 1, section: indexPath.section)) as? PickerInputCell{
                                                                    cellAssignedto.inputTf.text = ""
                                                                }
                                                            }
                                                        }

                                                        
                                                    }
                                                    
                                                    let startDate = self.calendarView.currentPage.startOfMonth()
                                                    let endDate = self.calendarView.currentPage.endOfMonth()
                                                    
                                                    let startDateStr = Utility.getStringFromDate(date: startDate, dateFormat: DateFormats.YYYY_MM_DD)
                                                    let endDateStr = Utility.getStringFromDate(date: endDate, dateFormat: DateFormats.YYYY_MM_DD)

                                                    self.viewModel.getAvailabilityList(fromDate: startDateStr, toDate: endDateStr, shiftId: self.selectedShiftSchedule?.shiftMasterId ?? 0,staffId: self.selectedStaffId)

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
    
    //Returns (Int,Int) -> (Index,SubIndex)
    func getIndexAndSubIndexFromTag(textFieldTag : Int) -> (Int,Int){
        var index = textFieldTag
        var dictIndex = 0

        if index < TagConstants.DoubleTF_FirstTextfield_Tag{
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
        print("index=== \(index), dictIndex = \(dictIndex)")
        
        return (index,dictIndex)
    }
    
    func getIndexForMultipleTf(textFieldTag : Int) -> Int{
            var index = textFieldTag
            var dictIndex = 0
            if index < TagConstants.DoubleTF_FirstTextfield_Tag{
            }else if textFieldTag >= TagConstants.RecursiveTF_FirstTextfield_Tag{
            let isFirstTf = index - TagConstants.RecursiveTF_FirstTextfield_Tag >= 0 && index - TagConstants.RecursiveTF_FirstTextfield_Tag < TagConstants.DoubleTF_FirstTextfield_Tag
            let isSecondTf = index >= TagConstants.RecursiveTF_SecondTextfield_Tag && index < TagConstants.RecursiveTF_ThirdTextfield_Tag
            
            if  isFirstTf{
                index = index - TagConstants.RecursiveTF_FirstTextfield_Tag
            }else if isSecondTf {
                index = index - TagConstants.RecursiveTF_SecondTextfield_Tag
            }else{
                index = index - TagConstants.RecursiveTF_ThirdTextfield_Tag
            }
            
    //            if let cell = self.activeTextfield?.superview?.superview as? RecursiveBPCell{
    //                if let indexPath = self.tblView.indexPath(for: cell){
    //                    if let mainArray = self.arrInput[indexPath.section] as? [Any]{
    //                        var copyMainArray = mainArray
    //                        if let subArray = copyMainArray[indexPath.row] as? [InputTextfieldModel]{
    //                            let dictIndex = self.getIndexForMultipleTf(textFieldTag: self.activeTextfieldTag)
    //                        }
    //                    }
    //                }
    //            }

                
    //        if let dict = self.arrInput[index] as? [Any]{
    //        }else{
                if  isFirstTf{
                    dictIndex = 0
                }else if isSecondTf {
                    dictIndex = 1
                }else{
                    dictIndex = 2
                }
          //  }
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

//MARK:- DateTimeInputCellDelegate
extension AddTaskViewController : DateTimeInputCellDelegate{
    func selectedDateForInput(date: Date, textfieldTag: Int, isDateField : Bool) {
        let dateStr = Utility.getStringFromDate(date: date, dateFormat: isDateField ? DateFormats.mm_dd_yyyy : DateFormats.hh_mm_a)
        debugPrint("Date = \(dateStr) --- Tf tag \(textfieldTag)")
        
//        let index = self.activeTextfieldTag
//        let indexPath = IndexPath(row: index, section: 0)
//
//        if let dict = self.arrInput[index] as? InputTextfieldModel{
//            let copyDict = dict
//            copyDict.value = dateStr
//            copyDict.valueId = date
//            copyDict.isValid = true
//            self.arrInput[index] = copyDict
//        }
//
//        if let cell = self.tblView.cellForRow(at: indexPath) as? DateTimeInputCell{
//            cell.inputTf.text = dateStr
//        }
        
        let indexTuple = self.getIndexAndSubIndexFromTag(textFieldTag: self.activeTextfieldTag)
               let index = indexTuple.0
        let dictIndex = self.getIndexForMultipleTf(textFieldTag: self.activeTextfieldTag)//indexTuple.1
               
               let isFirstTf = index - TagConstants.DoubleTF_FirstTextfield_Tag >= 0 && index - TagConstants.DoubleTF_FirstTextfield_Tag < TagConstants.DoubleTF_FirstTextfield_Tag
               
        if let cell = self.activeTextfield?.superview?.superview as? DoubleInputCell{
               if let indexPath = self.tblView.indexPath(for: cell){//IndexPath(row: index, section: 0){

                if let dictArr = (self.arrInput[indexPath.section] as! [Any]) as? [InputTextfieldModel]{
                    var copyArr = dictArr
                    let dict = copyArr[dictIndex]
                    dict.value = dateStr
                    dict.valueId = dateStr
                    dict.isValid = true
                    copyArr[dictIndex] = dict
                    self.arrInput[index] = copyArr
                    
                    
                }
               
                   if  dictIndex == 0{
                       cell.inputTf1.text = dateStr
                   }else{
                       cell.inputTf2.text = dateStr
                   }
               }
        }else if let cell = self.activeTextfield?.superview?.superview as? DateTimeInputCell{
            if let indexPath = self.tblView.indexPath(for: cell){
                if let dictArr = (self.arrInput[indexPath.section] as? [Any])  {
                    var copyArr = dictArr
                    if let dict = copyArr[indexPath.row] as? InputTextfieldModel{
                        if((dict.inputType ?? "") == InputType.Date || (dict.inputType ?? "") == InputType.Time)
                        {
                            _ = (dict.inputType ?? "") == InputType.Date
                            
                            dict.value = dateStr
                            dict.valueId = dateStr//Date()
                            dict.isValid = true
                            copyArr[indexPath.row] = dict
                            self.arrInput[indexPath.section] = copyArr
                            
                            cell.inputTf.text = dateStr
                        }
                    }
                }
            }
        }
        
    }
}
//MARK:- PickerInputCellDelegate
extension AddTaskViewController : PickerInputCellDelegate{
    func selectedPickerValueForInput(value: Any, valueID : Any, textfieldTag: Int) {
        
        if let indexPath = self.tblView.indexPath(for: (self.activeTextfield?.superview?.superview as! PickerInputCell)){
            if let dictArr = (self.arrInput[indexPath.section] as? [Any])  {
                var copyArr = dictArr
                if let dict = copyArr[indexPath.row] as? InputTextfieldModel{
                    if ((dict.inputType ?? "") == InputType.Dropdown){
                        let tempDict = dict
                        tempDict.value = (value as? String) ?? ""
                        tempDict.valueId = valueID
                        tempDict.isValid = true
                        copyArr[indexPath.row] = tempDict
                        self.arrInput[indexPath.section] = copyArr
                        self.activeTextfield?.text = (value as? String) ?? ""
                        
                        if (tempDict.placeholder ?? "") == AddTaskTitles.assignedto{
                            self.selectedStaffId = (valueID as? Int) ?? 0
                        }
                    }
                }
            }
        }
        
        /*
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
        
        if let cell = self.tblView.cellForRow(at: indexPath) as? PickerInputCell{
            cell.inputTf.text = (value as? String) ?? ""
        }*/
    }
    
}

//MARK:- DoubleInputCellDelegate
extension AddTaskViewController : DoubleInputCellDelegate{
    func selectedDateForDoubleInput(date : Date, textfieldTag : Int, isDateField : Bool){
        let dateStr = Utility.getStringFromDate(date: date, dateFormat: isDateField ? DateFormats.mm_dd_yyyy : DateFormats.hh_mm_a)
        if self.checkStaffAvailability(date: date) {
            self.setSelectedValueInTextfield(value: dateStr, valueId: date, index: self.activeTextfieldTag)
        }else{
            self.viewModel.errorMessage = "Provider is not available on this date."
        }
    }
    
    func checkStaffAvailability(date:Date ) -> Bool{
        var dayArr = [Days]()
        if let scheduleDays = self.selectedShiftSchedule?.days as? [Days]{
            dayArr = scheduleDays.compactMap { (days) -> Days? in
                return (days.dayId ?? 0 == date.getDayOfWeek()) ? days : nil
            }
        }
        
        var isSelectedDateValid = false
        for (_,day) in dayArr.enumerated(){
            if let startTime = self.convertServerTimeToValidTime(dateStr: day.startTime ?? "") as? Date{
                if let endTime = self.convertServerTimeToValidTime(dateStr: day.endTime ?? "") as? Date{
                    if self.isDaySame(fromDate: date, toDate: startTime){
                        isSelectedDateValid = true
                        break
                    }
                }
            }
        }
        return isSelectedDateValid
    }
    
    func isDaySame(fromDate: Date,toDate : Date) -> Bool{
        let diff = Calendar.current.dateComponents([.day], from: fromDate, to: toDate)
        return diff.day == 0
    }
    func convertServerTimeToValidTime(dateStr : String) -> Date?{
        let str = dateStr.replacingOccurrences(of: "T", with: " ")
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DateFormats.server_format
        let date = dateFormatter.date(from: str)
        return date
    }
    func selectedPickerValueForDoubleInput(value : Any, valueID : Any, textfieldTag : Int)
    {
        
        self.setSelectedValueInTextfield(value: value, valueId: valueID, index: self.activeTextfieldTag)
    }
    
    func setSelectedValueInTextfield(value : Any , valueId : Any, index : Int){
        let indexTuple = self.getIndexAndSubIndexFromTag(textFieldTag: self.activeTextfieldTag)
        let index = indexTuple.0
        let dictIndex = self.getIndexForMultipleTf(textFieldTag: self.activeTextfieldTag)
        
        let isFirstTf = index - TagConstants.DoubleTF_FirstTextfield_Tag >= 0 && index - TagConstants.DoubleTF_FirstTextfield_Tag < TagConstants.DoubleTF_FirstTextfield_Tag
        
        if let indexPath = self.tblView.indexPath(for: (self.activeTextfield?.superview?.superview as! DoubleInputCell)){//IndexPath(row: index, section: 0){

        if let dictArr = (self.arrInput[indexPath.section] as? [Any]){
            print("Indexpath==== section : \(indexPath.section), row: \(indexPath.row)")
            print("App instance textfield tag === \(AppInstance.shared.activeTextfieldIndex)")
            print("textfield tag === \(self.activeTextfieldTag)")

            var copySectionArray = dictArr
            var copyArr = copySectionArray[indexPath.row] as! [InputTextfieldModel]
            let dict = copyArr[dictIndex]
            dict.value = (value as? String) ?? ""
            dict.valueId = valueId
            dict.isValid = true
            copyArr[dictIndex] = dict
            copySectionArray[indexPath.row] = copyArr
            self.arrInput[indexPath.section] = copySectionArray
            
            if (dict.placeholder ?? "") == AddTaskTitles.startDue{
                self.selectedStartDate = valueId as? Date
            }else{
                self.selectedEndDate = valueId as? Date
            }
 
        }
        
        if let cell = self.tblView.cellForRow(at: indexPath) as? DoubleInputCell{
            if  dictIndex == 0{
                if let dictArr = (self.arrInput[indexPath.section] as? [Any]){
                    var copyArr = dictArr[indexPath.row] as! [InputTextfieldModel]
                    let dict = copyArr[dictIndex]
                    if dict.placeholder == AddTaskTitles.unit{
                        
                        self.viewModel.unitID = (valueId as? Int) ?? 0
                        self.selectedUnitId = (valueId as? Int) ?? 0
                    }
                    
                    if dict.placeholder == AddTaskTitles.role{
                        self.selectedRoleId = (valueId as? Int) ?? 0
                    }

                }

                cell.inputTf1.text = (value as? String) ?? ""
            }else{
                cell.inputTf2.text = (value as? String) ?? ""
            }
        }
        }
    }
}


//MARK:- UICollectionViewDelegate & UICollectionViewDataSource
extension AddTaskViewController : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagesArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReuseIdentifier.MultipleImageCell, for: indexPath) as! MultipleImageCell
        
//        if let url = self.attachmentArray[indexPath.row] as? URL{
//            cell.imgAttachment.image = self.pdfThumbnail(withUrl: url)
//        }
       
        //Attachment Type = Photo (Selected photo from gallery/icloud)
        if let asset = self.imagesArray[indexPath.row].image as? PHAsset{
            asset.image(completionHandler: { (thumbnail) in
                cell.imgAttachment.image = thumbnail
            })
        }else if let image = self.imagesArray[indexPath.row].image as? UIImage {
            cell.imgAttachment.image = image
        }//Attachment Type = PDF  (Selected photo from drive)
        else if let _ = self.imagesArray[indexPath.row].image as? Data{
          cell.imgAttachment.image = UIImage.docPlaceholder()
        }
        
        cell.lblDate.text = Utility.getStringFromDate(date: self.imagesArray[indexPath.row].date, dateFormat: DateFormats.MM_dd_yyyy_hh_mm_a)
        cell.btnDelete.tag = indexPath.row
        
        cell.btnDelete.addTarget(self, action: #selector(self.btnDeleteAttachment_Action(_:)), for: .touchUpInside)

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
         
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return  CGSize(width: 150, height: 150)
    }
    
    @objc func btnDeleteAttachment_Action(_ sender: UIButton){
        self.imagesArray.remove(at: sender.tag)
        self.imagesCollectionView.reloadData()
        
        self.viewImages.isHidden = self.imagesArray.isEmpty
        self.btnShowImages.isHidden = self.imagesArray.isEmpty

    }


    
}


