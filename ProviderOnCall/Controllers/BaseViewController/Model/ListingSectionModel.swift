//
//  ListingModel.swift
//  AccessEMR
//
//  Created by Vasundhara Parakh on 3/6/20.
//  Copyright © 2020 smartData Enterprises (I) Ltd. All rights reserved.
//

import UIKit

class ListingSectionModel{
    var headerTitle: String?
    var content: [ListModel]?
    init(headerTitle : String?, content:[ListModel]?){
        self.headerTitle = headerTitle
        self.content = content
    }
}

class ListModel{
    var title : String?
    var value : String?
    init(title : String?, value: String?){
        self.title = title
        self.value = value
    }
}
