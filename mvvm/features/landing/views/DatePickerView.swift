//
//  DatePickerView.swift
//  mvvm
//
//  Created by azun on 20/07/2023.
//

import UIKit
import Combine

protocol DatePickerViewProtocol {
    var onDateUpdated: AnyPublisher<Date, Never> { get }
    
    func show()
}

class DatePickerView: UIView {
    
    private lazy var pickerHolderView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .white
        v.layer.cornerRadius = 8
        return v
    }()
    
    private lazy var datePicker: UIDatePicker = {
        let v = UIDatePicker()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.preferredDatePickerStyle = .inline
        v.datePickerMode = .date
        v.minimumDate = Date.minDoB
        v.maximumDate = Date().addingTimeInterval(-15 * 365 * 24 * 60 * 60)
        v.date = Date().addingTimeInterval(-30 * 365 * 24 * 60 * 60)
        return v
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupBindings()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let dateUpdatedSubject = PassthroughSubject<Date, Never>()
}

// MARK: - DatePickerViewProtocol

extension DatePickerView: DatePickerViewProtocol {
    var onDateUpdated: AnyPublisher<Date, Never> {
        dateUpdatedSubject.eraseToAnyPublisher()
    }
    
    func show() {
        pickerHolderView.transform = CGAffineTransform.identity.scaledBy(x: 0.1, y: 0.1)
        isHidden = false
        backgroundColor = .systemFill.withAlphaComponent(0.6)
        
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveLinear, animations: {
            self.pickerHolderView.transform = CGAffineTransform.identity.scaledBy(x: 1.5, y: 1.5)
        }) { _ in
            UIView.animate(withDuration: 0.3, delay: 0,
                           usingSpringWithDamping: 0.5,
                           initialSpringVelocity: 4.5) {
                self.pickerHolderView.transform = CGAffineTransform.identity
            }
        }
    }
}

// MARK: - Private

extension DatePickerView {
    private func setupUI() {
        addSubview(pickerHolderView)
        pickerHolderView.addSubview(datePicker)
        
        NSLayoutConstraint.activate([
            pickerHolderView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20.0),
            pickerHolderView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20.0),
            pickerHolderView.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            datePicker.topAnchor.constraint(equalTo: pickerHolderView.topAnchor, constant: 20.0),
            datePicker.leadingAnchor.constraint(equalTo: pickerHolderView.leadingAnchor, constant: 20.0),
            datePicker.trailingAnchor.constraint(equalTo: pickerHolderView.trailingAnchor, constant: -20.0),
            datePicker.bottomAnchor.constraint(equalTo: pickerHolderView.bottomAnchor, constant: -20.0)
        ])
    }
    
    private func setupBindings() {
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(backgroundDidTap)))
        datePicker.addTarget(self, action: #selector(dateDidChange), for: .valueChanged)
    }
    
    @objc private func backgroundDidTap() {
        backgroundColor = .clear
        UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveLinear, animations: {
            self.pickerHolderView.transform = CGAffineTransform.identity.scaledBy(x: 1.5, y: 1.5)
        }) { _ in
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
                self.pickerHolderView.transform = CGAffineTransform.identity.scaledBy(x: 0.1, y: 0.1)
            }) { _ in self.isHidden = true}
        }
    }

    @objc private func dateDidChange() {
        dateUpdatedSubject.send(datePicker.date)
    }
}
