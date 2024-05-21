//
//  MedicationListViewController.swift
//  appName
//
//  Created by Vasundhara Parakh on 2/28/20.
//  Copyright © 2020 smartData Enterprises (I) Ltd. All rights reserved.
//

import UIKit

class MedicationListViewController: BaseViewController {

    @IBOutlet weak var residentCardView: ResidentCardView!
    @IBOutlet weak var tblView: UITableView!
    lazy var viewModel: MedicationListViewModel = {
        let obj = MedicationListViewModel(with: ResidentService())
        self.baseViewModel = obj
        return obj
    }()
    var medicationList = [Medication]()
    var sectionTitle = ["Medication", "Over-the-counter medication", "Herbal Supplement"]
    //LoadMore
    var spinner: UIActivityIndicatorView = UIActivityIndicatorView()
    var patientHeaderInfo : PatientBasicHeaderInfo?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.title = NavigationTitle.MedicationList
        self.addBackButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.initialSetup()
        self.viewModel.getMedicationList(pageNo: 1, patientID: self.patientHeaderInfo?.patientID ?? 0)
        self.viewModel.getOverCounterMedicationList(patientID: self.patientHeaderInfo?.patientID ?? 0)
        self.viewModel.getHerbalMedicationList(patientID: self.patientHeaderInfo?.patientID ?? 0)
        self.setupClosures()
    }
    func initialSetup(){
        //LoadMore
        self.spinner.color = Color.LightGray
        self.spinner.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        self.tblView.tableFooterView = spinner
        //Ends

        //Update Resident Card View
        if let cardView = self.residentCardView{
            if let basicInfo = self.patientHeaderInfo{
                self.updateResidentCardView(cardView: cardView, residentInfo: basicInfo)
            }
        }

    }
    
    func setupClosures() {
        self.viewModel.reloadListViewClosure = { [weak self] () in
            DispatchQueue.main.async {
                //self?.tblView.tableFooterView = self?.viewModel.strForIsMore == ConstantStrings.no ? nil : self?.spinner
                self?.tblView.reloadData()
            }
        }
    }

}

extension MedicationListViewController:UITableViewDataSource, UITableViewDelegate {
   
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 3
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return self.viewModel.numberOfRows() == 0 ? 1 : self.viewModel.numberOfRows()
        }else if section == 1{
            return self.viewModel.arrOverCounterMedication.count == 0 ? 1 : self.viewModel.arrOverCounterMedication.count
        }else if section == 2{ //Herbal
            return self.viewModel.arrHerbalMedication.count == 0 ? 1 : self.viewModel.arrHerbalMedication.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: ReuseIdentifier.MedicationListTableViewCell, for: indexPath as IndexPath) as! MedicationListTableViewCell
            cell.lblNoRecords.isHidden = true
            cell.lblPrescribedByTitle.isHidden = false

            if self.viewModel.numberOfRows() != 0{
                cell.medication = self.viewModel.roomForIndexPath(indexPath)
            }else{
                cell.lblNoRecords.isHidden = false
                cell.lblPrescribedByTitle.isHidden = true

            }
            return cell
        }
            // Over counter
        else if indexPath.section == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: ReuseIdentifier.OtherMedicineCell, for: indexPath as IndexPath) as! OtherMedicineCell
            cell.lblNoRecords.isHidden = true
            
            if self.viewModel.arrOverCounterMedication.count != 0{
                cell.medication = self.viewModel.arrOverCounterMedication[indexPath.row]
            }else{
                cell.lblNoRecords.isHidden = false
            }
            return cell
            
        }
            // Herbal
        else if indexPath.section == 2{
            let cell = tableView.dequeueReusableCell(withIdentifier: ReuseIdentifier.OtherMedicineCell, for: indexPath as IndexPath) as! OtherMedicineCell
            cell.lblNoRecords.isHidden = true
            if self.viewModel.arrHerbalMedication.count != 0{
                cell.medication = self.viewModel.arrHerbalMedication[indexPath.row]
            }else{
                cell.lblNoRecords.isHidden = false
            }
            return cell
            
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //Load More Functionality:--
        debugPrint("Load More === \(self.viewModel.numberOfRows())")
        /*
        if indexPath.row == self.viewModel.numberOfRows()-1 {
            if self.viewModel.strForIsMore == ConstantStrings.yes {
                self.perform(#selector(loadMore), with: nil, afterDelay: 0.0)
            }
        }*/
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 60))
        headerView.backgroundColor = UIColor.white
        
        let lblSection = UILabel(frame: CGRect(x: 10, y: 10, width: tableView.frame.size.width - 10, height: 40))
        lblSection.textColor = Color.Blue
        lblSection.text = self.sectionTitle[section]
        lblSection.font = UIFont.PoppinsMedium(fontSize: 18)
        headerView.addSubview(lblSection)

        //headerView.borderWidth = 1.0
        //headerView.borderColor = Color.Line
        
        return headerView
    }

    //MARK:- Pull To LoadMore
    @objc func loadMore(){
        self.tblView.tableFooterView = spinner
        spinner.startAnimating()
        self.viewModel.getMedicationList(pageNo: self.viewModel.intForPageNo, patientID: self.patientHeaderInfo?.patientID ?? 0)
    }


    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return self.viewModel.numberOfRows() == 0 ? 100 : UITableView.automaticDimension
        }else if indexPath.section == 1{
            return self.viewModel.arrOverCounterMedication.count == 0 ? 100 : UITableView.automaticDimension
        }else if indexPath.section == 2{ //Herbal
            return self.viewModel.arrHerbalMedication.count == 0 ? 100 : UITableView.automaticDimension
        }

        return UITableView.automaticDimension
    }
    
    
}
class OtherMedicineCell: UITableViewCell {
    @IBOutlet weak var lblName : UILabel!
    @IBOutlet weak var lblDose : UILabel!
    @IBOutlet weak var lblNotes : UILabel!
    @IBOutlet weak var lblNoRecords : UILabel!

    var medication : OtherMedicine?{
        didSet{
            setUpData()
        }
    }
        
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setUpData(){
        self.lblName.text = medication?.medicationName ?? ConstantStrings.NA
        
        self.lblNotes.text = medication?.note ?? ConstantStrings.NA
        
        self.lblDose.text = medication?.dosage ?? ConstantStrings.NA
    }
}
class MedicationListTableViewCell: UITableViewCell {
    @IBOutlet weak var lblName : UILabel!
    @IBOutlet weak var lblQuantity : UILabel!
    @IBOutlet weak var lblFrequency : UILabel!
    @IBOutlet weak var lblStartDate : UILabel!
    @IBOutlet weak var lblEndDate : UILabel!
    @IBOutlet weak var lblActive : UILabel!
    @IBOutlet weak var lblmedicineInfo : UILabel!
    @IBOutlet weak var lblOrderType : UILabel!
    @IBOutlet weak var lblTreatmentType : UILabel!
    @IBOutlet weak var lblDuration : UILabel!
    @IBOutlet weak var lblIndicationOfUse : UILabel!
    @IBOutlet weak var lblRoute : UILabel!
    @IBOutlet weak var lblNoRecords : UILabel!
    @IBOutlet weak var lblPrescribedByTitle : UILabel!

    var medication : Medication?{
        didSet{
            setUpData()
        }
    }
        
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setUpData(){
        let highlightQuantity =  medication?.dose ?? ConstantStrings.NA
        let highlightFrequency =  medication?.frequency ?? ConstantStrings.NA
        var docName = (medication?.transcriberName ?? ConstantStrings.NA).removeDoctorPrefix()
        docName = docName.count == 0 ? ConstantStrings.NA : docName
        let highlightMedicineInfo = docName//"Dr. " + docName
        let highlightOrderType = medication?.typeofOrderName ?? ConstantStrings.NA
        let highlightTreatment = medication?.prescriptionTypeName ?? ConstantStrings.NA
        let highlightRoute = medication?.route ?? ConstantStrings.NA
        let highlightDuration = (medication?.duration ?? ConstantStrings.NA) + " " + (medication?.durationType ?? "")
        let highlightUse = ((medication?.indicationForUseName ?? ConstantStrings.NA).trimmingCharacters(in: .whitespacesAndNewlines)).count == 0 ? ConstantStrings.NA : (medication?.indicationForUseName ?? ConstantStrings.NA)

        self.lblName.text = medication?.medicationName ?? ConstantStrings.NA
        
        self.lblQuantity.attributedText = Utility.highlightPartialTextOfLabel(mainString: highlightQuantity , highlightString: highlightQuantity, highlightColor: Color.DarkGray, highlightFont: UIFont.PoppinsMedium(fontSize: 14.0))
        
        self.lblFrequency.attributedText = Utility.highlightPartialTextOfLabel(mainString: highlightFrequency, highlightString: highlightFrequency, highlightColor: Color.DarkGray, highlightFont: UIFont.PoppinsMedium(fontSize: 14.0))

        self.lblRoute.attributedText = Utility.highlightPartialTextOfLabel(mainString: highlightRoute, highlightString: highlightRoute, highlightColor: Color.DarkGray, highlightFont: UIFont.PoppinsMedium(fontSize: 14.0))

        self.lblDuration.attributedText = Utility.highlightPartialTextOfLabel(mainString: highlightDuration, highlightString: highlightDuration, highlightColor: Color.DarkGray, highlightFont: UIFont.PoppinsMedium(fontSize: 14.0))

        self.lblIndicationOfUse.attributedText = Utility.highlightPartialTextOfLabel(mainString: highlightUse, highlightString: highlightUse, highlightColor: Color.DarkGray, highlightFont: UIFont.PoppinsMedium(fontSize: 14.0))

        let startDate = (medication?.startDate ?? ConstantStrings.NA).replacingOccurrences(of: "T", with: " ")
        let endDate = (medication?.endDate ?? ConstantStrings.NA).replacingOccurrences(of: "T", with: " ")
        
        let displayStartDate = Utility.convertServerDateToRequiredDate(dateStr: startDate, requiredDateformat: DateFormats.mm_dd_yyyy)
        self.lblStartDate.text = displayStartDate == "01/01/0001" ? ConstantStrings.NA : displayStartDate
        
        let displayEndDate = Utility.convertServerDateToRequiredDate(dateStr: endDate, requiredDateformat: DateFormats.mm_dd_yyyy)
        self.lblEndDate.text = displayEndDate == "01/01/0001" ? ConstantStrings.NA : displayEndDate

        let medicineDate = (medication?.prescriptionDate ?? ConstantStrings.NA).replacingOccurrences(of: "T", with: " ")
        let finalDateStr = Utility.convertServerDateToRequiredDate(dateStr: medicineDate, requiredDateformat: DateFormats.mm_dd_yyyy)
        
        let medicineInfo = finalDateStr == "01/01/0001" ? "\(highlightMedicineInfo)" : "\(highlightMedicineInfo) on \(finalDateStr)"
        self.lblmedicineInfo.attributedText = Utility.highlightPartialTextOfLabel(mainString: medicineInfo , highlightString: highlightMedicineInfo, highlightColor: Color.Blue, highlightFont: UIFont.PoppinsMedium(fontSize: 14.0))

        self.lblActive.text = medication?.statusName ?? ""//(medication?.isActive ?? false) ? "Active" : "Inactive"
        self.lblActive.textColor = (medication?.statusName ?? "") == "Active"
         ? Color.Green : Color.Red

        //Order type
        if medication?.typeofOrderName == nil {
            self.lblOrderType.attributedText = Utility.highlightPartialTextOfLabel(mainString: highlightOrderType, highlightString: highlightOrderType, highlightColor: Color.DarkGray, highlightFont: UIFont.PoppinsMedium(fontSize: 14.0))
        }else{
            self.lblOrderType.text = highlightOrderType
        }
        
        //Prescription type
        if medication?.prescriptionTypeName == nil {
            self.lblTreatmentType.attributedText = Utility.highlightPartialTextOfLabel(mainString: highlightTreatment, highlightString: highlightTreatment, highlightColor: Color.DarkGray, highlightFont: UIFont.PoppinsMedium(fontSize: 14.0))
        }else{
             self.lblTreatmentType.text = highlightTreatment
        }
        
    }
}

