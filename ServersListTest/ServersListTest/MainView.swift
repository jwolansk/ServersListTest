//
//  MainView.swift
//  ServersListTest
//
//  Created by Jakub Wolański on 23/06/2023.
//

import Common
import SwiftUI
import UICommon
import User

struct MainView: View {
    @ObservedObject private var viewModel: MainViewViewModel
    @State var showLoginForm = false
    @State var hideLogo = false

    init(viewModel: MainViewViewModel) {
        self.viewModel = viewModel
    }
    var body: some View {
        VStack {
            Spacer()
            Image("splash")
                .resizable()
                .frame(width: 430, height: 378)
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: .infinity)
        }
        .ignoresSafeArea()
        .onAppear() {
            // check login form needed
            withAnimation {
                showLoginForm = viewModel.isLoggedIn == false
            }
        }
        .overlay() {
            GeometryReader { geometry in
                ScrollView {
                    VStack(spacing: 40) {
                        Spacer()
                        if hideLogo == false {
                            Image("logo")
                        }
                        if showLoginForm {
                            // TODO: normally with full app this conditional view creation should be a part of dedicated view provider object
                            if let viewModel: LoginFormViewModel = SLApplication.viewModelFactory.create() {
                                LoginForm(viewModel: viewModel)
                            }
                        }
                        if hideLogo {
                            VStack(spacing: 6) {
                                LoadingSpinner()
                                Text("Loading list")
                                    .font(SLFont.caption.font)
                                    .foregroundColor(SLColor.grayForeground.color)
                            }
                        }
                        Spacer()
                    }
                    .padding(32)
                    .frame(width: geometry.size.width)
                    .frame(minHeight: geometry.size.height)
                }
            }
            .ignoresSafeArea(.container)
        }
        .onChange(of: viewModel.isLoggedIn) { isLoggedIn in
            withAnimation {
                showLoginForm = isLoggedIn == false
                hideLogo = isLoggedIn
            }
        }
    }
}

struct LoadingSpinner: View {
    @State private var show = false

    var body: some View {
        Image("Spinner")
            .rotationEffect(.degrees(show ? 360 : 0))
            .animation(.linear(duration: 2).repeatForever(autoreverses: false), value: show)
            .onAppear {
                DispatchQueue.main.async {
                    show.toggle()
                }
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(viewModel: MainViewViewModel(sessionManager: SLSessionManager()))
    }
}

class MainViewViewModel: ObservableObject {
    @Published private(set) var isLoggedIn: Bool = false

    private var sessionManager: SessionManager

    init(sessionManager: SessionManager) {
        self.sessionManager = sessionManager

        sessionManager.isLoggedIn.assign(to: &$isLoggedIn)
    }
}
