//
//  BaseViewController.swift
//  iOSMVVMArchitecture
//
//  Created by Amit Shukla on 27/01/20.
//  Copyright © 2020 smartData Enterprises (I) Ltd. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import SDWebImage
import EasyTipView

class BaseViewController: UIViewController, NVActivityIndicatorViewable {
    var logoutView : LogoutView = LogoutView()
    
    var incomingCallSignalRConnection : IncomingCallSignalR?

    let animationType:NVActivityIndicatorType = NVActivityIndicatorType.lineScale
    var baseViewModel: BaseViewModel? {
        didSet {
            initBaseModel()
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureNavigationBar()
        self.configureSignalRConnection()
        // Do any additional setup after loading the view.
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func configureSignalRConnection(){
        //Setup signalR connection
        self.incomingCallSignalRConnection = IncomingCallSignalR()
        self.incomingCallSignalRConnection?.delegate = self
        self.incomingCallSignalRConnection?.startConnection(currentUser:AppInstance.shared.user ?? User(dictionary: ["id":0])!)

    }
    // Cann't be override by subclass
    final func initBaseModel() {
        // Native binding
        baseViewModel?.showAlertClosure = { [weak self] (_ type:AlertType) in
            DispatchQueue.main.async {
                if type == .success, let message = self?.baseViewModel?.alertMessage  {
                    UIAlertController.showAlert(title: Alert.Title.appName, message: message, preferredStyle: .alert, sender: nil , target: self, actions:.Ok) { (AlertAction) in
                        self?.doneAction()
                    }
                } else {
                    let message = self?.baseViewModel?.errorMessage ?? "Some Error occured"
                    UIAlertController.showAlert(title: "", message: message)
                }
            }
        }
        
        baseViewModel?.updateLoadingStatus = { [weak self] () in
            DispatchQueue.main.async {
                let isLoading = self?.baseViewModel?.isLoading ?? false
                isLoading ? self?.showLoader() : self?.hideLoader()
            }
        }
    }
    func doneAction() {
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }

    func updateResidentCardView(cardView : ResidentCardView, residentInfo : PatientBasicHeaderInfo){
        cardView.nameLbl.text = residentInfo.name
        //Replace patientID with Room No. -> Client Feedback
        cardView.patientIdLbl.text = residentInfo.room ?? ConstantStrings.NA//String(residentInfo.patientID ?? 0)
        cardView.genderLbl.text = residentInfo.gender ?? ConstantStrings.NA
        cardView.ageLbl.text = (residentInfo.age ?? "") + " years"
        cardView.phcLbl.text = residentInfo.phcNo ?? ConstantStrings.NA
        //Replace Room no. with Allergies -> Client Feedback
        cardView.roomNoLbl.text = (residentInfo.allergies ?? "Not Specified").count == 0 ? "Not Specified" : (residentInfo.allergies ?? "Not Specified")
        
        if (residentInfo.allergies ?? "Not Specified").count == 0{
            cardView.roomNoLbl.textColor = cardView.phcLbl.textColor
            cardView.roomNoLbl.font = cardView.phcLbl.font
        }else{
            cardView.roomNoLbl.textColor = Color.Red
        }
        
        if let isAllerygy = residentInfo.isAllergy{
            if isAllerygy{
                cardView.roomNoLbl.text = "No Known Allergies"
                cardView.roomNoLbl.textColor = cardView.phcLbl.textColor
                cardView.roomNoLbl.font = cardView.phcLbl.font
            }
        }
        
        cardView.residentProfileImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
        cardView.residentProfileImageView.sd_setImage(with: URL(string:(residentInfo.photoThumbnailPath ?? "")), placeholderImage: UIImage.defaultProfilePicture(), completed: nil)
        
        //Customizing organisation Type
        if UserDefaults.getOrganisationType() == OrganisationType.HomeCare || UserDefaults.getOrganisationType() == OrganisationType.Clinic{
            cardView.patientIdLbl.text = residentInfo.address ?? ConstantStrings.NA
        }
        //Ends
    }
}
//MARK:- Loader Methods
extension BaseViewController {
    func showLoader() {
        startAnimating(CGSize(width: 50.0, height: 50.0), message: "", messageFont: nil, type: self.animationType, color:Color.Loader , padding: 0.0, displayTimeThreshold: 0, minimumDisplayTime: nil, backgroundColor: UIColor.lightText)
    }
    
    func hideLoader() {
        stopAnimating()
    }
}

//MARK:- EasyTipView
extension BaseViewController {
    func showTipView( textString : String, senderBtn: UIButton){
        var preferences = EasyTipView.Preferences()
        preferences.drawing.font = UIFont.PoppinsRegular(fontSize: 14)
        preferences.drawing.foregroundColor = UIColor.white
        preferences.drawing.backgroundColor =  Color.HighlightTextLPN
        preferences.drawing.arrowPosition = .top
        
        let tipView = EasyTipView(text: textString, preferences: preferences)
        tipView.show(forView: senderBtn)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            tipView.dismiss()
        }
    }
}

//MARK:- Navigation Bar Appearance
extension BaseViewController {
    
    // MARK: - Add back button with custom image
    func addBackButton(with name:String = "back_arrow") {
        let backButtonImage = UIImage(named: name)?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        let leftBarButtonItem = UIBarButtonItem(image: backButtonImage,
                                      style: .plain,
                                      target: self,
                                      action: #selector(onLeftBarButtonClicked(_ :)))
        navigationItem.leftBarButtonItem = leftBarButtonItem
    }
    
    // MARK: - Override this function if want to change back button behaviour
    @objc func onLeftBarButtonClicked(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }

    
    func hideBackButton() {
        self.navigationItem.hidesBackButton = true
    }
    
    func hideNavigationBar(_ hide: Bool, animated: Bool = true) {
        self.navigationController?.setNavigationBarHidden(hide, animated: animated)
    }
    
    func configureNavigationBar() {
        
        guard let navigationController = navigationController,
            let flareGradientImage = CAGradientLayer.primaryGradient(navigationController.navigationBar, primaryColor: Color.Primary, secondaryColor: Color.Secondary)  else { return }

        navigationController.navigationBar.barTintColor = UIColor(patternImage: flareGradientImage)
        let attrs = [
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: Device.IS_IPAD ? Font.Regular.of(size: 20.0) : Font.Regular.of(size: 18.0)
        ]
        navigationController.navigationBar.titleTextAttributes = attrs
        
    }
}

//MARK:- Logout
extension BaseViewController : LogoutViewDelegate {
    func showLogoutPopup(){
        self.logoutView = Bundle.main.loadNibNamed("LogoutView", owner: self, options: nil)?.first as! LogoutView
        if let window =  UIApplication.shared.windows.first as? UIWindow{
            self.logoutView.frame = window.frame
            self.logoutView.delegate = self
            window.addSubview(self.logoutView)
        }
    }
    
    func logout() {
        AppInstance.shared.user = nil
        AppInstance.shared.accessToken = nil
        AppInstance.shared.businessToken = nil

        UserDefaults.standard.removeObject(forKey: UserDefaultKeys.udKey_user)
        UserDefaults.standard.removeObject(forKey: UserDefaultKeys.udKey_userName)
        UserDefaults.standard.removeObject(forKey: UserDefaultKeys.udKey_password)
        UserDefaults.standard.removeObject(forKey: UserDefaultKeys.udKey_accessToken)
        UserDefaults.standard.removeObject(forKey: UserDefaultKeys.udKey_rememberMe)

        let identifier = String(describing: LoginViewController.self)

        let storyboard = UIStoryboard(name: Storyboard.Main.rawValue, bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: identifier) as! LoginViewController
        let nav = UINavigationController(rootViewController: controller)
        nav.isNavigationBarHidden = true
        nav.setNavigationBarHidden(true, animated: false)
        UIApplication.shared.keyWindow?.rootViewController = nav
    }
    
    func cancelLogout() {
        
        self.logoutView.removeFromSuperview()

    }

    
    
}
//MARK:----- Signal R Delegate ----
extension BaseViewController: IncomingCallSignalRDelegate{
    func signalRConnectionIncomingCall(sendCall dict: [String : Any]) {
        
    }
    
    func signalRConnectionIncomingCall(receiveCall message: [String : Any]) {
        print("incoming call detail == \(message) --- sessioninfo = \(AppInstance.shared.telehealthSessionInfo)")
        if AppInstance.shared.telehealthSessionInfo == nil{
            let vc = IncomingCallViewController.instantiate(appStoryboard: Storyboard.VirtualConsult) as! IncomingCallViewController
            vc.hidesBottomBarWhenPushed = true
            vc.callerDetail = message
            //self.present(vc, animated: false, completion: nil)
            
            if let navController = self.navigationController{
                navController.pushViewController(vc,animated:true)
            }else{
                /*
                if let navVC = UIApplication.topViewController()?.navigationController as? UINavigationController{
                    navVC.pushViewController(vc,animated:true)
                }else{
                    print("Navigation Controller is nil")
                }*/
            }
        }
    }
    
    func signalRConnectionIncomingCall(didDisconnected disconnected: Bool) {
    }
    func signalRConnectionIncomingCall(didConnected connected: Bool) {
    }
    func signalRConnectionIncomingCall(errorInConnection errorMessage: String) {
        self.incomingCallSignalRConnection?.startConnection(currentUser:AppInstance.shared.user ?? User(dictionary: ["id": 0])!)
        //        appendMessage(message: Message(text: er@objc rorMessage, user: User.current))
    }
    func signalRConnectionIncomingCall(error errorMessage: String) {
    }
    
    func signalRConnectionIncomingCall(didReceivedFile received: Bool){
    }
}
 
