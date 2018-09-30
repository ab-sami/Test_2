//
//  Manufacture_Model.swift
//  Test_2
//
//  Created by Abdul Sami on 29/09/2018.
//  Copyright © 2018 Abdul Sami. All rights reserved.
//

import Foundation

public class Manufacture_Model: Decodable {
    
    public var page: Int
    public var pageSize: Int
    public var totalPageCount : Int
    public var manufacturer_modelList: [String:String]?
    
    private enum CodingKeys: String, CodingKey {
        case page, pageSize, totalPageCount, manufacturer_modelList = "wkda"
    }
    
    public init() {
        page = 0
        pageSize = 0
        totalPageCount = 0
        manufacturer_modelList = [String:String]()
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        page = try container.decode(Int.self, forKey: .page)
        pageSize = try container.decode(Int.self, forKey: .pageSize)
        totalPageCount = try container.decode(Int.self, forKey: .totalPageCount)
        manufacturer_modelList = try container.decode([String:String].self, forKey: .manufacturer_modelList)
    }
}

