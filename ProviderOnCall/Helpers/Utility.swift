//
//  Utility.swift
//  AccessEMR
//
//  Created by Vasundhara Parakh on 2/25/20.
//  Copyright © 2020 smartData Enterprises (I) Ltd. All rights reserved.
//

import Foundation
import UIKit
import SystemConfiguration
import MobileCoreServices
import AVFoundation
import AVKit
import LocalAuthentication
import Charts
public protocol NibLoadable {
    static var nibName: String { get }
}

public extension NibLoadable where Self: UIView {
    
    public static var nibName: String {
        return String(describing: Self.self) // defaults to the name of the class implementing this protocol.
    }
    
    public static var nib: UINib {
        let bundle = Bundle(for: Self.self)
        return UINib(nibName: Self.nibName, bundle: bundle)
    }
    
    func setupFromNib() {
        guard let view = Self.nib.instantiate(withOwner: self, options: nil).first as? UIView else { fatalError("Error loading \(self) from nib") }
        addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 0).isActive = true
        view.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        view.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: 0).isActive = true
        view.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
    }
}
struct Platform {
    
    static var isSimulator: Bool {
        return TARGET_OS_SIMULATOR != 0
    }
    
}
class Utility {
    
    var isIphoneXOrBigger: Bool {
        // 812.0 on iPhone X, XS.
        // 896.0 on iPhone XS Max, XR.
        return UIScreen.main.bounds.height >= 812
    }

    class var canUseFaceID: Bool {
        
        if #available(iOS 11.0, *) {
            let context = LAContext()
            return (context.canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, error: nil) && context.biometryType == LABiometryType.faceID)
        }
        return false

    }
    
    // MARK: - Get Image With Color
    class func imageWithColor(_ color: UIColor, size:CGSize) -> UIImage? {
        let rect = CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height)
        UIGraphicsBeginImageContext(rect.size)
        if let context = UIGraphicsGetCurrentContext(){
            context.setFillColor(color.cgColor)
            context.fill(rect)
            
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            return image!
        }
        return nil
    }
        
    // MARK: - Network Check Method
    class func isNetworkAvailable() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
    
    
    
    class func getTrimmedStringWithoutExtraSpacesAndNewLineCharacter(_ rawString : String) -> String {
        return rawString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    //MARK:- Application fonts
    /// Returns List of Application supported fonts
    class func getListOfApplicationFonts(){
        for name in UIFont.familyNames {
            //debugPrint("Name === \(name)")
            //debugPrint("Family === \(UIFont.fontNames(forFamilyName: name))")
        }
    }
    
    //MARK:- Alert View
    class func showAlertWithMessage(titleStr : String? , messageStr : String? , controller : UIViewController){
        let alert = UIAlertController(title: titleStr ?? Alert.Title.appName, message: messageStr, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Alert.ButtonTitle.ok, style: .default, handler: nil))
        controller.present(alert, animated: true, completion: nil)
    }
    
    
    /**
     This method converts a string to Base64
     
     - parameter stringToConvert: A string which needs to be converted in Base64
     
     - returns: returns A base64Encided String
     */
    class func toBase64(stringToConvert:String) -> String
    {
        let data = stringToConvert.data(using: String.Encoding.utf8)
        return data!.base64EncodedString(options: [])
//        return data!.base64EncodedStringWithOptions(NSData.Base64EncodingOptions(rawValue: 0))
    }
    
    
    //MARK: getHrsFromMinutes
    class func getHrsFromMinutes(minutes : Int) -> String{
        var time = ""
        let hr = minutes/60
        let minutes = minutes % 60
        var formatHr = "hr"
        if hr > 1{
            formatHr = "hrs"
        }
        var formatMin = "min"
        if minutes > 1{
            formatMin = "mins"
        }

        //debugPrint("Session Time Duraction ==== \("\(hr) \(formatHr) \(minutes) \(formatMin)")")
        time = "\(hr) \(formatHr) \(minutes) \(formatMin)"
        if minutes == 0 {
            //debugPrint("Session Time Duraction ==== \("\(hr) \(formatHr)")")
            time = "\(hr) \(formatHr)"
        }
        if hr == 0 {
            time = "\(minutes) \(formatMin)"
        }
        return time
    }
    
    //MARK: getHrsFromMinutes
    class func getHrsFromSeconds(seconds : Int) -> String{
        var time = ""
        let hr = seconds/60/60
        let minutes = seconds / 60
        let seconds = seconds % 60
        var formatHr = "hr"
        if hr > 1{
            formatHr = "hrs"
        }
        var formatMin = "min"
        if minutes > 1{
            formatMin = "mins"
        }
        
        var formatSeconds = "sec"
        if seconds > 1 {
            formatSeconds = "secs"
        }
        //debugPrint("Session Time Duraction ==== \("\(hr) \(formatHr) \(minutes) \(formatMin)")")
        //time = "\(hr) \(formatHr) \(minutes) \(formatMin) \(seconds) \(formatSeconds)"
        
        if hr != 0 {
            time.append("\(hr) \(formatHr) ")
        }
        
        if minutes != 0 {
            //debugPrint("Session Time Duraction ==== \("\(hr) \(formatHr)")")
            time.append("\(minutes) \(formatMin) ")
        }
        
        if seconds != 0 {
            time.append("\(seconds) \(formatSeconds)")
        }

        if time.count == 0 {
            return "0"
        }
        return time
    }

    
    //MARK: getHrsFromMinutes
    class func getTimeStringFromSeconds(seconds : Int64) -> String{
        let hr = seconds / 3600
        let minutes = seconds / 60 % 60
        let seconds = seconds % 60
        var time = ""

        var formatHr = "hr"
        if hr > 1{
            formatHr = "hrs"
        }
        var formatMin = "min"
        if minutes > 1{
            formatMin = "mins"
        }
        
        var formatSec = "sec"
        if seconds > 1{
            formatSec = "secs"
        }
        
        //debugPrint("Session Time Duraction ==== \("\(hr)\(formatHr) \(minutes)\(formatMin)")")
        if hr > 0{
            time.append("\(hr) \(formatHr)")
        }
        
        time.append(" \(minutes) \(formatMin)")
        
        if seconds > 0{
            time.append(" \(seconds) \(formatSec)")
        }
        
        
        return time
    }

    //MARK:- TimeStamp Time ago Date Format
    class func setTimeAgoStringFromTimeStamp(_ timeStamp: Double , dateFormat : String) -> String? {
        let date = Date(timeIntervalSince1970: timeStamp/1000)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        return dateFormatter.string(from: date)
    }
    
    
    class func addPercentEncoding(urlString:String) -> String?
    {
      var decodedStr = urlString.trimmingCharacters(in: .whitespacesAndNewlines).removingPercentEncoding
        
      decodedStr = decodedStr?.trimmingCharacters(in: .whitespacesAndNewlines).addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)//urlPathAllowed
        return decodedStr
    }
    


    //MARK:- Convert Date From Timsetamp
    class func getDateFromTimeStamp(timeStamp : Double, dateFormat : String) -> String {
        let date = NSDate(timeIntervalSince1970: timeStamp)
        let dayTimePeriodFormatter = DateFormatter()
        dayTimePeriodFormatter.dateFormat = dateFormat
        let dateString = dayTimePeriodFormatter.string(from: date as Date)
        return dateString
    }
    
    //MARK:- Convert Server Date
    class func convertServerDateToRequiredDate(dateStr: String,requiredDateformat : String) -> String{
        var dateString = dateStr
        let containsDot = dateStr.contains(".")
        if containsDot{
            dateString = dateStr.components(separatedBy: ".").first ?? ""
        }
        let str = dateString.replacingOccurrences(of: "T", with: " ")
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DateFormats.server_format
        let date : Date = dateFormatter.date(from: str) ?? Date()
        
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = requiredDateformat
        return (dateFormatter1.string(from: date))
    }
    
    class func convertDateStringToServerFormatString(dateStr: String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DateFormats.dd_mm_yyyy
        let date : Date = dateFormatter.date(from: dateStr) ?? Date()
        
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = DateFormats.server_format
        return (dateFormatter1.string(from: date))
    }
    
    class func getDateFromstring(dateStr : String,dateFormat : String ) -> Date{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        dateFormatter.timeZone = TimeZone.current
        guard let date = dateFormatter.date(from: dateStr) else { return Date() }
        return date
    }
    
    class func getStringFromDate(date: Date,dateFormat : String)-> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        let str = dateFormatter.string(from: date)
        return str
    }
    
    class func getSeventhDateFromToday() -> Date{
        var seventh = Date()
        var calendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier(rawValue: NSGregorianCalendar))
        var dateComponent = NSDateComponents()
        
        for i in 1...7
        {
            dateComponent.day = i
            seventh = calendar?.date(byAdding: dateComponent as DateComponents, to: Date(), options: NSCalendar.Options.matchStrictly) ?? Date()
        }
        return seventh
    }
    
    //MARK: convertDateStringToOtherFormatString
    class func convertDateStringToOtherFormatString(dateString : String,inputFormat : String, outputFormat : String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = inputFormat
        let date : Date = dateFormatter.date(from: dateString) ?? Date()
        
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = outputFormat
        let newDateString = dateFormatter1.string(from: date)
        return newDateString
    }
    
    //MARK: getAgeFromDOB
    class func getAgeFromDOB(date: String) -> (Years : Int, Months : Int,Days :Int) {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = DateFormats.server_format
        let dateOfBirth = dateFormater.date(from: date)
        let calender = Calendar.current
        let dateComponent = calender.dateComponents([.year, .month, .day], from:
            dateOfBirth!, to: Date())
        return (dateComponent.year!, dateComponent.month!, dateComponent.day!)
    }
    
    //MARK: highlightPartialTextOfLabel
    class func highlightPartialTextOfLabel(mainString : String, highlightString : String, highlightColor : UIColor, highlightFont : UIFont) -> NSMutableAttributedString{
        let main_string = mainString
        let string_to_color = highlightString
        let range = (main_string as NSString).range(of: string_to_color)
        let attributedString = NSMutableAttributedString(string:main_string)
        attributedString.addAttribute(NSAttributedString.Key.font, value: highlightFont , range: range)
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: highlightColor , range: range)
        return attributedString
    }
    
    //MARK:- setTableFooterWithMessage
    class func setTableFooterWithMessage(tableView : UITableView,message : String){
        tableView.tableFooterView = UIView()
        tableView.tableFooterView?.frame(forAlignmentRect: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
        
        
        let emptyView  = UIView(frame: CGRect(x: 0, y: (tableView.bounds.size.height/2)-75, width: tableView.bounds.size.width, height: 150))
        
        let noResultView = Bundle.main.loadNibNamed("NoResultView", owner: nil, options: nil)?[0] as! NoResultView
        
        // noResultView.frame.origin = emptyView.frame.origin;
        noResultView.frame = CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 150)
        noResultView.backgroundColor = UIColor.clear
        
        
        noResultView.messageLabel.text = message
        emptyView.addSubview(noResultView)
        tableView.tableFooterView?.addSubview(emptyView)
    }
    
    //MARK: setEmptyTableFooter
    class func setEmptyTableFooter(tableView : UITableView){
        tableView.tableFooterView = UIView()
        tableView.tableFooterView?.frame(forAlignmentRect: CGRect(x: 0, y: 0, width: 0, height: 0))
    }
    
    
    
    
}

//MARK:- Double
extension Double {
    func roundTo(places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
//MARK:- CGFloat
extension CGFloat {
    func roundTo4places() -> CGFloat{
       return  (self * 1000).rounded(.toNearestOrEven) / 1000
    }
}

struct DateISO: Codable {
    var date: Date
}
//MARK:- Date
extension Date
{
    
    var isoString: String {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        guard let data = try? encoder.encode(DateISO(date: self)),
            let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as?  [String: String]
            else { return "" }
        return json.first?.value ?? ""
    }
    
    var month: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM"
        return dateFormatter.string(from: self)
    }
    func isBetween(startDate:Date, endDate:Date)->Bool
    {
        return (startDate.compare(self) == .orderedAscending) && (endDate.compare(self) == .orderedDescending)
    }
    
    func daysFromToday() -> Int {
        return abs(Calendar.current.dateComponents([.day], from: self, to: Date()).day!)
    }
    
    func daysInMonth(_ monthNumber: Int? = nil, _ year: Int? = nil) -> Int {
        var dateComponents = DateComponents()
        dateComponents.year = year ?? Calendar.current.component(.year,  from: self)
        dateComponents.month = monthNumber ?? Calendar.current.component(.month,  from: self)
        if
            let d = Calendar.current.date(from: dateComponents),
            let interval = Calendar.current.dateInterval(of: .month, for: d),
            let days = Calendar.current.dateComponents([.day], from: interval.start, to: interval.end).day
        { return days } else { return -1 }
    }
    
    func getDayOfWeek() -> Int{
        let formatter = DateFormatter()
        formatter.dateFormat = "e" // "eeee" -> Friday
        let weekDay = formatter.string(from: self)
        return Int(weekDay)!
    }
    
    func timeAgoSinceDate() -> String {
        
        // From Time
        let fromDate = self
        
        // To Time
        let toDate = Date()
        
        // Estimation
        // Year
        if let interval = Calendar.current.dateComponents([.year], from: fromDate, to: toDate).year, interval > 0  {
            
            return interval == 1 ? "\(interval)" + " " + "year ago" : "\(interval)" + " " + "years ago"
        }
        
        // Month
        if let interval = Calendar.current.dateComponents([.month], from: fromDate, to: toDate).month, interval > 0  {
            
            return interval == 1 ? "\(interval)" + " " + "month ago" : "\(interval)" + " " + "months ago"
        }
        
        // Day
        if let interval = Calendar.current.dateComponents([.day], from: fromDate, to: toDate).day, interval > 0  {
            
            return interval == 1 ? "\(interval)" + " " + "day ago" : "\(interval)" + " " + "days ago"
        }
        
        // Hours
        if let interval = Calendar.current.dateComponents([.hour], from: fromDate, to: toDate).hour, interval > 0 {
            
            return interval == 1 ? "\(interval)" + " " + "hr ago" : "\(interval)" + " " + "hrs ago"
        }
        
        // Minute
        if let interval = Calendar.current.dateComponents([.minute], from: fromDate, to: toDate).minute, interval > 0 {
            
            return interval == 1 ? "\(interval)" + " " + "min ago" : "\(interval)" + " " + "mins ago"
        }
        
        return "now"
    }
    
    func startOfMonth() -> Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: self)))!
    }
    
    func endOfMonth() -> Date {
        return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth())!
    }
    
    var startOfWeek: Date? {
        let gregorian = Calendar(identifier: .gregorian)
        guard let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) else { return nil }
        return gregorian.date(byAdding: .day, value: 0, to: sunday)
    }

    var endOfWeek: Date? {
        let gregorian = Calendar(identifier: .gregorian)
        guard let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) else { return nil }
        return gregorian.date(byAdding: .day, value: 6, to: sunday)
    }

    func isBetweeen(date date1: Date, andDate date2: Date) -> Bool {
        return date1.compare(self) == self.compare(date2)
    }

}

extension UIColor {
        static var random: UIColor {
        let r:CGFloat  = .random(in: 0...1)
        let g:CGFloat  = .random(in: 0...1)
        let b:CGFloat  = .random(in: 0...1)
        return UIColor(red: r, green: g, blue: b, alpha: 1)
    }
}
extension Dictionary {
    mutating func merge(dict: [Key: Value]){
        for (k, v) in dict {
            updateValue(v, forKey: k)
        }
    }
}

extension Utility {
    
    class func printJson(dict : [String : Any]){
        var error : NSError?
        let jsonData = try! JSONSerialization.data(withJSONObject: dict, options: JSONSerialization.WritingOptions.prettyPrinted)
        let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
        print("JSON of input dict == \(jsonString)")
    }
    
    class func getSelectedValue(arrDropdown : [Any], row : Int) -> (value :String, valueID : Any){
        if arrDropdown is [MasterVitalPosition], arrDropdown.count > row{
            return ((arrDropdown[row] as! MasterVitalPosition).position ?? "",(arrDropdown[row] as! MasterVitalPosition).id ?? 0)
        }else if arrDropdown is [MasterVitalBPMethod], arrDropdown.count > row{
            return ((arrDropdown[row] as! MasterVitalBPMethod).bpMethod ?? "",(arrDropdown[row] as! MasterVitalBPMethod).id ?? 0)
        }else if arrDropdown is [MasterVitalBodyTempUnit], arrDropdown.count > row{
            return ((arrDropdown[row] as! MasterVitalBodyTempUnit).bodyTempUnit ?? "",(arrDropdown[row] as! MasterVitalBodyTempUnit).id ?? 0)
        }else if arrDropdown is [MasterVitalTempMeasurmentSite], arrDropdown.count > row{
            return ((arrDropdown[row] as! MasterVitalTempMeasurmentSite).temperatureMeasurmentSite ?? "",(arrDropdown[row] as! MasterVitalTempMeasurmentSite).id ?? 0)
        }else if arrDropdown is [MasterVitalTempDevice], arrDropdown.count > row{
            return ((arrDropdown[row] as! MasterVitalTempDevice).temperatureDevice ?? "",(arrDropdown[row] as! MasterVitalTempDevice).id ?? 0)
        }else if arrDropdown is [MasterVitalHeightUnit], arrDropdown.count > row{
            return ((arrDropdown[row] as! MasterVitalHeightUnit).heightUnit ?? "",(arrDropdown[row] as! MasterVitalHeightUnit).id ?? 0)
        }else if arrDropdown is [MasterVitalWeightUnit], arrDropdown.count > row{
            return ((arrDropdown[row] as! MasterVitalWeightUnit).weightUnit ?? "",(arrDropdown[row] as! MasterVitalWeightUnit).id ?? 0)
        }else if arrDropdown is [MasterVitalRbsUnit], arrDropdown.count > row{
            return ((arrDropdown[row] as! MasterVitalRbsUnit).rbsUnit ?? "", (arrDropdown[row] as! MasterVitalRbsUnit).id ?? 0)
        }else if arrDropdown is [MasterVitalFbsUnit], arrDropdown.count > row{
            return ((arrDropdown[row] as! MasterVitalFbsUnit).fbsUnit ?? "", (arrDropdown[row] as! MasterVitalFbsUnit).id ?? 0)
        }else if arrDropdown is [PointOfCareMasterDropdown], arrDropdown.count > row{
            return ((arrDropdown[row] as! PointOfCareMasterDropdown).value ?? "", (arrDropdown[row] as! PointOfCareMasterDropdown).id ?? 0)
        }else if arrDropdown is [CarePlanMaster], arrDropdown.count > row{
            return ((arrDropdown[row] as! CarePlanMaster).dropDownValue ?? "", (arrDropdown[row] as! CarePlanMaster).id ?? 0)
        }else if arrDropdown is [LocationMaster], arrDropdown.count > row{
            return ((arrDropdown[row] as! LocationMaster).locationName ?? "", (arrDropdown[row] as! LocationMaster).locationID ?? 0)
        }else if arrDropdown is [Shift], arrDropdown.count > row{
            return ((arrDropdown[row] as! Shift).shiftName ?? "", (arrDropdown[row] as! Shift).id ?? 0)
        }else if arrDropdown is [AllAssessmentMasters], arrDropdown.count > row{
            return ((arrDropdown[row] as! AllAssessmentMasters).value ?? "", (arrDropdown[row] as! AllAssessmentMasters).id ?? 0)
        }else if arrDropdown is [MasterTaskType], arrDropdown.count > row{
            return ((arrDropdown[row] as! MasterTaskType).taskType ?? "", (arrDropdown[row] as! MasterTaskType).id ?? 0)
        }else if arrDropdown is [MasterLocation], arrDropdown.count > row{
            return ((arrDropdown[row] as! MasterLocation).locationName ?? "", (arrDropdown[row] as! MasterLocation).id ?? 0)
        }else if arrDropdown is [MasterTaskPriority], arrDropdown.count > row{
            return ((arrDropdown[row] as! MasterTaskPriority).taskPriority ?? "", (arrDropdown[row] as! MasterTaskPriority).id ?? 0)
        }else if arrDropdown is [MasterTaskStatus], arrDropdown.count > row{
            return ((arrDropdown[row] as! MasterTaskStatus).taskStatus ?? "", (arrDropdown[row] as! MasterTaskStatus).id ?? 0)
        }else if arrDropdown is [MasterRoles], arrDropdown.count > row{
            return ((arrDropdown[row] as! MasterRoles).roleName ?? "", (arrDropdown[row] as! MasterRoles).id ?? 0)
        }else if arrDropdown is [MasterResidentList], arrDropdown.count > row{
            return ((arrDropdown[row] as! MasterResidentList).residenceName ?? "", (arrDropdown[row] as! MasterResidentList).patientID ?? 0)
        }else if arrDropdown is [Staff], arrDropdown.count > row{
            return ((arrDropdown[row] as! Staff).value ?? "", (arrDropdown[row] as! Staff).id ?? 0)
        }else if arrDropdown is [Patients], arrDropdown.count > row{
            return ((arrDropdown[row] as! Patients).value ?? "", (arrDropdown[row] as! MasterResidentList).patientID ?? 0)
        }else if arrDropdown is [MedicationsList], arrDropdown.count > row{
            return ((arrDropdown[row] as! MedicationsList).name ?? "", (arrDropdown[row] as! MedicationsList).id ?? 0)
        }else if arrDropdown is [Pharmacies], arrDropdown.count > row{
            return ((arrDropdown[row] as! Pharmacies).pharmacyName ?? "", (arrDropdown[row] as! Pharmacies).id ?? 0)
        }else if arrDropdown is [InventoryTypes], arrDropdown.count > row{
            return ((arrDropdown[row] as! InventoryTypes).name ?? "", (arrDropdown[row] as! InventoryTypes).id ?? 0)
        }else if arrDropdown is [InventoryLocation], arrDropdown.count > row{
            return ((arrDropdown[row] as! InventoryLocation).locationName ?? "", (arrDropdown[row] as! InventoryLocation).id ?? 0)
        }
        else if arrDropdown is [CancelMaster], arrDropdown.count > row{
            return ((arrDropdown[row] as! CancelMaster).value ?? "", (arrDropdown[row] as! CancelMaster).id ?? 0)
        }
        else if arrDropdown is [ZeroToTen], arrDropdown.count > row{
            return ((arrDropdown[row] as! ZeroToTen).value ?? "", (arrDropdown[row] as! ZeroToTen).id ?? 0)
        }
    else if arrDropdown is [ReportType], arrDropdown.count > row{
                       return ((arrDropdown[row] as! ReportType).value ?? "", (arrDropdown[row] as! ReportType).id ?? 0)
                   }
            
        else if arrDropdown is [MasterTaskType], arrDropdown.count > row{
            return ((arrDropdown[row] as! MasterTaskType).taskType ?? "", (arrDropdown[row] as! MasterTaskType).id ?? 0)
        }
        else if arrDropdown is [UnitMaster], arrDropdown.count > row{
            return ((arrDropdown[row] as! UnitMaster).unitName ?? "", (arrDropdown[row] as! UnitMaster).id ?? 0)
        }
        else if arrDropdown is [MealMasterDropdown], arrDropdown.count > row{
            return ((arrDropdown[row] as! MealMasterDropdown).name ?? "", (arrDropdown[row] as! MealMasterDropdown).id ?? 0)
        }
        else if arrDropdown is [FallBodyTempUnit], arrDropdown.count > row{
                return ((arrDropdown[row] as! FallBodyTempUnit).bodyTempUnit ?? "", (arrDropdown[row] as! FallBodyTempUnit).id ?? 0)
        }
        else if arrDropdown is [MasterVitalPositionFall], arrDropdown.count > row{
                return ((arrDropdown[row] as! MasterVitalPositionFall).position ?? "", (arrDropdown[row] as! MasterVitalPositionFall).id ?? 0)
        }
        else if arrDropdown is [ProgressNotesMaster], arrDropdown.count > row{
                           return ((arrDropdown[row] as! ProgressNotesMaster).name ?? "", (arrDropdown[row] as! ProgressNotesMaster).id ?? 0)
        }
        else if arrDropdown is [String], arrDropdown.count > row{
            var valueId = 0
            if (arrDropdown[row] as! String ) == "Day(s)" || (arrDropdown[row] as! String ) == "Hour(s)" || (arrDropdown[row] as! String ) == "Minute(s)"{
                valueId = row + 1
            }
            return ((arrDropdown[row] as! String ), valueId == 0 ? (arrDropdown[row] as! String ) : valueId )
        }else if arrDropdown is [CGFloat], arrDropdown.count > row{
            return ("\(Int(arrDropdown[row] as! CGFloat))", Int(arrDropdown[row] as! CGFloat))
        }else if arrDropdown is [Int], arrDropdown.count > row{
            return ("\(arrDropdown[row] as! Int)", (arrDropdown[row] as! Int))
        }
        return ("","")
    }
}
extension Array
{
    func filterDuplicate(_ keyValue:((AnyHashable...)->AnyHashable,Element)->AnyHashable) -> [Element]
    {
        func makeHash(_ params:AnyHashable ...) -> AnyHashable
        {
           var hash = Hasher()
           params.forEach{ hash.combine($0) }
           return hash.finalize()
        }
        var uniqueKeys = Set<AnyHashable>()
        return filter{uniqueKeys.insert(keyValue(makeHash,$0)).inserted}
    }
}
extension Sequence {
    /// Returns an array containing, in order, the first instances of
    /// elements of the sequence that compare equally for the keyPath.
    func unique<T: Hashable>(for keyPath: KeyPath<Element, T>) -> [Element] {
        var unique = Set<T>()
        return filter { unique.insert($0[keyPath: keyPath]).inserted }
    }
}

extension UIApplication {

    var screenShot: UIImage?  {

        if let rootViewController = keyWindow?.rootViewController {
            let scale = UIScreen.main.scale
            let bounds = rootViewController.view.bounds
            UIGraphicsBeginImageContextWithOptions(bounds.size, false, scale);
            if let _ = UIGraphicsGetCurrentContext() {
                rootViewController.view.drawHierarchy(in: bounds, afterScreenUpdates: true)
                let screenshot = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                return screenshot
            }
        }
        return nil
    }
}

//MARK:- UITableView
extension UITableView {

    func scrollToBottom(){

        DispatchQueue.main.async {
            let indexPath = IndexPath(
                row: self.numberOfRows(inSection:  self.numberOfSections-1) - 1,
                section: self.numberOfSections - 1)
            self.scrollToRow(at: indexPath, at: .bottom, animated: false)
        }
    }

    func scrollToTop() {

        DispatchQueue.main.async {
            let indexPath = IndexPath(row: 0, section: 0)
            self.scrollToRow(at: indexPath, at: .top, animated: false)
        }
    }
}

extension UILabel {
  func set(html: String) {
    if let htmlData = html.data(using: .unicode) {
      do {
        self.attributedText = try NSAttributedString(data: htmlData,
                                                     options: [.documentType: NSAttributedString.DocumentType.html],
                                                     documentAttributes: nil)
      } catch let e as NSError {
        print("Couldn't parse \(html): \(e.localizedDescription)")
      }
    }
  }
    func setHTMLFromString(htmlText: String) {
        let modifiedFont = String(format:"<span style=\"font-family: \(self.font!); font-size: \(self.font!.pointSize)\">%@</span>", htmlText)
        
        let attrStr = try! NSAttributedString(
            data: modifiedFont.data(using: .unicode, allowLossyConversion: true)!,
            options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue],
            documentAttributes: nil)
        
        self.attributedText = attrStr
    }

}

extension NSMutableAttributedString {

    /// Replaces the base font (typically Times) with the given font, while preserving traits like bold and italic
    func setBaseFont(baseFont: UIFont, preserveFontSizes: Bool = false) {
        let baseDescriptor = baseFont.fontDescriptor
        let wholeRange = NSRange(location: 0, length: length)
        beginEditing()
        enumerateAttribute(.font, in: wholeRange, options: []) { object, range, _ in
            guard let font = object as? UIFont else { return }
            // Instantiate a font with our base font's family, but with the current range's traits
            let traits = font.fontDescriptor.symbolicTraits
            guard let descriptor = baseDescriptor.withSymbolicTraits(traits) else { return }
            let newSize = preserveFontSizes ? descriptor.pointSize : baseDescriptor.pointSize
            let newFont = UIFont(descriptor: descriptor, size: newSize)
            self.removeAttribute(.font, range: range)
            self.addAttribute(.font, value: newFont, range: range)
        }
        endEditing()
    }
}

extension Utility{
    class func getEditImageAsBackground(tableView : UITableView , image : UIImage, indexPath : IndexPath,bgColor: UIColor) -> UIColor{
        let backView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: tableView.frame.size.height))
        backView.backgroundColor = bgColor
        let frame = tableView.rectForRow(at: indexPath)
        let myImage = UIImageView(frame: CGRect(x: 25, y: frame.size.height/2-15, width: 25, height: 25))
        myImage.image = image//UIImage(named: "delete-1")!
        backView.addSubview(myImage)
        let imgSize: CGSize = tableView.frame.size
        UIGraphicsBeginImageContextWithOptions(imgSize, false, UIScreen.main.scale)
        let context = UIGraphicsGetCurrentContext()
        backView.layer.render(in: context!)
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return UIColor(patternImage: newImage)
    }
}
