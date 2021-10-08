//
//  NetworkImageDownloadTest.swift
//  AppcentInterviewNetworkTests
//
//  Created by Oguzhan Ozturk on 4.10.2021.
//

import XCTest
@testable import AppcentInterview

class NetworkImageDownloadTest: XCTestCase {

    override func setUpWithError() throws {
        try super.setUpWithError()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
    }

    func testImageDownload() throws{
        
        let sut = ImageDownloadManager.shared
        let promise = expectation(description: "Image Load")
        
        sut.downloadImage(url: URL(string: "https://upload.wikimedia.org/wikipedia/tr/e/ec/Lisa_Simpson.png")!) { (result) in
            switch result{
            case .success(let data) :
                promise.fulfill()
            case .failure(let error) :
                XCTFail("\(error.localizedDescription)")
                break
            }
        }
        
        wait(for: [promise], timeout: 10)
        
    }
    
}
