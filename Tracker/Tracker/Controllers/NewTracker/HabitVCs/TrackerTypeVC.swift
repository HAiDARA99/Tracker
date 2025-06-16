import UIKit

final class TrackerTypeVC: UIViewController {
    private let button1 = {
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
    
    private let button2 = {
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
        view.addSubview(button1)
        view.addSubview(button2)
        
        view.backgroundColor = .white
        
        [button1, button2].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        button1.addTarget(self, action: #selector(handleButton1), for: .touchUpInside)
        button2.addTarget(self, action: #selector(handleButton2), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            button1.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            button1.heightAnchor.constraint(equalToConstant: 60),
            button1.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            button1.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            button1.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            button2.topAnchor.constraint(equalTo: button1.bottomAnchor, constant: 16),
            button2.heightAnchor.constraint(equalToConstant: 60),
            button2.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            button2.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
        ])
    }
    
    @objc func handleButton1() {
        let creationTrackerVC = CreationTrackerVC()
        let navController = UINavigationController(rootViewController: creationTrackerVC)
        present(navController, animated: true)
    }
    
    @objc func handleButton2() {
        let creationTrackerVC = CreationTrackerVC()
        let navController = UINavigationController(rootViewController: creationTrackerVC)
        present(navController, animated: true)
    }
}

