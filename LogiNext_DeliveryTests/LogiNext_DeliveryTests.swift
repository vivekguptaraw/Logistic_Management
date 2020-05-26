//
//  LogiNext_DeliveryTests.swift
//  LogiNext_DeliveryTests
//
//  Created by Vivek Gupta on 23/05/20.
//  Copyright © 2020 Vivek Gupta. All rights reserved.
//

import XCTest
@testable import LogiNext_Delivery

class LogiNext_DeliveryTests: XCTestCase {
    
    var logisticViewModel: LogisticViewModel? = LogisticViewModel()
    var orderDTO: OrderDTO?
    
    override func setUp() {
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test001CreateNewUser() {
        let promise = expectation(description: "Created New User")
        let user = UserDTO(name: "Vivek Gupta Test User", id: Int(Date().timeIntervalSince1970))
        logisticViewModel?.saveUser(userDTO: user, completion: { (result) in
            XCTAssertNotNil(result, "User creation failed..")
            logisticViewModel?.setCurrentUser(userDTO: result!)
             promise.fulfill()
        })
        wait(for: [promise], timeout: 5)
    }
    
    func test002getCurrentUser() {
        logisticViewModel?.getCurrentUser()
        XCTAssertNotNil(logisticViewModel?.currentUser, "Error.. Current User Not Available after creating..")
    }
    
    func test003getAllUser() {
        let promise = expectation(description: "Get All User..")
        logisticViewModel?.getAllUsers(completion: { (array) in
            XCTAssertTrue(array.count > 0, "Users are there in DB but problem in fetching user list")
            promise.fulfill()
        })
        wait(for: [promise], timeout: 5)
    }
    
    func test004CreateOrder() {
        let promise = expectation(description: "CreateOrder..")
        logisticViewModel?.createOrder(name: "Test Order", desc: "Test Order Desc", date: Date(), completion: { (result) in
            XCTAssertNotNil(result.createdDate, "Order createdDate is nil")
            XCTAssertNotNil(result.createdByUser, "Order createdByUser is nil")
            promise.fulfill()
        })
        wait(for: [promise], timeout: 5)
    }
    
    func test005GetAllOrders() {
        let promise = expectation(description: "GetAllOrders..")
        logisticViewModel?.getAllOrders(sorted: Sorted(key: "lastUpdatedDate", ascending: false), completion: { (array) in
            XCTAssertNotNil(array, "Order created successfully but issue in fetching orders..")
            XCTAssertTrue(array!.count > 0, "No orders fetched")
            promise.fulfill()
        })
        wait(for: [promise], timeout: 5)
    }
    
    func test006UpdateOrder() {
        let promise = expectation(description: "UpdateOrder..")
        XCTAssertNotNil(logisticViewModel?.currentUser, "CurrentUser deinitialized...")
        var order = OrderDTO(id: 12345, name: "New Order title", desc: "OrderDescription")
        order.pickUp(byUser: logisticViewModel!.currentUser!)
        logisticViewModel?.upadateOrder(order: order, completion: { (inTransitOrder) in
            XCTAssertTrue(inTransitOrder.isInTransit, "After pick up the order is not in In-transit")
            promise.fulfill()
        })
        wait(for: [promise], timeout: 5)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
