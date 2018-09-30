//
//  Constant.swift
//  Test_2
//
//  Created by Abdul Sami on 29/09/2018.
//  Copyright © 2018 Abdul Sami. All rights reserved.
//

import Foundation
import  UIKit

struct APIConstants {
    static let kBaseUrl = "http://api-aws-eu-qa-1.auto1-test.com/"
    static let waKey = "coding-puzzle-client-449cc9d"
}

enum LoadingPosition {
    case top, bottom, middle
}

struct Color {
    static let background = UIColor(red: 42/255, green: 41/255, blue: 190/255, alpha: 1.0)// UIColor(red: 210/255, green: 60/255, blue: 60/255, alpha: 1.0)
    static let text = UIColor(red: 51/255, green: 51/255, blue: 51/255, alpha: 1.0)
}
