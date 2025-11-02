import UIKit

protocol TrackerTypeVCDelegate: AnyObject {
    func createTracker(_ tracker: Tracker, with category: String)
}

protocol TrackerCreationProtocol: AnyObject {
    func passingTracker(_ tracker: Tracker, _ category: String)
}

final class TrackerTypeVC: UIViewController {
    weak var delegate: TrackerTypeVCDelegate?
    
    private lazy var titleLabel: UILabel = {
        var label = UILabel()
        label.text = NSLocalizedString("TrackerCreation", comment: "")
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .ypBlack
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let habitButton = {
        let button1 = UIButton()
        button1.setTitle(NSLocalizedString("Habit", comment: ""), for: .normal)
        button1.setTitleColor(.white, for: .normal)
        button1.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button1.contentMode = .scaleToFill
        button1.backgroundColor = .black
        
        button1.layer.cornerRadius = 16
        button1.layer.masksToBounds = true
        
        return button1
    }()
    
    private let unregularEventButton = {
        let button2 = UIButton()
        button2.setTitle(NSLocalizedString("IrregularEvents", comment: ""), for: .normal)
        button2.setTitleColor(.white, for: .normal)
        button2.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button2.contentMode = .scaleToFill
        button2.backgroundColor = .black
        
        button2.layer.cornerRadius = 16
        button2.layer.masksToBounds = true
        
        return button2
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    private func setupUI() {
        view.addSubview(titleLabel)
        view.addSubview(habitButton)
        view.addSubview(unregularEventButton)
        
        view.backgroundColor = .white
        
        [titleLabel, habitButton, unregularEventButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        habitButton.addTarget(self, action: #selector(habitButtonTapped), for: .touchUpInside)
        unregularEventButton.addTarget(self, action: #selector(unregularEventButtonTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 26),
            
            habitButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            habitButton.heightAnchor.constraint(equalToConstant: 60),
            habitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            habitButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            habitButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            unregularEventButton.topAnchor.constraint(equalTo: habitButton.bottomAnchor, constant: 16),
            unregularEventButton.heightAnchor.constraint(equalToConstant: 60),
            unregularEventButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            unregularEventButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
        ])
    }
    
    @objc func habitButtonTapped() {
        let habit = CreationTrackerVC()
        habit.trackerCreationDelegate = self
        navigationController?.pushViewController(habit, animated: true)
    }
    
    @objc func unregularEventButtonTapped() {
        let unregularTracker = IrregularTrackerVC()
        unregularTracker.delegate = self
        navigationController?.pushViewController(unregularTracker, animated: true)
    }
}

extension TrackerTypeVC: TrackerCreationProtocol {
    func passingTracker(_ tracker: Tracker, _ category: String) {
        delegate?.createTracker(tracker, with: category)
        self.dismiss(animated: true)
    }
}
