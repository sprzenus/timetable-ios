//
//  WorkTimeViewControllerMock.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 16/01/2019.
//  Copyright © 2019 Railwaymen. All rights reserved.
//

import Foundation
@testable import TimeTable

class WorkTimeViewControllerMock: WorkTimeViewControlleralbe {
    // swiftlint:disable large_tuple
    private(set) var configureViewModelData: (called: Bool, viewModel: WorkTimeViewModelType?, notificationCenter: NotificationCenterType?) = (false, nil, nil)
    private(set) var setUpCurrentProjectName: (currentProjectName: String, isLunch: Bool, allowsTask: Bool, body: String?, urlString: String?)?
    // swiftlint:enable large_tuple
    private(set) var dismissViewCalled = false
    private(set) var reloadProjectPickerCalled = false
    private(set) var reloadTagsViewCalled = false
    private(set) var dissmissKeyboardCalled = false
    private(set) var setMinimumDateForTypeToDateValues: (called: Bool, minDate: Date?) = (false, nil)
    private(set) var updateDayValues: (date: Date?, dateString: String?) = (nil, nil)
    private(set) var updateStartAtDateValues: (date: Date?, dateString: String?) = (nil, nil)
    private(set) var updateEndAtDateValues: (date: Date?, dateString: String?) = (nil, nil)
    private(set) var selectProjectPickerRow: Int?

    func configure(viewModel: WorkTimeViewModelType, notificationCenter: NotificationCenterType?) {
        configureViewModelData = (true, viewModel, notificationCenter)
    }
    
    func setUp(currentProjectName: String, isLunch: Bool, allowsTask: Bool, body: String?, urlString: String?) {
        setUpCurrentProjectName = (currentProjectName, isLunch, allowsTask, body, urlString)
    }

    func dismissView() {
        dismissViewCalled = true
    }
    
    func reloadProjectPicker() {
        reloadProjectPickerCalled = true
    }
    
    func reloadTagsView() {
        reloadTagsViewCalled = true
    }
    
    func dissmissKeyboard() {
        dissmissKeyboardCalled = true
    }
    
    func setMinimumDateForTypeEndAtDate(minDate: Date) {
        setMinimumDateForTypeToDateValues = (true, minDate)
    }
    
    func updateDay(with date: Date, dateString: String) {
        updateDayValues = (date, dateString)
    }
    
    func updateStartAtDate(with date: Date, dateString: String) {
        updateStartAtDateValues = (date, dateString)
    }
    
    func updateEndAtDate(with date: Date, dateString: String) {
        updateEndAtDateValues = (date, dateString)
    }
    
    func selectProjectPicker(row: Int) {
        selectProjectPickerRow = row
    }
}
