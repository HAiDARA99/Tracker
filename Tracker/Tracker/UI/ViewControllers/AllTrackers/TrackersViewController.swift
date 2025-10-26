import UIKit

final class TrackersViewController: UIViewController {
    
    var categories: [TrackerCategory] = []
    var completedTrackers: [TrackerRecord] = []
    var visibleCategories: [TrackerCategory] = []
    
    var trackerStore = TrackerStore.shared
    var trackerRecordStore = TrackerRecordStore.shared
    var trackerCategoryStore = TrackerCategoryStore.shared
    
    var collectionView: UICollectionView!
    private var selectedDate: Date = Date()
    
    private lazy var datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.preferredDatePickerStyle = .compact
        picker.datePickerMode = .date
        picker.locale = Locale(identifier: "ru_RU") // ← локаль России
        picker.calendar.firstWeekday = 2
        picker.layer.backgroundColor = UIColor.ypBackground.cgColor
        picker.layer.cornerRadius = 8
        picker.layer.masksToBounds = true
        picker.tintColor = .ypBlue
        picker.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
        picker.heightAnchor.constraint(equalToConstant: 34).isActive = true
        picker.widthAnchor.constraint(equalToConstant: 100).isActive = true
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavBar()
        trackerStore.delegate = self
        trackerCategoryStore.delegate = self
        trackerRecordStore.delegate = self
        
        loadRecords()
        setupCollectionView()
        filterTrackers(for: selectedDate)
        updateUI()
    }
    
    private func setNavBar() {
        let navigationBar = navigationController?.navigationBar
        
        let addButton = UIBarButtonItem(
            image: UIImage(named: "AddTrackerIcon"),
            style: .plain,
            target: self,
            action: #selector(addButtonTapped)
        )

        let rightItem = UIBarButtonItem(customView: datePicker)
        navigationItem.rightBarButtonItem = rightItem
        
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
        let trackerType = TrackerTypeVC()
        trackerType.delegate = self
        let navC = UINavigationController(rootViewController: trackerType)
        navC.modalPresentationStyle = .pageSheet
        navC.isModalInPresentation = true
        present(navC, animated: true)
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
            text.shadowColor = .ypGray
            return text
        }()
        
        view.backgroundColor = .ypWhite
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
        collectionView.register(TrackerHeader.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: TrackerHeader.identifier)
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.contentInset.top = 8
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isScrollEnabled = true
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func filterTrackers(for date: Date) {
        let weekday = Calendar.current.component(.weekday, from: date)
        let allCategories = trackerCategoryStore.categories
        
        visibleCategories = allCategories
            .compactMap { category in
                let filteredTrackers = category.trackers
                    .filter { $0.schedule.isEmpty || $0.schedule.contains { $0.calendarDayNumber == weekday } }
                    .sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
                
                return filteredTrackers.isEmpty ? nil : TrackerCategory(title: category.title, trackers: filteredTrackers)
            }
            .sorted { $0.title.localizedCaseInsensitiveCompare($1.title) == .orderedAscending }
        
        updateUI()
        collectionView.reloadData()
    }
    
    private func loadRecords() {
        completedTrackers = trackerRecordStore.records ?? []
    }
    
    private func isSameDay(_ lhs: Date, _ rhs: Date) -> Bool {
        Calendar.current.isDate(lhs, inSameDayAs: rhs)
    }
    
    private func isCompleted(_ tracker: Tracker, on date: Date) -> Bool {
        completedTrackers.contains { $0.trackerId == tracker.id && isSameDay($0.date, date) }
    }
    
    private func completionCount(for tracker: Tracker) -> Int {
        completedTrackers.filter { $0.trackerId == tracker.id }.count
    }
    
    private func updateUI() {
        if visibleCategories.isEmpty {
            setupEmptyView()
            collectionView.isHidden = true
        } else {
            collectionView.isHidden = false
            view.subviews
                .filter { $0 is UIImageView || $0 is UILabel }
                .forEach { $0.removeFromSuperview()}
        }
    }
    
    @objc func datePickerValueChanged(_ sender: UIDatePicker) {
        selectedDate = sender.date
        filterTrackers(for: selectedDate)
    }
}

extension TrackersViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return visibleCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return visibleCategories[section].trackers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! TrackerCell
        let tracker = visibleCategories[indexPath.section].trackers[indexPath.item]
        
        let completedCount = completedTrackers.filter { $0.trackerId == tracker.id }.count
        let isCompleted = completedTrackers.contains { record in
            record.trackerId == tracker.id && Calendar.current.isDate(record.date, inSameDayAs: selectedDate)
        }
        
        let cal = Calendar.current
        let isFutureDate = cal.startOfDay(for: selectedDate) > cal.startOfDay(for: Date())
        
        cell.configure(tracker: tracker,
                       completedCount: completedCount,
                       isCompleted: isCompleted,
                       date: selectedDate,
                       isFutureDate: isFutureDate)
        
        
        cell.onDoneButtonTapped = { [weak self] trackerId, date, isSelected in
            guard let self else { return }
            
            if cal.startOfDay(for: date) > cal.startOfDay(for: Date()) { return }
            
            let record = TrackerRecord(trackerId: trackerId, date: date)
            
            do {
                if isSelected {
                    try self.trackerRecordStore.addRecord(record)
                } else {
                    try self.trackerRecordStore.deleteOneRecord(trackerId: trackerId, date: date)
                }
            } catch {
                print("TrackerRecordStore error: \(error)")
            }
            
            self.loadRecords()
            self.collectionView.reloadData()
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: TrackerHeader.identifier, for: indexPath) as! TrackerHeader
        header.titleLabel.text = visibleCategories[indexPath.section].title
        return header
    }
}

extension TrackersViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = collectionView.bounds.width
        let itemWidth = (screenWidth - 41) / 2
        let height: CGFloat = 148
        return CGSize(width: itemWidth, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 9
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 24)
    }
}

extension TrackersViewController: TrackerTypeVCDelegate {
    func createTracker(_ tracker: Tracker, with category: String) {
        filterTrackers(for: selectedDate)
        updateUI()
        collectionView.reloadData()
    }
}

extension TrackersViewController: TrackerStoreDelegate {
    func trackerStoreDidUpdate() {
        filterTrackers(for: selectedDate)
    }
}

extension TrackersViewController: TrackerCategoryDelegate {
    func trackerCategoryDidUpdate() {
        filterTrackers(for: selectedDate)
    }
}

extension TrackersViewController: TrackerRecordStoreDelegate {
    func trackerRecordStoreDidUpdate() {
        loadRecords()
        collectionView.reloadData()
    }
}
