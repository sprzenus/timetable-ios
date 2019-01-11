//
//  WorkTimeViewModel.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 09/01/2019.
//  Copyright © 2019 Railwaymen. All rights reserved.
//

import Foundation

protocol WorkTimeViewModelOutput: class {
    func setUp(currentProjectName: String, allowsTask: Bool)
    func dismissView()
    func reloadProjectPicker()
    func dissmissKeyboard()
    func setMinimumDateForTypeToDate(minDate: Date)
    func updateFromDate(withDate date: Date, dateString: String)
    func updateToDate(withDate date: Date, dateString: String)
    func updateTimeLable(withTitle title: String?)
}

protocol WorkTimeViewModelType: class {
    func viewDidLoad()
    func viewRequestedForNumberOfProjects() -> Int
    func viewRequestedForProjectTitle(atRow row: Int) -> String?
    func viewSelectedProject(atRow row: Int)
    func viewRequestedToFinish()
    func taskNameDidChange(value: String?)
    func setDefaultTask()
    func taskURLDidChange(value: String?)
    func viewChanged(fromDate date: Date)
    func setDefaultFromDate()
    func viewChanged(toDate date: Date)
    func viewRequesetdToSave()
    func setDefaultToDate()
    func viewHasBeenTapped()
}

class WorkTimeViewModel: WorkTimeViewModelType {
    private weak var userInterface: WorkTimeViewModelOutput?
    private let apiClient: ApiClientProjectsType
    private let errorHandler: ErrorHandlerType
    private var projects: [ProjectDecoder]
    private var task: Task
    
    // MARK: - Initialization
    init(userInterface: WorkTimeViewModelOutput?, apiClient: ApiClientProjectsType, errorHandler: ErrorHandlerType) {
        self.userInterface = userInterface
        self.apiClient = apiClient
        self.errorHandler = errorHandler
        self.projects = []
        self.task = Task(project: .none, title: "", url: nil, fromDate: nil, toDate: nil)
    }
    
    // MARK: - WorkTimeViewModelType
    func viewDidLoad() {
        updateViewWithCurrentSelectedProject()
        fetchProjectList()
    }
    
    func viewRequestedForNumberOfProjects() -> Int {
        return projects.count
    }
    
    func viewRequestedForProjectTitle(atRow row: Int) -> String? {
        return projects.count > row ? projects[row].name : nil
    }
    
    func setDefaultTask() {
        guard !projects.isEmpty else { return }
        switch task.project {
        case .none:
            task.project = .some(projects[0])
            updateViewWithCurrentSelectedProject()
        case .some:
            return
        }
    }
    
    func viewSelectedProject(atRow row: Int) {
        guard projects.count > row else { return }
        task.project = .some(projects[row])
        updateViewWithCurrentSelectedProject()
    }
    
    func viewRequestedToFinish() {
        userInterface?.dismissView()
    }
    
    func taskNameDidChange(value: String?) {
        guard let title = value else { return }
        task.title = title
    }
    
    func taskURLDidChange(value: String?) {
        guard let stringURL = value, let url = URL(string: stringURL) else { return }
        task.url = url
    }
    
    func viewChanged(fromDate date: Date) {
        task.fromDate = date
        updateFromDateView(with: date)
    }
    
    func setDefaultFromDate() {
        var date = Date()
        if let fromDate = task.fromDate {
            date = fromDate
        } else {
            date = Date()
            task.fromDate = date
        }
        updateFromDateView(with: date)
    }
    
    func viewChanged(toDate date: Date) {
        task.toDate = date
        updateToDateView(with: date)
    }
    
    func setDefaultToDate() {
        var date = Date()
        if let toDate = task.toDate {
            date = toDate
        } else {
            date = task.fromDate ?? Date()
            task.toDate = date
        }
        updateToDateView(with: date)
    }
    
    func viewRequesetdToSave() {
        
    }
    
    func viewHasBeenTapped() {
        userInterface?.dissmissKeyboard()
    }
    
    // MARK: - Private
    private func updateViewWithCurrentSelectedProject() {
        userInterface?.setUp(currentProjectName: task.project.title, allowsTask: task.project.allowsTask)
        
        guard let type = task.project.type else { return }
        switch type {
        case .fullDay(let timeInterval):
            let calendar = Calendar.autoupdatingCurrent
            let fromDate = calendar.date(bySettingHour: 9, minute: 0, second: 0, of: Date()) ?? Date()
            let toDate = fromDate.addingTimeInterval(timeInterval)
            task.fromDate = fromDate
            task.toDate = toDate
            updateFromDateView(with: fromDate)
            updateToDateView(with: toDate)
        case .lunch(let timeInterval):
            let fromDate = task.fromDate ?? Date()
            let toDate = fromDate.addingTimeInterval(timeInterval)
            task.fromDate = fromDate
            task.toDate = toDate
            updateFromDateView(with: fromDate)
            updateToDateView(with: toDate)
        case .standard: break
        }
    }
    
    private func updateFromDateView(with date: Date) {
        updateTimeLabel()
        let dateString = DateFormatter.localizedString(from: date, dateStyle: .none, timeStyle: .short)
        userInterface?.updateFromDate(withDate: date, dateString: dateString)
        userInterface?.setMinimumDateForTypeToDate(minDate: date)
        if let toDate = task.toDate, toDate < date {
            task.toDate = date
            updateToDateView(with: date)
        }
    }
    
    private func updateToDateView(with date: Date) {
        updateTimeLabel()
        userInterface?.updateToDate(withDate: date, dateString: DateFormatter.localizedString(from: date, dateStyle: .none, timeStyle: .short))
    }
    
    private func updateTimeLabel() {
        guard let fromDate = task.fromDate else { return }
        
        if let toDate = task.toDate {
            let dateString = DateFormatter.localizedString(from: fromDate, dateStyle: .short, timeStyle: .none)
            let interval = toDate.timeIntervalSince(fromDate)
            let formatter = DateComponentsFormatter()
            formatter.allowedUnits = [.hour, .minute]
            formatter.unitsStyle = .abbreviated
            let title = "\(formatter.string(from: interval) ?? "") \(dateString)"
            userInterface?.updateTimeLable(withTitle: title)
        } else {
            let dateString = DateFormatter.localizedString(from: fromDate, dateStyle: .short, timeStyle: .none)
            let title = "00:00 \(dateString)"
            userInterface?.updateTimeLable(withTitle: title)
        }
    }
    
    private func fetchProjectList() {
        apiClient.fetchSimpleListOfProjects { [weak self] result in
            switch result {
            case .success(let projects):
                self?.projects = projects.filter { $0.isActive ?? false }
                self?.userInterface?.reloadProjectPicker()
            case .failure(let error):
                self?.errorHandler.throwing(error: error)
            }
        }
    }
}
