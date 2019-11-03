//
//  MetroTests.swift
//  MetroTests
//
//  Created by Manjeet Singh on 2/11/19.
//  Copyright © 2019 iOS. All rights reserved.
//

import XCTest
@testable import Metro

class MetroTests: XCTestCase {

    func testIfDataManagerReturnsAppropriateData() {
        // 1. Setup the expectation
        let expectation = XCTestExpectation(description: "DataManager fetches data and returns appropriate data")
        
        // 2. Exercise and verify the behaviour as usual
        DataManager.shared.fetchMetroStations { result in
            
            switch result {
            case .success(let price):
                XCTAssertTrue(price.detail != nil)
                expectation.fulfill()
            case .failure:
                XCTFail()
            }
        }
    }
}
