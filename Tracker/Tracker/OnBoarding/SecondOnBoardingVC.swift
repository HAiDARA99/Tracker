//
//  SecondOnBoardingVC.swift
//  Tracker
//
//  Created by Рауль on 24.09.2025.
//
import UIKit

class SecondOnBoardingVC: UIViewController {
    
    private let backgroundImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "SecondOnBoardingImage")
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let textLabel = {
        let label = UILabel()
        label.text = NSLocalizedString("EvenNotLiters", comment: "")
        label.textColor = .ypBlack
        label.font = .systemFont(ofSize: 32, weight: .bold)
        label.textAlignment = .center
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    private func setupUI() {
        view.addSubview(backgroundImageView)
        view.addSubview(textLabel)
        
        NSLayoutConstraint.activate([
            
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            textLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            textLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            textLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -330)
        ])
    }
}

