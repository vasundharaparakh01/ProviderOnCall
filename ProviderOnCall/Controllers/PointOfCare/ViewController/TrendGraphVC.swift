//
//  TrendGraphVC.swift
//  appName
//
//  Created by Sorabh Gupta on 12/18/20.
//  Copyright © 2020 smartData Enterprises (I) Ltd. All rights reserved.
//

import UIKit
import Charts

enum HeaderTrend : Int {
    static let FoodIntake = "Food Intake"
    static let FluidIntake = "Fluid Intake Amount"
    static let Urine_ml = "Urine Output"
    static let Emesis_ml = "Emesis Output"
    static let Blood_Loss_ml = "Blood Loss Output"
    static let Bowel_OutPut_ml = "Bowel Count"
    
    case FoodIntakeCheck = 0
    case FluidIntakeCheck
    case Urine_mlCheck
    case Emesis_mlCheck
    case Blood_Loss_mlCheck
    case Bowel_OutPut_mlCheck
}
enum HeaderTrendPersent : Int {
    static let FoodIntake = "Food Intake Percentage(%)"
    static let FluidIntake = "Fluid Intake Amount(ml)"
    static let Urine_ml = "Urine Output(ml)"
    static let Emesis_ml = "Emesis Output(ml)"
    static let Blood_Loss_ml = "Blood Loss Output(ml)"
    static let Bowel_OutPut_ml = "Bowel Count"
    
    case FoodIntakeCheck = 0
    case FluidIntakeCheck
    case Urine_mlCheck
    case Emesis_mlCheck
    case Blood_Loss_mlCheck
    case Bowel_OutPut_mlCheck
}

let headerTrend = [
    HeaderTrend.FoodIntake,
    HeaderTrend.FluidIntake,
    HeaderTrend.Urine_ml,
    HeaderTrend.Emesis_ml,
    HeaderTrend.Blood_Loss_ml,
    HeaderTrend.Bowel_OutPut_ml
]
let headerTrendPer = [
    HeaderTrendPersent.FoodIntake,
    HeaderTrendPersent.FluidIntake,
    HeaderTrendPersent.Urine_ml,
    HeaderTrendPersent.Emesis_ml,
    HeaderTrendPersent.Blood_Loss_ml,
    HeaderTrendPersent.Bowel_OutPut_ml
]

class TrendGraphVC: BaseViewController, ChartViewDelegate {
    
    @IBOutlet weak var heightConstarints: NSLayoutConstraint!
    @IBOutlet weak var tblTrendGraph: UITableView!
    @IBOutlet weak var tfFromDate: UITextField!
    @IBOutlet weak var tfTodate: UITextField!
    var dataSet = [LineChartDataSet]()
    
    var patientId = 0
    lazy var viewModel: TrendGraphViewModel = {
        let obj = TrendGraphViewModel(with: PointOfCareService())
        self.baseViewModel = obj
        return obj
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = NavigationTitle.InputOutputtrendgraph
        self.addBackButton()
        self.initialSetup()
        self.tfFromDate.setInputViewDatePicker(target: self, selector: #selector(tapFromDateDone))
        self.tfTodate.setInputViewDatePicker(target: self, selector: #selector(tapToDateDone))
        // Do any additional setup after loading the view.
        
    }
    
    @IBAction func ApplyFilert(_ sender: UIButton) {
        if tfFromDate.text?.count == 0{
            self.okAlert(stringData: "Plese enter from date")
        }
        else if tfTodate.text?.count == 0{
            self.okAlert(stringData: "Plese enter to date")
        }else{
            self.callAPI()
        }
    }
    func okAlert(stringData : String){
        let actionSheetController: UIAlertController = UIAlertController(title: Alert.Title.appName, message: stringData, preferredStyle: .alert)
        // create an action
        
        let firstAction: UIAlertAction = UIAlertAction(title: Alert.ButtonTitle.ok, style: .default) { action -> Void in
            
        }
        actionSheetController.addAction(firstAction)
        self.present(actionSheetController, animated: true) {
            //debugPrint("option menu presented")
        }
    }
    @IBAction func ClearData(_ sender: UIButton) {
        self.tfFromDate.text = ""
        self.tfTodate.text = ""
        viewModel.getTrendGraphDetail(patientId: patientId, strDate: tfFromDate.text ?? "", endDate:tfTodate.text ?? "") { (result) in
            print(self.viewModel.trendGraphModel?.data?.bloodLossTotal?.title)
            self.tblTrendGraph.reloadData()
        }
    }
    
    
    @objc func tapFromDateDone() {
        if let datePicker = self.tfFromDate.inputView as? UIDatePicker { // 2-1
            //datePicker.maximumDate = Date()
            datePicker.setValidation()
            let dateformatter = DateFormatter() // 2-2
            dateformatter.dateFormat = "MM/dd/yyyy"
            
            //dateformatter.dateStyle = .medium // 2-3
            self.tfFromDate.text = dateformatter.string(from: datePicker.date) //2-4
        }
        self.tfFromDate.resignFirstResponder() // 2-5
        
    }
    @objc func tapToDateDone() {
        if let datePicker = self.tfTodate.inputView as? UIDatePicker { // 2-1
            //datePicker.maximumDate = Date()
            datePicker.setValidation()
            let dateformatter = DateFormatter() // 2-2
            dateformatter.dateFormat = "MM/dd/yyyy"
            
            //dateformatter.dateStyle = .medium // 2-3
            self.tfTodate.text = dateformatter.string(from: datePicker.date) //2-4
        }
        self.tfTodate.resignFirstResponder() // 2-5
        
    }
    func callAPI(){
        
        viewModel.getTrendGraphDetail(patientId: patientId, strDate: tfFromDate.text ?? "", endDate: tfTodate.text ?? "") { (result) in
            print(self.viewModel.trendGraphModel?.data?.bloodLossTotal?.title)
            self.tblTrendGraph.reloadData()
        }
        
    }
    func initialSetup(){
        self.tblTrendGraph.register(UINib(nibName: ReuseIdentifier.CellTrendGraph, bundle: nil), forCellReuseIdentifier: ReuseIdentifier.CellTrendGraph)
        self.setRightViewIcon(icon:UIImage.init(named: "calendar")!, tfield: tfTodate)
        self.setRightViewIcon(icon:UIImage.init(named: "calendar")!, tfield: tfFromDate)
        
        let dateformatter = DateFormatter() // 2-2
        dateformatter.dateFormat = "MM/dd/yyyy"
        self.tfFromDate.text = dateformatter.string(from: Date()) //2-4
        
        let dateformatter2 = DateFormatter() // 2-2
        dateformatter2.dateFormat = "MM/dd/yyyy"
        self.tfTodate.text = dateformatter.string(from: Date()) //2-4
        self.callAPI()
    }
    func setRightViewIcon(icon: UIImage , tfield : UITextField) {
        let btnView = UIButton(frame: CGRect(x: 0, y: 0, width: 50 , height: tfTodate.bounds.size.height ))
        btnView.setImage(icon, for: .normal)
        btnView.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 3)
        tfield.rightViewMode = .always
        tfield.rightView = btnView
    }
}
extension TrendGraphVC: UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return headerTrend.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tblTrendGraph.frame.size.height
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerInputOutPutChart = Bundle.main.loadNibNamed("HeaderInputOutPutChart",
                                                              owner: self, options: nil)![0] as? HeaderInputOutPutChart
        headerInputOutPutChart?.lblHeader.text = headerItem[section]
        return headerInputOutPutChart
        
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let headerInputOutPutChart = Bundle.main.loadNibNamed("HeaderInputOutPutChart",
                                                              owner: self, options: nil)![0] as? HeaderInputOutPutChart
        headerInputOutPutChart?.lblHeader.text = headerItem[section]
        return headerInputOutPutChart
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblTrendGraph.dequeueReusableCell(withIdentifier: ReuseIdentifier.CellTrendGraph, for: indexPath as IndexPath) as! CellTrendGraph
        
        cell.lineChartView.delegate = self
        cell.lblBottemTitle.text = headerTrendPer[indexPath.section]
        cell.lblPercentTitle.text = headerTrendPer[indexPath.section]
        
        if indexPath.section == 0{
            if let data = viewModel.trendGraphModel?.data?.foodIntakeTotal{
                self.setupGraphView(cell: cell, foodIntakeT: data)
            }
        }
        if indexPath.section == 1{
            if let data = viewModel.trendGraphModel?.data?.fluidIntakeTotal{
                self.setupGraphView(cell: cell, foodIntakeT: data)
            }
        }
        if indexPath.section == 2{
            if let data = viewModel.trendGraphModel?.data?.urineTotal{
                self.setupGraphView(cell: cell, foodIntakeT: data)
            }
        }
        if indexPath.section == 3{
            if let data = viewModel.trendGraphModel?.data?.emesisTotal{
                self.setupGraphView(cell: cell, foodIntakeT: data)
            }
        }
        if indexPath.section == 4{
            if let data = viewModel.trendGraphModel?.data?.bloodLossTotal{
                self.setupGraphView(cell: cell, foodIntakeT: data)
            }
        }
        if indexPath.section == 5{
            if let data = viewModel.trendGraphModel?.data?.bowelCountTotal{
                self.setupGraphView(cell: cell, foodIntakeT: data)
            }
        }
        
        return cell
    }
    //MARK:- FoodIntakeTotalTrendGraph
    func setupGraphView(cell :CellTrendGraph , foodIntakeT : FoodIntakeTotalTrendGraph){
        //        if foodIntakeT.lables?.count  == 0 || foodIntakeT.data?.count == 0{
        //            return
        //        }
        let totalX  = foodIntakeT.lables?.count ?? 0
        cell.lineChartView.backgroundColor = .white
        cell.lineChartView.gridBackgroundColor = .white
        cell.lineChartView.drawGridBackgroundEnabled = true
        cell.lineChartView.drawBordersEnabled = true
        cell.lineChartView.chartDescription?.enabled = false
        cell.lineChartView.pinchZoomEnabled = false
        cell.lineChartView.dragEnabled = true
        cell.lineChartView.setScaleEnabled(true)
        cell.lineChartView.legend.enabled = false
        cell.lineChartView.rightAxis.enabled = false
        cell.lineChartView.xAxis.labelPosition = .bottom
        let leftAxis = cell.lineChartView.leftAxis
        leftAxis.axisMaximum = 100
        leftAxis.axisMinimum = 0
        leftAxis.granularity = 5.0
        leftAxis.labelCount = 11
        leftAxis.granularityEnabled = true
        leftAxis.labelFont = UIFont.PoppinsMedium(fontSize: 12)
        leftAxis.labelTextColor = Color.DarkGray
        
        let rightAxis = cell.lineChartView.rightAxis
        rightAxis.axisMaximum = 10
        rightAxis.axisMinimum = 0
        rightAxis.granularity = 1.0
        rightAxis.granularityEnabled = true
        rightAxis.axisLineColor = UIColor.white
        
        let xAxis = cell.lineChartView.xAxis
        xAxis.axisMaximum = Double(totalX-1)
        xAxis.axisMinimum = 0
        //xAxis.granularity = 1.0
        xAxis.granularityEnabled = true
        xAxis.labelFont = UIFont.PoppinsMedium(fontSize: 12)
        xAxis.labelTextColor = Color.DarkGray
        
        let months = foodIntakeT.lables?.compactMap({ (entity) -> [String] in
            return ( foodIntakeT.lables!)
        })
        var arrayH = [String]()
        
        if months?.count != 0{
            if  let hold = months?[0]{
                for dicth in hold{
                    arrayH.append(Utility.convertServerDateToRequiredDate(dateStr: dicth, requiredDateformat: DateFormats.mm_dd_yyyy))
                }
            }}
        xAxis.valueFormatter = IndexAxisValueFormatter(values:arrayH)
        xAxis.labelRotationAngle = 0
        xAxis.granularity = 1.0
        xAxis.labelCount = months?.count as! Int
        cell.lineChartView.setVisibleXRangeMaximum(10)
        
        self.setDataCount(cell: cell, foodIntakeT: foodIntakeT)
        
        
    }
    func setDataCount(cell :CellTrendGraph ,foodIntakeT : FoodIntakeTotalTrendGraph) {
        let dataSets = (0..<foodIntakeT.data!.count).map { i -> LineChartDataSet in
            let values = (0..<foodIntakeT.data!.count).map
            { (i) -> ChartDataEntry in
                let val = foodIntakeT.data![i]
                return ChartDataEntry(x: Double(i), y: Double(val))
            }
            
            let set = LineChartDataSet(entries: values, label: "DataSet")
            set.lineWidth = 2.5
            set.circleRadius = 5
            set.circleHoleRadius = 0
            set.valueTextColor = UIColor.clear
            let color = UIColor.red
            
            set.setColor(color)
            set.setCircleColor(color)
            set.mode = .cubicBezier
            let gradientColors = [color.withAlphaComponent(0.5).cgColor,
                                  color.withAlphaComponent(0.5).cgColor]
            let gradient = CGGradient(colorsSpace: nil, colors: gradientColors as CFArray, locations: nil)!
            
            set.fillAlpha = 1
            set.fill = Fill(linearGradient: gradient, angle: 90) //.linearGradient(gradient, angle: 90)
            set.drawFilledEnabled = true
            return set
        }
        dataSet = dataSets
        let data = LineChartData(dataSets: dataSet)
        data.setValueFont(.systemFont(ofSize: 0, weight: .light))
        cell.lineChartView.notifyDataSetChanged()
        cell.lineChartView.data =  data
        cell.lineChartView.setVisibleXRangeMaximum(6)
    }
    //MARK:- FluidIntakeTotalTrendGraph
    func setupGraphView(cell :CellTrendGraph , foodIntakeT : FluidIntakeTotalTrendGraph){
        //        if foodIntakeT.lables?.count  == 0 || foodIntakeT.data?.count == 0{
        //            return
        //        }
        let totalX  = foodIntakeT.lables?.count ?? 0
        cell.lineChartView.backgroundColor = .white
        cell.lineChartView.gridBackgroundColor = .white
        cell.lineChartView.drawGridBackgroundEnabled = true
        cell.lineChartView.drawBordersEnabled = true
        cell.lineChartView.chartDescription?.enabled = false
        cell.lineChartView.pinchZoomEnabled = false
        cell.lineChartView.dragEnabled = true
        cell.lineChartView.setScaleEnabled(true)
        cell.lineChartView.legend.enabled = false
        cell.lineChartView.rightAxis.enabled = false
        cell.lineChartView.xAxis.labelPosition = .bottom
        let leftAxis = cell.lineChartView.leftAxis
        if foodIntakeT.data?.count == 0 {
            leftAxis.axisMaximum = 100
        }else{
            leftAxis.axisMaximum = Double(foodIntakeT.data!.reduce(Int.min, { max($0, $1) })) + 10
        }
        
        leftAxis.axisMinimum = 0
        leftAxis.granularity = 5.0
        leftAxis.labelCount = 11
        leftAxis.granularityEnabled = true
        leftAxis.labelFont = UIFont.PoppinsMedium(fontSize: 12)
        leftAxis.labelTextColor = Color.DarkGray
        
        let rightAxis = cell.lineChartView.rightAxis
        rightAxis.axisMaximum = 10
        rightAxis.axisMinimum = 0
        rightAxis.granularity = 1.0
        rightAxis.granularityEnabled = true
        rightAxis.axisLineColor = UIColor.white
        
        let xAxis = cell.lineChartView.xAxis
        xAxis.axisMaximum = Double(totalX-1)
        xAxis.axisMinimum = 0
        //xAxis.granularity = 1.0
        xAxis.granularityEnabled = true
        xAxis.labelFont = UIFont.PoppinsMedium(fontSize: 12)
        xAxis.labelTextColor = Color.DarkGray
        
        let months = foodIntakeT.lables!.compactMap({ (entity) -> [String] in
            return ( foodIntakeT.lables!)
        })
        var arrayH = [String]()
        if months.count != 0{
            let hold = months[0]
            
            for dicth in hold{
                arrayH.append(Utility.convertServerDateToRequiredDate(dateStr: dicth, requiredDateformat: DateFormats.mm_dd_yyyy))
            }
        }
        xAxis.valueFormatter = IndexAxisValueFormatter(values:arrayH)
        xAxis.labelRotationAngle = 0
        xAxis.granularity = 1.0
        xAxis.labelCount = months.count
        cell.lineChartView.setVisibleXRangeMaximum(10)
        
        self.setDataCount(cell: cell, foodIntakeT: foodIntakeT)
        
        
    }
    func setDataCount(cell :CellTrendGraph ,foodIntakeT : FluidIntakeTotalTrendGraph) {
        let dataSets = (0..<foodIntakeT.data!.count).map { i -> LineChartDataSet in
            let values = (0..<foodIntakeT.data!.count).map
            { (i) -> ChartDataEntry in
                let val = foodIntakeT.data![i]
                return ChartDataEntry(x: Double(i), y: Double(val))
            }
            
            let set = LineChartDataSet(entries: values, label: "DataSet")
            set.lineWidth = 2.5
            set.circleRadius = 5
            set.circleHoleRadius = 0
            set.valueTextColor = UIColor.clear
            let color = UIColor.red
            
            set.setColor(color)
            set.setCircleColor(color)
            set.mode = .cubicBezier
            let gradientColors = [color.withAlphaComponent(0.5).cgColor,
                                  color.withAlphaComponent(0.5).cgColor]
            let gradient = CGGradient(colorsSpace: nil, colors: gradientColors as CFArray, locations: nil)!
            
            set.fillAlpha = 1
            set.fill = Fill(linearGradient: gradient, angle: 90) //.linearGradient(gradient, angle: 90)
            set.drawFilledEnabled = true
            return set
        }
        dataSet = dataSets
        let data = LineChartData(dataSets: dataSet)
        data.setValueFont(.systemFont(ofSize: 0, weight: .light))
        cell.lineChartView.notifyDataSetChanged()
        cell.lineChartView.data = data
        cell.lineChartView.setVisibleXRangeMaximum(6)
    }
    //MARK:- UrineTotalTrendGraph
    func setupGraphView(cell :CellTrendGraph , foodIntakeT : UrineTotalTrendGraph){
        //        if foodIntakeT.lables?.count  == 0 || foodIntakeT.data?.count == 0{
        //            return
        //        }
        let totalX  = foodIntakeT.lables?.count ?? 0
        cell.lineChartView.backgroundColor = .white
        cell.lineChartView.gridBackgroundColor = .white
        cell.lineChartView.drawGridBackgroundEnabled = true
        cell.lineChartView.drawBordersEnabled = true
        cell.lineChartView.chartDescription?.enabled = false
        cell.lineChartView.pinchZoomEnabled = false
        cell.lineChartView.dragEnabled = true
        cell.lineChartView.setScaleEnabled(true)
        cell.lineChartView.legend.enabled = false
        cell.lineChartView.rightAxis.enabled = false
        cell.lineChartView.xAxis.labelPosition = .bottom
        let leftAxis = cell.lineChartView.leftAxis
        if foodIntakeT.data?.count == 0 {
            leftAxis.axisMaximum = 100
        }else{
            leftAxis.axisMaximum = Double(foodIntakeT.data!.reduce(Int.min, { max($0, $1) })) + 10
        }
        leftAxis.axisMinimum = 0
        leftAxis.granularity = 5.0
        leftAxis.labelCount = 11
        leftAxis.granularityEnabled = true
        leftAxis.labelFont = UIFont.PoppinsMedium(fontSize: 12)
        leftAxis.labelTextColor = Color.DarkGray
        
        let rightAxis = cell.lineChartView.rightAxis
        rightAxis.axisMaximum = 10
        rightAxis.axisMinimum = 0
        rightAxis.granularity = 1.0
        rightAxis.granularityEnabled = true
        rightAxis.axisLineColor = UIColor.white
        
        let xAxis = cell.lineChartView.xAxis
        xAxis.axisMaximum = Double(totalX-1)
        xAxis.axisMinimum = 0
        //xAxis.granularity = 1.0
        xAxis.granularityEnabled = true
        xAxis.labelFont = UIFont.PoppinsMedium(fontSize: 12)
        xAxis.labelTextColor = Color.DarkGray
        
        let months = foodIntakeT.lables!.compactMap({ (entity) -> [String] in
            return ( foodIntakeT.lables!)
        })
        
        var arrayH = [String]()
        if months.count != 0{
            let hold = months[0]
            
            for dicth in hold{
                arrayH.append(Utility.convertServerDateToRequiredDate(dateStr: dicth, requiredDateformat: DateFormats.mm_dd_yyyy))
            }
        }
        xAxis.valueFormatter = IndexAxisValueFormatter(values:arrayH)
        xAxis.labelRotationAngle = 0
        xAxis.granularity = 1.0
        xAxis.labelCount = months.count
        cell.lineChartView.setVisibleXRangeMaximum(10)
        
        self.setDataCount(cell: cell, foodIntakeT: foodIntakeT)
        
        
    }
    func setDataCount(cell :CellTrendGraph ,foodIntakeT : UrineTotalTrendGraph) {
        let dataSets = (0..<foodIntakeT.data!.count).map { i -> LineChartDataSet in
            let values = (0..<foodIntakeT.data!.count).map
            { (i) -> ChartDataEntry in
                let val = foodIntakeT.data![i]
                return ChartDataEntry(x: Double(i), y: Double(val))
            }
            
            let set = LineChartDataSet(entries: values, label: "DataSet")
            set.lineWidth = 2.5
            set.circleRadius = 5
            set.circleHoleRadius = 0
            set.valueTextColor = UIColor.clear
            let color = UIColor.red
            
            set.setColor(color)
            set.setCircleColor(color)
            set.mode = .cubicBezier
            let gradientColors = [color.withAlphaComponent(0.5).cgColor,
                                  color.withAlphaComponent(0.5).cgColor]
            let gradient = CGGradient(colorsSpace: nil, colors: gradientColors as CFArray, locations: nil)!
            
            set.fillAlpha = 1
            set.fill = Fill(linearGradient: gradient, angle: 90) //.linearGradient(gradient, angle: 90)
            set.drawFilledEnabled = true
            return set
        }
        dataSet = dataSets
        let data = LineChartData(dataSets: dataSet)
        data.setValueFont(.systemFont(ofSize: 0, weight: .light))
        cell.lineChartView.notifyDataSetChanged()
        cell.lineChartView.data =  data
        cell.lineChartView.setVisibleXRangeMaximum(6)
    }
    //MARK:- EmesisTotalTrendGraph
    func setupGraphView(cell :CellTrendGraph , foodIntakeT : EmesisTotalTrendGraph){
        //        if foodIntakeT.lables?.count  == 0 || foodIntakeT.data?.count == 0{
        //            return
        //        }
        let totalX  = foodIntakeT.lables?.count ?? 0
        cell.lineChartView.backgroundColor = .white
        cell.lineChartView.gridBackgroundColor = .white
        cell.lineChartView.drawGridBackgroundEnabled = true
        cell.lineChartView.drawBordersEnabled = true
        cell.lineChartView.chartDescription?.enabled = false
        cell.lineChartView.pinchZoomEnabled = false
        cell.lineChartView.dragEnabled = true
        cell.lineChartView.setScaleEnabled(true)
        cell.lineChartView.legend.enabled = false
        cell.lineChartView.rightAxis.enabled = false
        cell.lineChartView.xAxis.labelPosition = .bottom
        let leftAxis = cell.lineChartView.leftAxis
        if foodIntakeT.data?.count == 0 {
            leftAxis.axisMaximum = 100
        }else{
            leftAxis.axisMaximum = Double(foodIntakeT.data!.reduce(Int.min, { max($0, $1) })) + 10
        }
        leftAxis.axisMinimum = 0
        leftAxis.granularity = 5.0
        leftAxis.labelCount = 11
        leftAxis.granularityEnabled = true
        leftAxis.labelFont = UIFont.PoppinsMedium(fontSize: 12)
        leftAxis.labelTextColor = Color.DarkGray
        
        let rightAxis = cell.lineChartView.rightAxis
        rightAxis.axisMaximum = 10
        rightAxis.axisMinimum = 0
        rightAxis.granularity = 1.0
        rightAxis.granularityEnabled = true
        rightAxis.axisLineColor = UIColor.white
        
        let xAxis = cell.lineChartView.xAxis
        xAxis.axisMaximum = Double(totalX-1)
        xAxis.axisMinimum = 0
        //xAxis.granularity = 1.0
        xAxis.granularityEnabled = true
        xAxis.labelFont = UIFont.PoppinsMedium(fontSize: 12)
        xAxis.labelTextColor = Color.DarkGray
        
        let months = foodIntakeT.lables!.compactMap({ (entity) -> [String] in
            return ( foodIntakeT.lables!)
        })
        
        var arrayH = [String]()
        if months.count != 0{
            let hold = months[0]
            
            for dicth in hold{
                arrayH.append(Utility.convertServerDateToRequiredDate(dateStr: dicth, requiredDateformat: DateFormats.mm_dd_yyyy))
            }
        }
        xAxis.valueFormatter = IndexAxisValueFormatter(values:arrayH)
        xAxis.labelRotationAngle = 0
        xAxis.granularity = 1.0
        xAxis.labelCount = months.count
        cell.lineChartView.setVisibleXRangeMaximum(10)
        
        self.setDataCount(cell: cell, foodIntakeT: foodIntakeT)
        
        
    }
    func setDataCount(cell :CellTrendGraph ,foodIntakeT : EmesisTotalTrendGraph) {
        let dataSets = (0..<foodIntakeT.data!.count).map { i -> LineChartDataSet in
            let values = (0..<foodIntakeT.data!.count).map
            { (i) -> ChartDataEntry in
                let val = foodIntakeT.data![i]
                return ChartDataEntry(x: Double(i), y: Double(val))
            }
            
            let set = LineChartDataSet(entries: values, label: "DataSet")
            set.lineWidth = 2.5
            set.circleRadius = 5
            set.circleHoleRadius = 0
            set.valueTextColor = UIColor.clear
            let color = UIColor.red
            
            set.setColor(color)
            set.setCircleColor(color)
            set.mode = .cubicBezier
            let gradientColors = [color.withAlphaComponent(0.5).cgColor,
                                  color.withAlphaComponent(0.5).cgColor]
            let gradient = CGGradient(colorsSpace: nil, colors: gradientColors as CFArray, locations: nil)!
            
            set.fillAlpha = 1
            set.fill = Fill(linearGradient: gradient, angle: 90) //.linearGradient(gradient, angle: 90)
            set.drawFilledEnabled = true
            return set
        }
        dataSet = dataSets
        let data = LineChartData(dataSets: dataSet)
        data.setValueFont(.systemFont(ofSize: 0, weight: .light))
        cell.lineChartView.notifyDataSetChanged()
        cell.lineChartView.data =  data
        cell.lineChartView.setVisibleXRangeMaximum(6)
    }
    //MARK:- BloodLossTotalTrendGraph
    func setupGraphView(cell :CellTrendGraph , foodIntakeT : BloodLossTotalTrendGraph){
        //        if foodIntakeT.lables?.count  == 0 || foodIntakeT.data?.count == 0{
        //            return
        //        }
        let totalX  = foodIntakeT.lables?.count ?? 0
        cell.lineChartView.backgroundColor = .white
        cell.lineChartView.gridBackgroundColor = .white
        cell.lineChartView.drawGridBackgroundEnabled = true
        cell.lineChartView.drawBordersEnabled = true
        cell.lineChartView.chartDescription?.enabled = false
        cell.lineChartView.pinchZoomEnabled = false
        cell.lineChartView.dragEnabled = true
        cell.lineChartView.setScaleEnabled(true)
        cell.lineChartView.legend.enabled = false
        cell.lineChartView.rightAxis.enabled = false
        cell.lineChartView.xAxis.labelPosition = .bottom
        let leftAxis = cell.lineChartView.leftAxis
        if foodIntakeT.data?.count == 0 {
            leftAxis.axisMaximum = 100
        }else{
            leftAxis.axisMaximum = Double(foodIntakeT.data!.reduce(Int.min, { max($0, $1) })) + 10
        }
        leftAxis.axisMinimum = 0
        leftAxis.granularity = 5.0
        leftAxis.labelCount = 11
        leftAxis.granularityEnabled = true
        leftAxis.labelFont = UIFont.PoppinsMedium(fontSize: 12)
        leftAxis.labelTextColor = Color.DarkGray
        
        let rightAxis = cell.lineChartView.rightAxis
        rightAxis.axisMaximum = 10
        rightAxis.axisMinimum = 0
        rightAxis.granularity = 1.0
        rightAxis.granularityEnabled = true
        rightAxis.axisLineColor = UIColor.white
        
        let xAxis = cell.lineChartView.xAxis
        xAxis.axisMaximum = Double(totalX-1)
        xAxis.axisMinimum = 0
        //xAxis.granularity = 1.0
        xAxis.granularityEnabled = true
        xAxis.labelFont = UIFont.PoppinsMedium(fontSize: 12)
        xAxis.labelTextColor = Color.DarkGray
        
        let months = foodIntakeT.lables!.compactMap({ (entity) -> [String] in
            return ( foodIntakeT.lables!)
        })
        
        var arrayH = [String]()
        if months.count != 0{
            let hold = months[0]
            
            for dicth in hold{
                arrayH.append(Utility.convertServerDateToRequiredDate(dateStr: dicth, requiredDateformat: DateFormats.mm_dd_yyyy))
            }
        }
        xAxis.valueFormatter = IndexAxisValueFormatter(values:arrayH)
        xAxis.labelRotationAngle = 0
        xAxis.granularity = 1.0
        xAxis.labelCount = months.count
        cell.lineChartView.setVisibleXRangeMaximum(10)
        
        self.setDataCount(cell: cell, foodIntakeT: foodIntakeT)
        
        
    }
    func setDataCount(cell :CellTrendGraph ,foodIntakeT : BloodLossTotalTrendGraph) {
        let dataSets = (0..<foodIntakeT.data!.count).map { i -> LineChartDataSet in
            let values = (0..<foodIntakeT.data!.count).map
            { (i) -> ChartDataEntry in
                let val = foodIntakeT.data![i]
                return ChartDataEntry(x: Double(i), y: Double(val))
            }
            
            let set = LineChartDataSet(entries: values, label: "DataSet")
            set.lineWidth = 2.5
            set.circleRadius = 5
            set.circleHoleRadius = 0
            set.valueTextColor = UIColor.clear
            let color = UIColor.red
            
            set.setColor(color)
            set.setCircleColor(color)
            set.mode = .cubicBezier
            let gradientColors = [color.withAlphaComponent(0.5).cgColor,
                                  color.withAlphaComponent(0.5).cgColor]
            let gradient = CGGradient(colorsSpace: nil, colors: gradientColors as CFArray, locations: nil)!
            
            set.fillAlpha = 1
            set.fill = Fill(linearGradient: gradient, angle: 90) //.linearGradient(gradient, angle: 90)
            set.drawFilledEnabled = true
            return set
        }
        dataSet = dataSets
        let data = LineChartData(dataSets: dataSet)
        data.setValueFont(.systemFont(ofSize: 0, weight: .light))
        cell.lineChartView.notifyDataSetChanged()
        cell.lineChartView.data = data
        cell.lineChartView.setVisibleXRangeMaximum(6)
    }
    //MARK:- BloodLossTotalTrendGraph
    func setupGraphView(cell :CellTrendGraph , foodIntakeT : BowelCountTotalTrendGraph){
        //        if foodIntakeT.lables?.count  == 0 || foodIntakeT.data?.count == 0{
        //            return
        //        }
        let totalX  = foodIntakeT.lables?.count ?? 0
        cell.lineChartView.backgroundColor = .white
        cell.lineChartView.gridBackgroundColor = .white
        cell.lineChartView.drawGridBackgroundEnabled = true
        cell.lineChartView.drawBordersEnabled = true
        cell.lineChartView.chartDescription?.enabled = false
        cell.lineChartView.pinchZoomEnabled = false
        cell.lineChartView.dragEnabled = true
        cell.lineChartView.setScaleEnabled(true)
        cell.lineChartView.legend.enabled = false
        cell.lineChartView.rightAxis.enabled = false
        cell.lineChartView.xAxis.labelPosition = .bottom
        let leftAxis = cell.lineChartView.leftAxis
        if foodIntakeT.data?.count == 0{
            leftAxis.axisMaximum = 1
        }else{
            leftAxis.axisMaximum = Double(foodIntakeT.data!.reduce(Int.min, { max($0, $1) })) + 1
        }
        leftAxis.axisMinimum = 0
        leftAxis.granularity = 1.0
        leftAxis.labelCount = 11
        leftAxis.granularityEnabled = true
        leftAxis.labelFont = UIFont.PoppinsMedium(fontSize: 12)
        leftAxis.labelTextColor = Color.DarkGray
        
        let rightAxis = cell.lineChartView.rightAxis
        rightAxis.axisMaximum = 10
        rightAxis.axisMinimum = 0
        rightAxis.granularity = 1.0
        rightAxis.granularityEnabled = true
        rightAxis.axisLineColor = UIColor.white
        
        let xAxis = cell.lineChartView.xAxis
        xAxis.axisMaximum = Double(totalX-1)
        xAxis.axisMinimum = 0
        //xAxis.granularity = 1.0
        xAxis.granularityEnabled = true
        xAxis.labelFont = UIFont.PoppinsMedium(fontSize: 12)
        xAxis.labelTextColor = Color.DarkGray
        
        let months = foodIntakeT.lables!.compactMap({ (entity) -> [String] in
            return ( foodIntakeT.lables!)
        })
        
        var arrayH = [String]()
        if months.count != 0{
            let hold = months[0]
            
            for dicth in hold{
                arrayH.append(Utility.convertServerDateToRequiredDate(dateStr: dicth, requiredDateformat: DateFormats.mm_dd_yyyy))
            }
        }
        xAxis.valueFormatter = IndexAxisValueFormatter(values:arrayH)
        xAxis.labelRotationAngle = 0
        xAxis.granularity = 1.0
        xAxis.labelCount = months.count
        cell.lineChartView.setVisibleXRangeMaximum(10)
        
        self.setDataCount(cell: cell, foodIntakeT: foodIntakeT)
        
        
    }
    func setDataCount(cell :CellTrendGraph ,foodIntakeT : BowelCountTotalTrendGraph) {
        let dataSets = (0..<foodIntakeT.data!.count).map { i -> LineChartDataSet in
            let values = (0..<foodIntakeT.data!.count).map
            { (i) -> ChartDataEntry in
                let val = foodIntakeT.data![i]
                return ChartDataEntry(x: Double(i), y: Double(val))
            }
            
            let set = LineChartDataSet(entries: values, label: "DataSet")
            set.lineWidth = 2.5
            set.circleRadius = 5
            set.circleHoleRadius = 0
            set.valueTextColor = UIColor.clear
            let color = UIColor.red
            
            set.setColor(color)
            set.setCircleColor(color)
            set.mode = .cubicBezier
            let gradientColors = [color.withAlphaComponent(0.5).cgColor,
                                  color.withAlphaComponent(0.5).cgColor]
            let gradient = CGGradient(colorsSpace: nil, colors: gradientColors as CFArray, locations: nil)!
            
            set.fillAlpha = 1
            set.fill = Fill(linearGradient: gradient, angle: 90) //.linearGradient(gradient, angle: 90)
            set.drawFilledEnabled = true
            return set
        }
        dataSet = dataSets
        let data = LineChartData(dataSets: dataSet)
        data.setValueFont(.systemFont(ofSize: 0, weight: .light))
        cell.lineChartView.notifyDataSetChanged()
        cell.lineChartView.data = data
        cell.lineChartView.setVisibleXRangeMaximum(6)
    }
    
}
