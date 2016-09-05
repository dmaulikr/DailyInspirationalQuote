//
//  Global.swift
//  Citazioni
//
//  Created by RJ Militante on 8/24/16.
//  Copyright © 2016 Kraftwerking LLC. All rights reserved.
//

import Foundation

class Main {
    var name:String
    var alertDate:NSDate
    init(name:String, alertDate:NSDate) {
        self.name = name
        self.alertDate = alertDate
    }
}
var mainInstance = Main(name:"", alertDate:NSDate.init())
var mainId = Main(name:"", alertDate:NSDate.init())
var comeFrom = Main(name:"", alertDate:NSDate.init())
var globalDevice = Main(name:"", alertDate:NSDate.init())