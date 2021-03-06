//
//  UserDecoderTests.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 18/01/2019.
//  Copyright © 2019 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class UserDecoderTests: XCTestCase {
    
    private enum UserResponse: String, JSONFileResource {
        case userFullResponse
    }
    
    private lazy var decoder = JSONDecoder()
    
    func testParsingUserFullResponse() throws {
        //Arrange
        let data = try self.json(from: UserResponse.userFullResponse)
        //Act
        let userDecoder = try decoder.decode(UserDecoder.self, from: data)
        //Assert
        XCTAssertEqual(userDecoder.firstName, "John")
        XCTAssertEqual(userDecoder.lastName, "Little")
        XCTAssertEqual(userDecoder.email, "john.little@example.com")
    }
}
