//
//  TaskListViewController.swift
//  appName
//
//  Created by Vasundhara Parakh on 3/5/20.
//  Copyright © 2020 smartData Enterprises (I) Ltd. All rights reserved.
//

import UIKit
import SDWebImage
enum TaskStatus : Int {
    
    case ToDo = 1
    case InProgress = 2
    case Completed = 3
    case Decline = 4

    func getStatusType() -> String{
        switch self {
        case .ToDo :
            return "ToDo,Pending"
        case .InProgress :
            return "InProgress"
        case .Completed :
            return "Complete"
        case .Decline :
            return "Decline"
        default:
            return ""
        }
    }
    
    static let taskIncompleteID = 3
    static let taskCompleteID = 1
    static let taskDeclineID = 6

}
class TaskListViewController : BaseViewController {
    var toDoAlertView : CustomAlertView = CustomAlertView()
    var inProgressAlertView : CustomAlertView = CustomAlertView()

    lazy var viewModel: TaskListViewModel = {
        let obj = TaskListViewModel(with: TaskService())
        self.baseViewModel = obj
        return obj
    }()
    

    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var btnToDo: UIButton!
    @IBOutlet weak var btnInProgress: UIButton!
    @IBOutlet weak var btnCompleted: UIButton!

    var selectedStatus = TaskStatus.ToDo.rawValue
    var selectedIndex = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationItem.title = NavigationTitle.MyTask
        self.viewModel.getTaskList(statusType: TaskStatus.ToDo.getStatusType())
        self.addBackButton()
        self.setupClosures()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewModel.getTaskList(statusType: self.getTaskStatusType(status: self.selectedStatus))
        self.initialSetup()
    }
    
    func getTaskStatusType(status : Int) -> String{
        switch status {
        case 1 :
            return "ToDo,Pending"
        case 2 :
            return "InProgress"
        case 3 :
            return "Complete"
        case 4 :
            return "Decline"
        default:
            return ""
        }
    }
        
    func initialSetup(){
        self.tblView.register(UINib(nibName: ReuseIdentifier.ListTableViewCell, bundle: nil), forCellReuseIdentifier: ReuseIdentifier.ListTableViewCell)
        
    }
    
    func setupClosures() {
        self.viewModel.reloadListViewClosure = { [weak self] () in
            DispatchQueue.main.async {
                self?.tblView.reloadData()
            }
        }
    }
    

    @IBAction func taskBtns_Clicked(_ sender: Any) {
        self.selectedStatus = (sender as! UIButton).tag
        switch self.selectedStatus {
        case TaskStatus.ToDo.rawValue:
            self.btnCompleted.alpha = 0.5
            self.btnInProgress.alpha = 0.5
            self.btnToDo.alpha = 1.0
            self.viewModel.getTaskList(statusType: TaskStatus.ToDo.getStatusType())

        case TaskStatus.InProgress.rawValue:
            self.btnCompleted.alpha = 0.5
            self.btnInProgress.alpha = 1.0
            self.btnToDo.alpha = 0.5
            self.viewModel.getTaskList(statusType: TaskStatus.InProgress
                .getStatusType())

        case TaskStatus.Completed.rawValue:
            self.btnCompleted.alpha = 1.0
            self.btnInProgress.alpha = 0.5
            self.btnToDo.alpha = 0.5
            self.viewModel.getTaskList(statusType: TaskStatus.Completed.getStatusType())

        default:
            print("Do nothing")
        }

    }
}

extension TaskListViewController:UITableViewDataSource, UITableViewDelegate {
   func numberOfSections(in tableView: UITableView) -> Int {
       if self.viewModel.numberOfRows() > 0{
           Utility.setEmptyTableFooter(tableView: tableView)
       }else{
           Utility.setTableFooterWithMessage(tableView: tableView, message: Alert.Message.noRecords)
       }
       return 1
   }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ReuseIdentifier.TaskListCell, for: indexPath as IndexPath) as! TaskListCell
        let task = self.viewModel.roomForIndexPath(indexPath)
        cell.task = task
        cell.lblStatusHeightConstraint.constant = self.selectedStatus == TaskStatus.ToDo.rawValue ? 23 : 0
        cell.btnDocument.tag = indexPath.row
        cell.btnDocument.addTarget(self, action: #selector(self.btnDocument_clicked(button:)), for: .touchUpInside)
        
        return cell
    }
    
    @objc func  btnDocument_clicked(button : UIButton) {
        let vc = PreviewDocumentViewController.instantiate(appStoryboard: Storyboard.VirtualConsult) as! PreviewDocumentViewController
        vc.modalPresentationStyle = .overFullScreen
        vc.docUrl = self.viewModel.roomForIndexPath(IndexPath(row: button.tag, section: 0)).filePath ?? ""
        vc.hidesBottomBarWhenPushed = true
        self.present(vc, animated: false, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        self.selectedIndex = indexPath.row
        switch self.selectedStatus {
        case TaskStatus.ToDo.rawValue:
            self.showTODOPopup()
        case TaskStatus.InProgress.rawValue:
             self.showInProgressPopup()
        default:
            print("Do nothing")
        }
    }
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        if self.selectedStatus == TaskStatus.Completed.rawValue{
        let delete = UITableViewRowAction(style: .destructive, title: "") { (action, indexPath) in
            let task = self.viewModel.roomForIndexPath(indexPath)
            // create an actionSheet
            let actionSheetController: UIAlertController = UIAlertController(title: Alert.Title.appName, message: "Are you sure you want to delete this task?", preferredStyle: .alert)
            // create an action
            
            let firstAction: UIAlertAction = UIAlertAction(title: Alert.ButtonTitle.yes, style: .default) { action -> Void in
                self.viewModel.deleteTask(params: ["appointmentId":"\(task.taskId ?? 0)"]) { (result) in
                    self.viewModel.getTaskList(statusType: TaskStatus.Completed.getStatusType())
                }
                
                /*let vc = CancelTaskViewController.instantiate(appStoryboard: Storyboard.Forms) as! CancelTaskViewController
                vc.hidesBottomBarWhenPushed = true
                vc.appointmentId = task.patientAppointmentId ?? 0
                self.navigationController?.pushViewController(vc,animated:true)*/

            }
            let secondAction: UIAlertAction = UIAlertAction(title: Alert.ButtonTitle.no, style: .default) { action -> Void in
            }
            // add actions
            actionSheetController.addAction(firstAction)
            actionSheetController.addAction(secondAction)
            actionSheetController.view.tintColor = Color.DarkGray
            actionSheetController.popoverPresentationController?.sourceView = self.view // works for both iPhone & iPad
            self.present(actionSheetController, animated: true) {
                //debugPrint("option menu presented")
            }
        }
        delete.backgroundColor = Utility.getEditImageAsBackground(tableView: tableView, image: UIImage(named: "red_delete")!, indexPath: indexPath,bgColor: UIColor.white)
        
        
        return  [delete]
        }
        if self.selectedStatus == TaskStatus.InProgress.rawValue{
            let task = self.viewModel.roomForIndexPath(indexPath)
            let vc = CancelTaskViewController.instantiate(appStoryboard: Storyboard.Forms) as! CancelTaskViewController
            vc.hidesBottomBarWhenPushed = true
            vc.appointmentId = task.taskId ?? 0
            self.navigationController?.pushViewController(vc,animated:true)
        }
        if self.selectedStatus == TaskStatus.ToDo.rawValue{
            let task = self.viewModel.roomForIndexPath(indexPath)
            let vc = CancelTaskViewController.instantiate(appStoryboard: Storyboard.Forms) as! CancelTaskViewController
            vc.hidesBottomBarWhenPushed = true
            vc.appointmentId = task.taskId ?? 0
            self.navigationController?.pushViewController(vc,animated:true)
        }
        return []
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

class TaskListCell: UITableViewCell {
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblRoomNo: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblPriority: UILabel!
    @IBOutlet weak var lblAssignedBy: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var imgProfilePic: UIImageView!
    @IBOutlet weak var lblTaskType: UILabel!
    @IBOutlet weak var lblStatusHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var lblStartDate: UILabel!
    @IBOutlet weak var lblDueDate: UILabel!
    @IBOutlet weak var btnDocument: UIButton!
    @IBOutlet weak var lblRoomTitle: UILabel!

    var task: Task?{
        didSet{
            setUpData()
        }
    }
        
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setUpData(){
        
        //Update Labels
        let roomNoPrefix = ""//ConstantStrings.roomNoPrefix
        let taskDescriptionPrefix = ""// ConstantStrings.taskDescriptionPrefix
        let highlightFont =  Device.IS_IPAD ? UIFont.PoppinsRegular(fontSize: 16.0) : UIFont.PoppinsRegular(fontSize: 14.0)
        
        self.lblName.text = task?.residenceName ?? ConstantStrings.NA
        
        var room = (task?.roomNumberUnit ?? "") + " " + (task?.roomNumber ?? "")
        room = room.count > 1 ? room : "Waiting Room"
        self.lblRoomNo.attributedText = Utility.highlightPartialTextOfLabel(mainString: roomNoPrefix + (room), highlightString: roomNoPrefix,highlightColor: Color.ListLabelHeading,highlightFont:highlightFont )
        
        let attributedStrTask = Utility.highlightPartialTextOfLabel(mainString: "\(task?.taskType ?? ConstantStrings.NA)", highlightString: "Task",highlightColor: Color.ListLabelHeading,highlightFont:highlightFont )
        let attributedStrTaskDesc = Utility.highlightPartialTextOfLabel(mainString:  taskDescriptionPrefix + (task?.taskDescription ?? ConstantStrings.NA), highlightString: taskDescriptionPrefix,highlightColor: Color.ListLabelHeading,highlightFont:highlightFont )

        self.lblTaskType.attributedText = attributedStrTask

        self.lblDescription.attributedText = attributedStrTaskDesc.length == 0 ? NSAttributedString(string: "NA")  : attributedStrTaskDesc
        
        self.lblPriority.text = (task?.taskPriority ?? ConstantStrings.NA)
        
        self.lblAssignedBy.text = "\(task?.assinee ?? ConstantStrings.NA)"
        
        self.lblStatus.text = task?.taskStatus ?? ConstantStrings.NA
        
        let startDate = Utility.convertServerDateToRequiredDate(dateStr: task?.startDateTime ?? "", requiredDateformat: DateFormats.mm_dd_yyyy)
        self.lblStartDate.text = startDate

        let dueDate = Utility.convertServerDateToRequiredDate(dateStr: task?.endDateTime ?? "", requiredDateformat: DateFormats.mm_dd_yyyy)
        self.lblDueDate.text = dueDate

        //Load Profile Picture
        self.imgProfilePic.roundedCorner()
        self.imgProfilePic.sd_imageIndicator = SDWebImageActivityIndicator.gray
        self.imgProfilePic.sd_setImage(with: URL(string:(task?.patientPhotoPath ?? "")), placeholderImage: UIImage.defaultProfilePicture(), completed: nil)
        self.imgProfilePic.addFullScreenView()

        self.btnDocument.isHidden = (task?.filePath ?? "").count == 0
        
        //Customizing organisation Type
        self.lblRoomTitle.text = (UserDefaults.getOrganisationType() == OrganisationType.HomeCare || UserDefaults.getOrganisationType() == OrganisationType.Clinic) ? "Address :" : "Room :"

        if UserDefaults.getOrganisationType() == OrganisationType.HomeCare || UserDefaults.getOrganisationType() == OrganisationType.Clinic{
            self.lblRoomNo.attributedText = Utility.highlightPartialTextOfLabel(mainString: roomNoPrefix + (task?.address ?? ConstantStrings.NA), highlightString: roomNoPrefix,highlightColor: Color.ListLabelHeading,highlightFont:highlightFont )
        }
        //Ends

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

extension TaskListViewController : CustomAlertViewDelegate{
   
    func showTODOPopup(){
        self.toDoAlertView = Bundle.main.loadNibNamed("CustomAlertView", owner: self, options: nil)?.first as! CustomAlertView
        self.toDoAlertView.lblSubtitle.text = Alert.Message.startTask
        self.toDoAlertView.btnLeft.setTitle(Alert.ButtonTitle.accept, for: .normal)
        self.toDoAlertView.btnRight.setTitle(Alert.ButtonTitle.decline, for: .normal)
        
        if let window =  UIApplication.shared.windows.first as? UIWindow{
            self.toDoAlertView.frame = window.frame
            self.toDoAlertView.delegate = self
            window.addSubview(self.toDoAlertView)
        }
    }
    func showInProgressPopup(){
        self.inProgressAlertView = Bundle.main.loadNibNamed("CustomAlertView", owner: self, options: nil)?.first as! CustomAlertView
        self.inProgressAlertView.lblSubtitle.text = Alert.Message.completeTask
        self.inProgressAlertView.btnLeft.setTitle(Alert.ButtonTitle.fillForm, for: .normal)
        self.inProgressAlertView.btnRight.setTitle(Alert.ButtonTitle.completed, for: .normal)

        if let window =  UIApplication.shared.windows.first as? UIWindow{
            self.inProgressAlertView.frame = window.frame
            self.inProgressAlertView.delegate = self
            window.addSubview(self.inProgressAlertView)
        }
    }
    
    func btnLeft_Action(forView: CustomAlertView) {
        self.inProgressAlertView.removeFromSuperview()
        self.toDoAlertView.removeFromSuperview()
        
        let task = self.viewModel.roomForIndexPath(IndexPath(row: self.selectedIndex, section: 0))
        if self.selectedStatus == TaskStatus.ToDo.rawValue{
            self.viewModel.arrTasks.remove(at: self.selectedIndex)
            self.viewModel.updateTaskStatus(taskStatus: TaskStatus.taskIncompleteID, taskID: task.taskId ?? 0)
        }else{
            let vc = CreateTARViewController.instantiate(appStoryboard: Storyboard.Forms) as! CreateTARViewController
            vc.hidesBottomBarWhenPushed = true
            vc.patientId = task.patientID ?? 0
            vc.selectedTask = task
            vc.checkReportType = 2
            SharedappName.sharedInstance.isCommingToCreatTar = "TaskListViewController"
            self.navigationController?.pushViewController(vc,animated:false)

            /*
            let vc = TARListViewController.instantiate(appStoryboard: Storyboard.Dashboard) as! TARListViewController
            vc.hidesBottomBarWhenPushed = true
            vc.patientID = task.patientID ?? 0
            self.navigationController?.pushViewController(vc,animated:true)*/
        }


    }
    func btnRight_Action(forView: CustomAlertView) {
        self.inProgressAlertView.removeFromSuperview()
        self.toDoAlertView.removeFromSuperview()
        let task = self.viewModel.roomForIndexPath(IndexPath(row: self.selectedIndex, section: 0))
        self.viewModel.arrTasks.remove(at: self.selectedIndex)
        if self.selectedStatus == TaskStatus.ToDo.rawValue{
            //self.viewModel.updateTaskStatus(taskStatus: TaskStatus.taskDeclineID, taskID: task.taskId ?? 0)
            let vc = CancelTaskViewController.instantiate(appStoryboard: Storyboard.Forms) as! CancelTaskViewController
            vc.hidesBottomBarWhenPushed = true
            vc.appointmentId = task.taskId ?? 0
            self.navigationController?.pushViewController(vc,animated:true)
        }else{
            self.viewModel.updateTaskStatus(taskStatus: TaskStatus.taskCompleteID, taskID: task.taskId ?? 0)
        }
    }
}
