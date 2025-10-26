import UIKit

protocol CategoryViewControllerDelegate: AnyObject {
    var selectedCategory: String { get set }
    func didSelectCategory()
}

final class CategoryViewController: UIViewController {
    
    var viewModel: CategoryViewModel
    var viewModelDelegate: CategoryViewControllerDelegate?
    
    private var alertPresenter: AlertPresenterProtocol?
    
    private var titleLabel: UILabel = {
        var label = UILabel()
        label.text = NSLocalizedString("Категория", comment: "")
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .ypBlack
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let addCategoryButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(NSLocalizedString("Добавить категорию", comment: ""), for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.tintColor = .ypWhite
        button.backgroundColor = .ypBlack
        button.layer.cornerRadius = 16
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var stubImageView: UIImageView = {
        let image = UIImage(named: "CometStar")
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var stubLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("Привычки и события можно\nобъединить по смыслу", comment: "")
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .ypBlack
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var categoryTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(CategoryCell.self, forCellReuseIdentifier: CategoryCell.identifier)
        tableView.layer.masksToBounds = true
        tableView.layer.cornerRadius = 16
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = .ypGray
        tableView.showsVerticalScrollIndicator = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsMultipleSelection = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.isScrollEnabled = false
        return tableView
    }()
    
    init(viewModel: CategoryViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhite
        setupUI()
        viewModel.delegate = viewModelDelegate
        alertPresenter = AlertPresenter(delegate: self)
        bind()
        showOrHideEmptyLabels()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.initSelectedCategory()
    }
    
    private func bind() {
        viewModel.onChange = { [weak self] in
            self?.showOrHideEmptyLabels()
            self?.categoryTableView.reloadData()
        }
    }
    
    private func showOrHideEmptyLabels() {
        if !viewModel.categories.isEmpty {
            stubLabel.isHidden = true
            stubImageView.isHidden = true
            categoryTableView.isHidden = false
        } else {
            stubLabel.isHidden = false
            stubImageView.isHidden = false
            categoryTableView.isHidden = true
        }
    }
    
    private func setupUI() {
        view.addSubview(titleLabel)
        view.addSubview(addCategoryButton)
        view.addSubview(stubImageView)
        view.addSubview(stubLabel)
        view.addSubview(categoryTableView)
        
        addCategoryButton.addTarget(self, action: #selector(addCategoryButtonClicked), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            stubImageView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            stubImageView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            stubImageView.heightAnchor.constraint(equalToConstant: 80),
            stubImageView.widthAnchor.constraint(equalToConstant: 80),
            
            stubLabel.centerXAnchor.constraint(equalTo: stubImageView.centerXAnchor),
            stubLabel.topAnchor.constraint(equalTo: stubImageView.bottomAnchor, constant: 8),
            stubLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            stubLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 26),
            
            categoryTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            categoryTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            categoryTableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 38),
            categoryTableView.bottomAnchor.constraint(equalTo: addCategoryButton.topAnchor),
            
            addCategoryButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            addCategoryButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            addCategoryButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            addCategoryButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    private func showAlert(for category: String) {
        let alertModel = AlertModel(
            title: "Категория не нужна",
            message: "Трекеры тоже будут удалены нахуй",
            firstText: "Удалить",
            secondText: "Отмена") { [weak self] in
                guard let self = self else { return }
                viewModel.deleteCategory(category)
            }
        alertPresenter?.showAlert(model: alertModel)
    }
    
    @objc private func addCategoryButtonClicked() {
        let viewController = CreateCategoryViewController(eventType: .create)
        self.present(viewController, animated: true)
    }
}

extension CategoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.categoriesNumber()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: CategoryCell.identifier,
            for: indexPath)
                as? CategoryCell
        else {
            assertionFailure("Не удалось выполнить приведение к UITableViewCell")
            return UITableViewCell()
        }
        cell.viewModel = viewModel
        cell.configureCell(indexPath: indexPath)
        return cell
    }
}

extension CategoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        75
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? CategoryCell else { return }
        tableView.cellForRow(at: indexPath)?.accessoryType = .none
        viewModel.setTextLabel(cell: cell)
        viewModel.didSelectCategory()
        if let nav = navigationController {
            nav.popViewController(animated: true)
        } else {
            self.dismiss(animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .none
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let configuration = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { actions in
            guard let cell = tableView.cellForRow(at: indexPath) as? CategoryCell else {
                return UIMenu()
            }
            
            let editAction = UIAction(title: NSLocalizedString("Редактировать", comment: "")) { [weak self] action in
                guard let self = self else { return }
                let editNameCategory = cell.textLabel?.text
                let viewController = CreateCategoryViewController(eventType: .edit)
                viewController.editCategoryName = editNameCategory
                self.present(viewController, animated: true)
            }
            
            let deleteAction = UIAction(title: NSLocalizedString("Удалить", comment: ""), attributes: .destructive) { [weak self] action in
                guard let self = self else { return }
                let deleteCategory = cell.textLabel?.text
                guard let categoryToDelete = deleteCategory else { return }
                self.showAlert(for: categoryToDelete)
            }
            return UIMenu(children: [editAction, deleteAction])
        }
        return configuration
    }
}
