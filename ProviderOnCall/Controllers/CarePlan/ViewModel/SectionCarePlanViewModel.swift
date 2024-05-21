//
//  SectionCarePlanViewModel.swift
/
//
//  Created by Vasundhara Parakh on 3/11/20.
//  Copyright © 2020 smartData Enterprises (I) Ltd. All rights reserved.
//

import UIKit

class SectionCarePlanViewModel: BaseViewModel{
    // MARK: - Parameters
    private(set) var service:CarePlanService
    
    // MARK: - Constructor
    init(with service:CarePlanService) {
        self.service = service
    }
    
    var arrData = [ListingSectionModel]()
    var dateOfPlan = ""
    var planAddedBy = ""

    //MARK: -Table view methods
    func numberOfSection()-> Int{
        return arrData.count
    }
    func numberOfRows(section : Int)-> Int{
        let listModel = self.arrData[section]
        let listArray = listModel.content
        return listArray?.count ?? 0
    }
    func roomForIndexPath(_ indexPath: IndexPath) -> ListModel? {
        let listModel = self.arrData[indexPath.section]
        let listArray = listModel.content
        return listArray?[indexPath.row] ?? ListModel(title: "", value: "")
    }
    
    func titleForSectionHeader(section : Int) -> String{
        let listModel = self.arrData[section]
        return listModel.headerTitle ?? ""
    }
    
    

}
//MARK:- Communication
extension SectionCarePlanViewModel{
    // MARK: - Network calls
    func getCommunicationPlan(patientId : Int) {
        self.isLoading = true

        service.getCommunicationPlan(with: patientId) { (result) in
            self.isLoading = false
            if let communication = result as? Communication{
                self.dateOfPlan = communication.createdDate ?? ""
                self.planAddedBy = communication.addedByName ?? ""
                self.arrData.append(self.getCallBell(communicationData: communication ))
                self.arrData.append(self.getLanguage(communicationData: communication))
                self.arrData.append(self.getVision(communicationData: communication))
                self.arrData.append(self.getHearing(communicationData: communication))
                self.isListLoaded = true
            }
        }
                
    }
    
    func getCallBell(communicationData : Communication) -> ListingSectionModel{
        return ListingSectionModel(headerTitle: "Call Bell/Pendant",
                                   content: [ListModel(title: "Call Bell/Pendant", value: communicationData.callBellType ?? ConstantStrings.NA),
                                        ListModel(title: "Notes", value: communicationData.callBellNotes ?? ConstantStrings.NA)])
    }
    
    func getLanguage(communicationData : Communication) -> ListingSectionModel{
        return ListingSectionModel(headerTitle: "Language & Speech",
                                content: [ListModel(title: "Primary Language", value: communicationData.languageName ?? ConstantStrings.NA),
                                          ListModel(title: "Speaks/Understands English", value: (communicationData.isSpeaksEnglish ?? false) ? "Yes" : "No"),
                                                    ListModel(title: "Needs Interpreter", value: (communicationData.isInterpreterNeeded ?? false) ? "Yes" : "No"),
                                        ListModel(title: "Notes", value: communicationData.languageNotes ?? ConstantStrings.NA),
                                        ListModel(title: "Speech", value: communicationData.speech ?? ConstantStrings.NA),
                                        ListModel(title: "Notes", value: communicationData.speechNotes ?? ConstantStrings.NA)])
    }
    
    func getVision(communicationData : Communication) -> ListingSectionModel{
        let dateEyeExam = Utility.convertServerDateToRequiredDate(dateStr: communicationData.lastEyeExamination ?? ConstantStrings.NA, requiredDateformat: DateFormats.mm_dd_yyyy)
        return ListingSectionModel(headerTitle: "Vision",
                                content: [ListModel(title: "Vision", value: communicationData.vision ?? ConstantStrings.NA),
                                        ListModel(title: "Wears contact lenses", value: (communicationData.isWearsContactLenses ?? false) ? "Yes" : "No"),
                                        ListModel(title: "Wears glasses", value: (communicationData.isWearsGlasses ?? false) ? "Yes" : "No"),
                                        ListModel(title: "Visual Acuity", value: communicationData.visualAcuity ?? ConstantStrings.NA),
                                        ListModel(title: "Eye Prosthesis", value: communicationData.eyeprosthesis ?? ConstantStrings.NA),
                                        ListModel(title: "Optometrist/Ophthalmologist", value: communicationData.ophthalmologist ?? ConstantStrings.NA),
                                        ListModel(title: "Date of Last Eye Exam", value: dateEyeExam),
                                        ListModel(title: "Notes", value: communicationData.visionNotes ?? ConstantStrings.NA)])
    }
    
    func getHearing(communicationData : Communication) -> ListingSectionModel{
        let dateEarExam = Utility.convertServerDateToRequiredDate(dateStr: communicationData.lastEarExamination ?? ConstantStrings.NA, requiredDateformat: DateFormats.mm_dd_yyyy)
        var aidsString = ""
        aidsString += (communicationData.rightHearingAid ?? false) ? "Right Hearing Aid : Yes \nSerial Number : \(communicationData.rightAidSerialNumber ?? 0)" : ""
        aidsString += aidsString.count != 0 ? "\n" : ""
        aidsString += (communicationData.leftHearingAid ?? false) ? "Left Hearing Aid : Yes \nSerial Number : \(communicationData.leftAidSerialNumber ?? 0)" : ""
        
        if aidsString.count == 0 {
            aidsString = ConstantStrings.NA
        }
        
        return ListingSectionModel(headerTitle: "Hearing",
                                content: [ListModel(title: "Ear Prosthesis", value: communicationData.hearingType ?? ConstantStrings.NA),
                                        ListModel(title: "Hearing perception", value: communicationData.hearingPerception ?? ConstantStrings.NA),
                                        ListModel(title: "Makes self understood", value: communicationData.makesSelfUnderstood ?? ConstantStrings.NA),
                                        ListModel(title: "Able to understand others", value: communicationData.ableToUnderstandOthers ?? ConstantStrings.NA),
                                        ListModel(title: "Notes", value: communicationData.notesOnUnderstanding ?? ConstantStrings.NA),
                                        ListModel(title: "Hearing Aids", value: aidsString),
                                        ListModel(title: "Hearing Aids kept with", value: communicationData.hearingAids ?? ConstantStrings.NA),
                                        ListModel(title: "Uses Aids independently", value:(communicationData.usesAidsIndependently ?? false) ? "Yes" : "No"),
                                        ListModel(title: "Audiologist", value: communicationData.audiologist ?? ConstantStrings.NA),
                                        ListModel(title: "Date of last Ear Exam", value: dateEarExam),
                                        ListModel(title: "Notes", value: communicationData.hearingNotes ?? ConstantStrings.NA)])
    }
}

//MARK:- Routine
extension SectionCarePlanViewModel{
    func getRoutinePlan(patientId : Int) {
        self.isLoading = true

        service.getRoutinePlan(with: patientId) { (result) in
            self.isLoading = false
            if let routine = result as? Routine{
                self.dateOfPlan = routine.createdDate ?? ""
                self.planAddedBy = routine.addedByName ?? ""
                self.arrData.append(self.getOxygenTherapy(data: routine))
                self.arrData.append(self.getSleep(data: routine))
                self.arrData.append(self.getLaundry(data: routine))

                self.isListLoaded = true
            }
        }
        
        

        
    }
    
    func getOxygenTherapy(data : Routine) -> ListingSectionModel{
        return ListingSectionModel(headerTitle: "Oxygen Therapy",
                                   content: [ListModel(title: "Oxygen Therapy", value: (data.oxygenTherapyId ?? false) ? "Yes" : "No"),
                                        ListModel(title: "Amount", value: data.amountLMin ?? ConstantStrings.NA),
                                        ListModel(title: "Delivery", value:  data.delivaryName ?? ConstantStrings.NA),
                                        ListModel(title: "Oxygen Saturation maintain at", value:  data.oxygenSaturation ?? ConstantStrings.NA),
                                        ListModel(title: "Glucose Monitoring", value:  (data.isGlucosemonitoring ?? false) ? "Yes" : "No"),
                                        ListModel(title: "Fasting Blood Sugar Test", value:  (data.isFastingBloodSugarTest ?? false) ? "Yes" : "No"),
                                        ListModel(title: "Random Blood Sugar Test", value: (data.randomBloodSugarTest ?? false) ? "Yes" : "No"),
                                        ListModel(title: "Notes", value:  data.glucoseNotes ?? ConstantStrings.NA)])
    }
    
    func getSleep(data : Routine) -> ListingSectionModel{
        let bedTime = Utility.convertServerDateToRequiredDate(dateStr: data.bedTime ?? ConstantStrings.NA, requiredDateformat: DateFormats.hh_mm_ss_a)
        let wakeupTime = Utility.convertServerDateToRequiredDate(dateStr: data.wakesUpAt ?? ConstantStrings.NA, requiredDateformat: DateFormats.hh_mm_ss_a)
        let restTime = Utility.convertServerDateToRequiredDate(dateStr: data.restTime ?? ConstantStrings.NA, requiredDateformat: DateFormats.hh_mm_ss_a)

        return ListingSectionModel(headerTitle: "Sleep",
                                   content: [ListModel(title: "Bed Time", value: bedTime),
                                        ListModel(title: "Wakes Up At", value: wakeupTime),
                                        ListModel(title: "Rest Time", value: restTime ),
                                        ListModel(title: "Notes", value:  data.sleepNotes ?? ConstantStrings.NA)])
    }
    
    func getLaundry(data : Routine) -> ListingSectionModel{
        return ListingSectionModel(headerTitle: "Laundry",
                                   content: [ListModel(title: "Laundry done by", value: data.loundryDoneBy ?? ConstantStrings.NA),
                                             ListModel(title: "Laundry Days", value: data.loundryDays ?? ConstantStrings.NA),
                                        ListModel(title: "Notes", value:  data.laundryNotes ?? ConstantStrings.NA)])
    }

}
