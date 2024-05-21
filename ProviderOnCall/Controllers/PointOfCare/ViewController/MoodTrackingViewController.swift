//
//  MoodTrackingViewController.swift
//  appName
//
//  Created by Vasundhara Parakh on 3/12/20.
//  Copyright © 2020 smartData Enterprises (I) Ltd. All rights reserved.
//

import UIKit

class MoodTrackingViewController : BaseViewController {

    @IBOutlet weak var residentCardView: ResidentCardView!
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblAddedBy: UILabel!

    var patientHeaderInfo : PatientBasicHeaderInfo?
    
    lazy var viewModel: MoodTrackingViewModel = {
        let obj = MoodTrackingViewModel(with: PointOfCareService())
        self.baseViewModel = obj
        return obj
    }()

    var arrDatasource = [ListingSectionModel]()
    var pointOfCareItem  = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.navigationItem.title = NavigationTitle.PointOfCareSections.MoodTracking
        
        self.addBackButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.initialSetup()
    }
    func initialSetup(){
        self.tblView.register(UINib(nibName: ReuseIdentifier.ListCell, bundle: nil), forCellReuseIdentifier: ReuseIdentifier.ListCell)
        self.tblView.register(UINib(nibName: ReuseIdentifier.MoodCell, bundle: nil), forCellReuseIdentifier: ReuseIdentifier.MoodCell)

        //Update Resident Card View
        if let cardView = self.residentCardView{
            if let basicInfo = self.patientHeaderInfo{
                self.updateResidentCardView(cardView: cardView, residentInfo: basicInfo)
            }
        }
        self.lblDate.text = ConstantStrings.NA
        self.lblAddedBy.text = "Added by : \(ConstantStrings.NA)"
        
        self.setupClosures()
        self.viewModel.getMoodAndBehaviourDetail(patientId: self.patientHeaderInfo?.patientID ?? 0) { (result) in
            
        }
    }
    
    func setupClosures() {
        self.viewModel.reloadListViewClosure = { [weak self] () in
            DispatchQueue.main.async {
                self?.lblDate.text = Utility.convertServerDateToRequiredDate(dateStr: self?.viewModel.dateOfPlan ?? ConstantStrings.NA, requiredDateformat: DateFormats.mm_dd_yyyy)
                self?.lblTime.text = Utility.convertServerDateToRequiredDate(dateStr: self?.viewModel.dateOfPlan ?? "", requiredDateformat: DateFormats.hh_mm_a)
                self?.lblAddedBy.text = "Added by : " + (self?.viewModel.planAddedBy ?? ConstantStrings.NA)

                self?.tblView.reloadData()
            }
        }
    }

}

extension MoodTrackingViewController:UITableViewDataSource, UITableViewDelegate {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.numberOfRows(section: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ReuseIdentifier.MoodCell, for: indexPath as IndexPath) as! MoodCell
        
        let list = self.viewModel.roomForIndexPath(indexPath)
        cell.lblTitle.text = list?.title ?? ""
        cell.lblValue.text = list?.value ?? ConstantStrings.NA
        
        //cell.lblSeperator.isHidden = indexPath.row != self.viewModel.numberOfRows(section: indexPath.section)-1
        
        //cell.lblDivider.isHidden = list?.value == ""
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
