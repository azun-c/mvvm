//
//  MockRegistrationViewModel.swift
//  mvvmTests
//
//  Created by azun on 21/07/2023.
//

@testable import mvvm
import Combine
import Foundation

class MockRegistrationViewModel {
    var name: String = ""
    var email: String = ""
    var dob: Date = Date.minDoB
    
    let errorsSubject = PassthroughSubject<[RegistrationViewModel.ValidationError], Never>()
    
    private(set) var didCallReload: Bool?
    private(set) var didCallRegister: Bool?
}

// MARK: - RegistrationViewModelProtocol

extension MockRegistrationViewModel: RegistrationViewModelProtocol {
    var onErrors: AnyPublisher<[RegistrationViewModel.ValidationError], Never> {
        errorsSubject.eraseToAnyPublisher()
    }
    
    func reload() {
        didCallReload = true
    }
    
    func register() {
        didCallRegister = true
    }
}
