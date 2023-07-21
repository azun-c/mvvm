//
//  ConfirmationViewModel.swift
//  mvvm
//
//  Created by azun on 20/07/2023.
//

import Foundation

protocol ConfirmationViewModelProtocol {
    var name: String { get }
    var email: String { get }
    var dobText: String { get }
    
    func unregister()
}

class ConfirmationViewModel {
    lazy var userService: UserServiceProtocol = UserService.shared
}

// MARK: - ConfirmationViewModelProtocol

extension ConfirmationViewModel: ConfirmationViewModelProtocol {
    
    var dobText: String {
        guard let dob = user?.birthDate else { return "" }
        return Self.dobFormatter.string(from: dob)
    }
    
    var email: String {
        user?.emailAddress ?? ""
    }
    
    var name: String {
        user?.name ?? ""
    }
    
    func unregister() {
        userService.unregister()
    }
}

// MARK: - Private

extension ConfirmationViewModel {
    private static let dobFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/YYYY"
        return formatter
    }()
    
    private var user: User? {
        userService.user
    }
}
