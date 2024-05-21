//
//  SettingsViewController.swift
//  appName
//
//  Created by Vasundhara Parakh on 2/25/20.
//  Copyright © 2020 smartData Enterprises (I) Ltd. All rights reserved.
//

import UIKit
enum SettingItems {
    static let AvailiableVirtualConsult = "Available for Virtual Consult"
    static let ClockIn = "Clock-In/Out"
}
class SettingsViewController: BaseViewController {

    @IBOutlet weak var tblView: UITableView!
    var clockView : CustomAlertView = CustomAlertView()

    //var items = [SettingItems.AvailiableVirtualConsult,SettingItems.ClockIn]
    var items = [SettingItems.AvailiableVirtualConsult]
    
    lazy var viewModel: SettingsViewModel = {
        let obj = SettingsViewModel(with: UserService())
        self.baseViewModel = obj
        return obj
    }()
    
    var logoutOrgView :CustomAlertView = CustomAlertView()

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.title = NavigationTitle.Settings
        self.initialSetup()
        self.setupClosures()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewModel.getSettings()
    }
    
    func initialSetup(){
    }
    
    func setupClosures() {
        self.viewModel.updateViewClosure = { [weak self] () in
            DispatchQueue.main.async {
                self?.tblView.reloadData()
            }
        }
    }
    
    @IBAction func logout_clicked(_ sender: Any) {
        self.showOrgLogoutPopup()
    }
    
    func showOrgLogoutPopup(){
        
        self.logoutOrgView = Bundle.main.loadNibNamed("CustomAlertView", owner: self, options: nil)?.first as! CustomAlertView
        self.logoutOrgView.lblTitle.text = "Logout"
        self.logoutOrgView.lblSubtitle.text =  "Are you sure you want to logout from organisation?"
        self.logoutOrgView.btnLeft.setTitle("Cancel", for: .normal)
        self.logoutOrgView.btnRight.setTitle("Logout", for: .normal)
        if let window =  UIApplication.shared.windows.first as? UIWindow{
            self.logoutOrgView.frame = window.frame
            self.logoutOrgView.delegate = self
            window.addSubview(self.logoutOrgView)
        }
        
    }

}
//MARK:- UITableViewDataSource, UITableViewDelegate
extension SettingsViewController:UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ReuseIdentifier.SettingsCell, for: indexPath as IndexPath) as! SettingsCell
        cell.lbltitle.text = items[indexPath.row]
        cell.toggleSwitch.tag = indexPath.row
        if indexPath.row == 0{
            cell.toggleSwitch.isOn = AppInstance.shared.isAvailableForVirtualConsult ?? true
        }else{
            cell.toggleSwitch.isOn = AppInstance.shared.isClockedIn ?? false
        }
        cell.toggleSwitch.addTarget(self, action: #selector(self.toggleSwitch_clicked(sender:)), for: .valueChanged)
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Device.IS_IPAD ? 80 : 70
    }

    @objc func  toggleSwitch_clicked(sender : UISwitch) {
        if sender.tag == 0 { //Availability
            self.viewModel.saveSettings(isAvailable: sender.isOn)
        }else{
            //Clockin/out
            if !sender.isOn{
                //TODO: Handle organisationType
                if UserDefaults.getOrganisationType() == OrganisationType.HomeCare{
                    self.showClockInPopupHomeCare()
                }else{
                    self.showClockInPopupNursingHome()
                }
            }else{
                self.clockIn()
            }
        }
    }
    func clockIn(){
        self.viewModel.getClockedInStatus()
    }
    func showClockInPopupNursingHome(){
        self.clockView = Bundle.main.loadNibNamed("CustomAlertView", owner: self, options: nil)?.first as! CustomAlertView
        self.clockView.lblTitle.text = "CLOCK OUT"
        self.clockView.lblSubtitle.text = "Are you sure you want to end your shift for the day?"
        self.clockView.btnRight.setTitle("YES", for: .normal)
        self.clockView.btnLeft.setTitle("NO", for: .normal)
        if let window =  UIApplication.shared.windows.first as? UIWindow{
            self.clockView.frame = window.frame
            self.clockView.delegate = self
            window.addSubview(self.clockView)
        }
    }
    
    func showClockInPopupHomeCare(){
        self.checkAllResidentAreVisited { (allAreVisited) in
            if allAreVisited{
                self.clockView = Bundle.main.loadNibNamed("CustomAlertView", owner: self, options: nil)?.first as! CustomAlertView
                self.clockView.lblTitle.text = "CLOCK OUT"
                self.clockView.lblSubtitle.text = "Are you sure you want to end your shift for the day?"
                self.clockView.btnRight.setTitle("YES", for: .normal)
                self.clockView.btnLeft.setTitle("NO", for: .normal)
                if let window =  UIApplication.shared.windows.first as? UIWindow{
                    self.clockView.frame = window.frame
                    self.clockView.delegate = self
                    window.addSubview(self.clockView)
                }
            }else{
                Utility.showAlertWithMessage(titleStr: Alert.Title.appName, messageStr: "You cannot clock out until you visit all \(UserDefaults.getOrganisationTypeName().lowercased())s.", controller: self)
            }
            self.tblView.reloadData()
        }
    }
    
    func checkAllResidentAreVisited(completion:@escaping (Bool) -> Void) {
        var residentListArr = [Resident]()
        var allResidents = [Resident]()
        ResidentService().getAllResidentsForClockOut { (visitedResidents,allResidentsArray) in
            if let residents = visitedResidents as? [Resident]{
                residentListArr = residents
            }
            if let allResidentsArr = allResidentsArray as? [Resident]{
                allResidents = allResidentsArr
            }
            completion(residentListArr.count == allResidents.count)
        }
    }
}
class SettingsCell : UITableViewCell{
    @IBOutlet weak var lbltitle: UILabel!
    @IBOutlet weak var toggleSwitch: UISwitch!

}

//MARK:----- CustomAlertViewDelegate ----
extension SettingsViewController : CustomAlertViewDelegate{
    func btnLeft_Action(forView: CustomAlertView) {
        if forView == self.clockView{
            self.clockView.removeFromSuperview()
            self.tblView.reloadData()
        }else{
            self.logoutOrgView.removeFromSuperview()
        }

    }
    func btnRight_Action(forView: CustomAlertView) {
        if forView == self.clockView{
            UserService().clockOutUser { (resultMessage) in
                let actionSheetController: UIAlertController = UIAlertController(title: Alert.Title.appName, message:  (resultMessage as? String) ?? "", preferredStyle: .alert)
                // create an action
                
                let firstAction: UIAlertAction = UIAlertAction(title: Alert.ButtonTitle.ok, style: .default) { action -> Void in
                    self.logout()
                }
                actionSheetController.addAction(firstAction)
                actionSheetController.view.tintColor = Color.DarkGray
                actionSheetController.popoverPresentationController?.sourceView = self.view // works for both iPhone & iPad
                self.present(actionSheetController, animated: true) {
                    //debugPrint("option menu presented")
                }
                self.clockView.removeFromSuperview()
            }
            
        }else{
        UserDefaults.standard.removeObject(forKey: UserDefaultKeys.udKey_businessToken)
        UserDefaults.standard.removeObject(forKey: UserDefaultKeys.udKey_orgTypeName)
        self.logout()
        }
    }
}
