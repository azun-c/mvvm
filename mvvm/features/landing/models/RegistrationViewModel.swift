//
//  RegistrationViewModel.swift
//  mvvm
//
//  Created by azun on 20/07/2023.
//

import Combine
import Foundation

protocol RegistrationViewModelProtocol {
    var onErrors: AnyPublisher<[RegistrationViewModel.ValidationError], Never> { get }
    var name: String { get set }
    var email: String { get set }
    var dob: Date { get set }
    
    func reload()
    func register()
}

class RegistrationViewModel {
    init() {
        setupBindings()
    }
    
    enum ValidationError: Error {
        case custom(message: String)
        var errorDescription: String {
            switch self {
            case .custom(let message):
                return message
            }
        }
    }
    
    lazy var userService: UserServiceProtocol = UserService.shared
    
    @Published private var validationErrors = [ValidationError]()
    private let errorsSubject = PassthroughSubject<[ValidationError], Never>()
    
    private let nameSubject = PassthroughSubject<String, Never>()
    var name: String = "" {
        didSet {
            nameSubject.send(name)
        }
    }
    private let emailSubject = PassthroughSubject<String, Never>()
    var email: String = "" {
        didSet {
            emailSubject.send(email)
        }
    }
    private let dobSubject = PassthroughSubject<Date, Never>()
    var dob: Date = Date.minDoB {
        didSet {
            dobSubject.send(dob)
        }
    }
}

// MARK: - RegistrationViewModelProtocol

extension RegistrationViewModel: RegistrationViewModelProtocol {
    var onErrors: AnyPublisher<[ValidationError], Never> {
        errorsSubject.eraseToAnyPublisher()
    }
    
    func reload() {
        name = ""
        email = ""
        dob = Date.minDoB
    }
    
    func register() {
        errorsSubject.send(validationErrors)
        guard validationErrors.isEmpty else { return }
        userService.register(.init(name: name, emailAddress: email, birthDate: dob))
    }
}

// MARK: - Private

extension RegistrationViewModel {
    private func setupBindings() {
        Publishers.CombineLatest3(nameSubject, emailSubject, dobSubject)
            .map { [weak self] username, emailAddress, dateOfBirth in
                let errors = [
                    self?.validate(type: .name, for: username),
                    self?.validate(type: .email, for: emailAddress),
                    self?.validate(type: .dob, for: dateOfBirth)
                ].compactMap { $0 }
                
                return errors
            }
            .assign(to: &$validationErrors)
        name = ""
        email = ""
        dob = Date.minDoB
    }
    
    private func validate(type: ValidatedType, for value: Any) -> ValidationError? {
        switch type {
        case .dob:
            guard let dob = value as? Date, dob > Date.minDoB else {
                return ValidationError.custom(message: "Missing DOB")
            }
            return nil
        case .email:
            guard let email = value as? String, !email.isEmpty else {
                return ValidationError.custom(message: "Missing email")
            }

            guard email.firstMatch(of: RegexRule.email) != nil else {
                return ValidationError.custom(message: "Invalid email")
            }
            return nil
        case .name:
            guard let name = value as? String, !name.isEmpty else {
                return ValidationError.custom(message: "Missing name")
            }

            guard name.firstMatch(of: RegexRule.name) != nil else {
                return ValidationError.custom(message: "Invalid name")
            }
            return nil
        }
    }
    
    private enum ValidatedType {
        case name
        case email
        case dob
    }
    
    private enum RegexRule {
        static let email = try! Regex("[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}")
        static let name = try! Regex("([a-zA-Z]{3,30}\\s*)+")
    }
}
