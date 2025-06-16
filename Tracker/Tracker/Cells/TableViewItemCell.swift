import UIKit

class TwoOptionsCell: UITableViewCell {
    static let reuseIdentifier = "Cell"

    let mainStack = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 16
        stack.alignment = .center
        return stack
    }()
    
    let label = {
        let label = UILabel()
        label.text = ""
        label.font = .systemFont(ofSize: 17, weight: .regular)
        return label
    }()
    
    let chevronImage = {
        let chevron = UIImageView()
        chevron.image = UIImage(named: "chevron")
        return chevron
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        [label, chevronImage, mainStack].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        mainStack.addArrangedSubview(label)
        mainStack.addArrangedSubview(chevronImage)
        contentView.addSubview(mainStack)
        contentView.backgroundColor = UIColor(named: "BackgroundDay")
        
        NSLayoutConstraint.activate([
            mainStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            mainStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            mainStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            mainStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            mainStack.heightAnchor.constraint(equalToConstant: 75)
        ])
    }
    
    func configure(labelOption: String) {
        label.text = labelOption
    }
}
