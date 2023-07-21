//
//  RegistrationView+Extensions.swift
//  mvvmTests
//
//  Created by azun on 21/07/2023.
//

@testable import mvvm
import UIKit

// MARK: - Unit tests

extension RegistrationView {
    var tstNameField: UITextField? {
        findNestedChild(ofType: "\(UITextField.self)") as? UITextField
    }
    
    var tstEmailField: UITextField? {
        guard let nameField = tstNameField else { return nil }
        
        return nameField.superview?.subviews.filter({ $0 is UITextField })[safe: 1] as? UITextField
    }
    
    var tstDOBField: UITextField? {
        guard let nameField = tstNameField else { return nil }
        
        return nameField.superview?.subviews.filter({ $0 is UITextField }).last as? UITextField
    }
    
    var tstPickerView: DatePickerView? {
        superview?.findNestedChild(ofType: "\(DatePickerView.self)") as? DatePickerView
    }
    
    var tstUnregisterButton: UIButton? {
        findNestedChild(ofType: "\(UIButton.self)") as? UIButton
    }
}
