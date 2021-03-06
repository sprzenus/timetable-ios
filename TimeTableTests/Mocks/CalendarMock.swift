//
//  CalendarMock.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 27/11/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import Foundation
@testable import TimeTable

// swiftlint:disable large_tuple
// swiftlint:disable function_parameter_count
class CalendarMock: CalendarType {
    
    private(set) var dateComponentsData: (components: Set<Calendar.Component>?, date: Date?) = (nil, nil)
    var dateComponentsReturnValue: DateComponents!
    func dateComponents(_ components: Set<Calendar.Component>, from date: Date) -> DateComponents {
        dateComponentsData = (components, date)
        return dateComponentsReturnValue
    }
    
    private(set) var dateFromComponents: DateComponents?
    var dateFromComponentsValue: Date?
    func date(from components: DateComponents) -> Date? {
        dateFromComponents = components
        return dateFromComponentsValue
    }
    
    private(set) var dateBySettingHourShortData: (hour: Int?, minute: Int?, second: Int?, date: Date?) = (nil, nil, nil, nil)
    var dateBySettingHourShortReturnValue: Date?
    func date(bySettingHour hour: Int, minute: Int, second: Int, of date: Date) -> Date? {
        dateBySettingHourShortData = (hour, minute, second, date)
        return dateBySettingHourShortReturnValue
    }
    
    private(set) var dateBySettingHourLongData: (hour: Int?, minute: Int?, second: Int?,
        date: Date?, matchingPolicy: Calendar.MatchingPolicy?,
        repeatedTimePolicy: Calendar.RepeatedTimePolicy?, direction: Calendar.SearchDirection?) = (nil, nil, nil, nil, nil, nil, nil)
    var dateBySettingHourLongReturnValue: Date?
    func date(bySettingHour hour: Int, minute: Int, second: Int, of date: Date,
              matchingPolicy: Calendar.MatchingPolicy, repeatedTimePolicy: Calendar.RepeatedTimePolicy, direction: Calendar.SearchDirection) -> Date? {
        dateBySettingHourLongData = (hour, minute, second, date, matchingPolicy, repeatedTimePolicy, direction)
        return dateBySettingHourLongReturnValue
    }
    
    private(set) var dateBySettingData: (component: Calendar.Component?, value: Int?, date: Date?) = (nil, nil, nil)
    var dateBySettingReturnValue: Date?
    func date(bySetting component: Calendar.Component, value: Int, of date: Date) -> Date? {
        dateBySettingData = (component, value, date)
        return dateBySettingReturnValue
    }
    
    private(set) var fullDateByAddingData: (components: DateComponents?, date: Date?, wrappingComponents: Bool?) = (nil, nil, nil)
    var fullDateByAddingReturnValue: Date?
    func date(byAdding components: DateComponents, to date: Date, wrappingComponents: Bool) -> Date? {
        fullDateByAddingData = (components, date, wrappingComponents)
        return fullDateByAddingReturnValue
    }
    
    private(set) var shortDateByAddingData: (components: DateComponents?, date: Date?) = (nil, nil)
    var shortDateByAddingReturnValue: Date?
    func date(byAdding components: DateComponents, to date: Date) -> Date? {
        shortDateByAddingData = (components, date)
        return shortDateByAddingReturnValue
    }
    
    private(set) var fullDateByAddingDataWithValueData: (components: Calendar.Component?, value: Int?, date: Date?,
        wrappingComponents: Bool?) = (nil, nil, nil, nil)
    var fullDateByAddingWithValueReturnValue: Date?
    func date(byAdding component: Calendar.Component, value: Int, to date: Date, wrappingComponents: Bool) -> Date? {
        fullDateByAddingDataWithValueData = (component, value, date, wrappingComponents)
        return fullDateByAddingWithValueReturnValue
    }
    
    private(set) var shortDateByAddingDataWithValueData: (components: Calendar.Component?, value: Int?, date: Date?) = (nil, nil, nil)
    var shortDateByAddingWithValueReturnValue: Date?
    func date(byAdding component: Calendar.Component, value: Int, to date: Date) -> Date? {
        shortDateByAddingDataWithValueData = (component, value, date)
        return shortDateByAddingWithValueReturnValue
    }
    
    private(set) var isDateInTodayValues: (called: Bool, date: Date?) = (false, nil)
    var isDateInTodayReturnValue = false
    func isDateInToday(_ date: Date) -> Bool {
        isDateInTodayValues = (true, date)
        return isDateInTodayReturnValue
    }
    
    private(set) var isDateInYesterdayValues: (called: Bool, date: Date?) = (false, nil)
    var isDateInYesterdayReturnValue = false
    func isDateInYesterday(_ date: Date) -> Bool {
        isDateInYesterdayValues = (true, date)
        return isDateInYesterdayReturnValue
    }
}
// swiftlint:enable large_tuple
// swiftlint:enable function_parameter_count
