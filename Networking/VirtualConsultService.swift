//
//  VirtualConsultService.swift
//  appName
//
//  Created by Vasundhara Parakh on 4/27/20.
//  Copyright © 2020 smartData Enterprises (I) Ltd. All rights reserved.
//

import UIKit

class VirtualConsultService: APIService {
    func getAppointmentList(with target:BaseViewModel? = nil,pageNo : Int, completion:@escaping (Any?) -> Void) {
        let param = [Key.Params.typeAppointment : "VideoCall",
                     Key.Params.pageNumber : "\(pageNo)",
            Key.Params.pageSize : "10000",//"\(Pagination.pageSize)",
            Key.Params.sortOrder : "",
            "staffIds": "\(AppInstance.shared.user?.id ?? 0)"] as [String : Any]
        super.startService(with: .get, path: APITargetPoint.getVideoAppointmentList, parameters: param, files: []) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .Success(let data):
                    // #parse response here
                    var tempArray = [VideoCallAppointments]()
                    if let array = (data as NSDictionary).object(forKey: "data") as? NSArray{
                        for (_,item) in array.enumerated(){
                            if let appointment = VideoCallAppointments(dictionary: item as! NSDictionary){
                                tempArray.append(appointment)
                            }
                        }
                    }
                    completion(tempArray)
                case .Error(let error):
                    completion(error)
                }
            }
        }
    }
    
    func getPatientEncounter(with target:BaseViewModel? = nil,appointmentId : Int, completion:@escaping (Any?) -> Void){
        let apiPath = APITargetPoint.getPatientEncounterDetails + "/" + "\(appointmentId)/0"
        super.startService(with: .get, path: apiPath, parameters: nil, files: []) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .Success(let data):
                    // #parse response here
                    let appointment = AppointmentDetail(dictionary: (data as NSDictionary).object(forKey: "data") as! NSDictionary)
                    completion(appointment)
                case .Error(let error):
                    completion(error)
                }
            }
        }
    }
    
    func startRecordingTelehealthSession(with target:BaseViewModel? = nil,sessionId : String,completion:@escaping (Any?) -> Void){
        let params : [String:Any] = [Key.Params.VideoCall.sessionId : sessionId]
        super.startService(with: .post, path:  APITargetPoint.startSessionRecording , parameters: params, files: []) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .Success(let data):
                    // #parse response here
                    let recording = Recording(dictionary: (data as NSDictionary).object(forKey: "data") as! NSDictionary)
                    completion(recording)
                case .Error(let error):
                    completion(error)
                }
            }
        }

    }
    func stopRecordingTelehealthSession(with target:BaseViewModel? = nil,archiveId : String,completion:@escaping (Any?) -> Void){
        let params : [String:Any] = [Key.Params.VideoCall.archiveId : archiveId]
        super.startService(with: .get, path:  APITargetPoint.stopSessionRecording , parameters: params, files: []) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .Success(let data):
                    // #parse response here
                    completion(data)
                case .Error(let error):
                    completion(error)
                }
            }
        }

    }
    func getTelehealthSession(with target:BaseViewModel? = nil,patientID : Int,staffID : String,startTime : String, endTime : String ,appointmentID: Int,completion:@escaping (Any?) -> Void){
//        let params : [String:Any] = [Key.Params.VideoCall.patientID : "\(patientID)",
//            Key.Params.VideoCall.staffID : "\(AppInstance.shared.user?.id ?? 0)",
//                      Key.Params.VideoCall.startTime : startTime,
//                      Key.Params.VideoCall.endTime : endTime,
//                    ]
        let params = [Key.Params.appointmentId : "\(appointmentID)"]
        super.startService(with: .get, path:  APITargetPoint.newGetTelehealthSession , parameters: params, files: []) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .Success(let data):
                    // #parse response here
                    let session = TelehealthSession(dictionary: (data as NSDictionary).object(forKey: "data") as! NSDictionary)
                    completion(session)
                case .Error(let error):
                    completion(error)
                }
            }
        }
    }
    
    func uploadCallDocuments(with target:BaseViewModel? = nil,params : [String: Any], completion:@escaping (Any?) -> Void) {
        super.startService(with: .post, path:  APITargetPoint.uploadDocument , parameters: params, files: []) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .Success(let data):
                    // #parse response here
                    completion(data)
                case .Error(let error):
                    completion(error)
                }
            }
        }
    }
    
    func getAppointmentDocuments(with target:BaseViewModel? = nil,appointmentId : Int, completion:@escaping (Any?) -> Void) {
        let params : [String : Any] = [Key.Params.appointmentId : "\(appointmentId)"]
        super.startService(with: .get, path:  APITargetPoint.getChatDocument , parameters: params, files: []) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .Success(let data):
                    // #parse response here
                    var tempArray = [SharedDocument]()
                    if let array = (data as NSDictionary).object(forKey: "data") as? NSArray{
                        for (_,item) in array.enumerated(){
                            if let doc = SharedDocument(dictionary: item as! NSDictionary){
                                tempArray.append(doc)
                            }
                        }
                    }
                    completion(tempArray)
                case .Error(let error):
                    completion(error)
                }
            }
        }
    }
    
    func getPreviousMessages(with target:BaseViewModel? = nil,sessionID : String, fromUserId : Int, completion:@escaping (Any?) -> Void) {
        let params : [String : Any] = [Key.Params.VideoCall.SessionId : sessionID,
                                    Key.Params.VideoCall.FromUserId :"\(fromUserId)",
                                    Key.Params.pageNumber : "1",
                                    Key.Params.pageSize : "100000000000"]
        super.startService(with: .get, path:  APITargetPoint.getChatHistory , parameters: params, files: []) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .Success(let data):
                    // #parse response here
                    var tempArray = [Message]()
                    if let array = (data as NSDictionary).object(forKey: "data") as? NSArray{
                        for (_,item) in array.enumerated(){
                            if let message = Message(dictionary: item as! NSDictionary){
                                tempArray.append(message)
                            }
                        }
                    }
                    completion(tempArray)
                case .Error(let error):
                    completion(error)
                }
            }
        }
    }

    func getPatientAppointment(params:[String:Any],target:BaseViewModel? = nil, completion:@escaping (Any?) -> Void){
        super.startService(with: .get, path:  APITargetPoint.getPatientAppointmentList , parameters: params, files: []) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .Success(let data):
                    // #parse response here
                    var tempArray = [Appointments]()
                    if let array = (data as NSDictionary).object(forKey: "data") as? NSArray{
                        for (_,item) in array.enumerated(){
                            if let appointment = Appointments(dictionary: item as! NSDictionary){
                                tempArray.append(appointment)
                            }
                        }
                    }
                    completion(tempArray)
                case .Error(let error):
                    completion(error)
                }
            }
        }
    }
    
    func getStaffAvailability(with target:BaseViewModel? = nil,locationId: Int, shiftId: Int, completion:@escaping (Any?) -> Void){
        let params : [String: Any] = [Key.Params.locationId : "\(locationId)",
                                    Key.Params.shiftId : "\(shiftId)",
                                    Key.Params.staffID : "\(AppInstance.shared.user?.id ?? 0)"]
        super.startService(with: .get, path:  APITargetPoint.getPatientAppointmentList , parameters: params, files: []) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .Success(let data):
                    // #parse response here
                    var tempArray = [Appointments]()
                    if let array = (data as NSDictionary).object(forKey: "data") as? NSArray{
                        for (_,item) in array.enumerated(){
                            if let appointment = Appointments(dictionary: item as! NSDictionary){
                                tempArray.append(appointment)
                            }
                        }
                    }
                    completion(tempArray)
                case .Error(let error):
                    completion(error)
                }
            }
        }
    }
    
    func getStaffAvailabilitySlots(with target:BaseViewModel? = nil,type : String,date: String, shiftId: Int, completion:@escaping (Any?) -> Void){
        let params : [String: Any] = ["date" : date,
                                    Key.Params.shiftId : shiftId,
                                    "type" : type
                                    ]
        super.startService(with: .post, path:  APITargetPoint.getStaffAvailabilityMobile , parameters: params, files: []) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .Success(let data):
                    // #parse response here
                    let slots = StaffAvailabilitySlot(dictionary: (data as NSDictionary).object(forKey: "data") as! NSDictionary)
                    completion(slots)
                case .Error(let error):
                    completion(error)
                }
            }
        }
    }
    
    func saveAvailability(with target:BaseViewModel? = nil,params : [String: Any], completion:@escaping (Any?) -> Void) {
        super.startService(with: .post, path:  APITargetPoint.saveUpdateAvailabilityWithLocation , parameters: params, files: []) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .Success(let data):
                    // #parse response here
                    if let dataObj = data as? Dictionary<String,Any>{
                        completion(dataObj["message"])
                    }else{
                        completion("An error has occured. Please try again later.")
                    }
                case .Error(let error):
                    completion(error)
                }
            }
        }
    }
    
    func getAvailabilityList(fromDate: String,toDate: String, shiftId : Int,staffId: Int, completion:@escaping (Any?) -> Void){
        let params : [String: Any] = [Key.Params.fromDate : fromDate + "T00:00:00.000Z",
                                      Key.Params.toDate : toDate + "T23:59:59.000Z",
                                      Key.Params.shiftId : shiftId,
                                      Key.Params.locationId : "\((AppInstance.shared.user?.staffLocation?[0])?.locationID ?? 0)",
                                        Key.Params.staffId : "\(staffId)"
        ]
        super.startService(with: .post, path:  APITargetPoint.getStaffAllAvailabilityMobile , parameters: params, files: []) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .Success(let data):
                    // #parse response here
                    
                    var tempArrayDay = [AvailabilityByDayName]()
                    var tempArrayAvailability = [AvailabilityByDayName]()
                    var tempArrayUnAvailability = [AvailabilityByDayName]()

                    if let data = data["data"] as? Dictionary<String,Any>{
                        if let masterArray = data["_Days"] as? NSArray{
                            for (_,item) in masterArray.enumerated(){
                                if let availability = AvailabilityByDayName(dictionary: item as! NSDictionary){
                                    tempArrayDay.append(availability)
                                    /*
                                    if availability.isAvailable ?? true { tempArrayDay.append(availability)
                                    }*/
                                }
                            }
                        }
                        
                        if let masterArray = data["_Avaibilitity"] as? NSArray{
                            for (_,item) in masterArray.enumerated(){
                                if let availability = AvailabilityByDayName(dictionary: item as! NSDictionary){
                                    tempArrayAvailability.append(availability)
                                }
                            }
                        }
                        
                        if let masterArray = data["_Unavaibility"] as? NSArray{
                            for (_,item) in masterArray.enumerated(){
                                if let availability = AvailabilityByDayName(dictionary: item as! NSDictionary){
                                    tempArrayAvailability.append(availability)
                                }
                            }
                        }
                    }
                    completion(tempArrayDay + tempArrayAvailability)
                    //completion(tempArrayAvailability)
                case .Error(let error):
                    completion(error)
                }
            }
        }
    }
    
    func saveVCSchedule(with target:BaseViewModel? = nil,params : [String: Any], completion:@escaping (Any?, Bool) -> Void) {
        super.startService(with: .post, path:  APITargetPoint.saveTask , parameters: params, files: []) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .Success(let data):
                    // #parse response here
                    if let dataObj = data as? Dictionary<String,Any>{
                        completion("Virtual Consult added successfully.",true)
                    }else{
                        completion("An error has occured. Please try again later.",false)
                    }
                case .Error(let error):
                    completion(error,false)
                }
            }
        }
    }
    func saveVCScheduleAppointment(with target:BaseViewModel? = nil,params : [String: Any], completion:@escaping (Any?, Bool) -> Void) {
        super.startService(with: .post, path:  APITargetPoint.saveMobileAppoitment , parameters: params, files: []) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .Success(let data):
                    // #parse response here
                    if let dataObj = data as? Dictionary<String,Any>{
                        completion("Virtual Consult added successfully.",true)
                    }else{
                        completion("An error has occured. Please try again later.",false)
                    }
                case .Error(let error):
                    completion(error,false)
                }
            }
        }
    }
}
