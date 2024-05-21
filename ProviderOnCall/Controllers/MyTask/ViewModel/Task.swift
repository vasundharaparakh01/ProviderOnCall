//
//  Task.swift
//  appName
//
//  Created by Vasundhara Parakh on 3/5/20.
//  Copyright © 2020 smartData Enterprises (I) Ltd. All rights reserved.
//

import UIKit

public class Task {
    public var patientAppointmentId : Int?
    public var residenceName : String?
    public var startDateTime : String?
    public var endDateTime : String?
    public var taskPriority : String?
    public var taskStatus : String?
    public var assinee : String?
    public var totalRecords : Int?
    public var taskDescription : String?
    public var taskType : String?
    public var taskTypeId : Int?
    public var taskStatusID : Int?
    public var roomNumber : String?
    public var uploadpath : String?
    public var roomNumberUnit : String?
    public var taskId : Int?
    public var patientPhotoPath : String?
    public var patientID : Int?
    public var assingnedTo : String?
    public var filePath : String?
    public var address : String?

/**
    Returns an array of models based on given dictionary.
    
    Sample usage:
    let json4Swift_Base_list = Json4Swift_Base.modelsFromDictionaryArray(someDictionaryArrayFromJSON)

    - parameter array:  NSArray from JSON dictionary.

    - returns: Array of Json4Swift_Base Instances.
*/
    public class func modelsFromDictionaryArray(array:NSArray) -> [Task]
    {
        var models:[Task] = []
        for item in array
        {
            models.append(Task(dictionary: item as! NSDictionary)!)
        }
        return models
    }

/**
    Constructs the object based on the given dictionary.
    
    Sample usage:
    let json4Swift_Base = Json4Swift_Base(someDictionaryFromJSON)

    - parameter dictionary:  NSDictionary from JSON.

    - returns: Json4Swift_Base Instance.
*/
    required public init?(dictionary: NSDictionary) {

        patientAppointmentId = dictionary["patientAppointmentId"] as? Int
        residenceName = dictionary["residenceName"] as? String
        startDateTime = dictionary["startDateTime"] as? String
        endDateTime = dictionary["endDateTime"] as? String
        taskPriority = dictionary["taskPriority"] as? String
        taskStatus = dictionary["taskStatus"] as? String
        assinee = dictionary["assinee"] as? String
        totalRecords = dictionary["totalRecords"] as? Int
        taskDescription = dictionary["taskDescription"] as? String
        taskType = dictionary["taskType"] as? String
        taskStatusID = dictionary["taskStatusID"] as? Int
        roomNumber = dictionary["roomNumber"] as? String
        uploadpath = dictionary["uploadpath"] as? String
        roomNumberUnit = dictionary["roomNumberUnit"] as? String
        taskId = dictionary["taskId"] as? Int
        patientPhotoPath = dictionary["patientPhotoPath"] as? String
        patientID = dictionary["patientID"] as? Int
        assingnedTo = dictionary["assingnedTo"] as? String
        taskTypeId = dictionary["taskTypeID"] as? Int
        filePath = dictionary["filePath"] as? String
        address = dictionary["address"] as? String

    }

        
/**
    Returns the dictionary representation for the current instance.
    
    - returns: NSDictionary.
*/
    public func dictionaryRepresentation() -> NSDictionary {

        let dictionary = NSMutableDictionary()

        dictionary.setValue(self.patientAppointmentId, forKey: "patientAppointmentId")
        dictionary.setValue(self.residenceName, forKey: "residenceName")
        dictionary.setValue(self.startDateTime, forKey: "startDateTime")
        dictionary.setValue(self.endDateTime, forKey: "endDateTime")
        dictionary.setValue(self.taskPriority, forKey: "taskPriority")
        dictionary.setValue(self.taskStatus, forKey: "taskStatus")
        dictionary.setValue(self.assinee, forKey: "assinee")
        dictionary.setValue(self.totalRecords, forKey: "totalRecords")
        dictionary.setValue(self.taskDescription, forKey: "taskDescription")
        dictionary.setValue(self.taskType, forKey: "taskType")
        dictionary.setValue(self.taskStatusID, forKey: "taskStatusID")
        dictionary.setValue(self.roomNumberUnit, forKey: "roomNumberUnit")
        dictionary.setValue(self.roomNumber, forKey: "roomNumber")
        dictionary.setValue(self.uploadpath, forKey: "uploadpath")
        dictionary.setValue(self.taskId, forKey: "taskId")
        dictionary.setValue(self.patientPhotoPath, forKey: "patientPhotoPath")
        dictionary.setValue(self.patientID, forKey: "patientID")
        dictionary.setValue(self.assingnedTo, forKey: "assingnedTo")
        dictionary.setValue(self.taskTypeId, forKey: "taskTypeID")
        dictionary.setValue(self.filePath, forKey: "filePath")
        dictionary.setValue(self.address, forKey: "address")

        return dictionary
    }

}
