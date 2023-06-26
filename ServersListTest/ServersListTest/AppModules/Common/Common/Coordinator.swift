//
//  Coordinator.swift
//  Common
//
//  Created by Jakub Wolański on 26/06/2023.
//

import Combine
import Foundation

public protocol Coordinator {
    var viewModelFactory: [any ViewModelFactory] { get }
}

public protocol DataProvider {
    var isDataReady: AnyPublisher<Bool, Never> { get }
}
