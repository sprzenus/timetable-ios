//
//  UserProfileView.swift
//  TimeTable
//
//  Created by Bartłomiej Świerad on 16/10/2019.
//  Copyright © 2019 Railwaymen. All rights reserved.
//

import SwiftUI

struct UserProfileView<T: UserProfileViewModelType>: View {
    @ObservedObject var viewModel: T
    
    var body: some View {
        GeometryReader { proxy in
            Form {
                Section {
                    ForEach(self.viewModel.informations) { information in
                        DisplayedInfoView(viewModel: self.viewModel.createDisplayedViewModel(for: information))
                    }
                }
                
                Section {
                    Button(action: self.viewModel.logOutButtonTapped) {
                        HStack {
                            Spacer()
                            Text("profile.button.logout")
                                .foregroundColor(Color(UIColor.crimson))
                            Spacer()
                        }
                    }
                }
            }
            .padding(.bottom, max(self.viewModel.bottomContentInset - proxy.safeAreaInsets.bottom, 0))
        }
        .navigationBarTitle("tabbar.title.profile", displayMode: .automatic)
        .onAppear(perform: viewModel.viewDidAppear)
    }
}

// MARK: - Preview
struct UserProfileView_Previews: PreviewProvider {
    static private let viewModel = UserProfileViewModelPreviewMock(informations: [
        .init(title: "first.name", value: "Michael", isDisabled: true),
        .init(title: "last.name", value: "Smith", isDisabled: false),
        .init(title: "Email Address", value: "m.smith@example.com", isDisabled: true)
    ])
    
    static var previews: some View {
        Group {
            UserProfileView(viewModel: viewModel)
                .previewDevice(PreviewDevice(rawValue: "iPhone SE"))

            TabView {
                NavigationView {
                    UserProfileView(viewModel: viewModel)
                }
            }
            .environment(\.colorScheme, .dark)
        }
    }
}

// MARK: - View model preview mock
fileprivate final class UserProfileViewModelPreviewMock: UserProfileViewModelType {
    @Published var informations: [DisplayedInfoViewModel.Information]
    @Published var bottomContentInset: CGFloat
    
    init(informations: [DisplayedInfoViewModel.Information]) {
        self.informations = informations
        self.bottomContentInset = 0
    }
    
    func viewDidAppear() {
        
    }
    
    func createDisplayedViewModel(for information: DisplayedInfoViewModel.Information) -> DisplayedInfoViewModel {
        return DisplayedInfoViewModel(binding(for: information))
    }
    
    func logOutButtonTapped() {
        
    }
    
    // MARK: Private
    private func binding(for information: DisplayedInfoViewModel.Information) -> Binding<DisplayedInfoViewModel.Information> {
        return .init(get: { information }) { [weak self] newValue in
            guard let index = self?.informations.firstIndex(of: information) else { return }
            self?.informations[index] = newValue
        }
    }
}
