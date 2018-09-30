//
//  Manufacture_ModelManager.swift
//  Test_2
//
//  Created by Abdul Sami on 29/09/2018.
//  Copyright © 2018 Abdul Sami. All rights reserved.
//

import Foundation

public class Manufacture_ModelManager {
    
    internal let fetcher:DataFetcher
    private let service:ApiService
    
    internal init() {
        self.fetcher = DataFetcher()
        self.service = ApiService()
    }
    
    func getManufacturersListBy(page: Int,
                                pageSize: Int = 15,
                                onSuccess: @escaping Manufacture_ModelCall,
                                onFailure: @escaping ErrorCall) {
        
        let request = service.getManufacturesList(page: page, forceNetwork: true)
        
        fetcher.run(request, onSuccess: {(manufacturers: Manufacture_Model) in
            onSuccess(manufacturers)
        }, onFailure: { (error) in
            onFailure(error)
        })
    }
    
    func getModelsListBy(manufacturesrId: String,
                         page: Int,
                         pageSize: Int = 15,
                         onSuccess: @escaping Manufacture_ModelCall,
                         onFailure: @escaping ErrorCall) {
        
        let request = service.getModelsList(manufacturerId: manufacturesrId, page: page, forceNetwork: true)
        
        fetcher.run(request, onSuccess: {(models: Manufacture_Model) in
            onSuccess(models)
        }, onFailure: { (error) in
            onFailure(error)
        })
    }
}
