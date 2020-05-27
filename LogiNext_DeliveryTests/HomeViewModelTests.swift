//
//  HomeViewModelTests.swift
//  LogiNext_DeliveryTests
//
//  Created by Vivek Gupta on 27/05/20.
//  Copyright © 2020 Vivek Gupta. All rights reserved.
//

import XCTest
@testable import LogiNext_Delivery

class HomeViewModelTests: XCTestCase {
    
    var homeViewModel: HomeViewModel?
    
    override func setUp() {
        let logisticViewModel = LogisticViewModel()
        homeViewModel = HomeViewModel(logistics: logisticViewModel)
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test001GetTabWiseResult() {
        let promise = expectation(description: "Get all orders")
        homeViewModel?.reloadBlock = {
            print(self.homeViewModel?.allOrders)
            promise.fulfill()
        }
        homeViewModel?.loadOrdersAsPerTabIndex(index: 0)
        wait(for: [promise], timeout: 5)
        
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
