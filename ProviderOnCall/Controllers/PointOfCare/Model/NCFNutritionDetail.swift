/* 
Copyright (c) 2020 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

import Foundation
 
/* For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar */

public class NCFNutritionDetail {
	public var id : Int?
	public var patientID : Int?
	public var appetiteId : Int?
	public var typeOfDietId : Int?
	public var dietAmount : String?
    public var percentOfMealEaten : Int?
	public var snack : String?
	public var isDraft : Bool?
	public var numberOfFluidIntake : Int?
	public var numberOfBowelMovement : Int?
	public var numberOfUrinaryVoids : Int?
	public var emesisSubTotal : Int?
	public var bloodLossTotal : Int?
	public var incontinentBowelId : Int?
    public var bowelCareId : Int?
	public var incontinentUrinaryId : Int?
	public var briefPullUp : Int?
	public var perinealPadsCount : Int?
	public var voidingPatternGUId : Int?
	public var mealEaten : String?
    public var mealTime : String?
	public var totalFluidOutput : Int?
	public var notes : String?
	public var dynamicFluidIntake : Array<DynamicFluidIntake>?
	public var dynamicUrinary : Array<DynamicUrinary>?
	public var dynamicEmesis : Array<DynamicEmesis>?
	public var dynamicBowel : Array<DynamicBowel>?
	public var dynamicBloodLoss : Array<DynamicBloodLoss>?
    public var rectalCheckPerformed : Bool?
    public var foodIntake : Bool?
    
    public var fluidIntake : Bool?
    public var bowel : Bool?
    public var urinaryVoid : Bool?
    public var emesis : Bool?
    public var bloodLoss : Bool?
   
/**
     
     
     
     
     
     "foodIntake": true,
     "fluidIntake": true,
     "bowel": true,
     "urinaryVoid": true,
     "emesis": true,
     "bloodLoss": true,
    Returns an array of models based on given dictionary.
    
    Sample usage:
    let json4Swift_Base_list = Json4Swift_Base.modelsFromDictionaryArray(someDictionaryArrayFromJSON)

    - parameter array:  NSArray from JSON dictionary.

    - returns: Array of Json4Swift_Base Instances.
*/
    public class func modelsFromDictionaryArray(array:NSArray) -> [NCFNutritionDetail]
    {
        var models:[NCFNutritionDetail] = []
        for item in array
        {
            models.append(NCFNutritionDetail(dictionary: item as! NSDictionary)!)
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

		id = dictionary["id"] as? Int
		patientID = dictionary["patientID"] as? Int
		appetiteId = dictionary["appetiteId"] as? Int
		typeOfDietId = dictionary["typeOfDietId"] as? Int
		dietAmount = dictionary["dietAmount"] as? String
		snack = dictionary["snack"] as? String
        percentOfMealEaten = dictionary["percentOfMealEaten"] as? Int
		isDraft = dictionary["isDraft"] as? Bool
        rectalCheckPerformed = dictionary["rectalCheckPerformed"] as? Bool
		numberOfFluidIntake = dictionary["numberOfFluidIntake"] as? Int
		numberOfBowelMovement = dictionary["numberOfBowelMovement"] as? Int
		numberOfUrinaryVoids = dictionary["numberOfUrinaryVoids"] as? Int
		emesisSubTotal = dictionary["emesisSubTotal"] as? Int
		bloodLossTotal = dictionary["bloodLossTotal"] as? Int
		incontinentBowelId = dictionary["incontinentBowelId"] as? Int
		incontinentUrinaryId = dictionary["incontinentUrinaryId"] as? Int
		briefPullUp = dictionary["briefPullUp"] as? Int
		perinealPadsCount = dictionary["perinealPadsCount"] as? Int
		voidingPatternGUId = dictionary["voidingPatternGUId"] as? Int
		mealEaten = dictionary["mealEaten"] as? String
        mealTime = dictionary["mealTime"] as? String
        
		totalFluidOutput = dictionary["totalFluidOutput"] as? Int
        bowelCareId = dictionary["bowelCareId"] as? Int
		notes = dictionary["notes"] as? String
        if (dictionary["dynamicFluidIntake"] != nil) { dynamicFluidIntake = DynamicFluidIntake.modelsFromDictionaryArray(array: dictionary["dynamicFluidIntake"] as! NSArray) }
        if (dictionary["dynamicUrinary"] != nil) { dynamicUrinary = DynamicUrinary.modelsFromDictionaryArray(array: dictionary["dynamicUrinary"] as! NSArray) }
        if (dictionary["dynamicEmesis"] != nil) { dynamicEmesis = DynamicEmesis.modelsFromDictionaryArray(array: dictionary["dynamicEmesis"] as! NSArray) }
        if (dictionary["dynamicBowel"] != nil) { dynamicBowel = DynamicBowel.modelsFromDictionaryArray(array: dictionary["dynamicBowel"] as! NSArray) }
        if (dictionary["dynamicBloodLoss"] != nil) { dynamicBloodLoss = DynamicBloodLoss.modelsFromDictionaryArray(array: dictionary["dynamicBloodLoss"] as! NSArray) }
        
        foodIntake = dictionary["foodIntake"] as? Bool
        fluidIntake = dictionary["fluidIntake"] as? Bool
        bowel = dictionary["bowel"] as? Bool
        urinaryVoid = dictionary["urinaryVoid"] as? Bool
        emesis = dictionary["emesis"] as? Bool
        bloodLoss = dictionary["bloodLoss"] as? Bool
	}

		
/**
    Returns the dictionary representation for the current instance.
    
    - returns: NSDictionary.
*/
	public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()

		dictionary.setValue(self.id, forKey: "id")
		dictionary.setValue(self.patientID, forKey: "patientID")
		dictionary.setValue(self.appetiteId, forKey: "appetiteId")
		dictionary.setValue(self.typeOfDietId, forKey: "typeOfDietId")
		dictionary.setValue(self.dietAmount, forKey: "dietAmount")
		dictionary.setValue(self.snack, forKey: "snack")
		dictionary.setValue(self.isDraft, forKey: "isDraft")
		dictionary.setValue(self.numberOfFluidIntake, forKey: "numberOfFluidIntake")
		dictionary.setValue(self.numberOfBowelMovement, forKey: "numberOfBowelMovement")
		dictionary.setValue(self.numberOfUrinaryVoids, forKey: "numberOfUrinaryVoids")
		dictionary.setValue(self.emesisSubTotal, forKey: "emesisSubTotal")
		dictionary.setValue(self.bloodLossTotal, forKey: "bloodLossTotal")
		dictionary.setValue(self.incontinentBowelId, forKey: "incontinentBowelId")
		dictionary.setValue(self.incontinentUrinaryId, forKey: "incontinentUrinaryId")
		dictionary.setValue(self.briefPullUp, forKey: "briefPullUp")
		dictionary.setValue(self.perinealPadsCount, forKey: "perinealPadsCount")
		dictionary.setValue(self.voidingPatternGUId, forKey: "voidingPatternGUId")
		dictionary.setValue(self.mealEaten, forKey: "mealEaten")
		dictionary.setValue(self.totalFluidOutput, forKey: "totalFluidOutput")
        dictionary.setValue(self.bowelCareId, forKey: "bowelCareId")
		dictionary.setValue(self.notes, forKey: "notes")
        dictionary.setValue(self.rectalCheckPerformed, forKey: "rectalCheckPerformed")
        dictionary.setValue(self.foodIntake, forKey: "foodIntake")
        
        dictionary.setValue(self.foodIntake, forKey: "fluidIntake")
        dictionary.setValue(self.foodIntake, forKey: "bowel")
        dictionary.setValue(self.foodIntake, forKey: "urinaryVoid")
        dictionary.setValue(self.foodIntake, forKey: "emesis")
        dictionary.setValue(self.foodIntake, forKey: "bloodLoss")
        dictionary.setValue(self.mealTime, forKey: "mealTime")
		return dictionary
	}

}
