//
//  UserProfileViewModel.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 17/01/2019.
//  Copyright © 2019 Railwaymen. All rights reserved.
//

import SwiftUI

protocol UserProfileViewModelOutput: class {
    func setUp()
    func update(firstName: String, lastName: String, email: String)
}

protocol UserProfileViewModelType: ObservableObject {
    var informations: [DisplayedInfoViewModel.Information] { get }
    var bottomContentInset: CGFloat { get }
    func viewDidAppear()
    func createDisplayedViewModel(for information: DisplayedInfoViewModel.Information) -> DisplayedInfoViewModel
    func logOutButtonTapped()
}

class UserProfileViewModel {
    private weak var coordinator: UserCoordinatorDelegate?
    private let apiClient: ApiClientUsersType
    private let accessService: AccessServiceUserIDType
    private let coreDataStack: CoreDataStackUserType
    private let errorHandler: ErrorHandlerType
    private let notificationCenter: NotificationCenterType
    
    private var user: UserDecoder = UserDecoder(identifier: 0, firstName: "", lastName: "", email: "") {
        didSet {
            self.updateInformations()
        }
    }
    
    @Published var informations: [DisplayedInfoViewModel.Information] = []
    @Published var bottomContentInset: CGFloat = 0
        
    // MARK: - Initialization
    init(coordinator: UserCoordinatorDelegate?,
         apiClient: ApiClientUsersType,
         accessService: AccessServiceUserIDType,
         coreDataStack: CoreDataStackUserType,
         errorHandler: ErrorHandlerType,
         notificationCenter: NotificationCenterType = NotificationCenter.default) {
        self.coordinator = coordinator
        self.apiClient = apiClient
        self.accessService = accessService
        self.coreDataStack = coreDataStack
        self.errorHandler = errorHandler
        self.notificationCenter = notificationCenter
        
        updateInformations()
        setUpNotifications()
    }
    
    deinit {
        notificationCenter.removeObserver(self)
    }
    
    // MARK: - Notifications
    @objc private func keyboardWillChangeFrame(notification: NSNotification) {
        guard let keyboardHeight = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size.height else { return }
        withAnimation(.easeOut(duration: 0.5)) { [weak self] in
            self?.bottomContentInset = keyboardHeight
        }
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        withAnimation(.easeOut(duration: 0.25)) { [weak self] in
            self?.bottomContentInset = 0
        }
    }
}

// MARK: - UserProfileViewModelType
extension UserProfileViewModel: UserProfileViewModelType {
    func viewDidAppear() {
        guard let userIdentifier = accessService.getLastLoggedInUserIdentifier() else { return }
        apiClient.fetchUserProfile(forIdetifier: userIdentifier) { [weak self] result in
            switch result {
            case .success(let decoder):
                self?.user = decoder
            case .failure(let error):
                self?.errorHandler.throwing(error: error)
            }
        }
    }
    
    func createDisplayedViewModel(for information: DisplayedInfoViewModel.Information) -> DisplayedInfoViewModel {
        return DisplayedInfoViewModel(binding(for: information))
    }
    
    func logOutButtonTapped() {
        guard let userIdentifier = accessService.getLastLoggedInUserIdentifier() else { return }
        coreDataStack.deleteUser(forIdentifier: userIdentifier) { [weak self] result in
            switch result {
            case .success:
                DispatchQueue.main.async { [weak self] in
                    self?.coordinator?.userProfileDidLogoutUser()
                }
            case .failure(let error):
                self?.errorHandler.throwing(error: error)
            }
        }
    }
}

// MARK: - Private
private extension UserProfileViewModel {
    func binding(for information: DisplayedInfoViewModel.Information) -> Binding<DisplayedInfoViewModel.Information> {
        return .init(get: { information }) { [weak self] newValue in
            guard let index = self?.informations.firstIndex(of: information) else { return }
            self?.informations[index] = newValue
        }
    }
    
    func updateInformations() {
        self.informations = [
            .init(title: "First Name", value: user.firstName, isDisabled: true),
            .init(title: "Last Name", value: user.lastName, isDisabled: false),
            .init(title: "Email Address", value: user.email, isDisabled: true)
        ]
    }
    
    func setUpNotifications() {
        self.notificationCenter.addObserver(self,
                                            selector: #selector(self.keyboardWillChangeFrame),
                                            name: UIResponder.keyboardWillChangeFrameNotification,
                                            object: nil)
        self.notificationCenter.addObserver(self,
                                            selector: #selector(self.keyboardWillHide),
                                            name: UIResponder.keyboardWillHideNotification,
                                            object: nil)
    }
}
