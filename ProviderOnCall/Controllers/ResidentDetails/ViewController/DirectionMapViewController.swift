//
//  DirectionMapViewController.swift
//  appName
//
//  Created by Vasundhara Mehta on 11/08/20.
//  Copyright © 2020 smartData Enterprises (I) Ltd. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

enum CheckInStatus {
    static let CheckIn = true
    static let CheckOut = false
}

enum TravelMode : Int {
    case driving = 0
    case walking
    case bicycling
    case transit
}

struct MapConstants {
    struct TravelMode {
        static let driving = "driving"
        static let walking = "walking"
        static let bicycling = "bicycling"
        static let transit = "transit"
    }
    static let yourLocation = "Your location"
    static let reachedDestination = "Reached destination"
    static let fastestRoute = "Fastest route, despite the usual traffic"
    static let you = "You"
}
class DirectionMapViewController: BaseViewController {
    
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var tfSource: InputTextField!
    @IBOutlet weak var tfDestination: InputTextField!
    @IBOutlet weak var directionsView: UIView!
    @IBOutlet weak var directionFullView: UIView!
    @IBOutlet weak var directionsViewHeight: NSLayoutConstraint!
    @IBOutlet weak var tblDirection: UITableView!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblDistance: UILabel!
    @IBOutlet weak var lblMapTime: UILabel!
    @IBOutlet weak var lblMapDistance: UILabel!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var lblVisitTime: UILabel!
    @IBOutlet weak var heightConstraintVisitLbl: NSLayoutConstraint!
    var gameTimer: Timer?
    
    var sourceLat = (UIApplication.shared.delegate as! AppDelegate).updatedLocation?.coordinate.latitude
    var sourceLong = (UIApplication.shared.delegate as! AppDelegate).updatedLocation?.coordinate.longitude
    /*
     var DestinationLat =  21.1480 //21.1390 //21.1480
     var DestinationLong =  79.0936 //79.1201 //
     
     
     //Vancouver Lat long - Sushi Restaurant
     var DestinationLat =  49.280046 //21.1390 //21.1480
     var DestinationLong =  -123.124929 //79.1201 //
     */
    
    var DestinationLat : Double =  0.0 //21.1390 //21.1480
    var DestinationLong : Double =  0.0 //79.1201 //
    var destinationAddress : String =  "" //79.1201 //
    
    var startLOC = CLLocation()
    var endLOC = CLLocation()
    let apiKey = Key.Google.PlacesKey
    var directionStepsArray = [Steps]()
    var polylineMapArray = [GMSPolyline]()
    var travelMode = MapConstants.TravelMode.driving
    var directionModel : GoogleDirectionModel?
    var routesGlobalArray = [Routes]()
    var patientInfo : PatientBasicHeaderInfo?
    
    lazy var viewModel: DirectionMapViewModel = {
        let obj = DirectionMapViewModel(with: ResidentService())
        self.baseViewModel = obj
        return obj
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.DestinationLat = 21.037556
//        self.DestinationLong = 79.01
         
        
        self.navigationItem.title = NavigationTitle.Maps
        self.addBackButton()
        self.addrightBarButtonItem()
        self.setupClosures()
        self.mapView.delegate = self
        
        self.getRoute()
        self.tfSource.text = MapConstants.yourLocation
        self.tfDestination.text = destinationAddress
        self.directionFullView.isHidden = true
        self.directionsViewHeight.constant = 0
        self.segmentControl.selectedSegmentIndex = 0
        self.travelMode = MapConstants.TravelMode.driving
        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotification(notification:)), name: Notification.Name("UpdateLocation"), object: nil)
        
        self.setVisitTime()
        
        self.callLocationAPI()
        gameTimer = Timer.scheduledTimer(timeInterval: 40, target: self, selector: #selector(callLocationAPI), userInfo: nil, repeats: true)
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        gameTimer?.invalidate()
    }
    @objc func callLocationAPI(){
        
        let dateformatter = DateFormatter() // 2-2
        dateformatter.dateFormat = "yyyy-MM-dd"
        let dateC = dateformatter.string(from: Date()) //2-4
        
        let patientLoc = CLLocation(latitude: DestinationLat, longitude: DestinationLong)
        self.viewModel.getTodayLastLocation(staftID: (AppInstance.shared.user?.staffLocation?[0])?.staffId ?? 0, strDate: dateC, locP: patientLoc, patientId: patientInfo?.patientID ?? 0)
    }
    
    func setVisitTime(){
        //---- Set visit time -----
        self.heightConstraintVisitLbl.constant = (self.patientInfo?.visitStatus != nil)   ? 40 : 0
        self.lblVisitTime.isHidden = self.patientInfo?.visitStatus == nil
        
        let prefixTiming = (self.patientInfo?.visitStatus ?? false) ? "Arrived at - " : "Left at - "
        var time = ConstantStrings.NA
        if let timeServer = self.patientInfo?.visitTime{
            time = Utility.convertServerDateToRequiredDate(dateStr: timeServer, requiredDateformat: DateFormats.mm_dd_yyyy) + ", " + Utility.convertServerDateToRequiredDate(dateStr: timeServer, requiredDateformat: DateFormats.hh_mm_a)
        }
        self.lblVisitTime.text = prefixTiming + time
        //Ends
    }
    func addrightBarButtonItem() {
        let titleOfButton = (self.patientInfo?.visitStatus ?? false) ? "Check-out" : "Check-in"
        let rightBarButtonItem = UIBarButtonItem(title: titleOfButton, style: .plain, target:  self, action: #selector(onRightBarButtonItemClicked(_ :)))
        rightBarButtonItem.tintColor = UIColor.white
        navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    // MARK:
    @objc func onRightBarButtonItemClicked(_ sender: UIBarButtonItem) {
        if self.patientInfo?.visitStatus ?? false{
            self.checkOutPatient()
        }else{
            self.checkInPatient()
        }
        
    }
    func checkOutPatient(){
        self.viewModel.checkinUser(checkinStatus: false, patientId: self.patientInfo?.patientID ?? 0)
    }
    func checkInPatient(){
        let patientLocation = CLLocation(latitude: DestinationLat, longitude: DestinationLong)
        if let currentLocation = (UIApplication.shared.delegate as! AppDelegate).updatedLocation{
            let loc = CLLocation(latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude)
            
            var isValidLoc = false
            let distanceThreshold = 200.0//20.0 // meters
            if patientLocation.distance(from: loc) < distanceThreshold
            {
                isValidLoc = true
            }
            if isValidLoc{
                gameTimer?.invalidate()
                self.viewModel.checkinUser(checkinStatus: true, patientId: self.patientInfo?.patientID ?? 0)
            }else{
                Utility.showAlertWithMessage(titleStr: Alert.Title.appName, messageStr: "You cannot check-in as your location does not match with \(UserDefaults.getOrganisationTypeName().lowercased())'s location.", controller: self)
                
            }
        }else{
            Utility.showAlertWithMessage(titleStr: Alert.Title.appName, messageStr: "You cannot check-in as your location does not match with \(UserDefaults.getOrganisationTypeName().lowercased())'s location.", controller: self)
        }
    }
    func setupClosures() {
        self.viewModel.updateViewClosure = { [weak self] () in
            DispatchQueue.main.async {
                if let basicInfo = self?.viewModel.residentDetailHeader?.patientBasicHeaderInfo{
                    self?.patientInfo = basicInfo
                    self?.setVisitTime()
                    self?.addrightBarButtonItem()
                }
            }
        }
    }
    deinit {
        NotificationCenter.default.removeObserver(self, name: Notification.Name("UpdateLocation"), object: nil)
    }
    
    @objc func methodOfReceivedNotification(notification: Notification) {
        self.getRoute()
    }
    
    @IBAction func btnSteps_Action(_ sender: Any) {
        self.animateDirectionViewHeight()
    }
    
    @IBAction func changeTravelMode_Action(_ sender: Any) {
        switch segmentControl.selectedSegmentIndex {
        case TravelMode.driving.rawValue:
            self.travelMode = MapConstants.TravelMode.driving
        case TravelMode.walking.rawValue:
            self.travelMode = MapConstants.TravelMode.walking
        case TravelMode.bicycling.rawValue:
            self.travelMode = MapConstants.TravelMode.bicycling
        default:
            self.travelMode = MapConstants.TravelMode.transit
        }
        self.getRoute()
    }
    func animateDirectionViewHeight() {
        self.directionFullView.isHidden = !self.directionFullView.isHidden
        UIView.animate(withDuration: 0.5, animations: {
            self.directionsViewHeight.constant = self.directionFullView.isHidden ? 0 : Screen.height - 200
            self.view.layoutIfNeeded()
        })
    }
    
    func drawPath(startLocation: CLLocation, endLocation: CLLocation, completion:@escaping (Any?) -> Void)
    {
        
        /*
         if let path = Bundle.main.path(forResource: "example_2", ofType: "json") {
         do {
         let dataObj = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
         let jsonResult = try JSONSerialization.jsonObject(with: dataObj, options: .mutableLeaves)
         if let data = jsonResult as? Dictionary<String, AnyObject> {
         // do stuff
         DispatchQueue.main.async {
         // #parse response here
         if let modelGoogle = GoogleDirectionModel(dictionary: data as! NSDictionary){
         if let routes = modelGoogle.routes{
         for (_,route) in routes.enumerated()
         {
         if let points = route.overview_polyline?.points{
         let path = GMSPath.init(fromEncodedPath: points )
         let polyline = GMSPolyline.init(path: path)
         polyline.strokeWidth = 4
         polyline.strokeColor =  Color.Blue
         polyline.map = self.mapView
         
         
         if let legsArry = route.legs{
         completion(legsArry)
         }
         }
         
         }
         }
         }
         }
         
         }
         } catch {
         // handle error
         }
         }
         else{
         */
        let origin = "\(startLocation.coordinate.latitude),\(startLocation.coordinate.longitude)"
        let destination = "\(endLocation.coordinate.latitude),\(endLocation.coordinate.longitude)"
        let url = APITargetPoint.directionGoogleAPI + "origin=\(origin)&destination=\(destination)&mode=\(travelMode)&key=\(apiKey)&alternatives=true"
        print("URL - \(url)")
        APIService().getDirectionService(with: .get, path: url, parameters: nil, files: nil) { (result) in
            DispatchQueue.main.async {
                self.removePath()
                
                switch result {
                case .Success(let data):
                    // #parse response here
                    if let modelGoogle = GoogleDirectionModel(dictionary: data as! NSDictionary){
                        self.directionModel = modelGoogle
                        if let routes = modelGoogle.routes{
                            self.routesGlobalArray = routes
                            let reversedArray = routes.reversed()
                            for (index,route) in reversedArray.enumerated()
                            {
                                if let points = route.overview_polyline?.points{
                                    let path = GMSPath.init(fromEncodedPath: points )
                                    let polyline = GMSPolyline.init(path: path)
                                    polyline.strokeWidth = 4
                                    
                                    polyline.strokeColor = index == routes.count - 1 ? Color.Blue : Color.LightGray
                                    polyline.isTappable = true
                                    polyline.title = "\(index)"
                                    polyline.map = self.mapView
                                    self.polylineMapArray.append(polyline)
                                    
                                    if let legsArry = route.legs{
                                        completion(legsArry)
                                    }
                                    
                                }
                                
                            }
                        }
                    }
                case .Error(let error):
                    print("Error in api = \(error)")
                }
            }
        }
        //}
        
    }
    func removePath(){
        self.mapView.clear()
    }
    func getRoute(){
        // Route Source & Destination
        self.startLOC = CLLocation(latitude: (UIApplication.shared.delegate as! AppDelegate).updatedLocation?.coordinate.latitude ?? 0.0, longitude: (UIApplication.shared.delegate as! AppDelegate).updatedLocation?.coordinate.longitude ?? 0.0)
        self.endLOC = CLLocation(latitude: DestinationLat, longitude: DestinationLong)
        
        self.drawPath(startLocation: startLOC, endLocation: endLOC) { (legsArray) in
            if let array = legsArray as? [Legs]{
                
                if let steps = array.first {
                    
                    if let stepsArr = steps.steps{
                        self.directionStepsArray = stepsArr
                        self.tblDirection.reloadData()
                        
                        let time = steps.duration?.text ?? ""
                        let distance = steps.distance?.text ?? ""
                        
                        if self.startLOC.distance(from: self.endLOC) < 15{
                            self.lblDistance.text = MapConstants.reachedDestination
                            self.lblMapDistance.text = MapConstants.reachedDestination
                            self.lblTime.text = ""
                            self.lblMapTime.text = ""
                        }else{
                            self.lblDistance.text = time + " (" + distance + ")"
                            self.lblMapDistance.text = time + " (" + distance + ")"
                            
                            
                            self.lblTime.text = MapConstants.fastestRoute
                            self.lblMapTime.text = MapConstants.fastestRoute
                        }
                    }
                }
                
                let marker = GMSMarker()
                marker.position = CLLocationCoordinate2D(latitude: (UIApplication.shared.delegate as! AppDelegate).updatedLocation?.coordinate.latitude ?? 0.0, longitude: (UIApplication.shared.delegate as! AppDelegate).updatedLocation?.coordinate.longitude ?? 0.0)
                marker.icon = UIImage(named:"sourceNavigation")//userImage.af_imageScaled(to: CGSize(width: 50, height: 50)).af_imageRoundedIntoCircle()
                marker.title = MapConstants.you
                marker.map = self.mapView
                
                
                let markerr = GMSMarker()
                markerr.position = CLLocationCoordinate2D(latitude: self.DestinationLat, longitude: self.DestinationLong)
                markerr.icon = UIImage(named:"destinationNavigation")
                // markerr.icon =  washerImage.af_imageScaled(to: CGSize(width: 50, height: 50)).af_imageRoundedIntoCircle()
                markerr.title = self.destinationAddress
                markerr.map = self.mapView
                
                let camera = GMSCameraPosition.camera(withLatitude: (UIApplication.shared.delegate as! AppDelegate).updatedLocation?.coordinate.latitude ?? 0.0, longitude: (UIApplication.shared.delegate as! AppDelegate).updatedLocation?.coordinate.longitude ?? 0.0, zoom: self.mapView.camera.zoom < 14.0 ? 14.0 : self.mapView.camera.zoom)
                self.mapView.camera = camera
                self.mapView.animate(to: camera)
            }else{
                self.lblDistance.text = ""
                self.lblMapDistance.text = ""
                
                self.lblTime.text = ""
                self.lblMapTime.text = ""
                
                self.directionStepsArray.removeAll()
                self.tblDirection.reloadData()
            }
        }
        
        
        
        
        
    }
    
}

extension Utility{
    class func saveJsonFile(_ name:String, data:Data) {
        // Get the url of File in document directory
        guard let documentDirectoryUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let fileUrl = documentDirectoryUrl.appendingPathComponent(name + ".json")
        
        // Transform array into data and save it into file
        do {
            //let data = try JSONSerialization.data(withJSONObject: list, options: [])
            try data.write(to: fileUrl, options: .completeFileProtection)
        } catch {
            print(error)
        }
    }
    
    class func retrieveFromJsonFile(_ name:String) -> [[String: Any]]? {
        // Get the url of File in document directory
        guard let documentsDirectoryUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil}
        let fileUrl = documentsDirectoryUrl.appendingPathComponent(name + ".json")
        
        // Check for file in file manager.
        guard  (FileManager.default.fileExists(atPath: fileUrl.path))else {return nil}
        
        // Read data from .json file and transform data into an arra y
        do {
            let data = try Data(contentsOf: fileUrl, options: [])
            guard let list = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] else { return nil}
            //print(list)
            return list
        } catch {
            print(error)
            return nil
        }
    }
    
}

//MARK:- UITableViewDelegate,UITableViewDataSource
extension DirectionMapViewController : UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return directionStepsArray.count
        //return directionStepsArray.count > 0 ? directionStepsArray.count + 2 : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ReuseIdentifier.DirectionStepCell, for: indexPath as IndexPath) as! DirectionStepCell
        /*
         if indexPath.row == 0 {
         cell.lblDescription.text = "Your location"
         cell.lblDistance.text = ""
         
         }else if indexPath.row == self.directionStepsArray.count + 1{
         cell.lblDescription.text = "Destination"
         cell.lblDistance.text = ""
         }else{
         */
        cell.direction = self.directionStepsArray[indexPath.row]
        //}
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

class DirectionStepCell : UITableViewCell{
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblDistance: UILabel!
    @IBOutlet weak var imgDirection: UIImageView!
    
    
    var direction: Steps?{
        didSet{
            setUpData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setUpData(){
        if let steps = direction{
            
            var str = steps.html_instructions ?? ""
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
            self.lblDescription.setHTMLFromString(htmlText:finalStr.trimmingCharacters(in: .whitespacesAndNewlines))
            
            self.lblDistance.text = steps.distance?.text ?? ""
            //print("Direction - \(steps.maneuver)")
            self.imgDirection.image = self.getDirectionImage(direction: steps.maneuver ?? "")
        }
    }
    
    func getDirectionImage(direction: String) -> UIImage?{
        switch direction {
        case "turn-sharp-left":
            return UIImage(named: "turn-sharp-left-1")
        case "uturn-right":
            return  UIImage(named: "uturn-right")
        case "turn-slight-right":
            return  UIImage(named: "turn-slight-right")
        case "merge":
            return  UIImage(named: "merge-right")
        case "roundabout-left":
            return  UIImage(named: "roundabout-left")
        case "roundabout-right":
            return  UIImage(named: "roundabout-right")
        case "uturn-left":
            return UIImage(named: "uturn-left")
        case "turn-left":
            return UIImage(named: "turn-left")
        case "ramp-right":
            return UIImage(named: "ramp-right")
        case "turn-right":
            return UIImage(named: "turn-right")
        case "fork-right":
            return UIImage(named: "fork-right")
        case "straight":
            return UIImage(named: "straight")
        case "fork-left":
            return UIImage(named: "fork-left")
        case "ferry-train":
            return UIImage(named: "ferry-train")
        case "turn-sharp-right":
            return  UIImage(named: "turn-sharp-left")
        case "ramp-left":
            return UIImage(named: "ramp-left")
        case "ferry":
            return UIImage(named: "ferry")
        default:
            return nil
        }
        return nil
    }
}

//MARK:- GMSMapViewDelegate
extension DirectionMapViewController : GMSMapViewDelegate{
    func mapView(_ mapView: GMSMapView, didTap overlay: GMSOverlay) {
        print("Index Path === \(Int(overlay.title ?? "0") ?? 0)")
        let indexToMap = Int(overlay.title ?? "0") ?? 0
        var copyRoutes = self.routesGlobalArray
        let myobject = copyRoutes.remove(at: indexToMap)
        copyRoutes.append(myobject)
        self.routesGlobalArray = copyRoutes
        for (index,route) in copyRoutes.enumerated()
        {
            if let points = route.overview_polyline?.points{
                let path = GMSPath.init(fromEncodedPath: points )
                let polyline = GMSPolyline.init(path: path)
                polyline.strokeWidth = 4
                polyline.title = "\(index)"
                polyline.strokeColor = index == copyRoutes.count - 1 ? Color.Blue : Color.LightGray
                polyline.isTappable = true
                polyline.map = self.mapView
                self.polylineMapArray.append(polyline)
                
                if let legsArry = route.legs{
                    if let array = legsArry as? [Legs]{
                        
                        if let steps = array.first {
                            
                            if let stepsArr = steps.steps{
                                self.directionStepsArray = stepsArr
                                self.tblDirection.reloadData()
                                
                                let time = steps.duration?.text ?? ""
                                let distance = steps.distance?.text ?? ""
                                
                                if self.startLOC.distance(from: self.endLOC) < 15{
                                    self.lblDistance.text = MapConstants.reachedDestination
                                    self.lblMapDistance.text = MapConstants.reachedDestination
                                    self.lblTime.text = ""
                                    self.lblMapTime.text = ""
                                }else{
                                    self.lblDistance.text = time + " (" + distance + ")"
                                    self.lblMapDistance.text = time + " (" + distance + ")"
                                    
                                    
                                    self.lblTime.text = MapConstants.fastestRoute
                                    self.lblMapTime.text = MapConstants.fastestRoute
                                }
                            }
                        }
                        
                    }
                }
                
            }
            
        }
        
    }
}

