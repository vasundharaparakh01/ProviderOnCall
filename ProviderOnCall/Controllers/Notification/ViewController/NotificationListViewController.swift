//
//  NotificationListViewController.swift

//
//  Created by Vasundhara Parakh on 5/12/20.
//  Copyright © 2020 smartData Enterprises (I) Ltd. All rights reserved.
//

import UIKit

class NotificationListViewController: BaseViewController {
    @IBOutlet weak var tblView: UITableView!
    lazy var viewModel: NotificationListViewModel = {
        let obj = NotificationListViewModel(with: UserService())
        self.baseViewModel = obj
        return obj
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addrightBarButtonItem()
        self.addBackButton()
        self.setupClosures()
        self.navigationItem.title = NavigationTitle.Notifications
        self.initialSetup()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    func addrightBarButtonItem() {
        let rightBarButtonItem = UIBarButtonItem(title: "Delete All", style: .plain, target:  self, action: #selector(onRightBarButtonItemClicked(_ :)))
        rightBarButtonItem.tintColor = UIColor.white
        navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    // MARK:
    @objc func onRightBarButtonItemClicked(_ sender: UIBarButtonItem) {
        let notificationIds = self.viewModel.arrNotification.compactMap({$0.notificationID ?? 0})
        let actionSheetController: UIAlertController = UIAlertController(title: Alert.Title.appName, message: "Are you sure you want to delete all the notifications?", preferredStyle: .alert)
        // create an action
        
        let firstAction: UIAlertAction = UIAlertAction(title: Alert.ButtonTitle.yes, style: .default) { action -> Void in
            self.viewModel.deleteNotification(notificationIds: notificationIds)
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
    func setupClosures() {
        self.viewModel.reloadListViewClosure = { [weak self] () in
            DispatchQueue.main.async {
                self?.tblView.reloadData()
            }
        }
    }
    

    func initialSetup(){
        self.viewModel.getNotificationList()
    }
    

}

extension NotificationListViewController:UITableViewDataSource, UITableViewDelegate {
   
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ReuseIdentifier.NotificationCell, for: indexPath as IndexPath) as! NotificationCell
        cell.notification = self.viewModel.roomForIndexPath(indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let notificationId = self.viewModel.roomForIndexPath(indexPath).notificationID ?? 0
        let delete = UITableViewRowAction(style: .destructive, title: "") { (action, indexPath) in
            let actionSheetController: UIAlertController = UIAlertController(title: Alert.Title.appName, message: "Are you sure you want to delete this notification?", preferredStyle: .alert)
            // create an action
            
            let firstAction: UIAlertAction = UIAlertAction(title: Alert.ButtonTitle.yes, style: .default) { action -> Void in
                self.viewModel.deleteNotification(notificationIds: [notificationId])
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
    

    
//    @available(iOS 11.0, *)
//    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//        let delete = UIContextualAction(style: .destructive, title: "Delete") { (action, sourceView, completionHandler) in
//            print("index path of delete: \(indexPath)")
//            completionHandler(true)
//        }
//
//        let swipeActionConfig = UISwipeActionsConfiguration(actions: [delete])
//        swipeActionConfig.performsFirstActionWithFullSwipe = false
//        return swipeActionConfig
//    }
    

}

class NotificationCell: UITableViewCell {
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblDate: UILabel!

    var notification: NotificationList?{
        didSet{
            setUpData()
        }
    }
        
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setUpData(){
        
        self.lblTitle.text = (notification?.notificationType ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        var finalDesc = (notification?.notificationMessage ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        let userName = AppInstance.shared.user?.value ?? ""
        if finalDesc.contains("\(userName)."){
            finalDesc = finalDesc.replacingOccurrences(of: "\(userName).", with: ". ")
        }else if finalDesc.contains("\(userName),"){
            finalDesc = finalDesc.replacingOccurrences(of: "\(userName),", with: "")
        }else if finalDesc.contains(", \(userName)."){
            finalDesc = finalDesc.replacingOccurrences(of: ", \(userName) ", with: "")
        }else if finalDesc.contains("\(userName)"){
            finalDesc = finalDesc.replacingOccurrences(of: "\(userName)", with: "")
        }
        
        if finalDesc.contains("Hello,"){
            finalDesc = finalDesc.replacingOccurrences(of: "Hello,", with: "Hello \(AppInstance.shared.user?.firstName ?? ""),")
        }
        self.lblDescription.text = finalDesc
        
        let dateArr = (notification?.notificationDate ?? "").components(separatedBy: ".")
        let dateToConvert = (dateArr.first ?? "").replacingOccurrences(of: "T", with: " ")
        let date = Utility.getDateFromstring(dateStr: dateToConvert, dateFormat: "YYYY-MM-dd  HH:mm:ss")
        self.lblDate.text = date.timeAgoSinceDate()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
