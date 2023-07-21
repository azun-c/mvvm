//
//  UIColor+Extensions.swift
//  mvvm
//
//  Created by azun on 20/07/2023.
//

import UIKit

extension UIColor {
    convenience init(hexint: UInt32) {
        let red = CGFloat((hexint & 0xff0000) >> 16) / 255.0
        let green = CGFloat((hexint & 0xff00) >> 8) / 255.0
        let blue = CGFloat((hexint & 0xff) >> 0) / 255.0
        self.init(red: red, green: green, blue: blue, alpha: 1)
    }
}
