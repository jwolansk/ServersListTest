//
//  LoginFormViewModel.swift
//  User
//
//  Created by Jakub Wolański on 23/06/2023.
//

import Foundation

class LoginFormViewModel: ObservableObject {
    @Published var username: String = ""
    @Published var password: String = ""

    func send() {
        // TODO: send api request
    }
}
