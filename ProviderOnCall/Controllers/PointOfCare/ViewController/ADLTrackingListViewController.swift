//
//  ADLTrackingListViewController.swift
//  AccessEMR
//
//  Created by Vasundhara Parakh on 3/12/20.
//  Copyright © 2020 smartData Enterprises (I) Ltd. All rights reserved.
//

import UIKit

class ADLTrackingListViewController : BaseViewController {
    
    @IBOutlet weak var residentCardView: ResidentCardView!
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblAddedBy: UILabel!
    
    var patientHeaderInfo : PatientBasicHeaderInfo?
    
    lazy var viewModel: ADLTrackingViewModel = {
        let obj = ADLTrackingViewModel(with: PointOfCareService())
        self.baseViewModel = obj
        return obj
    }()
    
    var arrDatasource = [ListingSectionModel]()
    var pointOfCareItem  = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        var title = ""
        switch self.pointOfCareItem {
        case ADLItems.MobilityItem.rawValue:
            title = ADLItems.Mobility
        case ADLItems.TransferItem.rawValue:
            title = ADLItems.Transfer
        case ADLItems.DressingItem.rawValue:
            title = ADLItems.Dressing
        case ADLItems.EatingAndDrinkingItem.rawValue:
            title = ADLItems.EatingAndDrinking
        case ADLItems.ToiletingItem.rawValue:
            title = ADLItems.Toileting
        case ADLItems.PersonalHygeineItem.rawValue:
            title = ADLItems.PersonalHygeine
        case ADLItems.BathingItem.rawValue:
            title = ADLItems.Bathing
        case ADLItems.ContinenceItem.rawValue:
            title = ADLItems.Continence
        case ADLItems.NotesItem.rawValue:
            title = ADLItems.Notes
        default:
            print("Do nothing")
        }
        self.navigationItem.title = title//NavigationTitle.CarePlanSections.Communication
        
        self.addBackButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.initialSetup()
    }
    func initialSetup(){
        self.tblView.register(UINib(nibName: ReuseIdentifier.ListCell, bundle: nil), forCellReuseIdentifier: ReuseIdentifier.ListCell)
        
        //Update Resident Card View
        if let cardView = self.residentCardView{
            if let basicInfo = self.patientHeaderInfo{
                self.updateResidentCardView(cardView: cardView, residentInfo: basicInfo)
            }
        }
        self.lblDate.text = ConstantStrings.NA
        self.lblAddedBy.text = "Added by : \(ConstantStrings.NA)"
        
        self.setupClosures()
        //self.viewModel.getADLTrackingDetail(ADLItem :self.pointOfCareItem,patientId: self.patientHeaderInfo?.patientID ?? 0)
        
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

extension ADLTrackingListViewController:UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.viewModel.numberOfSection()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.numberOfRows(section: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ReuseIdentifier.ListCell, for: indexPath as IndexPath) as! ListCell
        
        let list = self.viewModel.roomForIndexPath(indexPath)
        cell.lblTitle.text = list?.value == "" ? "" : list?.title ?? ""
        cell.lblValue.text = list?.value ?? ConstantStrings.NA
        
        cell.lblSeperator.isHidden = indexPath.row != self.viewModel.numberOfRows(section: indexPath.section)-1
        
        cell.lblDivider.isHidden = list?.value == ""
        
        cell.lblSingleTitle.text = list?.title ?? ""
        cell.lblSingleTitle.isHidden = !cell.lblDivider.isHidden
        cell.lblTitle.isHidden = cell.lblDivider.isHidden
        cell.lblValue.isHidden = cell.lblDivider.isHidden
        
        cell.lblSingleTitle.font = cell.lblDivider.isHidden ? Font.Medium.of(size: 16) :  Font.Medium.of(size: 14)
        cell.lblSingleTitle.textColor = cell.lblDivider.isHidden ? Color.Blue : Color.DarkGray
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        print("Height === \(UITableView.automaticDimension)")
        return UITableView.automaticDimension
    }
    /*
     func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
     return 60
     }
     
     func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
     let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 60))
     headerView.backgroundColor = UIColor.white
     
     let lblSection = UILabel(frame: CGRect(x: 10, y: 10, width: tableView.frame.size.width - 10, height: 40))
     lblSection.textColor = Color.Blue
     lblSection.text =  self.viewModel.titleForSectionHeader(section: section)
     lblSection.font = UIFont.PoppinsMedium(fontSize: 18)
     headerView.addSubview(lblSection)
     
     
     //headerView.borderWidth = 1.0
     //headerView.borderColor = Color.Line
     
     return headerView
     }
     */
}
