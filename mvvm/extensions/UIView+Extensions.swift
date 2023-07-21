//
//  UIView+Extensions.swift
//  mvvm
//
//  Created by azun on 21/07/2023.
//

import UIKit

extension UIView {
    func findNestedChild(ofType className: String) -> UIView? {
        var found: UIView?
        
        for (_, child) in subviews.enumerated() {
            if "\(type(of: child))" == className {
                found = child
                break
            }
            if let grandChild = child.findNestedChild(ofType: className) {
                found = grandChild
                break
            }
        }
        return found
    }
}
