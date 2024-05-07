//
//  BowelContinenece.swift
//  AccessEMR
//
//  Created by Vasundhara Parakh on 3/11/20.
//  Copyright © 2020 smartData Enterprises (I) Ltd. All rights reserved.
//

import UIKit

public class BowelContinenece{
    public var id : Int?
    public var patientID : Int?
    public var createdDate : String?
    public var bladderContinenceId : Int?
    public var bladderContinence : String?
    public var bladderIncontinentId : Int?
    public var bladderIncontinent : String?
    public var equipmentId : Int?
    public var equipments : String?
    public var isProduct : Bool?
    public var products : String?
    public var product : String?
    public var size : String?
    public var productUseInId : Int?
    public var productUseinthe : String?
    public var managedById : Int?
    public var managedBy : String?
    public var bowelNotes : String?
    public var addedByName : String?

/**
    Returns an array of models based on given dictionary.
    
    Sample usage:
    let json4Swift_Base_list = Json4Swift_Base.modelsFromDictionaryArray(someDictionaryArrayFromJSON)

    - parameter array:  NSArray from JSON dictionary.

    - returns: Array of Json4Swift_Base Instances.
*/
    public class func modelsFromDictionaryArray(array:NSArray) -> [BowelContinenece]
    {
        var models:[BowelContinenece] = []
        for item in array
        {
            models.append(BowelContinenece(dictionary: item as! NSDictionary)!)
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
        createdDate = dictionary["createdDate"] as? String
        bladderContinenceId = dictionary["bladderContinenceId"] as? Int
        bladderContinence = dictionary["bladderContinence"] as? String
        bladderIncontinentId = dictionary["bladderIncontinentId"] as? Int
        bladderIncontinent = dictionary["bladderIncontinent"] as? String
        equipmentId = dictionary["equipmentId"] as? Int
        equipments = dictionary["equipments"] as? String
        isProduct = dictionary["isProduct"] as? Bool
        products = dictionary["products"] as? String
        product = dictionary["product"] as? String
        size = dictionary["size"] as? String
        productUseInId = dictionary["productUseInId"] as? Int
        productUseinthe = dictionary["productUseinthe"] as? String
        managedById = dictionary["managedById"] as? Int
        managedBy = dictionary["managedBy"] as? String
        bowelNotes = dictionary["bowelNotes"] as? String
        addedByName = dictionary["addedByName"] as? String
    }

        
/**
    Returns the dictionary representation for the current instance.
    
    - returns: NSDictionary.
*/
    public func dictionaryRepresentation() -> NSDictionary {

        let dictionary = NSMutableDictionary()

        dictionary.setValue(self.id, forKey: "id")
        dictionary.setValue(self.patientID, forKey: "patientID")
        dictionary.setValue(self.createdDate, forKey: "createdDate")
        dictionary.setValue(self.bladderContinenceId, forKey: "bladderContinenceId")
        dictionary.setValue(self.bladderContinence, forKey: "bladderContinence")
        dictionary.setValue(self.bladderIncontinentId, forKey: "bladderIncontinentId")
        dictionary.setValue(self.bladderIncontinent, forKey: "bladderIncontinent")
        dictionary.setValue(self.equipmentId, forKey: "equipmentId")
        dictionary.setValue(self.equipments, forKey: "equipments")
        dictionary.setValue(self.isProduct, forKey: "isProduct")
        dictionary.setValue(self.products, forKey: "products")
        dictionary.setValue(self.product, forKey: "product")
        dictionary.setValue(self.size, forKey: "size")
        dictionary.setValue(self.productUseInId, forKey: "productUseInId")
        dictionary.setValue(self.productUseinthe, forKey: "productUseinthe")
        dictionary.setValue(self.managedById, forKey: "managedById")
        dictionary.setValue(self.managedBy, forKey: "managedBy")
        dictionary.setValue(self.bowelNotes, forKey: "bowelNotes")
        dictionary.setValue(self.addedByName, forKey: "addedByName")

        return dictionary
    }

}
