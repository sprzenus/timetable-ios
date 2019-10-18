//
//  DisplayedInfoView.swift
//  TimeTable
//
//  Created by Bartłomiej Świerad on 18/10/2019.
//  Copyright © 2019 Railwaymen. All rights reserved.
//

import SwiftUI

struct DisplayedInfoView<T: DisplayedInfoViewModel>: View {
    @ObservedObject var viewModel: T
    
    var body: some View {
        TextField(viewModel.title, text: viewModel.value)
            .textFieldStyle(PlainTextFieldStyle())
            .disabled(viewModel.isDisabled)
            .accentColor(Color(UIColor.crimson))
    }
}

// MARK: - Preview
struct DisplayedInfoView_Previews: PreviewProvider {
    static private var viewModel = DisplayedInfoViewModel(.constant(.init(title: "Title", value: "", isDisabled: false)))
    
    static var previews: some View {
        DisplayedInfoView(viewModel: viewModel)
            .previewLayout(PreviewLayout.fixed(width: 380, height: 40))
    }
}
