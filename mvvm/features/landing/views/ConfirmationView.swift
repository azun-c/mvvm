//
//  ConfirmationView.swift
//  mvvm
//
//  Created by azun on 20/07/2023.
//

import UIKit
import Combine

class ConfirmationView: UIView {
    lazy var viewModel: ConfirmationViewModelProtocol = ConfirmationViewModel()
    
    init(viewModel: ConfirmationViewModelProtocol = ConfirmationViewModel()) {
        super.init(frame: .zero)
        self.viewModel = viewModel
        setupUI()
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
    
    private lazy var headerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .title2)
        label.text = "Thank you for registering"
        label.textAlignment = .center
        return label
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        label.textAlignment = .center
        label.text = viewModel.name
        return label
    }()
    
    private lazy var emailLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        label.textAlignment = .center
        label.text = viewModel.email
        return label
    }()
    
    private lazy var dobLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        label.textAlignment = .center
        label.text = viewModel.dobText
        return label
    }()
    
    private lazy var unregisterButton: UIButton = {
        var configuration = UIButton.Configuration.filled()
        configuration.title = "Unregister"
        configuration.background.backgroundColor = .systemBlue
        configuration.background.cornerRadius = 8

        let button = UIButton(configuration: configuration,
                              primaryAction: UIAction() { [weak self] _ in
            self?.viewModel.unregister()
        })
        button.translatesAutoresizingMaskIntoConstraints = false
        button.configurationUpdateHandler = { [weak self] in self?.updateState(for: $0) }
        
        return button
    }()
}

// MARK: - ReloadableProtocol

extension ConfirmationView: ReloadableProtocol {
    func reload() {
        dobLabel.text = viewModel.dobText
        nameLabel.text = viewModel.name
        emailLabel.text = viewModel.email
    }
}

// MARK: - Private

extension ConfirmationView {
    private func setupUI() {
        setupBox()
        setupHeader()
        setupNameLabel()
        setupEmailLabel()
        setupDobLabel()
        setupButton()
    }
    
    private func setupBox() {
        addSubview(roundedBox)
        NSLayoutConstraint.activate([
            roundedBox.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
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
    
    private func setupNameLabel() {
        addSubview(nameLabel)
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 15),
            nameLabel.leadingAnchor.constraint(equalTo: roundedBox.leadingAnchor, constant: 8),
            nameLabel.centerXAnchor.constraint(equalTo: roundedBox.centerXAnchor)
        ])
    }
    
    private func setupEmailLabel() {
        addSubview(emailLabel)
        NSLayoutConstraint.activate([
            emailLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 3),
            emailLabel.leadingAnchor.constraint(equalTo: roundedBox.leadingAnchor, constant: 8),
            emailLabel.centerXAnchor.constraint(equalTo: roundedBox.centerXAnchor)
        ])
    }
    
    private func setupDobLabel() {
        addSubview(dobLabel)
        NSLayoutConstraint.activate([
            dobLabel.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 3),
            dobLabel.leadingAnchor.constraint(equalTo: headerLabel.leadingAnchor),
            dobLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
    
    private func setupButton() {
        addSubview(unregisterButton)
        NSLayoutConstraint.activate([
            unregisterButton.topAnchor.constraint(equalTo: dobLabel.bottomAnchor, constant: 15),
            unregisterButton.widthAnchor.constraint(equalToConstant: 120),
            unregisterButton.heightAnchor.constraint(equalToConstant: 44),
            unregisterButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            unregisterButton.bottomAnchor.constraint(equalTo: roundedBox.bottomAnchor, constant: -20)
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
}
