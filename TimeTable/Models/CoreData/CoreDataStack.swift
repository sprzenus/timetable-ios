//
//  CoreDataStack.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 08/11/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import Foundation
import CoreStore

typealias CoreDataStackType = (CoreDataStackUserType)

protocol CoreDataStackUserType: class {
    func deleteUser(forIdentifier identifier: Int64, completion: @escaping (Result<Void>) -> Void)
    func fetchUser(forIdentifier identifier: Int64, completion: @escaping (Result<UserEntity>) -> Void)
    func save<CDT: NSManagedObject>(userDecoder: SessionDecoder,
                                    coreDataTypeTranslation: @escaping ((AsynchronousDataTransactionType) -> CDT),
                                    completion: @escaping (Result<CDT>) -> Void)
}

class CoreDataStack {
    private static let xcodeModelName = "TimeTable"
    private static let fileName = "TimeTable.sqlite"
    private let stack: DataStackType
    
    enum Error: Swift.Error {
        case storageItemNotFound
    }
    
    // MARK: - Initialization
    init(buildStack: ((_ xcodeModelName: String, _ fileName: String) throws -> DataStackType)) throws {
        self.stack = try buildStack(CoreDataStack.xcodeModelName, CoreDataStack.fileName)
    }
}

// MARK: - CoreDataStackUserType
extension CoreDataStack: CoreDataStackUserType {
    
    func deleteUser(forIdentifier identifier: Int64, completion: @escaping (Result<Void>) -> Void) {
        fetchUser(forIdentifier: identifier) { [unowned self] result in
            switch result {
            case .success(let user):
                self.stack.perform(asynchronousTask: { (transaction) -> Void in
                    transaction.delete(user)
                }, success: { _ in
                    completion(.success(Void()))
                }, failure: { error in
                    completion(.failure(error))
                })
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchUser(forIdentifier identifier: Int64, completion: @escaping (Result<UserEntity>) -> Void) {
        guard let user = (try? stack.fetchAll(
            From<UserEntity>(),
            Where<UserEntity>("%K == %d", "identifier", identifier)
        ))?.first else {
            completion(.failure(Error.storageItemNotFound))
            return
        }
        completion(.success(user))
    }
    
    func save<CDT: NSManagedObject>(userDecoder: SessionDecoder,
                                    coreDataTypeTranslation: @escaping ((AsynchronousDataTransactionType) -> CDT),
                                    completion: @escaping (Result<CDT>) -> Void) {
        stack.perform(asynchronousTask: { transaction in
            return coreDataTypeTranslation(transaction)
        }, success: { entity in
            completion(.success(entity))
        }) { error in
            completion(.failure(error))
        }
    }
}
