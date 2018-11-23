//
//  WorkTimesViewModel.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 23/11/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import Foundation

protocol WorkTimesViewModelOutput: class {
    func setUpView()
    func updateView()
}

protocol WorkTimesViewModelType: class {
    func numberOfSections() -> Int
    func numberOfRows(in section: Int) -> Int
    func viewDidLoad()
    func viewWillAppear()
    func viewRequestedForCellModel(at index: IndexPath) -> WorkTimeCellViewModelType?
}

struct DailyWorkTime {
    let day: Date
    var workTimes: [WorkTimeDecoder]
}

class WorkTimesViewModel: WorkTimesViewModelType {
    private weak var userInterface: WorkTimesViewModelOutput?
    private let apiClient: ApiClientWorkTimesType
    private let errorHandler: ErrorHandlerType
    
    private var dailyWorkTimesArray: [DailyWorkTime]
    
    // MARK: - Initialization
    init(userInterface: WorkTimesViewModelOutput, apiClient: ApiClientWorkTimesType, errorHandler: ErrorHandlerType) {
        self.userInterface = userInterface
        self.apiClient = apiClient
        self.errorHandler = errorHandler
        self.dailyWorkTimesArray = []
    }
    
    // MARK: - WorkTimesViewModelType
    func numberOfSections() -> Int {
        return dailyWorkTimesArray.count
    }
    
    func numberOfRows(in section: Int) -> Int {
        return dailyWorkTimesArray[section].workTimes.count
    }
    
    func viewDidLoad() {
        userInterface?.setUpView()
    }
    
    func viewWillAppear() {
        let dates = getStartAndEndDate(for: Date())
        let parameters = WorkTimesParameters(fromDate: dates.startOfMonth, toDate: dates.endOfMonth, projectIdentifier: nil)
        fetchWorkTimes(for: parameters)
    }
    
    func viewRequestedForCellModel(at index: IndexPath) -> WorkTimeCellViewModelType? {
        let workTime = dailyWorkTimesArray[index.section].workTimes.sorted(by: { $0.startsAt > $1.startsAt })[index.row]
        return WorkTimeCellViewModel(workTime: workTime)
    }
    
    // MARK: - Private
    private func fetchWorkTimes(for parameters: WorkTimesParameters) {
        apiClient.fetchWorkTimes(parameters: parameters) { [weak self] result in
            switch result {
            case .success(let workTimes):
                self?.dailyWorkTimesArray = workTimes.reduce([DailyWorkTime](), { (array, workTime) in
                    var newArray = array
                    if var dailyWorkTimes = array.first(where: { $0.day == workTime.date }) {
                        dailyWorkTimes.workTimes.append(workTime)
                    } else {
                        let new = DailyWorkTime(day: workTime.date, workTimes: [workTime])
                        newArray.append(new)
                    }
                    return newArray
                }).sorted(by: { $0.day > $1.day })
                self?.userInterface?.updateView()
            case .failure(let error):
                self?.errorHandler.throwing(error: error)
            }
        }
    }
    
    private func getStartAndEndDate(for date: Date) -> (startOfMonth: Date?, endOfMonth: Date?) {
        let calendar = Calendar.autoupdatingCurrent
        let startOfMonthComponents = calendar.dateComponents([.year, .month], from: date)
        let startOfMonth = calendar.date(from: startOfMonthComponents)
        guard let date = startOfMonth else { return (startOfMonth, nil) }
        let endOfMonthComponents = DateComponents(month: 1, day: -1)
        let endOfMonth = calendar.date(byAdding: endOfMonthComponents, to: date)
        return (startOfMonth, endOfMonth)
    }
}
