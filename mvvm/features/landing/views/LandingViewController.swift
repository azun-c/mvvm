//
//  LandingViewController.swift
//  mvvm
//
//  Created by azun on 20/07/2023.
//

import UIKit
import Combine

// https://iosexample.com/swiftui-ios-app-showcasing-mvvm-architecture/

class LandingViewController: UIViewController {
    private var disposeBag = Set<AnyCancellable>()
    let viewModel: LandingViewModelProtocol
    
    init(viewModel: LandingViewModelProtocol = LandingViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
    }
    
    private lazy var confirmationView: ConfirmationView = {
        let view = ConfirmationView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var registrationView: RegistrationView = {
        let view = RegistrationView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
}

// MARK: - Private

extension LandingViewController {
    private func setupUI() {
        setupBackground()
        setupRegistrationView()
        setupConfirmationView()
    }
    
    private func setupBackground() {
        let colors = [UIColor(hexint: 0xa8ff78).cgColor, UIColor(hexint: 0x78ffd6).cgColor]
        let gradientLayer = CAGradientLayer()
        gradientLayer.type = .axial
        gradientLayer.colors = colors
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.75)
        gradientLayer.endPoint = CGPoint(x: 0.75, y: 0)
        gradientLayer.frame = view.bounds
        view.layer.addSublayer(gradientLayer)
    }
    
    private func setupConfirmationView() {
        view.addSubview(confirmationView)
        NSLayoutConstraint.activate([
            confirmationView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            confirmationView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            confirmationView.centerYAnchor.constraint(equalTo: registrationView.centerYAnchor)
        ])
        confirmationView.isHidden = !viewModel.hasRegistered
    }
    
    private func setupRegistrationView() {
        view.addSubview(registrationView)
        NSLayoutConstraint.activate([
            registrationView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            registrationView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            registrationView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -150)
        ])
        registrationView.isHidden = viewModel.hasRegistered
    }
    
    private func setupBindings() {
        viewModel.shouldUpdateView
            .sink { [weak self] _ in
                self?.updateView()
            }
            .store(in: &disposeBag)
    }
    
    private func updateView() {
        if viewModel.hasRegistered {
            flip(viewToHide: registrationView, viewToShow: confirmationView) {
                
            }
        }
        else {
            flip(viewToHide: confirmationView, viewToShow: registrationView) {
                
            }
        }
    }
    
    @objc func flip(viewToHide: UIView, viewToShow: UIView, completion: @escaping (() -> Void)) {
        let totalTime: TimeInterval = 1.0
        let transitionOptions: UIView.AnimationOptions = [.transitionFlipFromRight]

        UIView.transition(with: viewToHide, duration: totalTime, options: transitionOptions, animations: nil)
        UIView.transition(with: viewToShow, duration: totalTime, options: transitionOptions, animations: nil)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + totalTime / 2) {
            viewToHide.isHidden = true
            viewToShow.isHidden = false
            self.registrationView.reload()
            self.confirmationView.reload()
        }
    }
}
