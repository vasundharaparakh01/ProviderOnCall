//
//  InputOutPutChartVC.swift
//  appName
//
//  Created by Sorabh Gupta on 12/17/20.
//  Copyright © 2020 smartData Enterprises (I) Ltd. All rights reserved.
//

import UIKit
enum HeaderItem : Int {
    static let FoodIntake = "Food Intake"
    static let FluidIntake = "Fluid Intake"
    static let Urine_ml = "Urine (ml)"
    static let Emesis_ml = "Emesis (ml)"
    static let Blood_Loss_ml = "Blood Loss(ml)"
    static let Bowel_OutPut_ml = "Bowel OutPut"
    
    case FoodIntakeCheck = 0
    case FluidIntakeCheck
    case Urine_mlCheck
    case Emesis_mlCheck
    case Blood_Loss_mlCheck
    case Bowel_OutPut_mlCheck
}

let headerItem = [
    HeaderItem.FoodIntake,
    HeaderItem.FluidIntake,
    HeaderItem.Urine_ml,
    HeaderItem.Emesis_ml,
    HeaderItem.Blood_Loss_ml,
    HeaderItem.Bowel_OutPut_ml
]
class InputOutPutChartVC: BaseViewController {
    @IBOutlet weak var tblInputOutput: UITableView!
    @IBOutlet weak var tfDate: UITextField!
    @IBOutlet weak var lblRecordNotFound: UILabel!
    
    var patientId = 0
    lazy var viewModel: TrendGraphViewModel = {
        let obj = TrendGraphViewModel(with: PointOfCareService())
        self.baseViewModel = obj
        return obj
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = NavigationTitle.InputOutputChart
        self.addBackButton()
        self.initialSetup()
        self.addrightBarButtonItem()
        self.tfDate.setInputViewDatePicker(target: self, selector: #selector(tapDone))
        
        let dateformatter = DateFormatter() // 2-2
        dateformatter.dateFormat = "MM/dd/yyyy"
        self.tfDate.text = dateformatter.string(from: Date()) //2-4
        // Do any additional setup after loading the view.
        
        self.callAPI()
    }//12/17/2020
    func callAPI(){
        self.tblInputOutput.isHidden = true
        self.lblRecordNotFound.text = ""
        viewModel.getIODetail(patientId: patientId, strDate: self.tfDate.text ?? "") { (result) in
            var datacheck:Bool = false
            if  self.viewModel.inputOutPut?.dataInput?.foodIntake?.count ?? -1 > 0{
                datacheck = true
            }else if  self.viewModel.inputOutPut?.dataInput?.fluidIntake?.count ?? -1 > 0{
                datacheck = true
            }else if  self.viewModel.inputOutPut?.dataInput?.urine?.count ?? -1 > 0{
                datacheck = true
            }else if  self.viewModel.inputOutPut?.dataInput?.emesis?.count ?? -1 > 0{
                datacheck = true
            }else if  self.viewModel.inputOutPut?.dataInput?.bloodLoss?.count ?? -1 > 0{
                datacheck = true
            }else if  self.viewModel.inputOutPut?.dataInput?.bowel?.count ?? -1 > 0{
                datacheck = true
            }
            if datacheck{
                self.tblInputOutput.isHidden = false
                self.lblRecordNotFound.text = ""
            }else{
                self.lblRecordNotFound.text = "Record not found"
            }
            self.tblInputOutput.reloadData()
        }
    }
    
    @objc func tapDone() {
        if let datePicker = self.tfDate.inputView as? UIDatePicker { // 2-1
            //datePicker.maximumDate = Date()
            datePicker.setValidation()
            let dateformatter = DateFormatter() // 2-2
            dateformatter.dateFormat = "MM/dd/yyyy"
            
            //dateformatter.dateStyle = .medium // 2-3
            self.tfDate.text = dateformatter.string(from: datePicker.date) //2-4
        }
        self.tfDate.resignFirstResponder() // 2-5
        self.callAPI()
    }
    func addrightBarButtonItem() {
        let rightBarButtonItem = UIBarButtonItem(title: "Trend Graph", style: .plain, target:  self, action: #selector(onRightBarButtonItemClicked(_ :)))
        rightBarButtonItem.image = UIImage.init(named: "TG")
        rightBarButtonItem.tintColor = UIColor.white
        navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    @objc func onRightBarButtonItemClicked(_ sender: UIBarButtonItem) {
        let vc = TrendGraphVC.instantiate(appStoryboard: Storyboard.PointOfCare) as! TrendGraphVC
        vc.patientId = patientId
        self.navigationController?.pushViewController(vc,animated:true)
    }
    func initialSetup(){
        self.tblInputOutput.register(UINib(nibName: ReuseIdentifier.CellINputOutPut, bundle: nil), forCellReuseIdentifier: ReuseIdentifier.CellINputOutPut)
        self.tblInputOutput.register(UINib(nibName: ReuseIdentifier.CellDateTimeIOChart, bundle: nil), forCellReuseIdentifier: ReuseIdentifier.CellDateTimeIOChart)
        
        self.tblInputOutput.register(UINib(nibName: ReuseIdentifier.CellDateTimeTitleML, bundle: nil), forCellReuseIdentifier: ReuseIdentifier.CellDateTimeTitleML)
        self.tblInputOutput.register(UINib(nibName: ReuseIdentifier.CellDateTimeValueML, bundle: nil), forCellReuseIdentifier: ReuseIdentifier.CellDateTimeValueML)
        
    }
}
extension InputOutPutChartVC: UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return headerItem.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            if self.viewModel.inputOutPut?.dataInput?.foodIntake?.count ?? -1 > 0{
                return  (self.viewModel.inputOutPut?.dataInput?.foodIntake!.count)! + 1
            }else{
                return  0
            }
            
        }else if section == 1{
            
            
            if self.viewModel.inputOutPut?.dataInput?.fluidIntake?.count ?? -1 > 0{
                return  (self.viewModel.inputOutPut?.dataInput?.fluidIntake!.count)! + 1
            }else{
                return  0
            }
        }
        else if section == 2{
            
            if self.viewModel.inputOutPut?.dataInput?.urine?.count ?? -1 > 0{
                return  (self.viewModel.inputOutPut?.dataInput?.urine!.count)! + 1
            }else{
                return  0
            }
            
        }
        else if section == 3{
            if self.viewModel.inputOutPut?.dataInput?.emesis?.count ?? -1 > 0{
                return  (self.viewModel.inputOutPut?.dataInput?.emesis!.count)! + 1
            }else{
                return  0
            }
        }
        else if section == 4{
            if self.viewModel.inputOutPut?.dataInput?.bloodLoss?.count ?? -1 > 0{
                return  (self.viewModel.inputOutPut?.dataInput?.bloodLoss!.count)! + 1
            }else{
                return  0
            }
        }
        else if section == 5{
            
            if self.viewModel.inputOutPut?.dataInput?.bowel?.count  ?? -1 > 0{
                return  (self.viewModel.inputOutPut?.dataInput?.bowel!.count)! + 1
            }else{
                return  0
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            if indexPath.row == 0{
                let cell = tblInputOutput.dequeueReusableCell(withIdentifier: ReuseIdentifier.CellDateTimeIOChart, for: indexPath as IndexPath) as! CellDateTimeIOChart
                cell.lblamount.text = "% Meal Eaten"
                
                return cell
            }else{
                let cell = tblInputOutput.dequeueReusableCell(withIdentifier: ReuseIdentifier.CellINputOutPut, for: indexPath as IndexPath) as! CellINputOutPut
                
                if let dateH = self.viewModel.inputOutPut?.dataInput?.foodIntake?[indexPath.row - 1].date{
                    cell.lblDate.text = Utility.convertServerDateToRequiredDate(dateStr: dateH, requiredDateformat: DateFormats.mm_dd_yyyy)
                }else{
                    cell.lblDate.text = "-"
                }
                
                if let timeH = self.viewModel.inputOutPut?.dataInput?.foodIntake?[indexPath.row - 1].time{
                    cell.lblTime.text = Utility.convertServerDateToRequiredDate(dateStr: timeH, requiredDateformat: DateFormats.hh_mm_a)
                }else{
                    cell.lblTime.text = "-"
                }
                

                if  "" == self.viewModel.inputOutPut?.dataInput?.foodIntake?[indexPath.row - 1].foodIntake{
                    cell.lblIntack.text = "-"
                }else{
                    cell.lblIntack.text = self.viewModel.inputOutPut?.dataInput?.foodIntake?[indexPath.row - 1].foodIntake ?? "-"
                }
                
                
                let mealEaten = self.viewModel.inputOutPut?.dataInput?.foodIntake?[indexPath.row - 1].mealEaten ?? "-"
                cell.lblML.text = mealEaten + "%"
                if  "" == self.viewModel.inputOutPut?.dataInput?.foodIntake?[indexPath.row - 1].mealEaten{
                    cell.lblML.text = "-"
                }else{
                    cell.lblML.text = mealEaten + "%"
                }
                
                return cell
            }
        }else if indexPath.section == 1{
            if indexPath.row == 0{
                let cell = tblInputOutput.dequeueReusableCell(withIdentifier: ReuseIdentifier.CellDateTimeIOChart, for: indexPath as IndexPath) as! CellDateTimeIOChart
                cell.lblamount.text = "Amount (ml)"
                return cell
            }else{
                let cell = tblInputOutput.dequeueReusableCell(withIdentifier: ReuseIdentifier.CellINputOutPut, for: indexPath as IndexPath) as! CellINputOutPut
                
                if let dateH = self.viewModel.inputOutPut?.dataInput?.fluidIntake?[indexPath.row - 1].date{
                    cell.lblDate.text = Utility.convertServerDateToRequiredDate(dateStr: dateH, requiredDateformat: DateFormats.mm_dd_yyyy)
                }else{
                    cell.lblDate.text = "-"
                }
                
                if let timeH = self.viewModel.inputOutPut?.dataInput?.fluidIntake?[indexPath.row - 1].time{
                    cell.lblTime.text = Utility.convertServerDateToRequiredDate(dateStr: timeH, requiredDateformat: DateFormats.hh_mm_a)
                }else{
                    cell.lblTime.text = "-"
                }
                

                if  "" == self.viewModel.inputOutPut?.dataInput?.fluidIntake?[indexPath.row - 1].fluidIntake{
                    cell.lblIntack.text = "-"
                }else{
                    cell.lblIntack.text = self.viewModel.inputOutPut?.dataInput?.fluidIntake?[indexPath.row - 1].fluidIntake ?? "-"
                }
                
                if  "" == self.viewModel.inputOutPut?.dataInput?.fluidIntake?[indexPath.row - 1].amount{
                    cell.lblML.text = "-"
                }else{
                    cell.lblML.text = self.viewModel.inputOutPut?.dataInput?.fluidIntake?[indexPath.row - 1].amount ?? "-"
                }
                
                return cell
            }
        }
        else if indexPath.section == 2{
            if indexPath.row == 0{
                let cell = tblInputOutput.dequeueReusableCell(withIdentifier: ReuseIdentifier.CellDateTimeTitleML, for: indexPath as IndexPath) as! CellDateTimeTitleML
                cell.lblamount.text = "Amount (ml)"
                return cell
            }else{
                let cell = tblInputOutput.dequeueReusableCell(withIdentifier: ReuseIdentifier.CellDateTimeValueML, for: indexPath as IndexPath) as! CellDateTimeValueML
                if let dateH = self.viewModel.inputOutPut?.dataInput?.urine?[indexPath.row - 1].date{
                    cell.lblDate.text = Utility.convertServerDateToRequiredDate(dateStr: dateH, requiredDateformat: DateFormats.mm_dd_yyyy)
                }else{
                    cell.lblDate.text = "-"
                }
                
                if let timeH = self.viewModel.inputOutPut?.dataInput?.urine?[indexPath.row - 1].time{
                    cell.lblTime.text = Utility.convertServerDateToRequiredDate(dateStr: timeH, requiredDateformat: DateFormats.hh_mm_a)
                }else{
                    cell.lblTime.text = "-"
                }
                
                
                if  "" == self.viewModel.inputOutPut?.dataInput?.urine?[indexPath.row - 1].urine{
                    cell.lblML.text = "-"
                }else{
                    cell.lblML.text = self.viewModel.inputOutPut?.dataInput?.urine?[indexPath.row - 1].urine ?? "-"
                }
                
                return cell
            }
        }
        else if indexPath.section == 3{
            if indexPath.row == 0{
                let cell = tblInputOutput.dequeueReusableCell(withIdentifier: ReuseIdentifier.CellDateTimeTitleML, for: indexPath as IndexPath) as! CellDateTimeTitleML
                cell.lblamount.text = "Amount (ml)"
                return cell
            }else{
                let cell = tblInputOutput.dequeueReusableCell(withIdentifier: ReuseIdentifier.CellDateTimeValueML, for: indexPath as IndexPath) as! CellDateTimeValueML
            
                if let dateH = self.viewModel.inputOutPut?.dataInput?.emesis?[indexPath.row - 1].date{
                    cell.lblDate.text = Utility.convertServerDateToRequiredDate(dateStr: dateH, requiredDateformat: DateFormats.mm_dd_yyyy)
                }else{
                    cell.lblDate.text = "-"
                }
                
                if let timeH = self.viewModel.inputOutPut?.dataInput?.emesis?[indexPath.row - 1].time{
                    cell.lblTime.text = Utility.convertServerDateToRequiredDate(dateStr: timeH, requiredDateformat: DateFormats.hh_mm_a)
                }else{
                    cell.lblTime.text = "-"
                }
                
                if  "" == self.viewModel.inputOutPut?.dataInput?.emesis?[indexPath.row - 1].emesis{
                    cell.lblML.text = "-"
                }else{
                    cell.lblML.text = self.viewModel.inputOutPut?.dataInput?.emesis?[indexPath.row - 1].emesis ?? "-"
                }
                
                
                return cell
            }
        }
        else if indexPath.section == 4{
            if indexPath.row == 0{
                let cell = tblInputOutput.dequeueReusableCell(withIdentifier: ReuseIdentifier.CellDateTimeTitleML, for: indexPath as IndexPath) as! CellDateTimeTitleML
                cell.lblamount.text = "Amount (ml)"
                return cell
            }else{
                let cell = tblInputOutput.dequeueReusableCell(withIdentifier: ReuseIdentifier.CellDateTimeValueML, for: indexPath as IndexPath) as! CellDateTimeValueML
                
                if let dateH = self.viewModel.inputOutPut?.dataInput?.bloodLoss?[indexPath.row - 1].date{
                    cell.lblDate.text = Utility.convertServerDateToRequiredDate(dateStr: dateH, requiredDateformat: DateFormats.mm_dd_yyyy)
                }else{
                    cell.lblDate.text = "-"
                }
                
                if let timeH = self.viewModel.inputOutPut?.dataInput?.bloodLoss?[indexPath.row - 1].time{
                    cell.lblTime.text = Utility.convertServerDateToRequiredDate(dateStr: timeH, requiredDateformat: DateFormats.hh_mm_a)
                }else{
                    cell.lblTime.text = "-"
                }
                
                if  "" == self.viewModel.inputOutPut?.dataInput?.bloodLoss?[indexPath.row - 1].bloodLoss{
                    cell.lblML.text = "-"
                }else{
                    cell.lblML.text = self.viewModel.inputOutPut?.dataInput?.bloodLoss?[indexPath.row - 1].bloodLoss
                }
                
                
                return cell
            }
        }
        else{
            if indexPath.row == 0{
                let cell = tblInputOutput.dequeueReusableCell(withIdentifier: ReuseIdentifier.CellDateTimeTitleML, for: indexPath as IndexPath) as! CellDateTimeTitleML
                cell.lblamount.text = "Amount"
                return cell
            }else{
                let cell = tblInputOutput.dequeueReusableCell(withIdentifier: ReuseIdentifier.CellDateTimeValueML, for: indexPath as IndexPath) as! CellDateTimeValueML

                if let dateH = self.viewModel.inputOutPut?.dataInput?.bowel?[indexPath.row - 1].date{
                    cell.lblDate.text = Utility.convertServerDateToRequiredDate(dateStr: dateH, requiredDateformat: DateFormats.mm_dd_yyyy)
                }else{
                    cell.lblDate.text = "-"
                }
                
                if let timeH = self.viewModel.inputOutPut?.dataInput?.bowel?[indexPath.row - 1].time{
                    cell.lblTime.text = Utility.convertServerDateToRequiredDate(dateStr: timeH, requiredDateformat: DateFormats.hh_mm_a)
                }else{
                    cell.lblTime.text = "-"
                }
                
                
                cell.lblML.text = self.viewModel.inputOutPut?.dataInput?.bowel?[indexPath.row - 1].bowelAmount ?? "-"
                return cell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerInputOutPutChart = Bundle.main.loadNibNamed("HeaderInputOutPutChart",
                                                              owner: self, options: nil)![0] as? HeaderInputOutPutChart
        headerInputOutPutChart?.lblHeader.text = headerItem[section]
        return headerInputOutPutChart
        
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 0{
            let footerInputOutPutChart = Bundle.main.loadNibNamed("FooterInputOutPutChart",
                                                                  owner: self, options: nil)![0] as? FooterInputOutPutChart
            footerInputOutPutChart?.lblFooter.text = "Daily Total"
            return footerInputOutPutChart
        }
        else if section == 1{
            let footerInputOutPutChart = Bundle.main.loadNibNamed("FooterInputOutPutChart",
                                                                  owner: self, options: nil)![0] as? FooterInputOutPutChart
            footerInputOutPutChart?.lblFooter.text = "Daily Total"
            var intValue : Int = 0
            if let fluidIntArray = self.viewModel.inputOutPut?.dataInput?.fluidIntake{
                for dict in fluidIntArray{
                    if let amount = dict.amount{
                        if amount.count > 0{
                            let am = Int(amount)
                            intValue = intValue + am!
                        }
                        
                    }
                }
            }
            footerInputOutPutChart?.lblAmountFooter.text = "\(intValue)"
            return footerInputOutPutChart
        }  else if section == 2{
            let footerInputOutPutChart = Bundle.main.loadNibNamed("FooterMLOnly",
                                                                  owner: self, options: nil)![0] as? FooterMLOnly
            footerInputOutPutChart?.lblFooter.text = "Daily Total"
            var intValue : Int = 0
            if let urineArray = self.viewModel.inputOutPut?.dataInput?.urine{
                for dict in urineArray{
                    if let amount = dict.urine{
                        if amount.count > 0{
                            let am = Int(amount)
                            intValue = intValue + am!
                        }
                        
                    }
                }
            }
            footerInputOutPutChart?.lblAmountFooter.text = "\(intValue)"
            return footerInputOutPutChart
        }
        else if section == 3{
            let footerInputOutPutChart = Bundle.main.loadNibNamed("FooterMLOnly",
                                                                  owner: self, options: nil)![0] as? FooterMLOnly
            footerInputOutPutChart?.lblFooter.text = "Daily Total"
            var intValue : Int = 0
            if let emesisArray = self.viewModel.inputOutPut?.dataInput?.emesis{
                for dict in emesisArray{
                    if let amount = dict.emesis{
                        if amount.count > 0{
                            let am = Int(amount)
                            intValue = intValue + am!
                        }
                        
                    }
                }
            }
            footerInputOutPutChart?.lblAmountFooter.text = "\(intValue)"
            return footerInputOutPutChart
        }
        else if section == 4{
            let footerInputOutPutChart = Bundle.main.loadNibNamed("FooterMLOnly",
                                                                  owner: self, options: nil)![0] as? FooterMLOnly
            footerInputOutPutChart?.lblFooter.text = "Daily Total"
            var intValue : Int = 0
            if let bloodLossArray = self.viewModel.inputOutPut?.dataInput?.bloodLoss{
                for dict in bloodLossArray{
                    if let amount = dict.bloodLoss{
                        if amount.count > 0{
                            let am = Int(amount)
                            intValue = intValue + am!
                        }
                        
                    }
                }
            }
            footerInputOutPutChart?.lblAmountFooter.text = "\(intValue)"
            return footerInputOutPutChart
        }
        else{
            let footerInputOutPutChart = Bundle.main.loadNibNamed("FooterMLOnly",
                                                                  owner: self, options: nil)![0] as? FooterMLOnly
            footerInputOutPutChart?.lblFooter.text = "Daily Total"
            
            
            var intValue : Int = 0
            if let bloodLossArray = self.viewModel.inputOutPut?.dataInput?.bowel{
                for dict in bloodLossArray{
                    if let amount = dict.bowelAmount{
                        intValue = intValue + 1
                    }
                    
                }
            }
            footerInputOutPutChart?.lblAmountFooter.text = "\(intValue)"
            
            return footerInputOutPutChart
        }
        
        
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0{
            return 0
        }
        return 70
    }
}
extension UITextField {
    
    func setInputViewDatePicker(target: Any, selector: Selector) {
        // Create a UIDatePicker object and assign to inputView
        let screenWidth = UIScreen.main.bounds.width
        let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 216))//1
        datePicker.datePickerMode = .date //2
        // iOS 14 and above
        if #available(iOS 14, *) {// Added condition for iOS 14
            datePicker.preferredDatePickerStyle = .wheels
            datePicker.sizeToFit()
        }
        self.inputView = datePicker //3
        
        // Create a toolbar and assign it to inputAccessoryView
        let toolBar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: screenWidth, height: 44.0)) //4
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil) //5
        let cancel = UIBarButtonItem(title: "Cancel", style: .plain, target: nil, action: #selector(tapCancel)) // 6
        let barButton = UIBarButtonItem(title: "Done", style: .plain, target: target, action: selector) //7
        toolBar.setItems([cancel, flexible, barButton], animated: false) //8
        self.inputAccessoryView = toolBar //9
    }
    
    @objc func tapCancel() {
        self.resignFirstResponder()
    }
    
}
extension UIDatePicker {
    func setValidation() {
        let currentDate: Date = Date()
        var calendar: Calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        calendar.timeZone = TimeZone(identifier: "UTC")!
        var components: DateComponents = DateComponents()
        components.calendar = calendar
        components.year = -0
        let maxDate: Date = calendar.date(byAdding: components, to: currentDate)!
        components.year = -10
        let minDate: Date = calendar.date(byAdding: components, to: currentDate)!
        self.minimumDate = minDate
        self.maximumDate = maxDate
    } }
