//
//  NetworkStateTest.swift
//  AppcentInterviewNetworkTests
//
//  Created by Oguzhan Ozturk on 3.10.2021.
//

import XCTest
@testable import AppcentInterview

class NetworkStateTest: XCTestCase {

    override func setUpWithError() throws {
        try super.setUpWithError()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
    }

    func testNetworkState() throws{
        let sut = NetworkMonitor.networkMonitor
        sut.startMonitoring()
        Thread.sleep(forTimeInterval: 1)
        XCTAssertTrue(sut.isConnected,"\(sut.monitor.currentPath.status)")
    }
    
}
