//
//  DataResponse.swift
//  Tsetatonsisith
//
//  Created by Abdul Sami on 20/09/2018.
//  Copyright © 2018 Abdul Sami. All rights reserved.
//

import Foundation

public class DataResponse {
    
    public var statusCode:Int
    public var headers:[AnyHashable : Any]
    
    init(statusCode:Int, headers:[AnyHashable : Any]) {
        self.statusCode = statusCode
        self.headers = headers
    }
}
