//
//  Coordinator.swift
//  Common
//
//  Created by Jakub Wolański on 26/06/2023.
//

import Foundation

public protocol Coordinator {
    var viewModelFactory: [any ViewModelFactory] { get }
}
