//
//  ModelsViewModel.swift
//  Test_2
//
//  Created by Abdul Sami on 29/09/2018.
//  Copyright © 2018 Abdul Sami. All rights reserved.
//

import Foundation

public class ModelsViewModel: BaseViewModel {
    
    private var manufacturers: Manufacture_Model?
    private var apiManager: Manufacture_ModelManager?
    private var modelsList: [String]?
    private var page: Int = 0
    private var manufacturerId: String = ""
    private var lastPageLoaded: Bool = false
    
    init(manufacturerId: String) {
        self.page = 0
        self.modelsList = [String]()
        self.manufacturerId = manufacturerId
        self.apiManager = Manufacture_ModelManager()
    }
    
    public override func load() {
        super.load()
        guard isReady() == false else { return }
        
        page = 0
        apiManager?.getModelsListBy(manufacturesrId: manufacturerId, page: page, onSuccess: { [weak self] (manufacturers) in
            guard let values = manufacturers.manufacturer_modelList?.values else { return }
            self?.modelsList = Array(values)
            self?.modelsList?.sort()
            self?.manufacturers = manufacturers
            self?.lastPageLoaded = self?.manufacturers?.totalPageCount == 1 ? true : false
            self?.makeReady()
            }, onFailure: { [weak self] (error) in
                if let error = error {
                    self?.throwError(with: error)
                }
        })
    }
    
    public func loadNextPage(completion:@escaping IntCall,
                             onError:@escaping ErrorCall) {
        page += 1
        apiManager?.getModelsListBy(manufacturesrId: manufacturerId, page: page,
            onSuccess: { [weak self] (manufacturers) in
                guard self != nil else { return }
                
                guard let newManufactures = manufacturers.manufacturer_modelList,
                    let values = manufacturers.manufacturer_modelList?.values else { return }
                
                self?.modelsList?.append(contentsOf: Array(values))
                self?.modelsList?.sort()
                self?.manufacturers?.manufacturer_modelList?.merge(newManufactures, uniquingKeysWith: { (current, _) in current })
                self?.lastPageLoaded = self?.page == (self?.manufacturers?.totalPageCount ?? 0) - 1 ? true : false
                completion(self?.page ?? 0)
        }, onFailure: { (error) in
                onError(error)
        })
    }
    
    public func hasNextPage() -> Bool {
        return !lastPageLoaded
    }
    
    public func getModelListCount() -> Int {
        return modelsList?.count ?? 0
    }
    
    public func getModelTitleBy(idx: Int) -> String {
        guard let value = modelsList?[idx] else { return "" }
        return value
    }
}
