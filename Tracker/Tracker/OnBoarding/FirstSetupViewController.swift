//
//  FirstSetupVoewController.swift
//  Tracker
//
//  Created by Рауль on 26.09.2025.
//
import UIKit

final class FirstSetupViewController: UIViewController {
    private let firstLaunchStorage = OnboardingStorage.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkFirstSetup()
    }
    
    private func checkFirstSetup() {
        guard let sceneDelegate = UIApplication.shared.connectedScenes
            .first?.delegate as? SceneDelegate else {
            fatalError("Pizdachok")
        }
        if firstLaunchStorage.checkSecondSetup == false {
            sceneDelegate.window?.rootViewController = OnBoardingPageViewController()
            firstLaunchStorage.checkSecondSetup = true
        } else {
            sceneDelegate.window?.rootViewController = TabBarController()
        }
    }
}
