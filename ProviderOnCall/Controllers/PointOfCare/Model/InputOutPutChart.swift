

import Foundation
 
/* For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar */

public class InputOutPutChart {
    public var access_token : String?
    public var expires_in : Int?
    public var dataInput : DataInput?
    public var message : String?
    public var statusCode : Int?
    public var appError : String?
    public var firstTimeLogin : Bool?
    public var openDefaultClient : Bool?
    public var locationRange : Int?

    public class func modelsFromDictionaryArray(array:NSArray) -> [InputOutPutChart]
    {
        var models:[InputOutPutChart] = []
        for item in array
        {
            models.append(InputOutPutChart(dictionary: item as! NSDictionary)!)
        }
        return models
    }

    required public init?(dictionary: NSDictionary) {

        access_token = dictionary["access_token"] as? String
        expires_in = dictionary["expires_in"] as? Int
        if (dictionary["data"] != nil) { dataInput = DataInput(dictionary: dictionary["data"] as! NSDictionary) }
        message = dictionary["message"] as? String
        statusCode = dictionary["statusCode"] as? Int
        appError = dictionary["appError"] as? String
        firstTimeLogin = dictionary["firstTimeLogin"] as? Bool
        openDefaultClient = dictionary["openDefaultClient"] as? Bool
        locationRange = dictionary["locationRange"] as? Int
    }

    public func dictionaryRepresentation() -> NSDictionary {

        let dictionary = NSMutableDictionary()

        dictionary.setValue(self.access_token, forKey: "access_token")
        dictionary.setValue(self.expires_in, forKey: "expires_in")
        dictionary.setValue(self.dataInput?.dictionaryRepresentation(), forKey: "data")
        dictionary.setValue(self.message, forKey: "message")
        dictionary.setValue(self.statusCode, forKey: "statusCode")
        dictionary.setValue(self.appError, forKey: "appError")
        dictionary.setValue(self.firstTimeLogin, forKey: "firstTimeLogin")
        dictionary.setValue(self.openDefaultClient, forKey: "openDefaultClient")
        dictionary.setValue(self.locationRange, forKey: "locationRange")

        return dictionary
    }

}
public class DataInput {
    public var fluidIntake : Array<FluidIntakeInput>?
    public var foodIntake : Array<FoodIntakeInput>?
    public var urine : Array<UrineInpout>?
    public var emesis : Array<Emesis>?
    public var bloodLoss : Array<BloodLoss>?
    public var bowel : Array<Bowel>?

    public class func modelsFromDictionaryArray(array:NSArray) -> [DataInput]
    {
        var models:[DataInput] = []
        for item in array
        {
            models.append(DataInput(dictionary: item as! NSDictionary)!)
        }
        return models
    }

    required public init?(dictionary: NSDictionary) {

        if (dictionary["fluidIntake"] != nil) { fluidIntake = FluidIntakeInput.modelsFromDictionaryArray(array: dictionary["fluidIntake"] as! NSArray) }
        
        if (dictionary["foodIntake"] != nil) { foodIntake = FoodIntakeInput.modelsFromDictionaryArray(array: dictionary["foodIntake"] as! NSArray) }
        
        if (dictionary["urine"] != nil) { urine = UrineInpout.modelsFromDictionaryArray(array: dictionary["urine"] as! NSArray) }
        if (dictionary["emesis"] != nil) { emesis = Emesis.modelsFromDictionaryArray(array: dictionary["emesis"] as! NSArray) }
        if (dictionary["bloodLoss"] != nil) { bloodLoss = BloodLoss.modelsFromDictionaryArray(array: dictionary["bloodLoss"] as! NSArray) }
        if (dictionary["bowel"] != nil) { bowel = Bowel.modelsFromDictionaryArray(array: dictionary["bowel"] as! NSArray) }
    }

    public func dictionaryRepresentation() -> NSDictionary {

        let dictionary = NSMutableDictionary()


        return dictionary
    }

}

public class UrineInpout {
    public var id : Int?
    public var date : String?
    public var time : String?
    public var urine : String?


    public class func modelsFromDictionaryArray(array:NSArray) -> [UrineInpout]
    {
        var models:[UrineInpout] = []
        for item in array
        {
            models.append(UrineInpout(dictionary: item as! NSDictionary)!)
        }
        return models
    }


    required public init?(dictionary: NSDictionary) {

        id = dictionary["id"] as? Int
        date = dictionary["date"] as? String
        time = dictionary["time"] as? String
        urine = dictionary["urine"] as? String
    }

    public func dictionaryRepresentation() -> NSDictionary {

        let dictionary = NSMutableDictionary()

        dictionary.setValue(self.id, forKey: "id")
        dictionary.setValue(self.date, forKey: "date")
        dictionary.setValue(self.time, forKey: "time")
        dictionary.setValue(self.urine, forKey: "urine")

        return dictionary
    }

}
public class BloodLoss {
    public var id : Int?
    public var date : String?
    public var time : String?
    public var bloodLoss : String?

    public class func modelsFromDictionaryArray(array:NSArray) -> [BloodLoss]
    {
        var models:[BloodLoss] = []
        for item in array
        {
            models.append(BloodLoss(dictionary: item as! NSDictionary)!)
        }
        return models
    }

    required public init?(dictionary: NSDictionary) {

        id = dictionary["id"] as? Int
        date = dictionary["date"] as? String
        time = dictionary["time"] as? String
        bloodLoss = dictionary["bloodLoss"] as? String
    }

    public func dictionaryRepresentation() -> NSDictionary {

        let dictionary = NSMutableDictionary()

        dictionary.setValue(self.id, forKey: "id")
        dictionary.setValue(self.date, forKey: "date")
        dictionary.setValue(self.time, forKey: "time")
        dictionary.setValue(self.bloodLoss, forKey: "bloodLoss")

        return dictionary
    }

}
public class Bowel {
    public var id : Int?
    public var date : String?
    public var time : String?
    public var bowelAmount : String?

    public class func modelsFromDictionaryArray(array:NSArray) -> [Bowel]
    {
        var models:[Bowel] = []
        for item in array
        {
            models.append(Bowel(dictionary: item as! NSDictionary)!)
        }
        return models
    }

    required public init?(dictionary: NSDictionary) {

        id = dictionary["id"] as? Int
        date = dictionary["date"] as? String
        time = dictionary["time"] as? String
        bowelAmount = dictionary["bowelAmount"] as? String
    }

    public func dictionaryRepresentation() -> NSDictionary {

        let dictionary = NSMutableDictionary()

        dictionary.setValue(self.id, forKey: "id")
        dictionary.setValue(self.date, forKey: "date")
        dictionary.setValue(self.time, forKey: "time")
        dictionary.setValue(self.bowelAmount, forKey: "bowelAmount")

        return dictionary
    }

}
public class Emesis {
    public var id : Int?
    public var date : String?
    public var time : String?
    public var emesis : String?

    public class func modelsFromDictionaryArray(array:NSArray) -> [Emesis]
    {
        var models:[Emesis] = []
        for item in array
        {
            models.append(Emesis(dictionary: item as! NSDictionary)!)
        }
        return models
    }

    required public init?(dictionary: NSDictionary) {

        id = dictionary["id"] as? Int
        date = dictionary["date"] as? String
        time = dictionary["time"] as? String
        emesis = dictionary["emesis"] as? String
    }

    public func dictionaryRepresentation() -> NSDictionary {

        let dictionary = NSMutableDictionary()

        dictionary.setValue(self.id, forKey: "id")
        dictionary.setValue(self.date, forKey: "date")
        dictionary.setValue(self.time, forKey: "time")
        dictionary.setValue(self.emesis, forKey: "emesis")

        return dictionary
    }

}
public class FoodIntakeInput {
    public var id : Int?
    public var date : String?
    public var time : String?
    public var foodIntake : String?
    public var mealEaten : String?

    public class func modelsFromDictionaryArray(array:NSArray) -> [FoodIntakeInput]
    {
        var models:[FoodIntakeInput] = []
        for item in array
        {
            models.append(FoodIntakeInput(dictionary: item as! NSDictionary)!)
        }
        return models
    }

    required public init?(dictionary: NSDictionary) {

        id = dictionary["id"] as? Int
        date = dictionary["date"] as? String
        time = dictionary["time"] as? String
        foodIntake = dictionary["foodIntake"] as? String
        mealEaten = dictionary["mealEaten"] as? String
    }

    public func dictionaryRepresentation() -> NSDictionary {

        let dictionary = NSMutableDictionary()

        dictionary.setValue(self.id, forKey: "id")
        dictionary.setValue(self.date, forKey: "date")
        dictionary.setValue(self.time, forKey: "time")
        dictionary.setValue(self.foodIntake, forKey: "foodIntake")
        dictionary.setValue(self.mealEaten, forKey: "mealEaten")

        return dictionary
    }

}
public class FluidIntakeInput {
    public var id : Int?
    public var date : String?
    public var time : String?
    public var fluidIntake : String?
    public var amount : String?

    public class func modelsFromDictionaryArray(array:NSArray) -> [FluidIntakeInput]
    {
        var models:[FluidIntakeInput] = []
        for item in array
        {
            models.append(FluidIntakeInput(dictionary: item as! NSDictionary)!)
        }
        return models
    }

    required public init?(dictionary: NSDictionary) {

        id = dictionary["id"] as? Int
        date = dictionary["date"] as? String
        time = dictionary["time"] as? String
        fluidIntake = dictionary["fluidIntake"] as? String
        amount = dictionary["amount"] as? String
    }

    public func dictionaryRepresentation() -> NSDictionary {

        let dictionary = NSMutableDictionary()

        dictionary.setValue(self.id, forKey: "id")
        dictionary.setValue(self.date, forKey: "date")
        dictionary.setValue(self.time, forKey: "time")
        dictionary.setValue(self.fluidIntake, forKey: "fluidIntake")
        dictionary.setValue(self.amount, forKey: "amount")

        return dictionary
    }

}
