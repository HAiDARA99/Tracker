//
//  AlertModel.swift
//  Tracker
//
//  Created by Рауль on 01.10.2025.
//

import UIKit

struct AlertModel {
    let title: String
    let message: String?
    let firstText: String
    let secondText: String
    let completion: (() -> Void)
}
