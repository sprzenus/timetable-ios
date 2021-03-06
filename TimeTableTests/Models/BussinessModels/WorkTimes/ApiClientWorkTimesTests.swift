//
//  ApiClient+WorkTimes.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 22/11/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class ApiClientWorkTimesTests: XCTestCase {
    
    private var networkingMock: NetworkingMock!
    private var requestEncoderMock: RequestEncoderMock!
    private var jsonDecoderMock: JSONDecoderMock!
    private var apiClient: ApiClientWorkTimesType!
    
    private enum WorkTimesResponse: String, JSONFileResource {
        case workTimesResponse
    }
    
    private enum SimpleProjectResponse: String, JSONFileResource {
        case simpleProjectFullResponse
    }
    
    private lazy var decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(DateFormatter(type: .dateAndTimeExtended))
        return decoder
    }()
    
    override func setUp() {
        self.networkingMock = NetworkingMock()
        self.requestEncoderMock = RequestEncoderMock()
        self.jsonDecoderMock = JSONDecoderMock()
        apiClient = ApiClient(networking: networkingMock, buildEncoder: { () -> RequestEncoderType in
            return requestEncoderMock
        }) { () -> JSONDecoderType in
            return jsonDecoderMock
        }
        super.setUp()
    }

    // MARK: - ApiClientWorkTimesType
    func testFetchSucceed() throws {
        //Arrange
        let data = try self.json(from: WorkTimesResponse.workTimesResponse)
        let decoders = try decoder.decode([WorkTimeDecoder].self, from: data)
        var expectedWorkTimes: [WorkTimeDecoder]?
        let parameters = WorkTimesParameters(fromDate: nil, toDate: nil, projectIdentifier: nil)
        //Act
        apiClient.fetchWorkTimes(parameters: parameters) { result in
            switch result {
            case .success(let workTimeDecoder):
                expectedWorkTimes = workTimeDecoder
            case .failure:
                XCTFail()
            }
        }
        networkingMock.getCompletion?(.success(data))
        //Assert
        XCTAssertEqual(try (expectedWorkTimes?[0]).unwrap(), decoders[0])
        XCTAssertEqual(try (expectedWorkTimes?[1]).unwrap(), decoders[1])
    }
    
    func testFetchFailed() throws {
        //Arrange
        var expectedError: Error?
        let error = TestError(message: "fetch failed")
        let parameters = WorkTimesParameters(fromDate: nil, toDate: nil, projectIdentifier: nil)
        //Act
        apiClient.fetchWorkTimes(parameters: parameters) { result in
            switch result {
            case .success:
                XCTFail()
            case .failure(let error):
                expectedError = error
            }
        }
        networkingMock.getCompletion?(.failure(error))
        //Assert
        let testError = try (expectedError as? TestError).unwrap()
        XCTAssertEqual(testError, error)
    }
    
    func testAddWorkTimeSucceed() throws {
        //Arrange
        var successCalled = false
        let data = try self.json(from: SimpleProjectResponse.simpleProjectFullResponse)
        let projectDecoder = try decoder.decode(ProjectDecoder.self, from: data)
        let task = Task(workTimeIdentifier: nil,
                        project: projectDecoder,
                        body: "body",
                        url: nil,
                        day: nil,
                        startAt: nil,
                        endAt: nil,
                        tag: .development)
        //Act
        apiClient.addWorkTime(parameters: task) { result in
            switch result {
            case .success:
                successCalled = true
            case .failure:
                XCTFail()
            }
        }
        networkingMock.shortPostCompletion?(.success(data))
        //Assert
        XCTAssertTrue(successCalled)
    }
    
    func testAddWorkTimeFailed() throws {
        //Arrange
        var expectedError: Error?
        let error = TestError(message: "fetch failed")
        let data = try self.json(from: SimpleProjectResponse.simpleProjectFullResponse)
        let projectDecoder = try decoder.decode(ProjectDecoder.self, from: data)
        let task = Task(workTimeIdentifier: nil,
                        project: projectDecoder,
                        body: "body",
                        url: nil,
                        day: nil,
                        startAt: nil,
                        endAt: nil,
                        tag: .development)
        //Act
        apiClient.addWorkTime(parameters: task) { result in
            switch result {
            case .success:
                XCTFail()
            case .failure(let error):
                expectedError = error
            }
        }
        networkingMock.shortPostCompletion?(.failure(error))
        //Assert
        let testError = try (expectedError as? TestError).unwrap()
        XCTAssertEqual(testError, error)
    }
    
    func testDeleteWorkTimeSucceed() {
        //Arrange
        var successCalled = false
        //Act
        apiClient.deleteWorkTime(identifier: 2) { result in
            switch result {
            case .success:
                successCalled = true
            case .failure:
                XCTFail()
            }
        }
        networkingMock.deleteCompletion?(.success(Void()))
        //Assert
        XCTAssertTrue(successCalled)
    }
    
    func testDeleteWorkTimeFailed() throws {
        //Arrange
        var expectedError: Error?
        let error = TestError(message: "fetch failed")
        //Act
        apiClient.deleteWorkTime(identifier: 2) { result in
            switch result {
            case .success:
                XCTFail()
            case .failure(let error):
                expectedError = error
            }
        }
        networkingMock.deleteCompletion?(.failure(error))
        //Assert
        let testError = try (expectedError as? TestError).unwrap()
        XCTAssertEqual(testError, error)
    }
    
    func testUpdateWorkTime_succeed() throws {
        //Arrange
        var successCalled = false
        let data = try self.json(from: SimpleProjectResponse.simpleProjectFullResponse)
        let projectDecoder = try decoder.decode(ProjectDecoder.self, from: data)
        let task = Task(workTimeIdentifier: nil,
                        project: projectDecoder,
                        body: "body",
                        url: nil,
                        day: nil,
                        startAt: nil,
                        endAt: nil,
                        tag: .development)
        //Act
        apiClient.updateWorkTime(identifier: 1, parameters: task) { result in
            switch result {
            case .success:
                successCalled = true
            case .failure:
                XCTFail()
            }
        }
        networkingMock.putCompletion?(.success(data))
        //Assert
        XCTAssertTrue(successCalled)
    }
    
    func testUpdateWorkTime_fail() throws {
        //Arrange
        var expectedError: Error?
        let error = TestError(message: "fetch failed")
        let data = try self.json(from: SimpleProjectResponse.simpleProjectFullResponse)
        let projectDecoder = try decoder.decode(ProjectDecoder.self, from: data)
        let task = Task(workTimeIdentifier: nil,
                        project: projectDecoder,
                        body: "body",
                        url: nil,
                        day: nil,
                        startAt: nil,
                        endAt: nil,
                        tag: .development)
        //Act
        apiClient.updateWorkTime(identifier: 1, parameters: task) { result in
            switch result {
            case .success:
                XCTFail()
            case .failure(let error):
                expectedError = error
            }
        }
        networkingMock.putCompletion?(.failure(error))
        //Assert
        let testError = try (expectedError as? TestError).unwrap()
        XCTAssertEqual(testError, error)
    }
}
