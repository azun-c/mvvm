//
//  RegistrationViewModelTests.swift
//  mvvmTests
//
//  Created by azun on 21/07/2023.
//

import XCTest
@testable import mvvm

class RegistrationViewModelTests: BaseTestCase {
    func testReloadShouldResetValues() {
        // given
        let sut = RegistrationViewModel()
        let expectation = expectation(description: "test completed")
        var expectedErrors = [RegistrationViewModel.ValidationError]()
        sut.onErrors
            .sink { errors in
                expectedErrors = errors
                expectation.fulfill()
            }
            .store(in: &disposeBag)
        
        // when
        sut.reload()
        sut.register()
        
        // then
        waitForExpectations(timeout: 3) { _ in
            XCTAssertEqual(expectedErrors.count, 3)
            XCTAssertEqual(expectedErrors.first?.errorDescription, "Missing name")
            XCTAssertEqual(expectedErrors[safe: 1]?.errorDescription, "Missing email")
            XCTAssertEqual(expectedErrors.last?.errorDescription, "Missing DOB")
        }
    }
    
    func testRegisterShouldTriggerOnErrorsWithAllErrors() {
        // given
        let sut = RegistrationViewModel()
        let expectation = expectation(description: "test completed")
        var expectedErrors = [RegistrationViewModel.ValidationError]()
        sut.onErrors
            .sink { errors in
                expectedErrors = errors
                expectation.fulfill()
            }
            .store(in: &disposeBag)
        
        // when
        sut.register()
        
        // then
        waitForExpectations(timeout: 3) { _ in
            XCTAssertEqual(expectedErrors.count, 3)
            XCTAssertEqual(expectedErrors.first?.errorDescription, "Missing name")
            XCTAssertEqual(expectedErrors[safe: 1]?.errorDescription, "Missing email")
            XCTAssertEqual(expectedErrors.last?.errorDescription, "Missing DOB")
        }
    }
    
    func testRegisterShouldTriggerOnErrorsWithInvalidErrors() {
        // given
        let sut = RegistrationViewModel()
        sut.name = "##"
        sut.email = "##$"
        sut.dob = Date(timeIntervalSince1970: -300_000)
        
        let expectation = expectation(description: "test completed")
        var expectedErrors = [RegistrationViewModel.ValidationError]()
        sut.onErrors
            .sink { errors in
                expectedErrors = errors
                expectation.fulfill()
            }
            .store(in: &disposeBag)
        
        // when
        sut.register()
        
        // then
        waitForExpectations(timeout: 3) { _ in
            XCTAssertEqual(expectedErrors.count, 3)
            XCTAssertEqual(expectedErrors.first?.errorDescription, "Invalid name")
            XCTAssertEqual(expectedErrors[safe: 1]?.errorDescription, "Invalid email")
            XCTAssertEqual(expectedErrors.last?.errorDescription, "Missing DOB")
        }
    }
    
    func testRegisterShouldTriggerOnErrorsZeroErrors() {
        // given
        let sut = RegistrationViewModel()
        sut.name = "mock name"
        sut.email = "mock@email.com"
        sut.dob = Date(timeIntervalSinceNow: -20 * 365 * 24 * 60 * 60)
        
        let expectation = expectation(description: "test completed")
        var expectedErrors = [RegistrationViewModel.ValidationError]()
        sut.onErrors
            .sink { errors in
                expectedErrors = errors
                expectation.fulfill()
            }
            .store(in: &disposeBag)
        
        // when
        sut.register()
        
        // then
        waitForExpectations(timeout: 3) { _ in
            XCTAssertTrue(expectedErrors.isEmpty)
        }
    }
    
    func testRegisterShouldTriggerServiceRegister() {
        // given
        let sut = RegistrationViewModel()
        sut.name = "mock name"
        sut.email = "mock@email.com"
        sut.dob = Date()
        let userService = MockUserService()
        sut.userService = userService
        
        // when
        sut.register()
        
        // then
        let registeredUser = userService.didCallRegister
        XCTAssertEqual(registeredUser?.name, sut.name)
        XCTAssertEqual(registeredUser?.emailAddress, sut.email)
        XCTAssertEqual(registeredUser?.birthDate, sut.dob)
    }
}
