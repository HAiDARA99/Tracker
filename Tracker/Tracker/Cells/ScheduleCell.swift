import UIKit

class ScheduleCell: UITableViewCell {
    static let reuseIdentifier = "Cell"
    
    let weekdays: [String] = ["Понедельник", "Вторник", "Среда", "Четверг", "Пятница", "Суббота", "Воскресенье"]
    
    let mainStack = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 16
        stack.alignment = .center
        return stack
    }()
    
    let weekdayLabel = {
        let label = UILabel()
        label.text = "Понедельник"
        label.font = .systemFont(ofSize: 17, weight: .regular)
        return label
    }()
    
    let switcher = {
        let switcher = UISwitch()
        switcher.isOn = false
        switcher.onTintColor = .systemBlue
        return switcher
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        [weekdayLabel, switcher, mainStack].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        mainStack.addArrangedSubview(weekdayLabel)
        mainStack.addArrangedSubview(switcher)
        contentView.addSubview(mainStack)
        contentView.backgroundColor = UIColor(named: "BackgroundDay")
        
        NSLayoutConstraint.activate([
            mainStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            mainStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            mainStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            mainStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])
    }
    
    func configure(weekday: String, isOn: Bool) {
        weekdayLabel.text = weekday
        switcher.isOn = isOn
    }
}
