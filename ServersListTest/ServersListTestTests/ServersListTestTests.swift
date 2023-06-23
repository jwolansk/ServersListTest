//
//  ServersListTestTests.swift
//  ServersListTestTests
//
//  Created by Jakub Wolański on 23/06/2023.
//

import Common
@testable import ServersListTest
import User
import XCTest

final class ServersListTestTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testAppConfig() throws {
        let config = Config()
        SLApplication.initialize(with: config, sessionManager: SLSessionManager())

        XCTAssert(SLApplication.config.apiBaseUrl == config.apiBaseUrl)
    }

}
