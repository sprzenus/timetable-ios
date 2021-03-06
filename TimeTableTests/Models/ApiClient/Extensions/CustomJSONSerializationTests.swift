//
//  CustomJSONSerializationTests.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 07/11/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class CustomJSONSerializationTests: XCTestCase {
    
    private enum SessionResponse: String, JSONFileResource {
        case signInResponse
    }
    private lazy var decoder = JSONDecoder()
    
    func testJsonObject() throws {
        //Arrange
        let data = try self.json(from: SessionResponse.signInResponse)
        let sessionReponse = try decoder.decode(SessionDecoder.self, from: data)
        //Act
        let jsonData = try CustomJSONSerialization().jsonObject(with: data, options: .allowFragments) as? [AnyHashable: Any]
        let json = try jsonData.unwrap()
        //Assert
        XCTAssertEqual(json["id"] as? Int, sessionReponse.identifier)
        XCTAssertEqual(json["first_name"] as? String, sessionReponse.firstName)
        XCTAssertEqual(json["last_name"] as? String, sessionReponse.lastName)
        XCTAssertEqual(json["is_leader"] as? Bool, sessionReponse.isLeader)
        XCTAssertEqual(json["admin"] as? Bool, sessionReponse.admin)
        XCTAssertEqual(json["manager"] as? Bool, sessionReponse.manager)
        XCTAssertEqual(json["token"] as? String, sessionReponse.token)
    }
}
