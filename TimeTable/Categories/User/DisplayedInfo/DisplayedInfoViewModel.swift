//
//  DisplayedInfoViewModel.swift
//  TimeTable
//
//  Created by Bartłomiej Świerad on 18/10/2019.
//  Copyright © 2019 Railwaymen. All rights reserved.
//

import SwiftUI

protocol DisplayedInfoViewModelType: ObservableObject {
    var title: String { get }
    var value: Binding<String> { get }
    var isDisabled: Bool { get }
}

class DisplayedInfoViewModel {
    @Published var information: Binding<Information>
    
    // MARK: - Initialization
    init(_ info: Binding<Information>) {
        self.information = info
    }
}

// MARK: - DisplayedInfoViewModelType
extension DisplayedInfoViewModel: DisplayedInfoViewModelType {
    var title: String {
        information.wrappedValue.title
    }
    
    var value: Binding<String> {
        information.value
    }
    
    var isDisabled: Bool {
        information.wrappedValue.isDisabled
    }
}

// MARK: - Structures
extension DisplayedInfoViewModel {
    struct Information: Hashable, Identifiable {
        var id: String { title }
        
        let title: String
        var value: String
        var isDisabled: Bool
    }
}
