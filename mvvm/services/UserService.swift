//
//  UserService.swift
//  mvvm
//
//  Created by azun on 20/07/2023.
//

import Combine

protocol UserServiceProtocol {
    var user: User? { get }
    var onUserUpdated: AnyPublisher<Void, Never> { get }
    func register(_ user: User)
    func unregister()
}

class UserService {
    private let userChangedSubject = PassthroughSubject<Void, Never>()
    private var registeredUser: User? {
        didSet {
            userChangedSubject.send()
        }
    }
    static var shared: UserService = UserService()
}

// MARK: - UserServiceProtocol

extension UserService: UserServiceProtocol {
    var onUserUpdated: AnyPublisher<Void, Never> {
        userChangedSubject.eraseToAnyPublisher()
    }
    
    var user: User? {
        registeredUser
    }
    
    func register(_ user: User) {
        registeredUser = user
    }
    
    func unregister() {
        registeredUser = nil
    }
}
