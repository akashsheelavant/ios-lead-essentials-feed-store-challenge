//
//  XCTestCase+MemoryLeakTracking.swift
//  Tests
//
//  Created by Akash Seelavant on 12/03/21.
//  Copyright © 2021 Essential Developer. All rights reserved.
//

import XCTest

extension XCTestCase {
	func trackForMemoryLeak(_ instance: AnyObject, file: StaticString = #file, line: UInt = #line){
		addTeardownBlock { [weak instance] in
			XCTAssertNil(instance, "Instance should have deallocated. Possible memory leak",file: file, line: line)
		}
	}
}
