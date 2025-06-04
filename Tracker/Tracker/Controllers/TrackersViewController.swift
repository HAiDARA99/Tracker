import UIKit

final class TrackersViewController: UIViewController {
    var categories: [TrackerCategory] = []
    var completedTrackers: [TrackerRecord] = []
    var collectionView: UICollectionView!
    private var selectedDate: Date = Date()
    private var filteredCategories: [TrackerCategory] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavBar()
        setupCollectionView()
        
        let tracker1 = Tracker(id: UUID(), name: "Пить воду", color: UIColor(named: "ColorSection9") ?? .colorBlue, emoji: "💧", schedule: [.monday, .wednesday])
        let tracker2 = Tracker(id: UUID(), name: "Спорт", color: UIColor(named: "ColorSection8") ?? .colorRed, emoji: "🏋️", schedule: [.monday, .tuesday, .saturday])
        categories = [TrackerCategory(title: "Здоровье", trackers: [tracker1, tracker2])]
        filterTrackers(for: selectedDate)
        updateUI()
    }
    
    private func setNavBar() {
        let navigationBar = navigationController?.navigationBar
        
        let addButton = UIBarButtonItem(
            image: UIImage(named: "AddTrackerIcon"),
            style: .plain,
            target: nil,
            action: #selector(addButtonTapped)
        )
        
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .compact
        let currentDate = Date()
        let calendar = Calendar.current
        let minDate = calendar.date(byAdding: .year, value: -10, to: currentDate)
        let maxDate = calendar.date(byAdding: .year, value: 10, to: currentDate)
        datePicker.minimumDate = minDate
        datePicker.maximumDate = maxDate
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        
        let searchField = UISearchController()
        searchField.searchBar.placeholder = "Поиск"
        navigationItem.searchController = searchField
        
        navigationItem.leftBarButtonItem = addButton
        navigationItem.leftBarButtonItem?.tintColor = .black
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePicker)
        navigationItem.title = "Трекеры"
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .systemBackground
        appearance.largeTitleTextAttributes = [
            .foregroundColor: UIColor.label,
            .font: UIFont.boldSystemFont(ofSize: 34)
        ]
        
        navigationBar?.prefersLargeTitles = true
        navigationBar?.standardAppearance = appearance
    }
    
    @objc func addButtonTapped() {
        let addTrackerViewController = TrackerTypeVC()
        navigationController?.pushViewController(addTrackerViewController, animated: true)
    }
    
    private func setupEmptyView() {
        let starImage = {
            let star = UIImageView()
            star.image = UIImage(named: "CometStar")
            star.contentMode = .scaleToFill
            star.translatesAutoresizingMaskIntoConstraints = false
            return star
        }()
        
        let textLabel = {
            let text = UILabel()
            text.text = "Что будем отслеживать?"
            text.font = .systemFont(ofSize: 12)
            text.translatesAutoresizingMaskIntoConstraints = false
            text.textColor = .black
            text.shadowColor = .grey
            return text
        }()
        
        view.backgroundColor = .whiteDay
        view.addSubview(starImage)
        view.addSubview(textLabel)
        
        NSLayoutConstraint.activate([
            starImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 402),
            starImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            starImage.widthAnchor.constraint(equalToConstant: 80),
            starImage.heightAnchor.constraint(equalToConstant: 80),
            
            textLabel.topAnchor.constraint(equalTo: starImage.bottomAnchor, constant: 8),
            textLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func setupCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.register(TrackerCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        view.addSubview(collectionView)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func filterTrackers(for date: Date) {
        let calendar = Calendar.current
        let weekdayIndex = calendar.component(.weekday, from: date)
        let weekDayMapping: [Int: Weekday] = [
            1: .sunday,
            2: .monday,
            3: .tuesday,
            4: .wednesday,
            5: .thursday,
            6: .friday,
            7: .saturday
        ]
        
        guard let weekday = weekDayMapping[weekdayIndex] else { return }
        filteredCategories = categories.compactMap { category in
            let filteredTrackers = category.trackers.filter { $0.schedule.contains(weekday) }
            return filteredTrackers.isEmpty ? nil : TrackerCategory(title: category.title, trackers: filteredTrackers)
        }
    }
    
    private func updateUI() {
        if filteredCategories.isEmpty {
            setupEmptyView()
            collectionView.isHidden = true
        } else {
            collectionView.isHidden = false
            view.subviews.filter { $0 is UIImageView || $0 is UILabel }.forEach { $0.removeFromSuperview()}
        }
    }
    
    @objc func datePickerValueChanged(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        dateFormatter.locale = Locale(identifier: "ru_RU")
        selectedDate = sender.date
        filterTrackers(for: selectedDate)
        updateUI()
        collectionView.reloadData()
    }
}

extension TrackersViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return filteredCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! TrackerCell
        let tracker = filteredCategories[indexPath.section].trackers[indexPath.item]
        
        let completedCount = completedTrackers.filter { $0.trackerId == tracker.id }.count
        let isCompleted = completedTrackers.contains { record in
            record.trackerId == tracker.id && Calendar.current.isDate(record.date, inSameDayAs: selectedDate)
        }
        let isFutureDate = selectedDate > Date()
        
        cell.configure(tracker: tracker,
                       completedCount: completedCount,
                       isCompleted: isCompleted,
                       date: selectedDate,
                       isFutureDate: isFutureDate)
        cell.onDoneButtonTapped = { [weak self] trackerId, date, isSelected in
            guard let self else { return }
            let record = TrackerRecord(trackerId: trackerId, date: date)
            
            if isSelected {
                self.completedTrackers.append(record)
            } else {
                completedTrackers.removeAll { $0.trackerId == tracker.id && Calendar.current.isDate($0.date, inSameDayAs: date) }
            }
            
            self.collectionView.reloadData()
            
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredCategories[section].trackers.count
    }
}

extension TrackersViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = collectionView.bounds.width
        let itemWidth = (screenWidth - 41) / 2 // Левый 16, правый 16, между 9
        let height: CGFloat = 148
        return CGSize(width: itemWidth, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat { // отступ между ячейками по горизонтали
        return 9
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat { // отступ между ячейками по вертикали
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    }
}
