//
//  LoginForm.swift
//  User
//
//  Created by Jakub Wolański on 23/06/2023.
//

import SwiftUI
import UICommon

struct LoginForm: View {
    // TODO: inject view model

    @StateObject private var viewModel = LoginFormViewModel()

    var body: some View {
        VStack(spacing: 16) { // TODO: move strings to some storage
            TextInputView(icon: Image("user"), placeholder: "Username", text: $viewModel.username)
            TextInputView(icon: Image("lock"), placeholder: "Password", text: $viewModel.password, isSecure: true)
            SLButton.Primary(title: "Log in") {
                viewModel.send()
            }
        }
    }
}

struct LoginForm_Previews: PreviewProvider {
    static var previews: some View {
        LoginForm()
    }
}
