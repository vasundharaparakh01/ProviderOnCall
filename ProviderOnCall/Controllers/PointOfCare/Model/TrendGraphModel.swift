//
//  TrendGraphModel.swift
//  appName
//
//  Created by Sorabh Gupta on 12/22/20.
//  Copyright © 2020 smartData Enterprises (I) Ltd. All rights reserved.
//

import Foundation
struct TrendGraphModel : Codable {
    let access_token : String?
    let expires_in : Int?
    let data : DataTrendGraph?
    let message : String?
    let statusCode : Int?
    let firstTimeLogin : Bool?
    let openDefaultClient : Bool?
    let locationRange : Int?

    enum CodingKeys: String, CodingKey {

        case access_token = "access_token"
        case expires_in = "expires_in"
        case data = "data"
        case message = "message"
        case statusCode = "statusCode"
        case firstTimeLogin = "firstTimeLogin"
        case openDefaultClient = "openDefaultClient"
        case locationRange = "locationRange"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        access_token = try values.decodeIfPresent(String.self, forKey: .access_token)
        expires_in = try values.decodeIfPresent(Int.self, forKey: .expires_in)
        data = try values.decodeIfPresent(DataTrendGraph.self, forKey: .data)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        statusCode = try values.decodeIfPresent(Int.self, forKey: .statusCode)
        firstTimeLogin = try values.decodeIfPresent(Bool.self, forKey: .firstTimeLogin)
        openDefaultClient = try values.decodeIfPresent(Bool.self, forKey: .openDefaultClient)
        locationRange = try values.decodeIfPresent(Int.self, forKey: .locationRange)
    }

}
struct DataTrendGraph : Codable {
    let bloodLossTotal : BloodLossTotalTrendGraph?
    let urineTotal : UrineTotalTrendGraph?
    let emesisTotal : EmesisTotalTrendGraph?
    let foodIntakeTotal : FoodIntakeTotalTrendGraph?
    let fluidIntakeTotal : FluidIntakeTotalTrendGraph?
    let bowelCountTotal : BowelCountTotalTrendGraph?

    enum CodingKeys: String, CodingKey {

        case bloodLossTotal = "bloodLossTotal"
        case urineTotal = "urineTotal"
        case emesisTotal = "emesisTotal"
        case foodIntakeTotal = "foodIntakeTotal"
        case fluidIntakeTotal = "fluidIntakeTotal"
        case bowelCountTotal = "bowelCountTotal"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        bloodLossTotal = try values.decodeIfPresent(BloodLossTotalTrendGraph.self, forKey: .bloodLossTotal)
        urineTotal = try values.decodeIfPresent(UrineTotalTrendGraph.self, forKey: .urineTotal)
        emesisTotal = try values.decodeIfPresent(EmesisTotalTrendGraph.self, forKey: .emesisTotal)
        foodIntakeTotal = try values.decodeIfPresent(FoodIntakeTotalTrendGraph.self, forKey: .foodIntakeTotal)
        fluidIntakeTotal = try values.decodeIfPresent(FluidIntakeTotalTrendGraph.self, forKey: .fluidIntakeTotal)
        bowelCountTotal = try values.decodeIfPresent(BowelCountTotalTrendGraph.self, forKey: .bowelCountTotal)
    }

}
struct BloodLossTotalTrendGraph : Codable {
    let title : String?
    let data : [Int]?
    let lables : [String]?

    enum CodingKeys: String, CodingKey {

        case title = "title"
        case data = "data"
        case lables = "lables"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        title = try values.decodeIfPresent(String.self, forKey: .title)
        data = try values.decodeIfPresent([Int].self, forKey: .data)
        lables = try values.decodeIfPresent([String].self, forKey: .lables)
    }

}
struct BowelCountTotalTrendGraph : Codable {
    let title : String?
    let data : [Int]?
    let lables : [String]?

    enum CodingKeys: String, CodingKey {

        case title = "title"
        case data = "data"
        case lables = "lables"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        title = try values.decodeIfPresent(String.self, forKey: .title)
        data = try values.decodeIfPresent([Int].self, forKey: .data)
        lables = try values.decodeIfPresent([String].self, forKey: .lables)
    }

}
struct EmesisTotalTrendGraph : Codable {
    let title : String?
    let data : [Int]?
    let lables : [String]?

    enum CodingKeys: String, CodingKey {

        case title = "title"
        case data = "data"
        case lables = "lables"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        title = try values.decodeIfPresent(String.self, forKey: .title)
        data = try values.decodeIfPresent([Int].self, forKey: .data)
        lables = try values.decodeIfPresent([String].self, forKey: .lables)
    }

}
struct FluidIntakeTotalTrendGraph : Codable {
    let title : String?
    let data : [Int]?
    let lables : [String]?

    enum CodingKeys: String, CodingKey {

        case title = "title"
        case data = "data"
        case lables = "lables"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        title = try values.decodeIfPresent(String.self, forKey: .title)
        data = try values.decodeIfPresent([Int].self, forKey: .data)
        lables = try values.decodeIfPresent([String].self, forKey: .lables)
    }

}
struct FoodIntakeTotalTrendGraph : Codable {
    let title : String?
    let data : [Int]?
    let lables : [String]?

    enum CodingKeys: String, CodingKey {

        case title = "title"
        case data = "data"
        case lables = "lables"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        title = try values.decodeIfPresent(String.self, forKey: .title)
        data = try values.decodeIfPresent([Int].self, forKey: .data)
        lables = try values.decodeIfPresent([String].self, forKey: .lables)
    }

}
struct UrineTotalTrendGraph : Codable {
    let title : String?
    let data : [Int]?
    let lables : [String]?

    enum CodingKeys: String, CodingKey {

        case title = "title"
        case data = "data"
        case lables = "lables"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        title = try values.decodeIfPresent(String.self, forKey: .title)
        data = try values.decodeIfPresent([Int].self, forKey: .data)
        lables = try values.decodeIfPresent([String].self, forKey: .lables)
    }

}

