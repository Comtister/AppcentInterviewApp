//
//  NetworkDataServiceTest.swift
//  
//
//  Created by Oguzhan Ozturk on 3.10.2021.
//

import XCTest
@testable import AppcentInterview

class NetworkDataServiceTest: XCTestCase {

    class TestRequest : NetRequestModel{
        override var baseUrl: String{
            return "https://api.nasa.gov/planetary/"
        }
        override var path: String{
            return "apod"
        }
        override var body: [String : String]?{
            return ["api_key" : "DEMO_KEY"]
        }
        
    }
    
    class TestResponse : Codable{
        var date : String
        var explanation : String
        var title : String
    }
    
    override func setUpWithError() throws {
        try super.setUpWithError()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
    }
    
    func testRequestTestData() throws{
        
        let networkMonitor = NetworkMonitor.networkMonitor
        networkMonitor.startMonitoring()
        Thread.sleep(forTimeInterval: 0.5)
        
        try XCTSkipUnless(networkMonitor.isConnected)
        
        let sut = NetworkDataServiceManager.shared
        let promise = expectation(description: "Data fetch complete")
        
        let testRequest = TestRequest()
        
        sut.sendRequest(request: testRequest) { (result : Result<TestResponse,NetworkDataError>) in
            switch result{
            case .success(_) :
                promise.fulfill()
            break
            case .failure(let error) :
                XCTFail(error.localizedDescription)
            }
        }
        
        wait(for: [promise], timeout: 10)
        
    }
    
    func testRequestGamesData() throws {
        let networkMonitor = NetworkMonitor.networkMonitor
        networkMonitor.startMonitoring()
        Thread.sleep(forTimeInterval: 0.5)
        
        try XCTSkipUnless(networkMonitor.isConnected)
        
        let sut = NetworkDataServiceManager.shared
        let promise = expectation(description: "Data fetch complete")
            
        sut.sendRequest(request: GamesRequest()) { (result : Result<GamesResponse,NetworkDataError>) in
            switch result{
            case .success(_) :
                promise.fulfill()
            break
            case .failure(let error) :
                XCTFail(error.localizedDescription)
            }
        }
        
        wait(for: [promise], timeout: 10)
        
    }

}
