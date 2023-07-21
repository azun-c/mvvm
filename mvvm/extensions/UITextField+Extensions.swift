//
//  UITextField+Extensions.swift
//  mvvm
//
//  Created by azun on 20/07/2023.
//

import UIKit
import Combine

extension UITextField {
    func addPaddingAndIcon(_ image: UIImage?, padding: CGFloat = 16, isLeftView: Bool = true) {
        guard let image else { return }
        let frame = CGRect(x: 0, y: 0, width: 18 + padding, height: image.size.height)
        
        let iconView  = UIImageView(frame: frame)
        iconView.image = image
        iconView.contentMode = .center
        
        let outerView = UIView(frame: frame)
        outerView.addSubview(iconView)
        
        if isLeftView {
            leftViewMode = .always
            leftView = outerView
        } else {
            rightViewMode = .always
            rightView = outerView
        }
    }
    
    func addCustomView(_ view: UIView?, isLeftView: Bool = true) {
        if isLeftView {
            leftViewMode = .always
            leftView = view
        } else {
            rightViewMode = .always
            rightView = view
        }
    }
}

// MARK - Combine

extension UITextField {
    var textPublisher: AnyPublisher<String, Never> {
        NotificationCenter.default
            .publisher(for: UITextField.textDidChangeNotification, object: self)
            .map { ($0.object as? UITextField)?.text  ?? "" }
            .eraseToAnyPublisher()
    }
}
