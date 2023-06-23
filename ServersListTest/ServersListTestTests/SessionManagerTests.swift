//
//  SessionManagerTests.swift
//  ServersListTestTests
//
//  Created by Jakub Wolański on 23/06/2023.
//

import Common
@testable import ServersListTest
import User
import XCTest

final class SessionManagerTests: XCTestCase {

    var manager: SessionManager!

    override func setUpWithError() throws {
        manager = SLSessionManager()
    }

    func testSessionManager() throws {
        let token = "asfd"
        manager.store(token: token)
        XCTAssert(token == manager.token, "token not set")
    }

    func testLogout() throws {
        let token = "asfd"
        manager.store(token: token)
        XCTAssert(token == manager.token, "token not set")
        manager.logout()
        XCTAssert(manager.token == nil, "token not removed")
    }
}
