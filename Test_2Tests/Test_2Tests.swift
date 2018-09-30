//
//  Test_2Tests.swift
//  Test_2Tests
//
//  Created by Abdul Sami on 29/09/2018.
//  Copyright © 2018 Abdul Sami. All rights reserved.
//

import XCTest
@testable import Test_2

class Test_2Tests: ManagerTestSetup {

    var manager:Manufacture_ModelManager?
    var loadExpectation:XCTestExpectation = XCTestExpectation(description: "Manufacture_ModelManagerLoad")
    
    override func setUp() {
        super.setUp()
        
        manager = Manufacture_ModelManager()
    }
    
    func testGetManufactureList_SuccessCase() {
        manager?.getManufacturersListBy(page: 0, onSuccess: { (manufacturers) in
            XCTAssertTrue(manufacturers.totalPageCount > 0, "Manufactures List should not be empty.")
            self.loadExpectation.fulfill()
        }, onFailure: { (error) in
            XCTFail("Manufactures list load failed \(error.debugDescription)")
            self.loadExpectation.fulfill()
        })
        
        wait(for: [loadExpectation], timeout: 10)
    }
    
    func testGetManufactureList_InvalidPageErrorCase() {
        manager?.getManufacturersListBy(page: -1, onSuccess: { (manufacturers) in
            XCTFail("Manufactures List load should fail.")
            self.loadExpectation.fulfill()
        }, onFailure: { (error) in
            XCTAssertNotNil(error, "Error can't be nil.")
            self.loadExpectation.fulfill()
        })
        
        wait(for: [loadExpectation], timeout: 10)
    }
    
    
    func testGetModelList_SuccessCase() {
        manager?.getModelsListBy(manufacturesrId: "107", page: 0, onSuccess: { (models) in
            guard let modelName = models.manufacturer_modelList?["Arnage"] else { return }
            XCTAssertTrue(modelName == "Arnage", "Models name not accurate.")
            XCTAssertTrue(models.totalPageCount > 0, "Models List should not be empty.")
            self.loadExpectation.fulfill()
        }, onFailure: { (error) in
            XCTFail("Models list load failed \(error.debugDescription)")
            self.loadExpectation.fulfill()
        })
        
        wait(for: [loadExpectation], timeout: 10)
    }
    
    func testGetModelList_InvalidManufacturersId_ErrorCase() {
        manager?.getModelsListBy(manufacturesrId: "450", page: 0, onSuccess: { (models) in
            XCTAssertTrue(models.manufacturer_modelList?.count == 0, "Models name not accurate.")
            self.loadExpectation.fulfill()
        }, onFailure: { (error) in
            XCTFail("Models list load failed \(error.debugDescription)")
            self.loadExpectation.fulfill()
        })

        wait(for: [loadExpectation], timeout: 10)
    }

}
