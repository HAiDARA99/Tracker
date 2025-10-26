//import UIKit
//
//protocol IrregularEventCellDelegate: AnyObject {
//    func didTapCategory()
//}
//
//class IrregularEventCell: UICollectionViewCell {
//    weak var actionDelegate: IrregularEventCellDelegate?
//    weak var trackerCreationDelegate: TrackerCreationProtocol?
//    static let reuseIdentifier = "UnregularEventCell"
//    private let tableView = UITableView(frame: .zero)
//    private var currentCategoryTitle: String = "По умолчанию"
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setupTableView()
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    private func setupTableView() {
//        contentView.addSubview(tableView)
//        contentView.backgroundColor = .ypBackground
//        
//        tableView.isScrollEnabled = false
//        tableView.isUserInteractionEnabled = true
//        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
//        tableView.contentInset = UIEdgeInsets(top: -1, left: 0, bottom: 0, right: 0)
//        tableView.dataSource = self
//        tableView.delegate = self
//        tableView.register(TwoOptionsCell.self, forCellReuseIdentifier: TwoOptionsCell.reuseIdentifier)
//        tableView.translatesAutoresizingMaskIntoConstraints = false
//        tableView.allowsSelection = true
//        tableView.backgroundColor = UIColor(named: "BackgroundDay")
//        tableView.layer.masksToBounds = true
//        tableView.layer.cornerRadius = 10
//        tableView.layer.maskedCorners = [.layerMinXMinYCorner,
//                                         .layerMaxXMinYCorner,
//                                         .layerMinXMaxYCorner,
//                                         .layerMaxXMaxYCorner]
//        
//        NSLayoutConstraint.activate([
//            tableView.topAnchor.constraint(equalTo: contentView.topAnchor),
//            tableView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
//            tableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
//            tableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor)
//        ])
//    }
//    
//    func updateCategoryTitle(_ title: String) {
//        currentCategoryTitle = title
//        tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .none)
//    }
//}
//
//extension IrregularEventCell: UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 1
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: TwoOptionsCell.reuseIdentifier, for: indexPath) as? TwoOptionsCell else {
//            return UITableViewCell()
//        }
//        cell.configure(title: "Категория", subtitle: currentCategoryTitle)
//        return cell
//    }
//}
//
//extension IrregularEventCell: UITableViewDelegate {
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 75
//    }
//    
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        cell.separatorInset = UIEdgeInsets(top: 0, left: tableView.bounds.width, bottom: 0, right: 0)
//    }
//    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
//        actionDelegate?.didTapCategory()
//        
//    }
//}
