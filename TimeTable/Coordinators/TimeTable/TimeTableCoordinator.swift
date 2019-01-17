//
//  TimeTableTabCoordinator.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 19/11/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import UIKit

typealias TimeTableTabApiClientType = (ApiClientWorkTimesType & ApiClientProjectsType)

class TimeTableTabCoordinator: BaseTabBarCoordinator {

    private let tabBarChildCoordinators: [BaseTabBarCordninatorType]
    
    // MARK: - Initialization
    init(window: UIWindow?, storyboardsManager: StoryboardsManagerType, apiClient: TimeTableTabApiClientType, errorHandler: ErrorHandlerType) {
        let projectsCoordinator = ProjectsCoordinator(window: nil,
                                                      storyboardsManager: storyboardsManager,
                                                      apiClient: apiClient,
                                                      errorHandler: errorHandler)
        let workTimeCoordinator = WorkTimesCoordinator(window: nil,
                                                      storyboardsManager: storyboardsManager,
                                                      apiClient: apiClient,
                                                      errorHandler: errorHandler)
        let userCoordinator = UserCoordinator(window: nil,
                                              storyboardsManager: storyboardsManager)
        
        self.tabBarChildCoordinators = [projectsCoordinator, workTimeCoordinator, userCoordinator]
        super.init(window: window)
        self.tabBarController.tabBar.tintColor = UIColor.crimson
        self.tabBarChildCoordinators.forEach { $0.start() }
    }
    
    // MARK: - Overriden
    override func start(finishCompletion: (() -> Void)?) {
        self.tabBarController.viewControllers = self.tabBarChildCoordinators.map { $0.root }
        super.start(finishCompletion: finishCompletion)
    }
}
