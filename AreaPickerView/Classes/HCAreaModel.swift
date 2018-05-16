//
//  AreaModel.swift
//  Remind
//
//  Created by sessionCh on 2018/4/17.
//  Copyright © 2018年 ganyi. All rights reserved.
//

import UIKit

class ProvinceModel: NSObject {
    
    var province: String
    var cities: [CityModel]
    
    override init() {
        self.province = ""
        self.cities = []
    }
}

class CityModel: NSObject {
    
    var province: String
    var city: String
    var areas: [AreaModel]
    
    override init() {
        self.province = ""
        self.city = ""
        self.areas = []
    }
}

class AreaModel: NSObject {
    
    var city: String
    var area: String
    
    override init() {
        self.city = ""
        self.area = ""
    }
}


