//
//  DirectionMapViewModel.swift
//  appName
//
//  Created by Vasundhara Mehta on 13/08/20.
//  Copyright © 2020 smartData Enterprises (I) Ltd. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
class DirectionMapViewModel: BaseViewModel {
    // MARK: - Parameters
    private(set) var service:ResidentService
    var residentDetailHeader : ResidentDetailHeader? {
        didSet {
            self.updateViewClosure?()
        }
    }
    var lastLocation : LastLocation? {
        didSet {
            self.reloadListViewClosure?()
        }
    }
    // MARK: - Constructor
    init(with service:ResidentService) {
        self.service = service
    }
    
    func checkinUser(checkinStatus : Bool,patientId: Int){
        self.isLoading = true
        let visitDate = Utility.getStringFromDate(date: Date(), dateFormat: "YYYY-MM-dd" + " " + "HH:mm:ss").replacingOccurrences(of: " ", with: "T") + ".000Z"
         var params = [String : Any]()
        if checkinStatus == false{
            if SharedappName.sharedInstance.intMapID ?? -1 > 0{
                params = ["PatientId": "\(patientId)",
                    "VisitStatus":checkinStatus,
                    "VisitDate": visitDate,
                    "mapId": SharedappName.sharedInstance.intMapID ?? 0]
            }else{
                params = ["PatientId": "\(patientId)",
                    "VisitStatus":checkinStatus,
                    "VisitDate": visitDate]
            }
            
        }else{
           params = ["PatientId": "\(patientId)",
            "VisitStatus":checkinStatus,
            "VisitDate": visitDate,
            "mapId": SharedappName.sharedInstance.intMapID ?? 0]
        }
        
        service.patientCheckIn(with: params) { (result) in
            self.isLoading = false
            if let message = result as? String{
                self.errorMessage = message
                self.getResidentDetail(patientId: patientId)
            }
        }
    }
    
    func getResidentDetail(patientId : Int){
        self.isLoading = true
        service.getResidentDetail(patientId: patientId) { (result) in
            self.isLoading = false
            if let residentDetail = result as? ResidentDetailHeader{
                self.residentDetailHeader = residentDetail
            }
        }
    }
    
    func getTodayLastLocation(staftID : Int, strDate: String, locP: CLLocation , patientId : Int){
        let params : [String : Any] = ["currentDate": "\(strDate)", "staffId": "\(staftID)" ]
        service.getTodayLastLocation(with: params) { (result) in
            if let lL = result as? LastLocation{
                self.lastLocation = lL
                self.updateStaffCurrentLocation(staftID: staftID, locP: locP, patientId: patientId)
            }
        }
    }
    func updateStaffCurrentLocation(staftID : Int,  locP: CLLocation , patientId : Int){
        var idH: Int =  0
        if let id = self.lastLocation?.data?.id{
            idH = id
        }
       var staffIDH: Int =   AppInstance.shared.user?.id ?? 0 //AppInstance.shared.user?.staffLocation?[0].staffId ?? 0
        if let id = AppInstance.shared.user?.id{
            staffIDH = id
        }
        var appointmentIdH: String = self.random(digits: 2)
        if let id = self.lastLocation?.data?.appointmentId{
            appointmentIdH = "\(id)"
        }
        var organizationIDH: Int = AppInstance.shared.user?.staffLocation?[0].organizationID ?? 0
        if let id = self.lastLocation?.data?.organizationID{
            organizationIDH = id
        }
        var latitude: Double = 0.0
        if let sourceLat = (UIApplication.shared.delegate as! AppDelegate).updatedLocation?.coordinate.latitude{
            latitude = sourceLat
        }
        var longitude: Double = 0.0
        if let sourceLong = (UIApplication.shared.delegate as! AppDelegate).updatedLocation?.coordinate.longitude{
            longitude = sourceLong
        }

        let dateformatter = DateFormatter() // 2-2
        dateformatter.dateFormat = DateFormats.server_format_MealTime
        let dateToServer = dateformatter.string(from: Date()) //2-4

        var mileageH: Float = 0.0
        if var id = self.lastLocation?.data?.mileage{
            let coordinate₀ = locP
            let coordinate₁ = CLLocation(latitude: latitude, longitude: longitude)
            let distanceInMeters = coordinate₀.distance(from: coordinate₁)/1609
            print(distanceInMeters)
            if SharedappName.sharedInstance.coordiNat == coordinate₁{
                mileageH = Float(id)
            }else{
               SharedappName.sharedInstance.coordiNat = coordinate₁
                id =  id + Double(Float(distanceInMeters))
                mileageH = Float(id)
            }
            
        }else{
           let coordinate₀ = locP
            let coordinate₁ = CLLocation(latitude: latitude, longitude: longitude)
            let distanceInMeters = coordinate₀.distance(from: coordinate₁)/1609
            print(distanceInMeters)
            mileageH =  mileageH + Float(distanceInMeters)
        }
        
        let params : [String : Any] = [
            "id": idH,
            "staffID": staffIDH,
            "appointmentId": patientId,
            "latitude": "\(latitude)",
            "longitude": "\(longitude)",
            "mileage": mileageH,
            "updatedTimeStamp":dateToServer,
            "organizationID": organizationIDH]
        print("params = \(params)")
        service.updateStaffCurrentLocation(with: params) { (result) in
            if let updateStaff = result as? UpdateStaffCurrentLocation{
                
                print("self.lastLocation?.access_token = \(updateStaff.message)")
            }
        }
    }
    func random(digits:Int) -> String {
        var number = String()
        for _ in 1...digits {
            number += "\(Int.random(in: 1...9))"
        }
        return number
    }
}

