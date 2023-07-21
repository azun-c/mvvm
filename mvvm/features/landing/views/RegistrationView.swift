//
//  RegistrationView.swift
//  mvvm
//
//  Created by azun on 20/07/2023.
//

import UIKit
import Combine

class RegistrationView: UIView {
    lazy var viewModel: RegistrationViewModelProtocol = RegistrationViewModel()
    private var disposeBag = Set<AnyCancellable>()
    
    init(viewModel: RegistrationViewModelProtocol = RegistrationViewModel()) {
        super.init(frame: .zero)
        self.viewModel = viewModel
        setupUI()
        setupBindings()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var roundedBox: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.regular)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        blurView.layer.cornerRadius = 20
        blurView.clipsToBounds = true
        blurView.backgroundColor = .systemBackground
        blurView.alpha = 0.7
        return blurView
    }()
    
    private lazy var errorsBoxHeightConstraint = errorsBox.heightAnchor.constraint(equalToConstant: 0)
    private lazy var errorsBox: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 20
        view.clipsToBounds = true
        view.backgroundColor = .systemBackground
        view.isHidden = true
        view.textColor = .systemRed
        view.numberOfLines = 0
        return view
    }()
    
    private lazy var headerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .title2)
        label.text = "Register"
        label.textAlignment = .center
        return label
    }()
    
    private lazy var nameField: UITextField = {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.font = UIFont.preferredFont(forTextStyle: .subheadline)
        field.addPaddingAndIcon(.init(systemName: "person"))
        field.placeholder = "Enter your name"
        return field
    }()
    
    private lazy var emailField: UITextField = {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.font = UIFont.preferredFont(forTextStyle: .subheadline)
        field.addPaddingAndIcon(.init(systemName: "square.and.pencil"))
        field.placeholder = "Enter your email"
        field.keyboardType = .emailAddress
        field.autocapitalizationType = .none
        return field
    }()
    
    private lazy var dobField: UITextField = {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.font = UIFont.preferredFont(forTextStyle: .subheadline)
        field.addPaddingAndIcon(.init(systemName: "calendar"))
        field.placeholder = "Enter your DOB"
        field.delegate = self
        return field
    }()
    
    private lazy var datePickerView: DatePickerView = {
        let pickerView = DatePickerView()
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        pickerView.isHidden = true
        return pickerView
    }()
    
    private lazy var unregisterButton: UIButton = {
        var configuration = UIButton.Configuration.filled()
        configuration.title = "Register"
        configuration.background.backgroundColor = .systemBlue
        configuration.background.cornerRadius = 8

        let button = UIButton(configuration: configuration,
                              primaryAction: UIAction() { [weak self] _ in
            self?.registerUser()
        })
        button.translatesAutoresizingMaskIntoConstraints = false
        button.configurationUpdateHandler = { [weak self] in self?.updateState(for: $0) }
        
        return button
    }()
}

// MARK: - UITextField

extension RegistrationView: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        endEditing(true)
        setupPickerIfNeeded()
        datePickerView.show()
        return false
    }
}

// MARK: - ReloadableProtocol

extension RegistrationView: ReloadableProtocol {
    func reload() {
        dobField.text = ""
        nameField.text = ""
        emailField.text = ""
        endEditing(true)
        viewModel.reload()
    }
}

// MARK: - Private

extension RegistrationView {
    private func setupUI() {
        setupBox()
        setupHeader()
        setupNameField()
        setupEmailField()
        setupDobField()
        setupButton()
        setupErrorsBox()
    }
    
    private func setupBox() {
        addSubview(roundedBox)
        NSLayoutConstraint.activate([
            roundedBox.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
            roundedBox.centerXAnchor.constraint(equalTo: centerXAnchor),
            roundedBox.centerYAnchor.constraint(equalTo: centerYAnchor),
            heightAnchor.constraint(greaterThanOrEqualTo: roundedBox.heightAnchor)
        ])
    }
    
    private func setupHeader() {
        addSubview(headerLabel)
        NSLayoutConstraint.activate([
            headerLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            headerLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            headerLabel.topAnchor.constraint(equalTo: roundedBox.topAnchor, constant: 15)
        ])
    }
    
    private func setupNameField() {
        addSubview(nameField)
        NSLayoutConstraint.activate([
            nameField.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 15),
            nameField.leadingAnchor.constraint(equalTo: roundedBox.leadingAnchor),
            nameField.trailingAnchor.constraint(equalTo: roundedBox.trailingAnchor, constant: -8)
        ])
    }
    
    private func setupEmailField() {
        addSubview(emailField)
        NSLayoutConstraint.activate([
            emailField.topAnchor.constraint(equalTo: nameField.bottomAnchor, constant: 3),
            emailField.leadingAnchor.constraint(equalTo: nameField.leadingAnchor),
            emailField.trailingAnchor.constraint(equalTo: roundedBox.trailingAnchor, constant: -8)
        ])
    }
    
    private func setupDobField() {
        addSubview(dobField)
        NSLayoutConstraint.activate([
            dobField.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: 3),
            dobField.leadingAnchor.constraint(equalTo: nameField.leadingAnchor),
            dobField.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
    
    private func setupButton() {
        addSubview(unregisterButton)
        NSLayoutConstraint.activate([
            unregisterButton.topAnchor.constraint(equalTo: dobField.bottomAnchor, constant: 15),
            unregisterButton.widthAnchor.constraint(equalToConstant: 120),
            unregisterButton.heightAnchor.constraint(equalToConstant: 44),
            unregisterButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            unregisterButton.bottomAnchor.constraint(equalTo: roundedBox.bottomAnchor, constant: -20)
        ])
    }
    
    private func setupErrorsBox() {
        addSubview(errorsBox)
        NSLayoutConstraint.activate([
            errorsBox.topAnchor.constraint(equalTo: roundedBox.bottomAnchor, constant: 15),
            errorsBox.widthAnchor.constraint(equalTo: roundedBox.widthAnchor),
            errorsBox.leadingAnchor.constraint(equalTo: roundedBox.leadingAnchor),
            errorsBox.centerXAnchor.constraint(equalTo: roundedBox.centerXAnchor),
            errorsBoxHeightConstraint
        ])
    }
    
    private func setupPickerIfNeeded() {
        guard datePickerView.superview == nil,
              let parentView = superview else { return }
        parentView.addSubview(datePickerView)
        NSLayoutConstraint.activate([
            datePickerView.topAnchor.constraint(equalTo: parentView.topAnchor),
            datePickerView.bottomAnchor.constraint(equalTo: parentView.bottomAnchor),
            datePickerView.leadingAnchor.constraint(equalTo: parentView.leadingAnchor),
            datePickerView.trailingAnchor.constraint(equalTo: parentView.trailingAnchor)
        ])
    }
    
    private func updateState(for button: UIButton) {
        var config = button.configuration
        let normalColor = UIColor.systemBlue
        let targetColor: UIColor?
        switch button.state {
        case .selected, .highlighted, .disabled:
            targetColor = normalColor.withAlphaComponent(0.5)
        default:
            targetColor = normalColor
        }
        config?.background.backgroundColor = targetColor
        button.configuration = config
    }
    
    private func registerUser() {
        viewModel.register()
    }
    
    private func setupBindings() {
        datePickerView.onDateUpdated
            .sink { [weak self] in
                self?.updateDob(from: $0)
            }
            .store(in: &disposeBag)
        
        nameField.textPublisher
            .sink { [weak self] in
                self?.viewModel.name = $0
            }
            .store(in: &disposeBag)
        
        emailField.textPublisher
            .sink { [weak self] in
                self?.viewModel.email = $0
            }
            .store(in: &disposeBag)
        
        viewModel.onErrors
            .sink { [weak self] errors in
                self?.updateErrors(errors)
            }
            .store(in: &disposeBag)
    }
    
    private func updateDob(from date: Date) {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/YYYY"
        dobField.text = formatter.string(from: date)
        viewModel.dob = date
    }
    
    private func updateErrors(_ errors: [RegistrationViewModel.ValidationError]) {
        guard !errors.isEmpty else {
            UIView.animate(withDuration: 0.1, animations: {
                self.errorsBoxHeightConstraint.constant = 0
            }, completion: { _ in self.errorsBox.isHidden = true })
            return
        }
        errorsBox.isHidden = false
        let message = errors.map { "\t* \($0.errorDescription)" }.joined(separator: "\n")
        errorsBox.text = message
        let errorsCount = errors.count
        let height: CGFloat
        if errorsCount == 1 {
            height = 50
        } else if errorsCount == 2 {
            height = 70
        } else {
            height = 90
        }
        
        self.errorsBoxHeightConstraint.constant = height
        UIView.animate(withDuration: 0.2, animations: {
            self.layoutIfNeeded()
        })
    }
}
