//
//  ViewModelStore.swift
//  Common
//
//  Created by Jakub Wolański on 26/06/2023.
//

import Foundation

public typealias ViewModel = Any

public protocol ViewModelFactory {

    func creates<VM: ViewModel>(type: VM.Type) -> Bool

    func create<VM: ViewModel>() -> VM?
}

public final class SingleViewModelFactory<SVM: ViewModel>: ViewModelFactory {

    private let factory: () -> SVM?

    public init(with factory: @escaping () -> SVM?) {
        self.factory = factory
    }

    public func creates<VM: ViewModel>(type: VM.Type) -> Bool {
        guard type == SVM.self else { return false }
        return true
    }

    public func create<VM: ViewModel>() -> VM? {
        guard creates(type: VM.self) else { return nil }
        return factory() as? VM
    }
}

public final class CompositeViewModelFactory: ViewModelFactory {

    private var factories: [ViewModelFactory] = []

    public init(with factories: [ViewModelFactory]) {
        self.factories.append(contentsOf: factories)
    }

    public func creates<VM: ViewModel>(type: VM.Type) -> Bool {
        return factories.contains { $0.creates(type: type) }
    }

    public func create<VM: ViewModel>() -> VM? {
        for factory in factories {
            if let viewModel: VM = factory.create() {
                return viewModel
            }
        }
        return nil
    }
}
