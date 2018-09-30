//
//  ApiService.swift
//  Tsetatonsisith
//
//  Created by Abdul Sami on 20/09/2018.
//  Copyright © 2018 Abdul Sami. All rights reserved.
//

import Foundation

internal class ApiService {
    private let baseUrl:String = APIConstants.kBaseUrl
    private var apiUrl:String
    
    init() {
        self.apiUrl = baseUrl
    }
    
    func getManufacturesList(page: Int, pageSize: Int = 15, forceNetwork: Bool) -> DataRequest {
        
        apiUrl = baseUrl.concat(urlPath: "v1/car-types/manufacturer")
        
        let request = DataRequest(url: apiUrl)
        request.addQueryParameter(key: "page", value: page.toString())
        request.addQueryParameter(key: "pageSize", value: pageSize.toString())
        request.addQueryParameter(key: "wa_key", value: APIConstants.waKey)
        request.forceNetwork = forceNetwork
        return request
    }
    
    func getModelsList(manufacturerId: String, page: Int, pageSize: Int = 15, forceNetwork: Bool) -> DataRequest {
        
        apiUrl = baseUrl.concat(urlPath: "v1/car-types/main-types")
        
        let request = DataRequest(url: apiUrl)
        request.addQueryParameter(key: "manufacturer", value: manufacturerId)
        request.addQueryParameter(key: "page", value: page.toString())
        request.addQueryParameter(key: "pageSize", value: pageSize.toString())
        request.addQueryParameter(key: "wa_key", value: APIConstants.waKey)
        request.forceNetwork = forceNetwork
        return request
    }
    
}
