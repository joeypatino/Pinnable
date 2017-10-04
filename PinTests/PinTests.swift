//
//  PinTests.swift
//  PinTests
//
//  Created by Joey Patino on 10/2/17.
//  Copyright © 2017 Joseph Patino. All rights reserved.
//

import XCTest
@testable import Pin

class PinTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
	func testMethod() {
		let a = Pin(type: .axis)
		print(a)
		
		switch a.type {
		case .axis:
			print("is axis")
		case .dimension:
			print("is dimension")
		case .edge:
			print("is edge")
		}
		
		print(a.value)
	}
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
