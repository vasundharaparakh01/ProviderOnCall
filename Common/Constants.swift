//
//  Constants.swift
//  appName
//
//  Created by Vasundhara Parakh on 2/25/20.
//  Copyright © 2020 smartData Enterprises (I) Ltd. All rights reserved.
//

import Foundation
import UIKit

enum Screen {
    static let width     = UIScreen.main.bounds.size.width
    static let height    = UIScreen.main.bounds.size.height
    static let scale     = UIScreen.main.scale
}

struct Device {
    static let IS_IPAD = UIDevice.current.userInterfaceIdiom == .pad
    static let IS_IPHONE = UIDevice.current.userInterfaceIdiom == .phone
}

enum Config {

    // STAGING
    #if STAGING
    static let BASE_URL:String = "https://"
    static let resetPassword_URL = "https://"
    #else
    static let BASE_URL:String = "https://"
    static let resetPassword_URL = "https://"
    #endif
//
    
   

//MARK:- APITargetPoint
enum APITargetPoint{
    //User
    static let verifyBusiness   = "VerifyBusinessNameMobile" //"VerifyBusinessName"
    
    static let login                           = "Login/NurseLogin"
    static let forgotPassword                  = "ForgotPassword"
    static let getStaffSetting = "StaffSetting/GetStaffSetting"
    static let updateStaffSetting = "StaffSetting/UpdateStaffSetting"
    static let clockOut = "Login/UpdateClockOut"
    static let getClockInStatus = "Login/ClockInStatus"
    
    //Residents
    static let getResidents                    = "Patients/GetPatients"
    static let getResidentHeaderInfo           = "Patients/GetPatientHeaderInfo"
    static let getResidentVitals               = "PatientsVitals/GetVitals"
    static let saveVital                               = "PatientsVitals/SaveVital"
    static let getResidentAllergies             = "PatientsAllergy/GetAllergies"
    static let getResidentDiagnosis             = "PatientsDiagnosis/GetDiagnosis"
    static let getResidentMedication             = "PatientsMedication/GetMedication"
    static let getOverCounterMedication             = "PatientsMedication/GetOverCounterMedication"
    static let getHerbalMedication = "PatientsMedication/GetHerbalSupplement"
    static let getAllPatientFoodDiary = "MealPlan/GetAllPatientFoodDiaryByPatientId"//GetAllPatientFoodDiary"
    static let getNotification = "api/Notification/GetNotifications"
    static let deleteBulkNotification = "api/Notification/DeleteBulkNotification"
    static let getTNC = "TermsAndConditions/GetTermsAndCondition"
    static let saveTNC = "Login/UpdateAgreemetnAndFistLoginStatus"
    
    //Common
    static let getMasterData                   = "api/MasterData/MasterDataByNameForMobile"
    static let getMealCategory                   = "MealPlan/GetAllMasterMealCategoryForDropDown"
    static let getMealItem                   = "MealPlan/GetAllMasterMealItemForDropDown"
    static let getTypeOfFood                   = "MealPlan/GetAllMasterTypeofFoodForDropDown"
    static let getFluidConsistency                   = "MealPlan/GetAllMasterFluidConsistencyForDropDown"
    static let getPatientMasterProgressNotes      = "Patients/GetPatientMasterProgressNotes"
    //CarePlan
    static let getCommunicationPlan = "GetCommunicationCarePlanByPatientId"
    static let getRoutinePlan = "CarePlan/GetRoutineCarePlanByPatientId"
    static let getConginitiveStatusPlan = "CarePlan/GetCognitiveStatusCarePlanByPatientId"
    static let getBehaviour = "CarePlan/GetBehaviourCarePlanByPatientId"
    static let getSafety = "CarePlan/GetSafetyCarePlanByPatientId"
    static let getNutrition = "CarePlan/GetNutritionHydrationCarePlanByPatientId"
    static let getBathing = "CarePlan/GetBathingCarePlanByPatientId"
    static let getDressing = "CarePlan/GetDressingCarePlanByPatientId"
    static let getHygiene = "CarePlan/GetHygieneCarePlanByPatientId"
    static let getSkin = "CarePlan/GetSkinCarePlanByPatientId"
    static let getMobility = "CarePlan/GetMobilityCarePlanByPatientId"
    static let getTransfer = "CarePlan/GetTransferCarePlanByPatientId"
    static let getToileting = "CarePlan/GetToiletingCarePlanByPatientId"
    static let getBladderContinenece = "CarePlan/GetBladderCarePlanByPatientId"
    static let getBowelContinenece = "CarePlan/GetBowelCarePlanByPatientId"
    
    //PointOfCare
    static let getADLTracking = "PointOfCare/GetADLTrackingToolByPatientId"
    static let getMoodAndBehaviour = "PointOfCare/GetMoodAndBehaviorByPatientId"
    static let saveMoodAndBehaviour = "PointOfCare/SaveUpdateMoodAndBehavior"
    static let saveADL = "PointOfCare/SaveUpdateADLTrackingTool"
    static let save_NCF_Safety = "SafetyAndSecurity/SaveUpdateSafetyAndSecurity"
    static let save_NCF_PersonalHygiene = "PersonalHygiene/SaveUpdatePersonalHygiene"
    static let save_NCF_Activity = "ActivityExercise/SaveUpdateActivityExercise"
    static let save_NCF_Sleep = "SleepRestAndComfort/SaveUpdateSleepRestAndComfortMobile"
    //"SleepRestAndComfort/SaveUpdateSleepRestAndComfort"
    static let save_NCF_Nutrition = "NutritionAndHydration/SaveUpdateNutritionAndHydrationMobile"
    //"NutritionAndHydration/SaveUpdateNutritionAndHydration"
    static let saveESASRating = "ESASRatings/SaveUpdateESASRatings"
    static let saveAsDraftESASRating = "ESASRatings/SaveUpdateESASRatingsSaveAsDraft"
    static let getLocation = "MasterShift/GetPatientLocationById"
    static let getShift = "MasterShift/GetShiftByLocationIds"
    static let getESASGraph = "ESASRatings/GetViewESASRatingsByPatientId"
    static let getShiftByUnitId = "MasterShift/GetShiftByUnitId"
    static let getPersonalHygoeneDetail = "PersonalHygiene/GetPersonalHygieneByPatientId"
    static let getSleepRestDetail = "SleepRestAndComfort/GetSleepRestAndComfortByPatientId"
    static let getSafetySecurity = "SafetyAndSecurity/GetSafetyAndSecurityByPatientId"
    static let getActivityDetail = "ActivityExercise/GetActivityExerciseByPatientId"
    static let getDraftStatus = "PersonalHygiene/GetNCFIsDraftStatusMobile"
    static let getESASRatingDetail = "ESASRatings/GetESASRatingsByPatientId"
    static let getNCFNutritionDetail = "NutritionAndHydration/GetNutritionAndHydrationSaveAsDraft"
    static let getInputOutputDetail = "NutritionAndHydration/MobileInputOutoutChartByPatientId"
    static let InputOutputTrendGraph = "/NutritionAndHydration/InputOutputTrendGraph"
    
    static let SafetyAndSecurity_Discard = "SafetyAndSecurity/DiscardSaveAsDraftById"
    static let PersonalHygiene_Discard = "PersonalHygiene/DiscardPersonalHygieneById"
    static let NutritionAndHydration_Discard = "NutritionAndHydration/DiscardNutritionAndHydrationById"
    static let ActivityExercise_Discard = "ActivityExercise/DiscardActivityExerciseById"
    static let SleepRestAndComfort_Discard = "SleepRestAndComfort/DiscardSleepRestAndComfortById"
    static let PointOfCare_ADLTrackingToolById_Discard = "PointOfCare/DiscardADLTrackingToolById"
    static let PointOfCare_MoodAndBehaviorById_Discard = "PointOfCare/DiscardMoodAndBehaviorById"

    //Assessment
    static let saveWoundAssessment = "Assessment/CreateUpdateWoundAssessment"
    static let savePainAssessment = "Assessment/CreateUpdatePainAssessment"
    static let saveSkinAssessment = "Assessment/CreateUpdateSkinAssessment"
    static let saveFallAssessment = ""
    static let saveGlosgowAssessment = "Assessment/CreateUpdateGlasgowComScaleAssessment"
    static let saveNutritionAssessment = "Assessment/CreateUpdatePainNutritionFluidintakeAssessment"
    static let createFallAssessment = "Assessment/CreateFallAssessment"
    
    
    
    //Task
    static let getTaskList = "api/PatientAppointments/GetMyTaskListMobile"
    static let getSubTaskList = "api/PatientAppointments/GetMySubTaskListByTaskId"
    static let updateTaskStatus = "api/PatientAppointments/UpdateTaskStatus"
    static let getFollowingTaskList = "api/PatientAppointments/GetTaskCreatedList"
    static let saveTask = "api/PatientAppointments/SaveMobileTask?IsFinish=false&IsAdmin=false"
    static let saveMobileAppoitment = "api/PatientAppointments/SaveMobileTask?IsFinish=true&IsAdmin=false"
    static let getMasterResidentList = "api/PatientAppointments/GetPatientByStaffForMobile"
    static let getPatientStaffDropdown = "api/PatientAppointments/GetStaffAndPatientByLocation"
    static let getShiftSchedule = "MasterShift/GetShiftWithShiftId"
    static let getUnitByLocationId = "MasterShift/GetUnitByLocationId"
    //EMAR
    static let getEMARList = "PatientsMedication/GetEMRPatientList"
    static let getEMARListByTime = "PatientsMedication/GetEMRPatientListByDueTime"
    
    static let getPatientDrugHistory = "Drugs/GetPatientDrugHistory"
    static let getDrugSideEffectBulk = "Drugs/GetDrugSideEffectBulk"
    static let getDrugDiseaseBulk = "Drugs/GetDrugDiseaseBulk"
    static let getDrugIndicationBulk = "Drugs/GetDrugIndicationBulk"
    static let getDrugAllergyBulkPost = "Drugs/GetDrugAllergyBulk"
    static let geriatricsPrecautionBulkPost = "Drugs/DrugGeriatricsPrecautionBulk"
    static let getDrugFoodFamilyEducationBulk = "Drugs/DrugFoodFamilyEducationBulk"
    static let getDrugInterationBulk = "Drugs/GetDrugInterationBulk"
    static let getDrugDuplicateTherapyBulk = "Drugs/GetDrugDuplicateTherapyBulk"
    static let getDrugDrugIntration = "Drugs/GetDrugDrugIntration"
    static let getEMRPatientMedicationList = "PatientsMedication/GetEMRPatientMedicationList"
    static let saveEditMedication = "PatientsMedication/SaveEmarMedication"
    static let getMedicationDetail = "PatientsMedication/GetEmarMedication"
    static let updateForMissedMedication = "PatientsMedication/UpdateForMissedMedication"
    static let getCurrentmedicationById = "Plan/GetCurrentmedicationById"
    
    //Inventory
    static let getInventoryList = "MasterInventory/GetAllMasterInventoryList"
    static let deleteInventoryItem = "MasterInventory/DeleteMobileMasterInventoryById"
    static let getInventoryAddDetail = "MasterInventory/GetSaveUpdateMasterInventoryById"
    static let getInventoryDetail = "MasterInventory/GetInventoryDetailsById"
    static let addInventory = "MasterInventory/SaveUpdateMasterInventory"
    static let getPatients = "Patients/GetPatientName"
    static let saveInventoryTrack = "InventoryTrack/SaveUpdateInventoryTrack"
    static let saveReorder = "MasterInventory/ReorderInventory"
    
    //Task
    static let deleteTask = "api/PatientAppointments/DeleteAppointmentMobile"
    static let cancelTask = "api/PatientAppointments/CancelAppointments"
    
    //Virtual Consult
    static let getVideoAppointmentList = "api/PatientAppointments/GetVideoAppointmentList"
    static let getPatientEncounterDetails = "patient-encounter/GetPatientEncounterDetails"
    static let getTelehealthSession = "api/Telehealth/GetTelehealthSession"//anonymous-call/GetTelehealthSession"
    static let newGetTelehealthSession = "api/Telehealth/GetTelehealthSessionByAppointmentId"
    
    static let startSessionRecording = "api/Telehealth/StartRecording"
    static let stopSessionRecording = "api/Telehealth/StopRecording"
    static let uploadDocument = "Chat/UploadVirtualConsultDocument"
    static let getChatDocument = "Chat/GetChatDocument"
    static let getChatHistory = "Chat/GetGroupChatHistory"
    static let getPatientAppointmentList = "api/PatientAppointments/GetPatientAppointmentList"
    static let getStaffAvailabilityMobile = "AvailabilityTemplates/GetStaffAvailabilityMobile"
    static let saveUpdateAvailabilityWithLocation = "AvailabilityTemplates/SaveUpdateAvailabilityWithLocation"
    static let getStaffAllAvailabilityMobile = "AvailabilityTemplates/GetStaffAllAvailabilityMobile"
    //Testing "AvailabilityTemplates/DummyApi"//"
    static let savePatientAppointment = "api/PatientAppointments/SavePatientAppointment"
    
    //TAR
    static let getTARByPatientId = "TAR/GetTARByPatientId"
    static let createTAR = "TAR/CreateTAR"
    
    //Incident Report
    static let saveUpdateIncidentReport = "IncidentReport/SaveUpdateIncidentReport"
    
    static let saveMealPlan = "MealPlan/SaveUpdateMealPlan"
    
    
    //Checkin-out
    static let PatientCheckin = "Patients/PatientCheckin"
    static let StaffGeoLocationGetTodaysLastLocation = "StaffGeoLocation/GetTodaysLastLocation"
    static let UpdateStaffCurrentLocation = "StaffGeoLocation/UpdateStaffCurrentLocation"
}

// MARK: Pagination
enum Pagination {
    static let pageSize = 10
}
// MARK: Pagination
enum TagConstants {
    static let DoubleTF_FirstTextfield_Tag = 1000
    static let DoubleTF_SecondTextfield_Tag = 2000
    static let RecursiveTF_FirstTextfield_Tag = 5000
    static let RecursiveTF_SecondTextfield_Tag = 6000
    static let RecursiveTF_ThirdTextfield_Tag = 7000
    static let RecursiveTF_FourthTextfield_Tag = 8000
    
}

//MARK:- ReportConstants
struct ReportConstants {
    static let dummyReportUrl = "https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf"
    static let reportName = "Report.pdf"
}

// MARK: Color
// Declare all all hex colors here
// Example: self.view.backgroundColor = AppColor.backgroundColor
enum Color {
    static let Primary       = UIColor("#2D79B9")
    static let Secondary     = UIColor("#42B3B5")
    static let Button        = UIColor("#33AFFF")
    static let LightGray     = UIColor("#A7A7A7")
    static let DarkGray      = UIColor("#666565")
    static let Line          = UIColor(666565, alpha: 0.2)
    static let Error         = UIColor("#FF0000")
    static let Loader         = UIColor("#4C97CD")
    static let Green          = UIColor("#4BB80E")
    static let Red          = UIColor("#F80B0B")
    static let Blue         = UIColor("#3D9CC4")
    static let transparentBackground = UIColor.black.withAlphaComponent(0.6)
    static let ListLabelHeading = UIColor("#333333")
    static let ListLabelValue = UIColor("#7A6F6F")
    static let ListLabelRed = UIColor("#FF2E2E")
    static let HighlightTextLPN = UIColor("#3890C6")
    static let LowSliderColor = UIColor.yellow
    static let MediumSliderColor = UIColor.green
    static let HighSliderColor = UIColor.red
    static let SectionTitleColor = UIColor("#454F63")
    static let ESASColor0 = UIColor("#219001")
    static let ESASColor1 = UIColor("#53aa00")
    static let ESASColor2 = UIColor("#7dbe00")
    static let ESASColor3 = UIColor("#a1d000")
    static let ESASColor4 = UIColor("#cfe701")
    static let ESASColor5 = UIColor("#ffd001")
    static let ESASColor6 = UIColor("#ffd001")
    static let ESASColor7 = UIColor("#ff9a00")
    static let ESASColor8 = UIColor("#ff6f00")
    static let ESASColor9 = UIColor("#fe4300")
    static let ESASColor10 = UIColor("#ff1600")
    
}
// MARK: TextFiledType
// Declare all TextFiledType
//
enum InputTypes{
    case email
    case password
    case mobile
    case text
    case alphanumeric
    case numeric
    case username
    
}

enum TextfieldTypes{
    case email
    case password
}

// MARK: Font
// Declare all all fonts here
// Example: something.font = AppFont.Regular.of(1024)
enum Font: String {
    case Regular = "Poppins-Regular"
    case Medium  = "Poppins-Medium"
    case Bold  = "Poppins-Bold"
    func of(size: CGFloat) -> UIFont {
        return UIFont(name: self.rawValue, size: size)!
    }
}

// MARK: Key
// Declare all keys here.
enum Key {
    
    static let DeviceType = "iOS"
    enum Beacon {
        static let ONEXUUID = "xxxx-xxxx-xxxx-xxxx"
    }
    
    enum UserDefaults {
        static let k_App_Running_FirstTime = "userRunningAppFirstTime"
    }
    
    enum Headers {
        static let Authorization = "Authorization"
        static let ContentType = "Content-Type"
    }
    enum Google {

        static let serverKey = "some key here"
    }
    enum Params {
        static let name                 = "name"
        static let email                = "email"
        static let password             = "password"
        static let ipAddress            = "ipAddress"
        static let userName             = "userName"
        static let searchKey            = "searchKey"
        static let searchText            = "searchText"
        static let locationIDs          = "locationIDs"
        static let pageNumber           = "pageNumber"
        static let pageSize             = "pageSize"
        static let sortOrder            = "sortOrder"
        static let id                   = "id"
        static let patientId            = "patientId"
        static let resetPasswordURL     = "resetPasswordURL"
        static let totalRecords = "totalRecords"
        static let masterdata = "masterdata"
        static let masterDataNames = "masterDataNames"
        static let SearchDate = "SearchDate"
        static let weekStartDate = "weekStartDate"
        static let weekEndDate = "weekEndDate"
        static let isMedication = "isMedication"
        static let isReorder = "isReorder"
        static let typeAppointment = "Type"
        static let searchDate = "searchDate"
        static let date = "Date"
        static let base64 = "base64"
        static let Re_Ordrer_Type = "type"
        static let UnitId         = "UnitId"
        static let ShiftId         = "ShiftId"
        static let LocationId         = "LocationId"
        
        //Vitals
        static let bpDiastolic = "bpDiastolic"
        static let bpSystolic = "bpSystolic"
        static let heightIn = "heightIn"
        static let weightLbs = "weightLbs"
        static let heartRate = "heartRate"
        static let pulse = "pulse"
        static let respiration = "respiration"
        static let bmi = "bmi"
        static let temperature = "temperature"
        static let vitalDate = "vitalDate"
        static let vitalPositionId = "vitalPositionId"
        static let saturation = "saturation"
        static let vitalTime = "vitalTime"
        static let vitalBPMethodId = "vitalBPMethodId"
        static let vitalTempDeviceId = "vitalTempDeviceId"
        static let vitalTempUnitId = "vitalTempUnitId"
        static let vitalHeightUnitId = "vitalHeightUnitId"
        static let vitalWeightUnitId = "vitalWeightUnitId"
        static let vitalTempMeasurmentSiteId = "vitalTempMeasurmentSiteId"
        static let hght = "hght"
        static let wght = "wght"
        static let tmpunt = "tmpunt"
        static let position = "position"
        static let rbsUnit = "vitalRbsUnitId"//"rbsUnit"
        static let fbsUnit = "vitalFbsUnitId"//"fbsUnit"
        static let rbs = "rbs"
        static let fbs = "fbs"
        static let isDraft = "isDraft"
        static let drugId = "drugId"
        //Task
        static let taskId = "taskId"
        static let taskStatusId = "taskStatusId"
        static let cancelTypeId = "cancelTypeId"
        static let cancelReason = "cancelReason"
        static let ids = "ids"
        
        
        //Vitals
              static let idFall = "id"
              static let fallDate = "fallDate"
              static let fallTime = "fallTime"
              static let typeOfFallID = "typeOfFallID"
              static let episodeID = "episodeID"
              static let preFallID = "preFallID"
              static let postFallID = "postFallID"
              static let prbps = "prbps"
              static let patientBP = "patientBP"
              static let rrbps = "rrbps"
              static let otowSat = "otowSat"
              static let temprature = "temprature"
              static let tempratureUnitID = "tempratureUnitID"
              static let inr = "inr"
              static let fractureID = "fractureID"
              static let patientID = "patientID"
              static let bruises = "bruises"
              static let patientCarePlanReviewed = "patientCarePlanReviewed"
              static let details = "details"
              static let action = "action"
              static let outcome = "outcome"
              static let recomandation = "recomandation"
              static let signature = "signature"
              static let assessmentDate = "assessmentDate"
              static let assessmentTime = "assessmentTime"//"fbsUnit"
              static let notifyPhysician = "notifyPhysician"
              static let notifyFamily = "notifyFamily"
              static let notifyOthers = "notifyOthers"
              static let patientFallFrom = "patientFallFrom"
              //Task
              static let fallRisk = "fallRisk"
              static let safetyMeasures = "safetyMeasures"
              static let patientMoves = "patientMoves"
              static let physicianNotification = "physicianNotification"
              static let familyNotification = "familyNotification"
              static let otherNotification = "otherNotification"
        
        
        
        //Add Document
        static let appointmentId = "appointmentId"
        static let staffID = "staffID"
        static let isAvailabel = "isAvailabel"
        static let locationId = "locationId"
        static let shiftId = "shiftId"
        static let fromDate = "fromDate"
        static let toDate = "toDate"
        static let patientIds = "patientIds"
        static let locationIds = "locationIds"
        static let startDate = "startDate"
        static let stopDate = "stopDate"
        static let staffIds = "staffIds"
        static let staffId = "staffId"
        static let StaffId_Resident = "StaffId"
        
        static let BusinessName = "BusinessName"
        //Mood Tracking
        enum MoodTracking{
            static let makeNegativeStatementId = "makeNegativeStatementId"
            static let repetativeQuestionId = "repetativeQuestionId"
            static let repetativeVerbilizationId = "repetativeVerbilizationId"
            static let persistAngerId = "persistAngerId"
            static let runSelfDownId = "runSelfDownId"
            static let expressUnrealisticFearId = "expressUnrealisticFearId"
            static let makeRecurrentStatementId = "makeRecurrentStatementId"
            static let frequentlyComplainAboutHealthId = "frequentlyComplainAboutHealthId"
            static let anxiousComplaintsId = "anxiousComplaintsId"
            static let facialExpressionsId = "facialExpressionsId"
            static let cryingOrTearfulnessId = "cryingOrTearfulnessId"
            static let repetitivePhysicalMovementId = "repetitivePhysicalMovementId"
            static let withdrawnOrdisinterestedInSurroundingsId = "withdrawnOrdisinterestedInSurroundingsId"
            static let decreasedSocialInteractionId = "decreasedSocialInteractionId"
            static let wandersWithNoRationalPurposeId = "wandersWithNoRationalPurposeId"
            static let screamsOrThreatensCursesId = "screamsOrThreatensCursesId"
            static let hitsOrShovesOrScratchesId = "hitsOrShovesOrScratchesId"
            static let sociallyInappropriateId = "sociallyInappropriateId"
            static let resistCareId = "resistCareId"
            static let ratingOfPainRating = "ratingOfPainRating"
            static let sleptOrDozedMoreThanOneHourThisShiftId = "sleptOrDozedMoreThanOneHourThisShiftId"
            static let spentTimeInLeisureActivitiesPursuitOwnInterestId = "spentTimeInLeisureActivitiesPursuitOwnInterestId"
        }
        
        //ADL Tracking
        enum ADLTracking{
            static let movesInBedSelfPerformanceId = "movesInBedSelfPerformanceId"
            static let movesInBedSupportProvidedId = "movesInBedSupportProvidedId"
            static let walksInRoomSelfPerformanceId = "walksInRoomSelfPerformanceId"
            static let walksInRoomSupportProvidedId = "walksInRoomSupportProvidedId"
            static let walksInHallSelfPerformanceId = "walksInHallSelfPerformanceId"
            static let walksInHallSupportProvidedId = "walksInHallSupportProvidedId"
            static let movesOnUnitSelfPerformanceId = "movesOnUnitSelfPerformanceId"
            static let movesOnUnitSupportProvidedId = "movesOnUnitSupportProvidedId"
            static let movesOffUnitSelfPerformanceId = "movesOffUnitSelfPerformanceId"
            static let movesOffUnitSupportProvidedId = "movesOffUnitSupportProvidedId"
            static let transferSelfPerformanceId = "transferSelfPerformanceId"
            static let transferSupportProvidedId = "transferSupportProvidedId"
            static let dresesSelfPerformanceId = "dresesSelfPerformanceId"
            static let dresesSupportProvidedId = "dresesSupportProvidedId"
            static let unDresesSelfPerformanceId = "unDresesSelfPerformanceId"
            static let unDresesSupportProvidedId = "unDresesSupportProvidedId"
            static let eatAndDrinkSelfPerformanceId = "eatAndDrinkSelfPerformanceId"
            static let eatAndDrinkSupportProvidedId = "eatAndDrinkSupportProvidedId"
            static let usesToiletSupportProvidedId = "usesToiletSupportProvidedId"
            static let usesToiletSelfPerformanceId = "usesToiletSelfPerformanceId"
            static let personalHygieneSelfPerformanceId = "personalHygieneSelfPerformanceId"
            static let personalHygieneSupportProvidedId = "personalHygieneSupportProvidedId"
            static let bathingSupportProvidedId = "bathingSupportProvidedId"
            static let bathingSelfPerformanceId = "bathingSelfPerformanceId"
            static let bladderId = "bladderId"
            static let bowelId = "bowelId"
            static let notes = "notes"
        }
        enum NursingCareFlow{
            enum Safety{
                static let transfer = "transfer"
                static let careDoneAccordingToCarePlanId = "careDoneAccordingToCarePlanId"
                static let sideRailsUpId = "sideRailsUpId"
                static let safetyRoundsId = "safetyRoundsId"
                static let cluttersRemovedId = "cluttersRemovedId"
                static let callBellWithInReachId = "callBellWithInReachId"
                static let oneOnOneCompanionshipId = "oneOnOneCompanionshipId"
                static let notes = "notes"
                static let fallId = "fallId"
                static let fallTime = "fallTime"
                static let fallPatternId = "fallPatternId"
                static let pressureUlcer = "pressureUlcer"
                static let bodySite = "bodySite"
                static let bodySiteId = "bodySiteId"
                static let behaviourTypeId = "behaviourTypeId"
                static let behaviourTime = "behaviourTime"
                static let behaviourId = "behaviorId"//"behaviourId"
                static let behaviorTypes = "behaviorTypes"
                
            }
            
            enum PersonalHygiene{
                static let mouthCareId = "mouthCareId"
                static let bathTypeId = "bathTypeId"
                static let waterTemprature = "waterTemprature"
                static let bathId = "bathId"
                static let temperatureUnit = "temperatureUnit"
                static let nailCareId = "nailCareId"
                static let notes = "notes"
                static let skinProtocolId = "skinProtocolId"
            }
            
            enum Activity{
                static let usualAsPerSelfId = "usualAsPerSelfId"
                static let participitedInActivityId = "participitedInActivityId"
                static let weightBearingId = "weightBearingId"
                static let abnormilityDetectedId = "abnormilityDetectedId"
                static let wellToleratedId = "wellToleratedId"
                static let transferSelfPerformanceId = "transferSelfPerformanceId"
                static let transferSupportProvidedId = "transferSupportProvidedId"
                static let repositioningId = "repositioningId"
                static let rangeOfMotionId = "rangeOfMotionId"
                static let notes = "notes"
            }
            
            enum Sleep{
                static let usualAsPerSelfId = "usualAsPerSelfId"
                static let noAbnormilityDetectedId = "noAbnormilityDetectedId"
                static let painId = "painId"
                static let onGoingPainId = "onGoingPainId"
                static let sleepAtTime = "sleepAtTime"
                static let awakeAtTime = "awakeAtTime"
                static let notes = "notes"
            }
            
            enum Nutrition{
                static let mealTime = "mealTime"
                static let appetiteId = "appetiteId"
                static let typeOfDietId = "typeOfDietId"
                static let dietAmount = "dietAmount"
                static let snack = "snack"
                static let notes = "notes"
                static let numberOfFluidIntake = "numberOfFluidIntake"
                static let numberOfBowelMovement = "numberOfBowelMovement"
                static let numberOfUrinaryVoids = "numberOfUrinaryVoids"
                static let emesisSubTotal = "emesisSubTotal"
                static let bloodLossTotal = "bloodLossTotal"
                static let incontinentBowelId = "incontinentBowelId"
                static let incontinentUrinaryId = "incontinentUrinaryId"
                static let briefPullUp = "briefPullUp"
                static let perinealPadsCount = "perinealPadsCount"
                static let colorUrine = "colorUrine"
                static let voidingPatternGUId = "voidingPatternGUId"
                static let mealEaten = "mealEaten"
                static let percentOfMealEaten = "percentOfMealEaten"
                static let totalFluidOutput = "totalFluidOutput"
                static let dynamicFluidIntake = "dynamicFluidIntake"
                static let fluidIntake = "fluidIntake"
                static let fluidIntakeAmount =   "fluidIntakeAmount"
                static let fluidIntakeTime =    "fluidIntakeTime"
                static let dynamicUrinary = "dynamicUrinary"
                static let urinAmount =    "urinAmount"
                static let urinColor =    "urinColor"
                static let urinTime =    "urinTime"
                static let dynamicEmesis = "dynamicEmesis"
                static let emesisAmount =    "emesisAmount"
                static let emesisTime =    "emesisTime"
                static let dynamicBowel = "dynamicBowel"
                static let amountBowelId =    "amountBowelId"
                static let consistencyId =    "consistencyId"
                static let bowelTime =    "bowelTime"
                static let dynamicBloodLoss = "dynamicBloodLoss"
                static let bloodLossAmount =    "bloodLossAmount"
                static let bloodLossTime =   "bloodLossTime"
                static let rectalCheckPerformed = "rectalCheckPerformed"
                static let bowelCareId = "bowelCareId"
            }
        }
        
        enum ESAS{
            enum Rating{
                static let pain = "pain"
                static let tired = "tired"
                static let nauseated = "nauseated"
                static let depressed = "depressed"
                static let anxious = "anxious"
                static let drowsy = "drowsy"
                static let appetite = "appetite"
                static let wellbeing = "wellbeing"
                static let shortnessOfBreath = "shortnessOfBreath"
                static let locationId = "locationId"
                static let shiftId = "shiftId"
            }
        }
        
        enum WoundAssessment{
            static let woundTypeId = "woundTypeId"
            static let deviceAnatomicVisibleStructuresId = "deviceAnatomicVisibleStructuresId"
            static let presentConditionAdmitionId = "presentConditionAdmitionId"
            static let injuryCauseId = "injuryCauseId"
            static let dtConditionAbatementId = "dtConditionAbatementId"
            static let woundEpisodeId = "woundEpisodeId"
            static let trendsId = "trendsId"
            static let onsetImpairementId = "onsetImpairementId"
            static let bodySitesId = "bodySitesId"
            static let bodyLocationQualifiersId = "bodyLocationQualifiersId"
            static let anatomicLaterilityId = "anatomicLaterilityId"
            static let periWoundDecriptionsId = "periWoundDecriptionsId"
            static let woundBaseAppearanceId = "woundBaseAppearanceId"
            static let woundBaseColorId = "woundBaseColorId"
            static let woundBedAppearsId = "woundBedAppearsId"
            static let woundBedColorsId = "woundBedColorsId"
            static let woundEdgeDescriptionsId = "woundEdgeDescriptionsId"
            static let tunnelingWoundsId = "tunnelingWoundsId"
            static let tunnelingWoundLengthId = "tunnelingWoundLengthId"
            static let tunnelingClockPositionId = "tunnelingClockPositionId"
            static let woundUnderminingId = "woundUnderminingId"
            static let woundUnderminingLengthId = "woundUnderminingLengthId"
            static let woundUnderminingClockPositionId = "woundUnderminingClockPositionId"
            static let woundExudateId = "woundExudateId"
            static let woundAreaId = "woundAreaId"
            static let woundDrainageAmountId = "woundDrainageAmountId"
            static let woundOdorExudateId = "woundOdorExudateId"
            static let woundColorExudateId = "woundColorExudateId"
            static let woundAppearanceExudateId = "woundAppearanceExudateId"
            static let woundWidthId = "woundWidthId"
            static let woundDepthId = "woundDepthId"
            static let woundLengthId = "woundLengthId"
            static let woundAssessmentImpressionId = "woundAssessmentImpressionId"
            static let assessmentModelId = "assessmentModelId"
            static let type = "type"
            static let value = "value"
            static let pressureUlcerStagingID = "pressureUlcerStagingID"
            static let imagePath = "imagePath"
            static let odorWoundExudate = "odorWoundExudate"
            static let woundEdgeColor = "woundEdgeColor"
            
        }
        
        enum GlasgowAssessemnt{
            static let glasgowcomascaleeye = "glasgowcomascaleeyeId"
            static let glasgowcomascalemotor = "glasgowcomascalemotorId"
            static let glasgowcomascaleverbal = "glasgowcomascaleverbalId"
            static let glasgowcomascaletotal = "glasgowcomascaletotal"
        }
        
        enum NutritionAssessemnt{
            static let typeofdietId = "typeofdietId"
            static let mealeatenId = "mealeatenId"
            static let turgorimpressionSkinId = "turgorimpressionSkinId"
            static let physiologicMucousmembraneId = "physiologicMucousmembraneId"
            static let nutritionstatusId = "nutritionstatusId"
            static let hydrationstatusId = "hydrationstatusId"
            static let nutritionfluidassessmentimpressionId = "nutritionfluidassessmentimpressionId" 
        }
        
        enum SkinAssessment{
            static let  bodysiteId = "bodysiteId"
            static let bodylocationqualifierId = "bodylocationqualifierId"
            static let anatomicalpartlateralityId = "anatomicalpartlateralityId"
            static let colorSkinId = "colorSkinId"
            static let moisturesizeId = "moisturesizeId"
            static let tempSkinId = "tempSkinId"
            static let turgorimpressionskinId = "turgorimpressionskinId"
            static let skinintegrityId = "skinintegrityId"
            static let presspointsexamskinId = "presspointsexamskinId"
            static let mucousmembraneintegrityId = "mucousmembraneintegrityId"
            static let skinassessmentimpressionId = "skinassessmentimpressionId"
            
        }
        
        enum FallAssessment{
            
        }
        
        enum PainAssessment{
            static let painscaletypeId = "painscaletypeId"
            static let painqualityId = "painqualityId"
            static let painOnSetReported = "painOnSetReported"
            static let painOnSetHoursAgo = "painOnSetHoursAgo"
            static let speedPainOnsetReported = "speedPainOnsetReported"
            static let bodysiteReportedId = "bodysiteReportedId"
            static let painprimarylocatioReported = "painprimarylocatioReported"
            static let painradiation = "painradiation"
            static let paintemporalpatternReported = "paintemporalpatternReported"
            static let paindurationReported = "paindurationReported"
            static let paindurationReportedUnitId = "paindurationReportedUnitId"
            static let painseverityReported = "painseverityReported"
            static let painexacerbatingfactorsReported = "painexacerbatingfactorsReported"
            static let painalleviatingfactorsReported = "painalleviatingfactorsReported"
            static let paininitiatingeventReported = "paininitiatingeventReported"
            static let painseverityWongBakerFacesScale = "painseverityWongBakerFacesScale"
            static let nonmedicationinterventionId = "nonmedicationinterventionId"
            static let painassessmentimpressionId = "painassessmentimpressionId"
        }
        
        enum AddTask{
            
            static let PatientID = "PatientID"
            static let PatientAppointmentId = "PatientAppointmentId"
            static let AppointmentStaffs = "AppointmentStaffs"
            static let StaffId = "StaffId"
            static let IsDeleted = "IsDeleted"
            static let ServiceLocationID = "ServiceLocationID"
            static let StartDateTime = "StartDateTime"
            static let EndDateTime = "EndDateTime"
            static let DueDate = "DueDate"
            static let shiftId = "shiftId"
            static let taskTypeId = "taskTypeId"
            static let TaskTypeID = "TaskTypeID"
            static let Notes = "Notes"
            static let AppointmentTasks = "AppointmentTasks"
            static let TaskType = "Type"
            static let TaskPriorityId = "TaskPriorityId"
            static let TaskStatusId = "TaskStatusId"
            static let isImFollowing = "isImFollowing"
            static let taskDocumentModel = "taskDocumentModel"
            static let base64 = "base64"
            static let key = "key"
            static let patientAppointmentModels = "patientAppointmentModels"
            static let locationId = "locationId"
            static let unitId = "unitId"
            static let shiftType = "shiftType"
        }
        
        enum EditMedication{
            static let medicationId = "medicationId"
            static let patientID = "patientID"
            static let medicationDate = "medicationDate"
            static let medStatusId = "medStatusId"
            static let quantityGiven = "quantityGiven"
            static let applicationSiteId = "applicationSiteId"
            static let route = "route"
            static let notes = "notes"
            static let signature = "signature"
            static let staffId = "staffId"
            static let patientseRxNurseOrderDateMappingId = "patientseRxNurseOrderDateMappingId"
            static let patientScheduleDateTimeId = "patientScheduleDateTimeId"
            static let emrMedicationMapping = "emrMedicationMapping"
            static let id = "id"
            static let vitalsCheckId = "vitalsCheckId"
            static let result = "result"
            static let unitId = "unitId"
            static let vitalsCheck = "vitalsCheck"
            static let unit = "unit"
            static let timeGiven = "timeGiven"
            static let reasonPrnUse = "reasonPrnUse"
        }
        
        enum Inventory {
            static let date = "date"
            static let description = "description"
            static let expiryDate = "expiryDate"
            static let id = "id"
            static let locationId = "locationId"
            static let medicationId = "medicationId"
            static let medicationTypeId = "medicationTypeId"
            static let minimumQuantity = "minimumQuantity"
            static let pharmacyId = "pharmacyId"
            static let pricePerUnit = "pricePerUnit"
            static let quantityReceived = "quantityReceived"
            static let receivedById = "receivedById"
            static let subLocation = "subLocation"
            static let time = "time"
            static let supplyId = "supplyId"
            static let inventoryId = "inventoryId"
            static let inventoryTypeId = "inventoryTypeId"
            static let quantity = "quantity"
            static let issuedById = "issuedById"
            static let issuedByStaffId = "issuedByStaffId"
        }
        enum VideoCall {
            static let patientID = "patientID"
            static let staffID = "staffID"
            static let startTime = "startTime"
            static let endTime = "endTime"
            static let sessionId = "sessionId"
            static let archiveId = "archiveId"
            static let SessionId = "SessionId"
            static let FromUserId = "FromUserId"
        }
        
        enum TAR{
            static let InterventionsId = "InterventionsId"
            static let details = "details"
            static let outcome = "outcome"
            static let patientID = "patientID"
            static let provider = "provider"
            static let staffId = "staffId"
            static let tarDate = "dateOfTAR"
            static let tarTime = "timeOfTAR"
            static let signature = "signature"
            
            static let response = "response"
            static let plan = "plan"
            static let recordTypeId = "recordTypeId"
            
        }
        
        enum IncidentReport{
            
            static let patientId = "patientId"
            static let incidentTypeId = "incidentTypeId"
            static let details = "details"
            static let action = "action"
            static let outcome = "outcome"
            static let recommendations = "recommendations"
            static let physicianName = "physicianName"
            static let faimilyName = "faimilyName"
            static let isFaimily = "isFaimily"
            static let isPhysician = "isPhysician"
            static let isOther = "isOther"
            static let reportedBy = "reportedBy"
            static let time = "time"
            static let signature = "signature"
            static let otherNames = "otherNames"
            static let date = "date"
            static let name = "name"
            static let incidentDate = "incidentDate"
            static let incidentTime = "incidentTime"
        }
        
        enum createVCSchedule{
            static let patientAppointmentId = "PatientAppointmentId"
            static let appointmentStaffs = "AppointmentStaffs"
            static let staffId = "StaffId"
            static let isDeleted = "isDeleted"
            static let patientID = "PatientID"
            static let serviceLocationID = "ServiceLocationID"
            static let startDateTime = "StartDateTime"
            static let endDateTime = "EndDateTime"
            static let shiftId = "shiftId"
            static let taskTypeId = "taskTypeId"
            static let notes = "notes"
            static let taskStatusId = "TaskStatusId"
            static let type = "Type"
            static let anoymousCallMemberModels = "anoymousCallMemberModels"
            static let appointmentPatientModels = "appointmentPatientModels"
            static let patientApptList = "patientApptList"
            
        }
        
        enum AddMeal{
            static let fluidConsistencyId = "fluidConsistencyId"
            static let foodAllergy = "foodAllergy"
            static let id = "id"
            static let mealItemMapping = "mealItemMapping"
            static let mealCategoryId = "mealCategoryId"
            static let mealItemsModel = "mealItemsModel"
            static let mealTime = "mealTime"
            static let notes = "notes"
            static let patientID = "patientID"
            static let servingHall = "servingHall"
            static let servingSize = "servingSize"
            static let servingSizePortion = "servingSizePortion"
            static let startDate = "startDate"
            static let stopDate = "stopDate"
            static let typeOfFoodId = "typeOfFoodId"
            static let mealDays = "dayName"
            static let mealDetails = "mealDetails"
            static let type = "type"
        }
    }
    
    
    
    enum Response{
        static let data                 = "data"
        static let message              = "message"
        static let access_token         = "access_token"
        static let masterInventoryFilter = "MASTER_INVENTORY"
        static let staffVirtualStatus = "staffVirtualStatus"
        static let clockInStatus = "clockInStatus"
    }
    
    enum TableEntries{
        static let HeaderTitle = "HeaderTitle"
        static let Content = "Content"
        static let title = "Title"
        static let value = "Value"
    }
}

enum MasterDataKeys{
    static let vitalMasterKeys = "MASTERBODYTEMP,MASTERBPMETHOD,MASTERHEIGHT,MASTERWEIGHT,MASTERPOSITION,MASTERTEMPDEVICE,MASTERTEMPSITE,MASTERFBS,MASTERRBS"
    static let pointOfCareKeys = "POINTOFCARE,ASSESSMENT"
    static let carePlanKeys = "CAREPLAN"
    static let assessmentKeys = "ASSESSMENT,MASTERBODYTEMP,MASTERPOSITION"
    static let TaskKeys = "MASTERTASKTYPE"
    static let addTaskKeys = "MASTERTASKTYPE,MASTERTASKPRIORITY,MASTERTASKSTATUS,MASTERROLES,masterLocation,shiftMasters"
    static let MedicationKeys = "MEDICATION"
    static let InventoryMasterKeys = "MASTERINVENTORY,PHARMACYMASTER,INVENTORYLOCATION"
    static let CancelTaskKeys = "MASTERCANCELTYPE"
    static let TARKeys = "MASTERTASKTYPE"
    
}

public struct UserDefaultKeys{
    static let udKey_user = "user"
    static let udKey_deviceToken:String = "device_token"
    static let udKey_deviceId:String = "device_id"
    static let udKey_password:String = "password"
    static let udKey_userName:String = "userName"
    static let udKey_accessToken:String = "accessToken"
    static let udKey_rememberMe:String = "rememberMe"
    static let udKey_businessToken:String = "businessToken"
    static let udKey_orgTypeName:String = "orgTypeName"
    static let udKey_orgType:String = "udKey_orgType"
    static let patient_status:String = "patient_status"
    static let businessURL:String = "businessURL"
}

// MARK: AlertMessage
// Declare all all alert messages here
// Example: invalidURL.localized
public struct  AlertMessage {
    static let invalidURL       = "Invalid server url"
    static let lostInternet     = "It seems you are offline, Please check your Internet connection."
    static let invalidEmail     = "Please enter a valid email address"
    static let invalidPassword  = "Please enter a minimum 6 character password"
    static let emailMissing  = NSLocalizedString("Please enter email", comment: "")
    static let emailInvalid     = NSLocalizedString("Please enter a valid email", comment: "")
    static let passwordInvalid  = NSLocalizedString("Please enter password", comment: "")
    static let usernameInvalid = NSLocalizedString("Please enter username", comment: "")
}

// MARK: Notification.Name
// Declare all notifications name here
// Example: NotificationCenter.default.post(name: .customNotification, object: nil)
extension Notification.Name {
    // Notifications
    static let customNotification = Notification.Name("customNotification")
}

// MARK: Storyboard
// Declare all storyboards name here
// Example: -
enum Storyboard: String {
    case Main = "Main"
    case Dashboard = "Dashboard"
    case Forms = "Forms"
    case PointOfCare = "PointOfCare"
    case CarePlan = "CarePlan"
    case Assessment = "Assessment"
    case EMAR = "EMAR"
    case VirtualConsult = "VirtualConsult"
    
}

// MARK: ReuseIdentifier
// Declare all Cell reuseidentifier here
// Example: -
enum ReuseIdentifier {
    static let HomeCollectionViewCell   = "HomeCollectionViewCell"
    static let ResidentTableViewCell    = "ResidentTableViewCell"
    static let ListTableViewCell        = "ListTableViewCell"
    static let VitalHistoryTableViewCell = "VitalHistoryTableViewCell"
    static let TextInputCell = "TextInputCell"
    static let NumberInputCell = "NumberInputCell"
    static let PickerInputCell = "PickerInputCell"
    static let DateTimeInputCell = "DateTimeInputCell"
    static let DecimalInputCell = "DecimalInputCell"
    static let DoubleInputCell = "DoubleInputCell"
    static let RecursiveBPCell = "RecursiveBPCell"
    static let RecursiveMealCell = "RecursiveMealCell"
    static let AllergyListTableViewCell = "AllergyListTableViewCell"
    static let DiagnosisListTableViewCell = "DiagnosisListTableViewCell"
    static let MedicationListTableViewCell = "MedicationListTableViewCell"
    static let OtherMedicineCell = "OtherMedicineCell"
    static let LabResultCell = "LabResultCell"
    static let FoodDiaryCell = "FoodDiaryCell"
    static let TaskListCell = "TaskListCell"
    static let ListCell = "ListCell"
    static let MoodCell = "MoodCell"
    static let TitlePickerInputCell = "TitlePickerInputCell"
    static let TitleDoubleInputCell = "TitleDoubleInputCell"
    static let SliderCell = "SliderCell"
    static let TitleCell = "TitleCell"
    static let RecursiveESASCell = "RecursiveESASCell"
    static let CategoryTabCell = "CategoryTabCell"
    static let TabCollectionCell = "TabCollectionCell"
    static let MultipleImageCell = "MultipleImageCell"
    static let CheckmarkInputCell = "CheckmarkInputCell"
    static let EMARListCell = "EMARListCell"
    static let PrescriptionCell = "PrescriptionCell"
    static let EMARMedicationCell = "EMARMedicationCell"
    static let InventoryCell = "InventoryCell"
    static let PatientCell = "PatientCell"
    static let FollowingListCell = "FollowingListCell"
    static let RecursiveTaskCell = "RecursiveTaskCell"
    static let AppointmentCell = "AppointmentCell"
    static let TARListCell = "TARListCell"
    static let SharedDocumentCell = "SharedDocumentCell"
    static let SettingsCell = "SettingsCell"
    static let AvailabilitySlotCell = "AvailabilitySlotCell"
    static let AppointmentSlotCell = "AppointmentSlotCell"
    static let ScheduleAppointmentCell = "ScheduleAppointmentCell"
    static let DayCalendarCell = "DayCalendarCell"
    static let NotificationCell = "NotificationCell"
    static let TextViewInputCell = "TextViewInputCell"
    static let RecursiveSingleInputCell = "RecursiveSingleInputCell"
    static let DirectionStepCell = "DirectionStepCell"
    static let CellINputOutPut = "CellINputOutPut"
    static let CellDateTimeIOChart = "CellDateTimeIOChart"
    static let CellDateTimeValueML = "CellDateTimeValueML"
    static let CellDateTimeTitleML = "CellDateTimeTitleML"
    static let CellTrendGraph = "CellTrendGraph"
    
    
}

// MARK: NavigationTitle
// Declare all navigation titles here
// Example: -
enum NavigationTitle {
    static let Home = NSLocalizedString("Home", comment: "")
    static let Dashboard = NSLocalizedString("Dashboard", comment: "")
    static let MyTask = NSLocalizedString("My Tasks", comment: "")
    static let Tasks = NSLocalizedString("Tasks", comment: "")
    static let Resident = NSLocalizedString("\(UserDefaults.getOrganisationTypeName())", comment: "")
    static let Settings = NSLocalizedString("Setting", comment: "")
    static let ResidentDetail = NSLocalizedString("\(UserDefaults.getOrganisationTypeName()) Detail", comment: "")
    static let Maps = NSLocalizedString("Map", comment: "")
    
    static let VitalHistory = NSLocalizedString("Vital History", comment: "")
    static let AddVital = NSLocalizedString("Add Vital", comment: "")
    static let AllergyList = NSLocalizedString("Allergy List", comment: "")
    static let DiagnosisList = NSLocalizedString("Diagnosis List", comment: "")
    static let MedicationList = NSLocalizedString("Medication List", comment: "")
    static let PointOfCare = NSLocalizedString("Point Of Care", comment: "")
    static let CarePlan = NSLocalizedString("Care Plan", comment: "")
    static let ADLTracking = NSLocalizedString("ADL Tracking", comment: "")
    static let NursingCareFlow = NSLocalizedString("Nursing Care Flow Sheet", comment: "")
    static let Lab = NSLocalizedString("Lab Results", comment: "")
    static let FoodDiary = NSLocalizedString("Food Diary", comment: "")
    static let InputOutputChart = NSLocalizedString("Input-Output Chart", comment: "")
    static let InputOutputtrendgraph = NSLocalizedString("Input Output trend graph", comment: "")
    static let Assessment = NSLocalizedString("Assessment", comment: "")
    static let TaskList = NSLocalizedString("Task List", comment: "")
    static let FollowingTask = NSLocalizedString("I'm Following", comment: "")
    static let AddTask = NSLocalizedString("Add Task", comment: "")
    static let EMAR = NSLocalizedString("EMAR", comment: "")
    static let PrescriptionList = NSLocalizedString("Prescription", comment: "")
    static let InventoryList = NSLocalizedString("Inventory", comment: "")
    static let SelectResident = NSLocalizedString("Select \(UserDefaults.getOrganisationTypeName())", comment: "")
    static let Appointments = NSLocalizedString("Appointments", comment: "")
    static let VirtualConsult = NSLocalizedString("Virtual Consult", comment: "")
    static let TAR = NSLocalizedString("TAR", comment: "")
    static let CreateTAR = NSLocalizedString("Create TAR", comment: "")
    static let Schedule = NSLocalizedString("Schedule", comment: "")
    static let Availability = NSLocalizedString("Availability", comment: "")
    static let AddSchedule = NSLocalizedString("Add Schedule", comment: "")
    static let Notifications = NSLocalizedString("Notifications", comment: "")
    static let CreateIncidentReport =  NSLocalizedString("Create Incident Report", comment: "")
    static let AddAppointment = NSLocalizedString("Add Appointment", comment: "")
    static let AddMealPlan = NSLocalizedString("Add Meal Plan", comment: "")
    
    
    //CarePlan
    enum CarePlanSections {
        static let Communication = NSLocalizedString("Communication", comment: "")
        static let Routine = NSLocalizedString("Routine", comment: "")
        static let ConginitiveStatus = NSLocalizedString("Conginitive Status", comment: "")
        static let Behaviour = NSLocalizedString("Behaviour", comment: "")
        static let Safety = NSLocalizedString("Safety", comment: "")
        static let Nutrition = NSLocalizedString("Nutrition & Hydration", comment: "")
        static let Bathing = NSLocalizedString("Bathing", comment: "")
        static let Dressing = NSLocalizedString("Dressing", comment: "")
        static let Hygiene = NSLocalizedString("Hygiene", comment: "")
        static let Skin = NSLocalizedString("Skin", comment: "")
        static let Mobility = NSLocalizedString("Mobility", comment: "")
        static let Transfer = NSLocalizedString("Transfer", comment: "")
        static let Toileting = NSLocalizedString("Toileting", comment: "")
        static let BladderContinence = NSLocalizedString("Bladder Continence", comment: "")
        static let BowelContinence = NSLocalizedString("Bowel Continence", comment: "")
    }
    
    enum PointOfCareSections {
        static let ADLTracking =  NSLocalizedString("ADL Tracking", comment: "")
        static let MoodTracking =  NSLocalizedString("Mood And Behaviour", comment: "")
        static let NursingCareFlow =  NSLocalizedString("Nursing Care Flow Sheet", comment: "")
        //static let ESAS =  NSLocalizedString("SAS", comment: "")
        static let ESAS =  NSLocalizedString("Symptom Tracker", comment: "")
        static let ESASRating =  NSLocalizedString("Symptom Rating", comment: "")
        static let ESASGraph =  NSLocalizedString("Symptom Rating Graph", comment: "")
        
    }
    
    enum AssessmentSections
    {
        static let Wound =  NSLocalizedString("Wound Assessment", comment: "")
        static let Pain =  NSLocalizedString("Pain Assessment", comment: "")
        static let Skin =  NSLocalizedString("Skin Assessment", comment: "")
        static let Fall =  NSLocalizedString("Fall Assessment", comment: "")
        static let Nutrition =  NSLocalizedString("Nutrition & Fluid Intake Assessment", comment: "")
        static let Glasgow =  NSLocalizedString("Glasgow Coma Scale", comment: "")
        
    }
}

//MARK:- DateFormats
enum DateFormats{
    static let EE_dd_MMMM = "EE, dd MMMM"
    static let EEEE_dd_MMMM = "EEEE, dd MMMM"
    static let dd_MMMM = "dd MMMM"
    static let dd = "dd"
    static let ee = "EE"
    static let dd_mm_yyyy = "dd/MM/yyyy"
    static let mm_dd_yyyy = "MM/dd/yyyy"
    static let mm_dd_yy = "MM/dd/YY"
    static let server_format = "yyyy-MM-dd HH:mm:ss"
    static let server_format_MealTime = "yyyy-MM-dd'T'HH:mm:ss'Z'"
    static let notification_server_format = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSS"
    static let hh_mm_a = "hh:mm a"
    static let hh_mm_ss_a = "hh:mm:ss a"
    static let hh_mm_sss = "hh:mm:sss"
    static let MMMM_dd_YYYY = "MMMM dd, yyyy"
    static let YYYY_MM_DD = "yyyy-MM-dd"
    static let YYYYMMdd = "yyyy/MM/dd"
    static let hh_mm_a_dd_mm_yyyy = "hh:mm a, DD/MM/yyyy"
    static let hh = "hh"
    static let mm = "mm"
    static let MMMM_dd_yyyy = "MMMM dd, yyyy"
    static let a = "a"
    static let MM_dd_yyyy_hh_mm_ss_a = "MM/dd/yyyy hh:mm:ss a"
    static let MM_dd_yyyy_hh_mm_a = "MM/dd/yyyy hh:mm a"
    static let MM_dd_yyyy_bracket_hh_mm_a_ = "MM/dd/yyyy (hh:mm a)"
    
    
    
}

//MARK:- InputType
enum InputType  {
    static let Text = "text"
    static let Number = "number"
    static let Date = "date"
    static let Dropdown = "dropdown"
    static let Decimal = "decimal"
    static let Recursive = "recursive"
    static let Time = "time"
    static let Slider = "slider"
    static let Title = "title"
    static let AddESASRating = "AddESASRating"
    static let Checkmark = "Checkmark"
    static let TextView = "TextView"
    static let RecursiveSingleInput = "RecursiveSingleInput"
    
}

//MARK:- ValidationType
enum ValidationType{
    case defaultType
    case valid
    case invalid
}

//MARK:- Predicates
public struct Predicates{
    static let password         = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)[a-zA-Z\\d\\W]$"
    static let email            = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    static let text             = "[a-z A-Z ]+"
    static let mobileNo         = "^\\d{3}\\d{3}\\d{4}$"
    static let numeric          = "^(?:|0|[1-9]\\d*)(?:\\.\\d*)?$"
    static let username          = "^[0-9a-zA-Z\\_]{7,18}$"
    
}

enum YesNONutritionHydration {
    static let Food_Intake       =  "Food Intake"
    static let Fluid_Intake     =  "Fluid Intake"
    static let Bowel     =  "Bowel"
    static let Urinary_Voids     =  "Urinary Voids"
    static let Emesis     =  "Emesis"
    static let Blood_Loss     =  "Blood Loss"
}
