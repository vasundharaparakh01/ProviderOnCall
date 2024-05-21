//
//  FoodDiaryViewController.swift

//
//  Created by Vasundhara Parakh on 3/3/20.
//  Copyright © 2020 smartData Enterprises (I) Ltd. All rights reserved.
//

import UIKit
import FSCalendar
class FoodDiaryViewController : BaseViewController {
    @IBOutlet weak var calendarView: FSCalendar!

    @IBOutlet weak var residentCardView: ResidentCardView!
    @IBOutlet weak var tblView: UITableView!
    var patientHeaderInfo : PatientBasicHeaderInfo?
    let sectionTitle  : [String] = ["Breakfast","Lunch","Diner"]
    let sectionImage : [UIImage] = [UIImage.breakfastImage(),UIImage.lunchImage(),UIImage.dinnerImage()]

    
    var selectedSection = -1
    var selectedCalendarDate : Date?
    
    lazy var viewModel: FoodDiaryViewModel = {
        let obj = FoodDiaryViewModel(with: ResidentService())
        self.baseViewModel = obj
        return obj
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.selectedCalendarDate = Date()

        // Do any additional setup after loading the view.
        self.navigationItem.title = NavigationTitle.FoodDiary
        self.addBackButton()
        self.addrightBarButtonItem()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.initialSetup()
    }
    func initialSetup(){
        self.setupClosures()
        self.setCalendarView()
        
        self.tblView.register(UINib(nibName: ReuseIdentifier.ListTableViewCell, bundle: nil), forCellReuseIdentifier: ReuseIdentifier.ListTableViewCell)

        //Update Resident Card View
        if let cardView = self.residentCardView{
            if let basicInfo = self.patientHeaderInfo{
                self.updateResidentCardView(cardView: cardView, residentInfo: basicInfo)
            }
        }
        self.viewModel.getPatientFoodDiary(patientID: self.patientHeaderInfo?.patientID ?? 0, date: self.selectedCalendarDate!)
        
        
    }
    func addrightBarButtonItem() {
        let addMealBtn : UIButton = UIButton.init(type: .custom)
        addMealBtn.setImage(UIImage.addMeal(), for: .normal)
        addMealBtn.addTarget(self, action: #selector(onRightBarButtonItemClicked(_ :)), for: .touchUpInside)
        addMealBtn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        let addMealButton = UIBarButtonItem(customView: addMealBtn)
        navigationItem.rightBarButtonItems = [addMealButton]
    }
    
    // MARK:
    @objc func onRightBarButtonItemClicked(_ sender: UIBarButtonItem) {
        if let vc = AddMealViewController.instantiate(appStoryboard: Storyboard.Forms) as? AddMealViewController{
            vc.patientId = self.patientHeaderInfo?.patientID ?? 0
            self.navigationController?.pushViewController(vc,animated:true)
        }
    }

    func setupClosures() {
        self.viewModel.reloadListViewClosure = { [weak self] () in
            DispatchQueue.main.async {
                self?.tblView.reloadData()
            }
        }
    }

    func setCalendarView(){
           if self.calendarView.scope == FSCalendarScope.month {
               self.calendarView.scope = FSCalendarScope.week
               
               self.calendarView.backgroundColor = UIColor.white
               self.calendarView.appearance.headerTitleFont = UIFont.PoppinsRegular(fontSize: 20.0)
               self.calendarView.appearance.weekdayFont = UIFont.PoppinsRegular(fontSize: 14.0)
               self.calendarView.appearance.caseOptions = FSCalendarCaseOptions.weekdayUsesUpperCase
               //self.calendarView.select(self.calendarView.today)
               self.calendarView.setCurrentPage(self.calendarView.today ?? Date(), animated: false)
               
               self.calendarView.dataSource = self
               self.calendarView.delegate = self
               
               self.calendarView.select(Date())
           }
       }

}

extension FoodDiaryViewController:UITableViewDataSource, UITableViewDelegate {
   
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var list = [FoodDiary]()
        switch section {
        case 0:
            list = self.viewModel.breakfastList
        case 1:
            list = self.viewModel.lunchList
        case 2:
            list = self.viewModel.dinnerList
        default:
            print("Do nothing")
        }
        return section == self.selectedSection ? list.count : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ReuseIdentifier.FoodDiaryCell, for: indexPath as IndexPath) as! FoodDiaryCell
        var foodItem : FoodDiary?
        switch indexPath.section {
        case 0:
            foodItem = self.viewModel.breakfastList[indexPath.row]
        case 1:
            foodItem = self.viewModel.lunchList[indexPath.row]
        case 2:
            foodItem = self.viewModel.dinnerList[indexPath.row]
        default:
            print("Do nothing")
        }

        cell.food = foodItem
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 50))
        headerView.backgroundColor = UIColor.white
        
        let imgSection = UIImageView(frame: CGRect(x: 10, y: 15, width: 40, height: 40))
        imgSection.image = self.sectionImage[section]
        headerView.addSubview(imgSection)
        
        let lblSection = UILabel(frame: CGRect(x: 60, y: 10, width: 200, height: 50))
        lblSection.textColor = Color.Blue
        lblSection.text = self.sectionTitle[section]
        lblSection.font = UIFont.PoppinsMedium(fontSize: 18)
        headerView.addSubview(lblSection)
        
        
        let dropDownImage = UIImageView(frame: CGRect(x: tableView.frame.size.width - 25, y: 26, width: 15 , height: 8))
        dropDownImage.image = section == self.selectedSection ? UIImage.upArrow() : UIImage.downArrow()
        headerView.addSubview(dropDownImage)

        
        let btnCollapse = UIButton(type: .custom)
        btnCollapse.frame = CGRect(x: 0, y: 0, width: tableView.frame.size.width  , height: 50)
        btnCollapse.tag = section
        btnCollapse.backgroundColor = .clear
        btnCollapse.addTarget(self, action: #selector(self.btnCollapse_Action(_:)), for: .touchUpInside)
        headerView.addSubview(btnCollapse)

        return headerView   
    }
    
    @IBAction func btnCollapse_Action(_ sender: Any) {
        let senderTag = (sender as! UIButton).tag
        self.selectedSection = self.selectedSection == senderTag ? -1 : senderTag
        self.tblView.reloadData()
    }
}

class FoodDiaryCell : UITableViewCell{
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var lblMeal: UILabel!
    @IBOutlet weak var lblServingSize: UILabel!
    @IBOutlet weak var lblPortion: UILabel!
    @IBOutlet weak var lblTexture: UILabel!
    @IBOutlet weak var lblFluidConsistency: UILabel!
    @IBOutlet weak var lblDiningRoom: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblFoodAlergy: UILabel!
    @IBOutlet weak var lblNote: UILabel!

    var food : FoodDiary?{
        didSet{
            setUpData()
        }
    }
        
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setUpData(){
        if let diaryDetail = food?.patientFoodDiaryDetails?.first{
            self.lblMeal.text = (diaryDetail.mealItemName ?? ConstantStrings.NA).trimmingCharacters(in: .whitespacesAndNewlines)
            self.lblServingSize.text = (diaryDetail.servingSize ?? ConstantStrings.NA).trimmingCharacters(in: .whitespacesAndNewlines)
            if (diaryDetail.servingSize ?? ConstantStrings.NA).trimmingCharacters(in: .whitespacesAndNewlines).count == 0 {
                self.lblServingSize.text = ConstantStrings.NA
            }
            self.lblPortion.text = (diaryDetail.servingSizePortion ?? ConstantStrings.NA).trimmingCharacters(in: .whitespacesAndNewlines)
            if (diaryDetail.servingSizePortion ?? ConstantStrings.NA).trimmingCharacters(in: .whitespacesAndNewlines).count == 0 {
                self.lblPortion.text = ConstantStrings.NA
            }
            self.lblTexture.text = (diaryDetail.typeOfFoodName ?? ConstantStrings.NA).trimmingCharacters(in: .whitespacesAndNewlines)
            self.lblFluidConsistency.text = (diaryDetail.fluidConsistencyName ?? ConstantStrings.NA).trimmingCharacters(in: .whitespacesAndNewlines)
        }
        self.lblDiningRoom.text = (food?.servingHall ?? ConstantStrings.NA).trimmingCharacters(in: .whitespacesAndNewlines)
        self.lblFoodAlergy.text = (food?.foodAllergy ?? ConstantStrings.NA).trimmingCharacters(in: .whitespacesAndNewlines)
        self.lblNote.text = (food?.notes ?? ConstantStrings.NA).trimmingCharacters(in: .whitespacesAndNewlines)
        
        self.lblDate.text = Utility.convertServerDateToRequiredDate(dateStr: food?.mealTime ?? "", requiredDateformat: DateFormats.hh_mm_a)

    }

}

//MARK: FSCalendarDataSource,FSCalendarDelegate
extension FoodDiaryViewController : FSCalendarDataSource,FSCalendarDelegate{
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        return 0
    }
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventDefaultColorsFor date: Date) -> [UIColor]? {
        
        return [Color.Blue]
    }
    
    //Commented to display past appointments - 04/11/2019
    //Developer - Vasundhara parakh
    /*func minimumDate(for calendar: FSCalendar) -> Date {
        return Date()
    }*/
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        self.selectedSection = -1
        self.selectedCalendarDate = date
        self.viewModel.getPatientFoodDiary(patientID: self.patientHeaderInfo?.patientID ?? 0, date: date)
    }
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        return true
    }
    
}
