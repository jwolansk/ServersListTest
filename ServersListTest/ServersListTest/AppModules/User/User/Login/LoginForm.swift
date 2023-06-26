//
//  LoginForm.swift
//  User
//
//  Created by Jakub Wolański on 23/06/2023.
//

import Common
import SwiftUI
import UICommon

public struct LoginForm: View {
    // TODO: inject view model

    @StateObject private var viewModel: LoginFormViewModel

    public init(viewModel: LoginFormViewModel) {
        self._viewModel = .init(wrappedValue: viewModel)
    }

    public var body: some View {
        VStack(spacing: 16) { // TODO: move strings to some storage
            TextInputView(icon: Image("user"), placeholder: "Username", text: $viewModel.username)
            TextInputView(icon: Image("lock"), placeholder: "Password", text: $viewModel.password, isSecure: true)
            SLButton.Primary(title: "Log in") {
                viewModel.send()
            }.padding(EdgeInsets(top: 8, leading: 0, bottom: 0, trailing: 0))
        }
    }
}

struct LoginForm_Previews: PreviewProvider {
    static var previews: some View {
        LoginForm(viewModel: LoginFormViewModel(sessionManager: SLSessionManager()))
    }
}
