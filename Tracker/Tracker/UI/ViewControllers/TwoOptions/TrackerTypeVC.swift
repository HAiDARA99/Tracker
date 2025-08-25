import UIKit

protocol TrackerTypeVCDelegate: AnyObject {
    func createTracker(_ tracker: Tracker, with category: String)
}

protocol TrackerCreationProtocol: AnyObject {
    func passingTracker(_ tracker: Tracker, _ category: String)
}

final class TrackerTypeVC: UIViewController {
    weak var delegate: TrackerTypeVCDelegate?
    
    private let habitButton = {
        let button1 = UIButton()
        button1.setTitle("Привычка", for: .normal)
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
        button2.setTitle("Нерегулярное событие", for: .normal)
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
        setupNavBar()
    }
    
    private func setupNavBar() {
        let appearance = UINavigationBarAppearance()
        appearance.titleTextAttributes = [
            .font: UIFont.systemFont(ofSize: 16, weight: .medium),
            .foregroundColor: UIColor.black
        ]
        appearance.configureWithOpaqueBackground()
        appearance.shadowColor = .clear
        
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        navigationItem.title = "Создание трекера"
    }
    
    private func setupUI() {
        view.addSubview(habitButton)
        view.addSubview(unregularEventButton)
        
        view.backgroundColor = .white
        
        [habitButton, unregularEventButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        habitButton.addTarget(self, action: #selector(habitButtonTapped), for: .touchUpInside)
        unregularEventButton.addTarget(self, action: #selector(unregularEventButtonTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
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
