//
//  ApiClient+WorkTimes.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 22/11/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import Foundation

protocol ApiClientWorkTimesType: class {
    func fetchWorkTimes(parameters: WorkTimesParameters, completion: @escaping ((Result<[WorkTimeDecoder]>) -> Void))
    func addWorkTime(parameters: Task, completion: @escaping ((Result<Void>) -> Void))
    func deleteWorkTime(identifier: Int64, completion: @escaping ((Result<Void>) -> Void))
    func updateWorkTime(identifier: Int64, parameters: Task, completion: @escaping ((Result<Void>) -> Void))
}

// MARK: - ApiClientWorkTimesType
extension ApiClient: ApiClientWorkTimesType {
    func fetchWorkTimes(parameters: WorkTimesParameters, completion: @escaping ((Result<[WorkTimeDecoder]>) -> Void)) {
        get(.workTimes, parameters: parameters, completion: completion)
    }
    
    func addWorkTime(parameters: Task, completion: @escaping ((Result<Void>) -> Void)) {
        post(.workTimes, parameters: parameters, completion: completion)
    }
    
    func deleteWorkTime(identifier: Int64, completion: @escaping ((Result<Void>) -> Void)) {
        delete(.workTime(identifier), completion: completion)
    }
    
    func updateWorkTime(identifier: Int64, parameters: Task, completion: @escaping ((Result<Void>) -> Void)) {
        put(.workTime(identifier), parameters: parameters, completion: completion)
    }
}
