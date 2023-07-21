//
//  MockUserService.swift
//  mvvmTests
//
//  Created by azun on 21/07/2023.
//

@testable import mvvm
import Combine

class MockUserService {
    var mockUser: User?
    
    let userUpdatedSubject = PassthroughSubject<Void, Never>()
    
    private(set) var didCallRegister: User?
    private(set) var didCallUnregister: Bool?
}

// MARK: - UserServiceProtocol

extension MockUserService: UserServiceProtocol {
    var user: User? {
        mockUser
    }
    
    var onUserUpdated: AnyPublisher<Void, Never> {
        userUpdatedSubject.eraseToAnyPublisher()
    }
    
    func register(_ user: User) {
        didCallRegister = user
    }
    
    func unregister() {
        didCallUnregister = true
    }
}
