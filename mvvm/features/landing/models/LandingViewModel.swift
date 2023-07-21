//
//  LandingViewModel.swift
//  mvvm
//
//  Created by azun on 20/07/2023.
//

import Combine

protocol LandingViewModelProtocol {
    var hasRegistered: Bool { get }
    var shouldUpdateView: AnyPublisher<Void, Never> { get }
}

class LandingViewModel {
    private var disposeBag = Set<AnyCancellable>()
    private let shouldUpdateViewSubject = PassthroughSubject<Void, Never>()
    let userService: UserServiceProtocol
    
    init(userService: UserServiceProtocol = UserService.shared) {
        self.userService = userService
        setupBindings()
    }
}

// MARK: - LandingViewModelProtocol

extension LandingViewModel: LandingViewModelProtocol {
    var hasRegistered: Bool {
        userService.user != nil
    }
    
    var shouldUpdateView: AnyPublisher<Void, Never> {
        shouldUpdateViewSubject.eraseToAnyPublisher()
    }
}

// MARK: - Private

extension LandingViewModel {
    private func setupBindings() {
        userService.onUserUpdated
            .sink { [weak self] _ in
                self?.shouldUpdateViewSubject.send()
            }
            .store(in: &disposeBag)
    }
}
