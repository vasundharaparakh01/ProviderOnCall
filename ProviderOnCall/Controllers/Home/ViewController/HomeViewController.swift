//
//  HomeViewController.swift
//  AccessEMR
//
//  Created by Vasundhara Parakh on 2/25/20.
//  Copyright © 2020 smartData Enterprises (I) Ltd. All rights reserved.
//

import UIKit
enum eHome:Int {
    case Task
    case Resident
    case Schedule
    case EMAR
    case Inventory
    case VConsult
    case Settings
    case Notification
    case Clock
}
class HomeViewController: BaseViewController{
    var tnCAlert : CustomAlertView = CustomAlertView()
    var tnCDetailPopup : TNCDetailPopup = TNCDetailPopup()
    var clockView : CustomAlertView = CustomAlertView()
    
    lazy var viewModel: SettingsViewModel = {
        let obj = SettingsViewModel(with: UserService())
        self.baseViewModel = obj
        return obj
    }()
    
    @IBOutlet weak var collectionView: UICollectionView!
    //AppInstance.shared.user == 0 ? "Clock_In"
    var items = ["Tasks", "\(UserDefaults.getOrganisationTypeName())", "Schedule","EMAR", "Inventory", "Virtual Consult", "Settings","Notifications" ,"Clock_IN" ]
    var images = ["mytask-large", "patient-large", "calendar-large", "EMARicon","inventory-large", "film-large", "settings-large","notification_ico" ,""]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let isFirstLogin = AppInstance.shared.user?.users3?.isFirstLogin as? Bool {
            if let agreed = AppInstance.shared.user?.users3?.isAgreeToTnc as? Bool {
                if isFirstLogin && !agreed{
                    self.showTNCDetailPopup()
                }else{
                    self.showTNCPopup()
                }
            }else{
                self.showTNCPopup()
            }
        }else{
            self.showTNCPopup()
        }
        self.initialSetup()
        self.navigationItem.title = NavigationTitle.Home
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        
    }
    func initialSetup(){
        self.addrightBarButtonItem()
        //self.addLeftBarButtonItem()
        self.setupClosures()
        self.viewModel.getSettings()
    }
    func setupClosures() {
        self.viewModel.updateViewClosure = { [weak self] () in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
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
//        self.checkAllResidentAreVisited { (allAreVisited) in
//            if allAreVisited{
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
//            }else{
//                Utility.showAlertWithMessage(titleStr: Alert.Title.appName, messageStr: "You cannot clock out until you visit all \(UserDefaults.getOrganisationTypeName().lowercased())s.", controller: self)
//            }
        }
    func checkAllResidentAreVisited(completion:@escaping (Bool) -> Void) {
        var residentListArr = [Resident]()
        ResidentService().getAllResidentsForClockOut { (residentList,allResidents) in
            if let residents = residentList as? [Resident]{
                residentListArr = residents
            }
        }
        completion(residentListArr.count != 0)
    }
    func addrightBarButtonItem() {
        let logoutButtonImage = UIImage(named:"logout")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        let rightBarButtonItem = UIBarButtonItem(image: logoutButtonImage,
                                                 style: .plain,
                                                 target: self,
                                                 action: #selector(onRightBarButtonItemClicked(_ :)))
        navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    // MARK:
    @objc func onRightBarButtonItemClicked(_ sender: UIBarButtonItem) {
        self.showLogoutPopup()
    }
    
    func addLeftBarButtonItem() {
        let clockButtonImage = UIImage(named:"clockIn")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        let leftBarButtonItem = UIBarButtonItem(image: clockButtonImage,
                                                style: .plain,
                                                target: self,
                                                action: #selector(onLeftBarButtonItemClicked(_ :)))
        navigationItem.leftBarButtonItem = leftBarButtonItem
    }
    
    // MARK:
    @objc func onLeftBarButtonItemClicked(_ sender: UIBarButtonItem) {
        //TODO: Handle organisationType
        self.showClockInPopupNursingHome()
    }
}

extension HomeViewController:UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // tell the collection view how many cells to make
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items.count
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReuseIdentifier.HomeCollectionViewCell, for: indexPath as IndexPath) as! HomeCollectionViewCell
        
        // Use the outlet in our custom class to get a reference to the UILabel in the cell
        cell.titleLabel.text = self.items[indexPath.item]
        cell.imageView.image = UIImage(named: self.images[indexPath.item])
        //        cell.backgroundColor = UIColor.cyan // make cell more visible in our example project
        if indexPath.row == self.items.count - 1{
            
            //print(\())
            if AppInstance.shared.isClockedIn == true{
                cell.titleLabel.text = "Clock Out"
                cell.imageView.image = UIImage(named: "Clock_Out")
            }else{
                cell.titleLabel.text = "Clock In"
                cell.imageView.image = UIImage(named: "Clock_In")
            }
            return cell
        }
        return cell
    }
    func clockInOutCall(){
        self.clockView = Bundle.main.loadNibNamed("CustomAlertView", owner: self, options: nil)?.first as! CustomAlertView
        if AppInstance.shared.isClockedIn == true{
            if UserDefaults.getOrganisationType() == OrganisationType.HomeCare{
                self.showClockInPopupHomeCare()
            }else{
                self.showClockInPopupNursingHome()
            }
        }
        else{
            self.clockView.lblTitle.text = "CLOCK IN"
            self.clockView.lblSubtitle.text = "Are you sure you want to start your shift for the day?"
            self.clockView.btnRight.setTitle("YES", for: .normal)
            self.clockView.btnLeft.setTitle("NO", for: .normal)
            if let window =  UIApplication.shared.windows.first as? UIWindow{
                self.clockView.frame = window.frame
                self.clockView.delegate = self
                window.addSubview(self.clockView)
            }
        }
    }
    // MARK: - UICollectionViewDelegate protocol
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        print("You selected cell #\(indexPath.item)!")
        switch eHome(rawValue: indexPath.item)! {
        case .Task:
            self.tabBarController?.selectedIndex = 1
        case .Resident:
            self.tabBarController?.selectedIndex = 2
        case .Settings:
            self.tabBarController?.selectedIndex = 3
        case .EMAR:
            if let vc = EMARListViewController.instantiate(appStoryboard: Storyboard.EMAR) as? EMARListViewController{
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc,animated:true)
            }
        case .Inventory:
            if let vc = InventoryListViewController.instantiate(appStoryboard: Storyboard.Dashboard) as? InventoryListViewController{
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc,animated:true)
            }
        case .VConsult:
            if let vc = VideoAppointmentListViewController.instantiate(appStoryboard: Storyboard.VirtualConsult) as? VideoAppointmentListViewController{
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc,animated:true)
            }
        case .Schedule:
            if let vc = StaffCalendarViewController.instantiate(appStoryboard: Storyboard.VirtualConsult) as? StaffCalendarViewController{
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc,animated:true)
            }
            
        case .Notification:
            if let vc = NotificationListViewController.instantiate(appStoryboard: Storyboard.Dashboard) as? NotificationListViewController{
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc,animated:true)
            }
        case .Clock:
            self.clockInOutCall()
        default:
            break
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemPerRow : CGFloat = Device.IS_IPAD ? 3.0 : 2.0
        let width = ((Screen.width - (30 * itemPerRow)))/itemPerRow
        let ratio = CGFloat(150.0/160.0)
        let height = width*ratio
        return CGSize(width: width, height: height)
    }
    
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 20.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20.0
    }
}
extension HomeViewController : CustomAlertViewDelegate{
    
    func showTNCPopup(){
        self.tnCAlert = Bundle.main.loadNibNamed("CustomAlertView", owner: self, options: nil)?.first as! CustomAlertView
        self.tnCAlert.lblTitle.text = Alert.Title.tnc
        self.tnCAlert.lblSubtitle.text = Alert.Message.tnc
        self.tnCAlert.btnLeft.setTitle(Alert.ButtonTitle.exit, for: .normal)
        self.tnCAlert.btnRight.setTitle(Alert.ButtonTitle.continueStr, for: .normal)
        if let agreed = AppInstance.shared.user?.users3?.isAgreeToTnc as? Bool {
            if agreed{
                let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapFunction(sender:)))
                self.tnCAlert.lblSubtitle.isUserInteractionEnabled = true
                self.tnCAlert.lblSubtitle.addGestureRecognizer(tap)
            }
        }
        if let window =  UIApplication.shared.windows.first as? UIWindow{
            self.tnCAlert.frame = window.frame
            self.tnCAlert.delegate = self
            window.addSubview(self.tnCAlert)
        }
    }
    @IBAction func tapFunction(sender: UITapGestureRecognizer) {
        self.showTNCDetailPopup()
    }
    func btnLeft_Action(forView: CustomAlertView) {
        if forView == self.tnCAlert{
            self.tnCAlert.removeFromSuperview()
            self.logout()
        }else{
            self.clockView.removeFromSuperview()
        }
    }
    func btnRight_Action(forView: CustomAlertView) {
        if forView == self.tnCAlert{
            self.tnCAlert.removeFromSuperview()
            if let agreed = AppInstance.shared.user?.users3?.isAgreeToTnc as? Bool {
                if !agreed{
                    self.showTNCDetailPopup()
                }
            }
        }else{
            if AppInstance.shared.isClockedIn == true{
                UserService().clockOutUser { (resultMessage) in
                    let actionSheetController: UIAlertController = UIAlertController(title: Alert.Title.appName, message:  (resultMessage as? String) ?? "", preferredStyle: .alert)
                     self.viewModel.getSettings()
                    self.clockView.removeFromSuperview()
                }
            }
            else{
                UserService().getClockInStatus { (resultMessage) in
                    let actionSheetController: UIAlertController = UIAlertController(title: Alert.Title.appName, message:  (resultMessage as? String) ?? "", preferredStyle: .alert)
                    self.collectionView.reloadData()
                    self.clockView.removeFromSuperview()
                }
            }
            
            
        }
    }
    
}
extension HomeViewController : TNCDetailPopupDelegate{
    
    func showTNCDetailPopup(){
        
        
        self.baseViewModel?.isLoading = true
        self.tnCDetailPopup = Bundle.main.loadNibNamed("TNCDetailPopup", owner: self, options: nil)?.first as! TNCDetailPopup
        
        self.tnCDetailPopup.btnTnc.isHidden = AppInstance.shared.user?.users3?.isAgreeToTnc ?? false
        self.tnCDetailPopup.lblTNC.isHidden = AppInstance.shared.user?.users3?.isAgreeToTnc ?? false
        
        self.tnCDetailPopup.btnClose.isHidden = !(AppInstance.shared.user?.users3?.isAgreeToTnc ?? false)
        
        self.tnCDetailPopup.lblSubtitle.text = ""
        self.tnCDetailPopup.textviewDetail.text = ""
        self.tnCDetailPopup.btnLeft.setTitle(Alert.ButtonTitle.exit, for: .normal)
        self.tnCDetailPopup.btnRight.setTitle(Alert.ButtonTitle.continueStr, for: .normal)
        self.tnCDetailPopup.btnTnc.addTarget(self, action: #selector(self.btnTNC_clicked(_:)), for: .touchUpInside)
        if let window =  UIApplication.shared.windows.first as? UIWindow{
            self.tnCDetailPopup.frame = window.frame
            self.tnCDetailPopup.delegate = self
            window.addSubview(self.tnCDetailPopup)
        }
        
        ResidentService().getTnC { (tncContent) in
            self.baseViewModel?.isLoading = false
            if let content = tncContent as? TNCDetail{
                var str = content.content ?? ""
                var finalStr = str
                /*
                 if Device.IS_IPAD{
                 str = str.replacingOccurrences(of: "<b>", with: "<font face='Poppins-Medium' size='5' color='#7A6F6F'><b>")
                 str = str.replacingOccurrences(of: "</b>", with: "</font></b>")
                 finalStr = "<font face='Poppins-Regular' size='5' color='#7A6F6F'>" + str + "</font>"
                 }else{
                 str = str.replacingOccurrences(of: "<b>", with: "<font face='Poppins-Medium' size='4' color='#7A6F6F'><b>")
                 str = str.replacingOccurrences(of: "</b>", with: "</font></b>")
                 finalStr = "<font face='Poppins-Regular' size='4' color='#7A6F6F'>" + str + "</font>"
                 }
                 */
                let htmlData = NSString(string: finalStr).data(using: String.Encoding.unicode.rawValue)
                
                let options = [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html]
                
                let attributedString = try! NSAttributedString(data: htmlData!, options: options, documentAttributes: nil)
                
                self.tnCDetailPopup.textviewDetail.attributedText = attributedString
            }
        }
    }
    func btnClose_Action(forView : TNCDetailPopup){
        self.tnCDetailPopup.removeFromSuperview()
    }
    func btnLeft_Action(forView: TNCDetailPopup) {
        self.tnCDetailPopup.removeFromSuperview()
        self.logout()
    }
    func btnRight_Action(forView: TNCDetailPopup) {
        if let agreed = AppInstance.shared.user?.users3?.isAgreeToTnc as? Bool {
            if !agreed{
                if self.tnCDetailPopup.btnTnc.isSelected{
                    ResidentService().saveTnC { (result) in
                        self.tnCDetailPopup.removeFromSuperview()
                    }
                }
            }else{
                self.tnCDetailPopup.removeFromSuperview()
            }
        }else{
            self.tnCDetailPopup.removeFromSuperview()
        }
    }
    
    @objc func btnTNC_clicked(_ sender: UIButton) {
        self.tnCDetailPopup.btnTnc.isSelected = !sender.isSelected
    }
}

