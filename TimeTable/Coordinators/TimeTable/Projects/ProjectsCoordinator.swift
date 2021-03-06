//
//  ProjectsCoordinator.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 20/11/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import UIKit

class ProjectsCoordinator: BaseNavigationCoordinator, BaseTabBarCoordinatorType {
    private let storyboardsManager: StoryboardsManagerType
    private let apiClient: ApiClientProjectsType
    private let errorHandler: ErrorHandlerType
    
    var root: UIViewController {
        return self.navigationController
    }
    
    var tabBarItem: UITabBarItem
    
    // MARK: - Initialization
    init(window: UIWindow?,
         messagePresenter: MessagePresenterType?,
         storyboardsManager: StoryboardsManagerType,
         apiClient: ApiClientProjectsType,
         errorHandler: ErrorHandlerType) {
        self.storyboardsManager = storyboardsManager
        self.apiClient = apiClient
        self.errorHandler = errorHandler
        var image: UIImage = #imageLiteral(resourceName: "project_icon")
        if #available(iOS 13, *), let sfSymbol = UIImage(systemName: "rectangle.grid.2x2.fill") {
            image = sfSymbol
        }
        self.tabBarItem = UITabBarItem(title: "tabbar.title.projects".localized,
                                       image: image,
                                       selectedImage: nil)
        super.init(window: window, messagePresenter: messagePresenter)
        self.navigationController.setNavigationBarHidden(false, animated: false)
        self.navigationController.navigationBar.prefersLargeTitles = true
        self.navigationController.navigationBar.tintColor = .crimson
        self.root.tabBarItem = tabBarItem
    }
    
    // MARK: - CoordinatorType
    func start() {
        self.runMainFlow()
        super.start()
    }
    
    // MARK: - Private
    private func runMainFlow() {
        let controller: ProjectsViewControllerable? = storyboardsManager.controller(storyboard: .projects, controllerIdentifier: .initial)
        let viewModel = ProjectsViewModel(userInterface: controller, apiClient: apiClient, errorHandler: errorHandler)
        controller?.configure(viewModel: viewModel)
        if let controller = controller {        
            navigationController.pushViewController(controller, animated: false)
        }
    }
}
