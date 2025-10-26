//
//  AlertPresenter.swift
//  Tracker
//
//  Created by Рауль on 01.10.2025.
//
import UIKit

protocol AlertPresenterProtocol: AnyObject {
    func showAlert(model: AlertModel)
}

class AlertPresenter: AlertPresenterProtocol {
    weak var delegate: UIViewController?
    
    init(delegate: UIViewController) {
        self.delegate = delegate
    }
    
    func showAlert(model: AlertModel) {
        let alert = UIAlertController(
            title: model.title,
            message: model.message,
            preferredStyle: .actionSheet)
        
        let firstAction = UIAlertAction(
            title: model.firstText,
            style: .destructive) { _ in
                model.completion()
            }
        
        let secondAction = UIAlertAction(
            title: model.secondText,
            style: .cancel)
        
        alert.addAction(firstAction)
        alert.addAction(secondAction)
        delegate?.present(alert, animated: true)
    }
}
