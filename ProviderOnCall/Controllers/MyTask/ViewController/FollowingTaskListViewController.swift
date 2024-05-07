//
//  FollowingTaskListViewController.swift
//  AccessEMR
//
//  Created by Vasundhara Parakh on 4/7/20.
//  Copyright © 2020 smartData Enterprises (I) Ltd. All rights reserved.
//

import UIKit
import SDWebImage
class FollowingTaskListViewController: BaseViewController {
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    lazy var viewModel: FollowingTaskListViewModel = {
        let obj = FollowingTaskListViewModel(with: TaskService())
        self.baseViewModel = obj
        return obj
    }()
    var residentList = [Resident]()
    
    //LoadMore
    var spinner: UIActivityIndicatorView = UIActivityIndicatorView()
    
    //Pull to Refresh
    var refreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialSetup()
        self.viewModel.getFollowingTaskList(pageNo: 1, searchText: searchBar.text ?? "")
        self.setupClosures()
        self.addRefreshController()
        self.navigationItem.title = NavigationTitle.FollowingTask
        self.addBackButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
            
        
    }
    
    func setupClosures() {
        self.viewModel.reloadListViewClosure = { [weak self] () in
            DispatchQueue.main.async {
                self?.tblView.tableFooterView = self?.viewModel.strForIsMore == ConstantStrings.no ? nil : self?.spinner
                self?.tblView.reloadData()
                self?.refreshControl.endRefreshing()
            }
        }
    }
    
    func addRefreshController(){
        self.refreshControl.addTarget(self, action: #selector(handleTopRefresh(_:)), for: .valueChanged )
        self.refreshControl.tintColor = Color.LightGray
        self.tblView.addSubview(self.refreshControl)
    }

    @IBAction func btnInfo_Action(_ sender: Any) {
        (sender as! UIButton).isSelected = !(sender as! UIButton).isSelected
        self.showTipView(textString: ConstantStrings.searchHelpTask, senderBtn: sender as! UIButton)
    }
    @objc func handleTopRefresh(_ sender:UIRefreshControl){
        self.viewModel.getFollowingTaskList(pageNo: 1, searchText: searchBar.text ?? "")

    }

    func initialSetup(){
        //LoadMore
        self.spinner.color = Color.LightGray
        self.spinner.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        self.tblView.tableFooterView = spinner
        //Ends

    }
    
    //MARK:- Pull To LoadMore
    @objc func loadMore(){
        self.tblView.tableFooterView = spinner
        spinner.startAnimating()
        self.viewModel.getFollowingTaskList(pageNo: self.viewModel.intForPageNo, searchText: searchBar.text ?? "")

    }

}

extension FollowingTaskListViewController:UITableViewDataSource, UITableViewDelegate {
   
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
        let cell = tableView.dequeueReusableCell(withIdentifier: ReuseIdentifier.FollowingListCell, for: indexPath as IndexPath) as! FollowingListCell
        cell.task = self.viewModel.roomForIndexPath(indexPath)
        cell.btnDelete.addTarget(self, action: #selector(self.btnDelete_Action(_:)), for: .touchUpInside)
        cell.btnDocument.tag = indexPath.row
        cell.btnDocument.addTarget(self, action: #selector(self.btnDocument_clicked(button:)), for: .touchUpInside)
            
            return cell
        }
        
        @objc func  btnDocument_clicked(button : UIButton) {
            let vc = PreviewDocumentViewController.instantiate(appStoryboard: Storyboard.VirtualConsult) as! PreviewDocumentViewController
            vc.modalPresentationStyle = .overFullScreen
            vc.docUrl = self.viewModel.roomForIndexPath(IndexPath(row: button.tag, section: 0)).uploadpath ?? ""
            vc.hidesBottomBarWhenPushed = true
            self.present(vc, animated: false, completion: nil)
        }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //Load More Functionality:--
        debugPrint("Load More === \(self.viewModel.numberOfRows())")
        if indexPath.row == self.viewModel.numberOfRows()-1 {
            if self.viewModel.strForIsMore == ConstantStrings.yes {
                self.perform(#selector(loadMore), with: nil, afterDelay: 0.0)
            }
        }
    }
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "") { (action, indexPath) in
            let task = self.viewModel.roomForIndexPath(indexPath)
            // create an actionSheet
            let actionSheetController: UIAlertController = UIAlertController(title: Alert.Title.appName, message: "Are you sure you want to delete this task?", preferredStyle: .alert)
            // create an action
            
            let firstAction: UIAlertAction = UIAlertAction(title: Alert.ButtonTitle.yes, style: .default) { action -> Void in
                self.viewModel.deleteTask(params: ["appointmentId":"\(task.patientAppointmentId ?? 0)"]) { (result) in
                        self.viewModel.getFollowingTaskList(pageNo: 1, searchText: "")
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
    @IBAction func btnDelete_Action(_ sender: Any) {
        let indexPath = IndexPath(row: (sender as! UIButton).tag, section: 0)
        let task = self.viewModel.roomForIndexPath(indexPath)
        // create an actionSheet
        let actionSheetController: UIAlertController = UIAlertController(title: Alert.Title.appName, message: "Are you sure you want to delete this task?", preferredStyle: .alert)
        // create an action
        
        let firstAction: UIAlertAction = UIAlertAction(title: Alert.ButtonTitle.yes, style: .default) { action -> Void in
            self.viewModel.deleteTask(params: ["appointmentId":task.patientAppointmentId ?? 0]) { (result) in
                    self.viewModel.getFollowingTaskList(pageNo: 1, searchText: "")
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
        present(actionSheetController, animated: true) {
            //debugPrint("option menu presented")
        }
    }
    
}

extension FollowingTaskListViewController: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        NSObject.cancelPreviousPerformRequests(
            withTarget: self,
            selector: #selector(self.getHintsFromSearchBar),
            object: searchBar)
        self.perform(
            #selector(self.getHintsFromSearchBar),
            with: searchBar,
            afterDelay: 0.5)
        
    }
    //Search text with delay
    @objc func getHintsFromSearchBar(searchBar: UISearchBar) {
        self.viewModel.getFollowingTaskList(pageNo: 1, searchText: searchBar.text ?? "")
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.viewModel.getFollowingTaskList(pageNo: 1, searchText:  "")

        self.view.endEditing(true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.viewModel.getFollowingTaskList(pageNo: 1, searchText: searchBar.text ?? "")

        self.view.endEditing(true)
    }
}

class FollowingListCell: UITableViewCell {
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblRoomNo: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblPriority: UILabel!
    @IBOutlet weak var lblAssignedBy: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var imgProfilePic: UIImageView!
    @IBOutlet weak var lblTaskType: UILabel!
    @IBOutlet weak var lblStatusHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var btnDelete: UIButton!
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
        let taskDescriptionPrefix = ""//ConstantStrings.taskDescriptionPrefix
        let highlightFont =  Device.IS_IPAD ? UIFont.PoppinsRegular(fontSize: 16.0) : UIFont.PoppinsRegular(fontSize: 14.0)
        
        self.lblName.text = task?.residenceName ?? ConstantStrings.NA
        
        var room = (task?.roomNumberUnit ?? "") + (task?.roomNumber ?? "")
        room = room.count > 0 ? room : "Waiting Room"
        self.lblRoomNo.attributedText = Utility.highlightPartialTextOfLabel(mainString: roomNoPrefix + (room), highlightString: roomNoPrefix,highlightColor: Color.ListLabelHeading,highlightFont:highlightFont )
        
        let attributedStrTask = Utility.highlightPartialTextOfLabel(mainString: "\(task?.taskType ?? ConstantStrings.NA)", highlightString: "Task",highlightColor: Color.ListLabelHeading,highlightFont:highlightFont )
        let attributedStrTaskDesc = Utility.highlightPartialTextOfLabel(mainString:  taskDescriptionPrefix + (task?.taskDescription ?? ConstantStrings.NA), highlightString: taskDescriptionPrefix,highlightColor: Color.ListLabelHeading,highlightFont:highlightFont )

        self.lblTaskType.attributedText = attributedStrTask

        self.lblDescription.attributedText = attributedStrTaskDesc.length == 0 ? NSAttributedString(string: "NA")  : attributedStrTaskDesc
        
        self.lblPriority.text = (task?.taskPriority ?? ConstantStrings.NA)
        
        self.lblAssignedBy.text = "\(task?.assingnedTo ?? ConstantStrings.NA)"
        
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

        self.btnDocument.isHidden = (task?.uploadpath ?? "").count == 0

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
