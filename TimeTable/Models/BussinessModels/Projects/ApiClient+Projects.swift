//
//  ApiClient+Projects.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 02/01/2019.
//  Copyright © 2019 Railwaymen. All rights reserved.
//

import Foundation

protocol ApiClientProjectsType: class {
    func fetchAllProjects(completion: @escaping ((Result<[ProjectRecordDecoder]>) -> Void))
    func fetchSimpleListOfProjects(completion: @escaping ((Result<SimpleProjectDecoder>) -> Void))
}

// MARK: - ApiClientSessionType
extension ApiClient: ApiClientProjectsType {
    func fetchAllProjects(completion: @escaping ((Result<[ProjectRecordDecoder]>) -> Void)) {
        get(.projects, completion: completion)
    }
    
    func fetchSimpleListOfProjects(completion: @escaping ((Result<SimpleProjectDecoder>) -> Void)) {
        get(.projectsSimpleList, completion: completion)
    }
}
