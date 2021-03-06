//
//  CoordinatorMock.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 22/11/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import Foundation
@testable import TimeTable

class CoordinatorMock: ServerConfigurationCoordinatorDelagete {
    private(set) var serverConfigurationDidFinishValues: (called: Bool, serverConfiguration: ServerConfiguration?) = (false, nil)
    
    func serverConfigurationDidFinish(with serverConfiguration: ServerConfiguration) {
        serverConfigurationDidFinishValues = (true, serverConfiguration)
    }
}
