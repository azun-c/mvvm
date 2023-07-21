//
//  RegistrationViewTests.swift
//  mvvmTests
//
//  Created by azun on 21/07/2023.
//

import XCTest
@testable import mvvm

class RegistrationViewTests: BaseTestCase {
    func testReloadShouldClearAllTexts() {
        // given
        let viewmodel = MockRegistrationViewModel()
        let sut = RegistrationView(viewModel: viewmodel)
        sut.tstNameField?.text = "name here"
        sut.tstEmailField?.text = "email here"
        sut.tstDOBField?.text = "dob here"
        XCTAssertEqual(sut.tstNameField?.text, "name here")
        XCTAssertEqual(sut.tstEmailField?.text, "email here")
        XCTAssertEqual(sut.tstDOBField?.text, "dob here")
        XCTAssertNil(viewmodel.didCallReload)
        
        // when
        sut.reload()
        
        // then
        XCTAssertEqual(viewmodel.didCallReload, true)
        XCTAssertEqual(sut.tstNameField?.text, "")
        XCTAssertEqual(sut.tstEmailField?.text, "")
        XCTAssertEqual(sut.tstDOBField?.text, "")
    }
    
    func testTextFieldShouldBeginEditingShouldShowPicker() {
        // given
        let sut = RegistrationView()
        let parentView = UIView()
        parentView.addSubview(sut)
        XCTAssertNil(sut.tstPickerView)
        
        // when
        let shouldBeginEditing = sut.textFieldShouldBeginEditing(UITextField())
        
        // then
        XCTAssertFalse(shouldBeginEditing)
        XCTAssertEqual(sut.tstPickerView?.isHidden, false)
    }
    
    func testTappingOnRegisterButtonShouldTriggerRegister() {
        // given
        let viewmodel = MockRegistrationViewModel()
        let sut = RegistrationView(viewModel: viewmodel)
        
        // when
        sut.tstUnregisterButton?.sendActions(for: .touchUpInside)
        
        // then
        XCTAssertEqual(viewmodel.didCallRegister, true)
    }
}
