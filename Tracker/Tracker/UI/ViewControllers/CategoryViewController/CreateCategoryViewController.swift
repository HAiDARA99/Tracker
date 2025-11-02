//
//  CreateCategoryViewController.swift
//  Tracker
//
//  Created by Рауль on 01.10.2025.
//
import UIKit

enum checkTrackerType {
    case create
    case edit
}

class CreateCategoryViewController: UIViewController {
    static let identifier = Notification.Name(rawValue: "Изменить название категории")
    
    var editCategoryName: String?
    
    let eventTypeHabit: checkTrackerType
    private var categoryName: String = ""
    private let categoryStore = TrackerCategoryStore.shared
    private var categoryTopTitle: String {
        switch eventTypeHabit {
        case .create:
            return NSLocalizedString("NewCategory", comment: "")
        case .edit:
            return NSLocalizedString("EditingCategory", comment: "")
        }
    }
    
    private lazy var titleLabel: UILabel = {
        var label = UILabel()
        label.text = categoryTopTitle
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .ypBlack
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var doneButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(NSLocalizedString("Done", comment: ""), for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.tintColor = .ypWhite
        button.backgroundColor = .ypBlack
        button.layer.cornerRadius = 16
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var nameTrackerTextField: UITextField = {
        var textField = UITextField()
        textField.backgroundColor = .ypBackground
        textField.textColor = .ypBlack
        textField.placeholder = NSLocalizedString("EnterNameOfCategory", comment: "")
        textField.font = .systemFont(ofSize: 17, weight: .regular)
        textField.layer.cornerRadius = 16
        textField.delegate = self
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: textField.frame.height))
        textField.leftViewMode = .always
        textField.clearButtonMode = .whileEditing
        textField.addTarget(self, action: #selector(setTextValue), for: .editingChanged)
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    init(eventType: checkTrackerType) {
        self.eventTypeHabit = eventType
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhite
        if eventTypeHabit == .edit {
            nameTrackerTextField.text = editCategoryName
            categoryName = editCategoryName ?? ""
        }
        setupUI()
        checkCorrectness()
    }
    
    private func setupUI() {
        view.addSubview(titleLabel)
        view.addSubview(nameTrackerTextField)
        view.addSubview(doneButton)
        
        doneButton.addTarget(self, action: #selector(doneButtonClicked), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 26),
            
            nameTrackerTextField.heightAnchor.constraint(equalToConstant: 75),
            nameTrackerTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
             nameTrackerTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
             nameTrackerTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 38),
             
             doneButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            doneButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            doneButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    private func checkCorrectness() {
        guard let text = nameTrackerTextField.text else {
            return
        }
        doneButton.isEnabled = !text.isEmpty
        if doneButton.isEnabled {
            doneButton.backgroundColor = .ypBlack
            doneButton.tintColor = .ypWhite
        } else {
            doneButton.backgroundColor = .ypGray
            doneButton.tintColor = .ypWhite
        }
    }
    
    @objc private func doneButtonClicked() {
        categoryName = nameTrackerTextField.text ?? ""
        if eventTypeHabit == .create {
            do {
                try categoryStore.createCategoryCD(with: categoryName)
            } catch {
                let alertController = UIAlertController(
                    title: NSLocalizedString("Error", comment: ""),
                    message: NSLocalizedString("ErrorCreatingCategory", comment: ""),
                    preferredStyle: .alert)
                let OKAction = UIAlertAction(title: "OK", style: .default)
                alertController.addAction(OKAction)
                self.present(alertController, animated: true, completion: nil)
            }
        } else if eventTypeHabit == .edit {
            guard let editingCategoryName = editCategoryName else { return }
            do {
                try categoryStore.updateCategory(currentTitle: editingCategoryName, newTitle: categoryName)
            } catch {
                //TODO: Alert
            }
        }
        
        NotificationCenter.default.post(name: CreateCategoryViewController.identifier, object: self)
        self.dismiss(animated: true)
    }
    
    @objc private func setTextValue() {
        categoryName = nameTrackerTextField.text ?? ""
        checkCorrectness()
    }
}

extension CreateCategoryViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        categoryName = textField.text ?? ""
    }
}
