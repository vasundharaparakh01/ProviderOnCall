/* 
Copyright (c) 2020 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

import Foundation
 
/* For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar */

public class WccApointmentList {
	public var patientAppointmentId : Int?
	public var startDateTime : String?
	public var endDateTime : String?
	public var appointmentTypeName : String?
	public var appointmentTypeID : Int?
	public var shiftId : Int?
	public var color : String?
	public var fontColor : String?
	public var defaultDuration : Int?
	public var isBillable : Bool?
	public var canEdit : Bool?
	public var notes : String?
	public var serviceLocationID : Int?
	public var appointmentStaffs : Array<AppointmentStaffs>?
	public var isClientRequired : Bool?
	public var isRecurrence : Bool?
	public var offSet : Int?
	public var allowMultipleStaff : Bool?
	public var cancelTypeId : Int?
	public var isExcludedFromMileage : Bool?
	public var isDirectService : Bool?
	public var patientPhotoThumbnailPath : String?
	public var statusId : Int?
	public var statusName : String?
	public var isTelehealthAppointment : Bool?
	public var type : String?
	public var taskStatusId : Int?
	public var isImFollowing : Bool?
	public var appointmentPatientModels : Array<AppointmentPatientModels>?

/**
    Returns an array of models based on given dictionary.
    
    Sample usage:
    let wccApointmentList_list = WccApointmentList.modelsFromDictionaryArray(someDictionaryArrayFromJSON)

    - parameter array:  NSArray from JSON dictionary.

    - returns: Array of WccApointmentList Instances.
*/
    public class func modelsFromDictionaryArray(array:NSArray) -> [WccApointmentList]
    {
        var models:[WccApointmentList] = []
        for item in array
        {
            models.append(WccApointmentList(dictionary: item as! NSDictionary)!)
        }
        return models
    }

/**
    Constructs the object based on the given dictionary.
    
    Sample usage:
    let wccApointmentList = WccApointmentList(someDictionaryFromJSON)

    - parameter dictionary:  NSDictionary from JSON.

    - returns: WccApointmentList Instance.
*/
	required public init?(dictionary: NSDictionary) {

		patientAppointmentId = dictionary["patientAppointmentId"] as? Int
		startDateTime = dictionary["startDateTime"] as? String
		endDateTime = dictionary["endDateTime"] as? String
		appointmentTypeName = dictionary["appointmentTypeName"] as? String
		appointmentTypeID = dictionary["appointmentTypeID"] as? Int
		shiftId = dictionary["shiftId"] as? Int
		color = dictionary["color"] as? String
		fontColor = dictionary["fontColor"] as? String
		defaultDuration = dictionary["defaultDuration"] as? Int
		isBillable = dictionary["isBillable"] as? Bool
		canEdit = dictionary["canEdit"] as? Bool
		notes = dictionary["notes"] as? String
		serviceLocationID = dictionary["serviceLocationID"] as? Int
        if (dictionary["appointmentStaffs"] != nil) { appointmentStaffs = AppointmentStaffs.modelsFromDictionaryArray(array: dictionary["appointmentStaffs"] as! NSArray) }
		isClientRequired = dictionary["isClientRequired"] as? Bool
		isRecurrence = dictionary["isRecurrence"] as? Bool
		offSet = dictionary["offSet"] as? Int
		allowMultipleStaff = dictionary["allowMultipleStaff"] as? Bool
		cancelTypeId = dictionary["cancelTypeId"] as? Int
		isExcludedFromMileage = dictionary["isExcludedFromMileage"] as? Bool
		isDirectService = dictionary["isDirectService"] as? Bool
		patientPhotoThumbnailPath = dictionary["patientPhotoThumbnailPath"] as? String
		statusId = dictionary["statusId"] as? Int
		statusName = dictionary["statusName"] as? String
		isTelehealthAppointment = dictionary["isTelehealthAppointment"] as? Bool
		type = dictionary["type"] as? String
		taskStatusId = dictionary["taskStatusId"] as? Int
		isImFollowing = dictionary["isImFollowing"] as? Bool
        if (dictionary["appointmentPatientModels"] != nil) { appointmentPatientModels = AppointmentPatientModels.modelsFromDictionaryArray(array: dictionary["appointmentPatientModels"] as! NSArray) }
	}

		
/**
    Returns the dictionary representation for the current instance.
    
    - returns: NSDictionary.
*/
	public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()

		dictionary.setValue(self.patientAppointmentId, forKey: "patientAppointmentId")
		dictionary.setValue(self.startDateTime, forKey: "startDateTime")
		dictionary.setValue(self.endDateTime, forKey: "endDateTime")
		dictionary.setValue(self.appointmentTypeName, forKey: "appointmentTypeName")
		dictionary.setValue(self.appointmentTypeID, forKey: "appointmentTypeID")
		dictionary.setValue(self.shiftId, forKey: "shiftId")
		dictionary.setValue(self.color, forKey: "color")
		dictionary.setValue(self.fontColor, forKey: "fontColor")
		dictionary.setValue(self.defaultDuration, forKey: "defaultDuration")
		dictionary.setValue(self.isBillable, forKey: "isBillable")
		dictionary.setValue(self.canEdit, forKey: "canEdit")
		dictionary.setValue(self.notes, forKey: "notes")
		dictionary.setValue(self.serviceLocationID, forKey: "serviceLocationID")
		dictionary.setValue(self.isClientRequired, forKey: "isClientRequired")
		dictionary.setValue(self.isRecurrence, forKey: "isRecurrence")
		dictionary.setValue(self.offSet, forKey: "offSet")
		dictionary.setValue(self.allowMultipleStaff, forKey: "allowMultipleStaff")
		dictionary.setValue(self.cancelTypeId, forKey: "cancelTypeId")
		dictionary.setValue(self.isExcludedFromMileage, forKey: "isExcludedFromMileage")
		dictionary.setValue(self.isDirectService, forKey: "isDirectService")
		dictionary.setValue(self.patientPhotoThumbnailPath, forKey: "patientPhotoThumbnailPath")
		dictionary.setValue(self.statusId, forKey: "statusId")
		dictionary.setValue(self.statusName, forKey: "statusName")
		dictionary.setValue(self.isTelehealthAppointment, forKey: "isTelehealthAppointment")
		dictionary.setValue(self.type, forKey: "type")
		dictionary.setValue(self.taskStatusId, forKey: "taskStatusId")
		dictionary.setValue(self.isImFollowing, forKey: "isImFollowing")

		return dictionary
	}

}
