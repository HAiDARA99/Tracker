import UIKit

protocol TableViewCollectionViewCellDelegate: AnyObject {
    func didSelectScheduleRow()
    func didSelectCategoryRow()
}

class TableViewCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "TableViewCell"
    weak var delegate: TableViewCollectionViewCellDelegate?
    
    private let tableView = UITableView(frame: .zero)
    private var currentCategoryTitle: String = ""
    private var currentSchedule: String = ""

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTableView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateCategoryTitle(_ title: String) {
        currentCategoryTitle = title
        tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .none)
    }
    
    func updateCurrentSchedule(_ days: String) {
        currentSchedule = days
        tableView.reloadRows(at: [IndexPath(row: 1, section: 0)], with: .none)
    }
    
    func setupTableView() {
        contentView.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.isScrollEnabled = false
        tableView.isUserInteractionEnabled = true
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        tableView.contentInset = UIEdgeInsets(top: -1, left: 0, bottom: 0, right: 0)
        tableView.dataSource = self
        tableView.delegate = self

        tableView.allowsSelection = true
        tableView.backgroundColor = .ypBackground
        tableView.layer.masksToBounds = true
        tableView.layer.cornerRadius = 10
        tableView.layer.maskedCorners = [.layerMinXMinYCorner,
                                         .layerMaxXMinYCorner,
                                         .layerMinXMaxYCorner,
                                         .layerMaxXMaxYCorner,
        ]
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: contentView.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            tableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor)
        ])
        
        tableView.register(TwoOptionsCell.self, forCellReuseIdentifier: TwoOptionsCell.reuseIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension TableViewCollectionViewCell: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { 2 }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TwoOptionsCell.reuseIdentifier, for: indexPath) as? TwoOptionsCell else {
            return UITableViewCell()
        }
        
        if indexPath.row == 0 {
            let subtitle = currentCategoryTitle.isEmpty ? nil : currentCategoryTitle
            cell.configure(title: "Категория", subtitle: subtitle)
        } else {
            let subtitle = currentSchedule.isEmpty ? nil : currentSchedule
            cell.configure(title: "Расписание", subtitle: subtitle)
        }
        return cell
    }
}

extension TableViewCollectionViewCell: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let numberOfRows = tableView.numberOfRows(inSection: indexPath.section)
        if indexPath.row == 0 {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        } else if indexPath.row == numberOfRows - 1 {
            cell.separatorInset = UIEdgeInsets(top: 0, left: tableView.bounds.width, bottom: 0, right: 0)
        } else {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        }
    }
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        let rows = tableView.numberOfRows(inSection: indexPath.section)
//        if indexPath.row == rows - 1 {
//            cell.separatorInset = UIEdgeInsets(top: 0, left: tableView.bounds.width, bottom: 0, right: 0)
//        } else {
//            cell.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
//        }
//    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 1 {
            delegate?.didSelectScheduleRow()
        } else {
            delegate?.didSelectCategoryRow()
        }
    }
}
