//
//  MainView.swift
//  ServersListTest
//
//  Created by Jakub Wolański on 23/06/2023.
//

import SwiftUI
import User

struct MainView: View {
    private let viewModel = MainViewViewModel()
    @State var showLoginForm = false

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
        .onReceive(viewModel.$isLoggedIn, perform: { isLoggedIn in
            withAnimation {
                showLoginForm = isLoggedIn == false
            }
        })
        .overlay() {
            GeometryReader { geometry in
                ScrollView {
                    VStack(spacing: 40) {
                        Spacer()
                        Image("logo")
                        if showLoginForm {
                            LoginForm()
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
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}

class MainViewViewModel: ObservableObject {
    @Published private(set) var isLoggedIn: Bool = false

    init() {
        isLoggedIn = false
    }
}
