import UIKit

final class CreationTrackerVC: UIViewController {
    // MARK: - Delegates
    weak var scheduleVCDelegate: ScheduleVCDelegate?
    weak var trackerCreationDelegate: TrackerCreationProtocol?
    
    // MARK: - State
    private var selectedCategoryTitle: String = ""
    private var selectedWeekDays: [Weekday] = []
    private var trackerName: String?
    private var selectedEmoji: String?
    private var selectedColor: UIColor?
    
    private let nameLimit = 38
    
    // MARK: - Stores / VM
    private let viewModel = CategoryViewModel()
    private let trackerStore = TrackerStore.shared
    
    // MARK: - UI
    private lazy var titleLabel: UILabel = {
        let l = UILabel()
        l.text = "Новая привычка"
        l.font = .systemFont(ofSize: 16, weight: .medium)
        l.textColor = .ypBlack
        l.textAlignment = .center
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    private lazy var nameTextField: UITextField = {
        let tf = UITextField()
        tf.backgroundColor = .ypBackground
        tf.textColor = .ypBlack
        tf.placeholder = "Введите название трекера"
        tf.font = .systemFont(ofSize: 17, weight: .regular)
        tf.layer.cornerRadius = 16
        tf.delegate = self
        tf.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 44))
        tf.leftViewMode = .always
        tf.clearButtonMode = .whileEditing
        tf.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    private lazy var restrictionLabel: UILabel = {
        let l = UILabel()
        l.text = "Ограничение 38 символов"
        l.font = .systemFont(ofSize: 17, weight: .regular)
        l.textColor = .ypRed
        l.textAlignment = .center
        l.isHidden = true
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    private lazy var optionsTableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .plain)
        tv.register(TwoOptionsCell.self, forCellReuseIdentifier: TwoOptionsCell.reuseIdentifier)
        tv.layer.cornerRadius = 16
        tv.separatorStyle = .singleLine
        tv.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        tv.delegate = self
        tv.dataSource = self
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.backgroundColor = .ypBackground
        tv.isScrollEnabled = false
        return tv
    }()
    
    private lazy var emojiCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(EmojiCell.self, forCellWithReuseIdentifier: EmojiCell.reuseIdentifier)
        cv.register(EmojiHeaderView.self,
                    forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                    withReuseIdentifier: EmojiHeaderView.identifier)
        cv.dataSource = self
        cv.delegate = self
        cv.allowsMultipleSelection = false
        cv.showsVerticalScrollIndicator = false
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = .clear
        cv.isScrollEnabled = false
        return cv
    }()
    
    private lazy var colorCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(ColorCell.self, forCellWithReuseIdentifier: ColorCell.reuseIdentifier)
        cv.register(ColorHeaderView.self,
                    forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                    withReuseIdentifier: ColorHeaderView.identifier)
        cv.dataSource = self
        cv.delegate = self
        cv.allowsMultipleSelection = false
        cv.showsVerticalScrollIndicator = false
        cv.isScrollEnabled = false
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = .clear
        return cv
    }()
    
    private lazy var cancelButton: UIButton = {
        let b = UIButton(type: .system)
        b.setTitle("Отменить", for: .normal)
        b.backgroundColor = .ypWhite
        b.tintColor = .ypRed
        b.layer.cornerRadius = 16
        b.layer.borderWidth = 1
        b.layer.borderColor = UIColor.ypRed.cgColor
        b.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)
        b.translatesAutoresizingMaskIntoConstraints = false
        return b
    }()
    
    private lazy var createButton: UIButton = {
        let b = UIButton(type: .system)
        b.setTitle("Создать", for: .normal)
        b.backgroundColor = .ypGray
        b.tintColor = .ypWhite
        b.layer.cornerRadius = 16
        b.addTarget(self, action: #selector(createTapped), for: .touchUpInside)
        b.isEnabled = false
        b.translatesAutoresizingMaskIntoConstraints = false
        return b
    }()
    
    private lazy var buttonsStack: UIStackView = {
        let s = UIStackView()
        s.axis = .horizontal
        s.spacing = 8
        s.distribution = .fillEqually
        s.translatesAutoresizingMaskIntoConstraints = false
        return s
    }()
    
    private lazy var scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    private lazy var contentView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        view.backgroundColor = .ypWhite
    }
    
    private func setupView() {
        view.addSubview(titleLabel)
        view.addSubview(scrollView)
        view.addSubview(buttonsStack)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(nameTextField)
        contentView.addSubview(restrictionLabel)
        contentView.addSubview(optionsTableView)
        contentView.addSubview(emojiCollectionView)
        contentView.addSubview(colorCollectionView)
        
        buttonsStack.addArrangedSubview(cancelButton)
        buttonsStack.addArrangedSubview(createButton)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 26),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            buttonsStack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            buttonsStack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            buttonsStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            cancelButton.heightAnchor.constraint(equalToConstant: 60),
            createButton.heightAnchor.constraint(equalToConstant: 60),
            
            scrollView.topAnchor.constraint(equalTo: titleLabel.topAnchor, constant: 48),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: buttonsStack.topAnchor, constant: -8),
            
            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),
            
            nameTextField.topAnchor.constraint(equalTo: contentView.topAnchor),
            nameTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            nameTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            nameTextField.heightAnchor.constraint(equalToConstant: 75),
            
            restrictionLabel.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 8),
            restrictionLabel.leadingAnchor.constraint(equalTo: nameTextField.leadingAnchor, constant: 12),
            restrictionLabel.trailingAnchor.constraint(equalTo: nameTextField.trailingAnchor, constant: -12),
            
            optionsTableView.topAnchor.constraint(equalTo: restrictionLabel.bottomAnchor, constant: 16),
            optionsTableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            optionsTableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            optionsTableView.heightAnchor.constraint(equalToConstant: 150),
            
            emojiCollectionView.topAnchor.constraint(equalTo: optionsTableView.bottomAnchor, constant: 24),
            emojiCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 19),
            emojiCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -19),
            emojiCollectionView.heightAnchor.constraint(equalToConstant: 222),
            
            colorCollectionView.topAnchor.constraint(equalTo: emojiCollectionView.bottomAnchor, constant: 16),
            colorCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 18),
            colorCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -18),
            colorCollectionView.heightAnchor.constraint(equalToConstant: 222),
            colorCollectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
        ])
    }
    
    // MARK: - Actions
    @objc private func cancelTapped() {
        dismiss(animated: true)
    }
    
    @objc private func createTapped() {
        guard
            let name = trackerName, !name.isEmpty,
            let emoji = selectedEmoji,
            let color = selectedColor,
            !selectedCategoryTitle.isEmpty,
            !selectedWeekDays.isEmpty
        else { return }
        
        let newTracker = Tracker(
            id: UUID(),
            name: name,
            color: color,
            emoji: emoji,
            schedule: selectedWeekDays
        )
        do {
            try trackerStore.addTracker(newTracker, categoryTitle: selectedCategoryTitle)
            trackerCreationDelegate?.passingTracker(newTracker, selectedCategoryTitle)
            dismiss(animated: true)
        } catch {
            print("Ошибка сохранения трекера: \(error)")
            dismiss(animated: true)
        }
    }
    
    @objc private func textFieldDidChange() {
        trackerName = nameTextField.text
        restrictionLabel.isHidden = (nameTextField.text ?? "").count < 38
        checkCorrectness()
    }
    
    // MARK: - Validation
    private func checkCorrectness() {
        let valid = !(trackerName?.isEmpty ?? true)
        && !selectedCategoryTitle.isEmpty
        && !selectedWeekDays.isEmpty
        && selectedEmoji != nil
        && selectedColor != nil
        
        createButton.isEnabled = valid
        createButton.backgroundColor = valid ? .ypBlack : .ypGray
    }
}

// MARK: - UITextFieldDelegate
extension CreationTrackerVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn nsRange: NSRange,
                   replacementString string: String) -> Bool {
        
        // Разрешаем ввод для "живых" языков (IME, китайский и т.д.)
        if let marked = textField.markedTextRange,
           textField.position(from: marked.start, offset: 0) != nil {
            return true
        }
        
        let current = textField.text ?? ""
        guard let range = Range(nsRange, in: current) else { return false }
        let updated = current.replacingCharacters(in: range, with: string)
        
        // Показываем или скрываем предупреждение
        restrictionLabel.isHidden = updated.count < nameLimit
        
        // Ограничиваем ввод
        return updated.count <= nameLimit
    }
}

// MARK: - UITableViewDataSource / Delegate
extension CreationTrackerVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { 2 }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: TwoOptionsCell.reuseIdentifier,
            for: indexPath
        ) as? TwoOptionsCell else { return UITableViewCell() }
        
        if indexPath.row == 0 {
            let subtitle = selectedCategoryTitle.isEmpty ? nil : selectedCategoryTitle
            cell.configure(title: "Категория", subtitle: subtitle)
        } else {
            let subtitle = selectedWeekDays.isEmpty
            ? nil
            : selectedWeekDays.map { $0.shortDayName }.joined(separator: ", ")
            cell.configure(title: "Расписание", subtitle: subtitle)
        }
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 0 {
            let categories = CategoryViewController(viewModel: viewModel)
            categories.viewModelDelegate = self
            navigationController?.pushViewController(categories, animated: true)
        } else {
            let schedule = ScheduleVC()
            schedule.delegate = self
            schedule.selectedWeekDays = self.selectedWeekDays
            navigationController?.pushViewController(schedule, animated: true)
        }
    }
}

// MARK: - UICollectionViewDataSource / Delegate
extension CreationTrackerVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int { 1 }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { 1 }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == emojiCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmojiCell.reuseIdentifier, for: indexPath) as! EmojiCell
            cell.delegate = self
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ColorCell.reuseIdentifier, for: indexPath) as! ColorCell
            cell.delegate = self
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        if collectionView == emojiCollectionView {
            let v = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: EmojiHeaderView.identifier,
                for: indexPath
            ) as! EmojiHeaderView
            v.configure(text: "Эмоджи")
            return v
        } else {
            let v = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: ColorHeaderView.identifier,
                for: indexPath
            ) as! ColorHeaderView
            v.configure(text: "Цвета")
            return v
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout l: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.bounds.width, height: 222)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout l: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        CGSize(width: collectionView.bounds.width, height: 35)
    }
}

// MARK: - Делегаты контейнеров
extension CreationTrackerVC: EmojiCellDelegate, ColorCellDelegate {
    func didSelectEmoji(_ emoji: String) {
        selectedEmoji = emoji
        checkCorrectness()
    }
    
    func didSelectColor(_ color: UIColor) {
        selectedColor = color
        checkCorrectness()
    }
}

// MARK: - ScheduleVCDelegate
extension CreationTrackerVC: ScheduleVCDelegate {
    func didSelectDays(_ days: [Weekday]) {
        selectedWeekDays = days
        optionsTableView.reloadRows(at: [IndexPath(row: 1, section: 0)], with: .none)
        checkCorrectness()
    }
}

// MARK: - CategoryViewControllerDelegate
extension CreationTrackerVC: CategoryViewControllerDelegate {
    var selectedCategory: String {
        get { selectedCategoryTitle }
        set { selectedCategoryTitle = newValue }
    }
    func didSelectCategory() {
        optionsTableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .none)
        checkCorrectness()
    }
}
