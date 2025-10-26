//
//  OnboardingStorage.swift
//  Tracker
//
//  Created by Рауль on 26.09.2025.
//
import UIKit

final class OnboardingStorage {
    static let shared = OnboardingStorage()
    private var userDefaults = UserDefaults.standard
    private init() {}
    
    var checkSecondSetup: Bool {
        get {
            userDefaults.bool(forKey: "checkSetup")
        }
        set {
            userDefaults.set(newValue, forKey: "checkSetup")
        }
    }
}
