//
//  ResidentListViewController.swift
//  AccessEMR
//
//  Created by Vasundhara Parakh on 2/25/20.
//  Copyright © 2020 smartData Enterprises (I) Ltd. All rights reserved.
//

import UIKit
import SDWebImage
class ResidentListViewController: BaseViewController {
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    lazy var viewModel: ResidentListViewModel = {
        let obj = ResidentListViewModel(with: ResidentService())
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
        self.setupClosures()
        self.addRefreshController()
        self.navigationItem.title = "\(UserDefaults.getOrganisationTypeName())"

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewModel.getResidentList(pageNo: 1,searchText: self.searchBar.text ?? "")
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
        self.showTipView(textString: ConstantStrings.searchHelp, senderBtn: sender as! UIButton)
    }
    @objc func handleTopRefresh(_ sender:UIRefreshControl){
        
        self.viewModel.getResidentList(pageNo: 1,searchText: searchBar.text ?? "")
    }

    func initialSetup(){
        self.searchBar.placeholder = "Search \(UserDefaults.getOrganisationTypeName())s..."
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
        self.viewModel.getResidentList(pageNo: self.viewModel.intForPageNo,searchText: searchBar.text ?? "")
    }

}

extension ResidentListViewController:UITableViewDataSource, UITableViewDelegate {
   
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ReuseIdentifier.ResidentTableViewCell, for: indexPath as IndexPath) as! ResidentTableViewCell
        cell.resident = self.viewModel.roomForIndexPath(indexPath)
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let resident = self.viewModel.roomForIndexPath(indexPath)
        if let vc = ResidentDetailViewController.instantiate(appStoryboard: Storyboard.Dashboard) as? ResidentDetailViewController{
            vc.patientId = resident.patientId ?? 0
            self.navigationController?.pushViewController(vc,animated:true)
        }
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
    
    
}

extension ResidentListViewController: UISearchBarDelegate{
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
        self.viewModel.getResidentList(pageNo: 1,searchText: searchBar.text ?? "")
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.viewModel.getResidentList(pageNo: 1,searchText: "")
        self.view.endEditing(true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.viewModel.getResidentList(pageNo: 1,searchText: searchBar.text ?? "")
        self.view.endEditing(true)
    }
}
class ResidentTableViewCell: UITableViewCell {
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblRoomNo: UILabel!
    @IBOutlet weak var lblRoomTitle: UILabel!
    @IBOutlet weak var lblPHCNo: UILabel!
    @IBOutlet weak var lblDiagnosis: UILabel!
    @IBOutlet weak var lblAllergies: UILabel!
    @IBOutlet weak var lblGoalOfCare: UILabel!
    @IBOutlet weak var imgProfilePic: UIImageView!
    @IBOutlet weak var imgCheckin: UIImageView!

    var resident: Resident?{
        didSet{
            setUpData()
        }
    }
        
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setUpData(){
        self.lblAllergies.textColor = (resident?.patientAllergy == nil) ? Color.DarkGray : Color.Red
        let allerygyFontiPhone = (resident?.patientAllergy == nil) ? UIFont.PoppinsRegular(fontSize: 14.0) : UIFont.PoppinsMedium(fontSize: 14.0)
        let allerygyFontiPad = (resident?.patientAllergy == nil) ? UIFont.PoppinsRegular(fontSize: 17.0) : UIFont.PoppinsMedium(fontSize: 17.0)

        self.lblAllergies.font = Device.IS_IPAD ? allerygyFontiPad : allerygyFontiPhone
        
        //Update Labels
        let roomNoPrefix = ""//ConstantStrings.roomNoPrefix
        let phcNoPrefix = ""//ConstantStrings.phcNoPrefix
        let diagnosisPrefix = ""//ConstantStrings.diagnosisPrefix
        let allergiesPrefix = ""//ConstantStrings.allergiesPrefix
        let goalOfCarePrefix = ""//ConstantStrings.goalOfCarePrefix
        let highlightFont =  Device.IS_IPAD ? UIFont.PoppinsRegular(fontSize: 16.0) : UIFont.PoppinsRegular(fontSize: 14.0)
        self.lblName.text = (resident?.firstName ?? "") + " " + (resident?.lastName ?? "")
        self.lblRoomNo.attributedText = Utility.highlightPartialTextOfLabel(mainString: roomNoPrefix + (resident?.room ?? ConstantStrings.NA), highlightString: roomNoPrefix,highlightColor: Color.ListLabelHeading,highlightFont:highlightFont )
        self.lblPHCNo.attributedText =  Utility.highlightPartialTextOfLabel(mainString: phcNoPrefix + (resident?.phcNo ?? ConstantStrings.NA), highlightString: phcNoPrefix,highlightColor: Color.ListLabelHeading,highlightFont:highlightFont )
        
        var str = resident?.patientDiagnosis ?? ConstantStrings.NA
        var finalStr = ""
        if Device.IS_IPAD{
            str = str.replacingOccurrences(of: "<b>", with: "<font face='Poppins-Medium' size='5' color='#7A6F6F'><b>")
            str = str.replacingOccurrences(of: "</b>", with: "</font></b>")
            finalStr = "<font face='Poppins-Regular' size='5' color='#7A6F6F'>" + str + "</font>"
        }else{
            str = str.replacingOccurrences(of: "<b>", with: "<font face='Poppins-Medium' size='4' color='#7A6F6F'><b>")
            str = str.replacingOccurrences(of: "</b>", with: "</font></b>")
            finalStr = "<font face='Poppins-Regular' size='4' color='#7A6F6F'>" + str + "</font>"
        }
        self.lblDiagnosis.setHTMLFromString(htmlText:finalStr)
        
        self.lblAllergies.attributedText =  Utility.highlightPartialTextOfLabel(mainString: allergiesPrefix + (resident?.patientAllergy ?? "Not Specified"), highlightString: allergiesPrefix,highlightColor: Color.ListLabelHeading,highlightFont:highlightFont )
        if let isAllerygy = resident?.isAllergy{
            if isAllerygy{
                self.lblAllergies.text = "No Known Allergies"
                self.lblAllergies.textColor = lblPHCNo.textColor
                self.lblAllergies.font = lblPHCNo.font
            }
        }
        self.lblGoalOfCare.attributedText =  Utility.highlightPartialTextOfLabel(mainString: goalOfCarePrefix + String(resident?.goalOfCare ?? ConstantStrings.NA), highlightString: goalOfCarePrefix,highlightColor: Color.ListLabelHeading,highlightFont:highlightFont )

        
        
        //Load Profile Picture
        self.imgProfilePic.roundedCorner()
        self.imgProfilePic.sd_imageIndicator = SDWebImageActivityIndicator.gray
        self.imgProfilePic.sd_setImage(with: URL(string:(resident?.photoThumbnailPath ?? "")), placeholderImage: UIImage.defaultProfilePicture(), completed: nil)
        self.imgProfilePic.addFullScreenView()
        
        //Customizing organisation Type
        self.lblRoomTitle.text = (UserDefaults.getOrganisationType() == OrganisationType.HomeCare || UserDefaults.getOrganisationType() == OrganisationType.Clinic) ? "Address :" : "Room :"

        if UserDefaults.getOrganisationType() == OrganisationType.HomeCare || UserDefaults.getOrganisationType() == OrganisationType.Clinic{
            self.lblRoomNo.attributedText = Utility.highlightPartialTextOfLabel(mainString: roomNoPrefix + (resident?.address ?? ConstantStrings.NA), highlightString: roomNoPrefix,highlightColor: Color.ListLabelHeading,highlightFont:highlightFont )
        }
        //Ends
        
        self.imgCheckin.isHidden = !(resident?.visitStatus ?? false)

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
