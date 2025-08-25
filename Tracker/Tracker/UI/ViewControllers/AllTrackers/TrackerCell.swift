import UIKit

final class TrackerCell: UICollectionViewCell {
    private var trackerId: UUID?
    private var date: Date?
    var onDoneButtonTapped: ((UUID, Date, Bool) -> Void)?
    
    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        return stackView
    }()
    
    private let topView: UIView = {
        let topView = UIView()
        topView.backgroundColor = .orange
        topView.layer.cornerRadius = 16
        return topView
    }()
    
    private let emojiView: UIView = {
        let emojiView = UIView()
        emojiView.backgroundColor = .white.withAlphaComponent(0.3)
        emojiView.layer.cornerRadius = 12
        return emojiView
    }()
    
    private let emojiLabel: UILabel = {
        let emojiLabel = UILabel()
        emojiLabel.font = .systemFont(ofSize: 12, weight: .medium)
        return emojiLabel
    }()
    
    private let textLabel: UILabel = {
        let textLabel = UILabel()
        textLabel.textColor = .white
        textLabel.font = .systemFont(ofSize: 12, weight: .medium)
        textLabel.numberOfLines = 2
        textLabel.textAlignment = .left
        return textLabel
    }()
    
    private let bottomView: UIView = {
        let bottomView = UIView()
        return bottomView
    }()
    
    private let counterStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        return stackView
    }()
        
    private let counterLabel: UILabel = {
        let counter = UILabel()
        counter.font = .systemFont(ofSize: 12, weight: .medium)
        counter.textColor = .black
        counter.textAlignment = .left
        return counter
    }()
    
    let doneButton: UIButton = {
        let doneButton = UIButton()
        doneButton.setImage(UIImage(named: "plusCounter"), for: .normal)
        doneButton.setImage(UIImage(named: "doneCounter"), for: .selected)
        doneButton.tintColor = .orange
        return doneButton
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        [mainStackView, emojiView, emojiLabel, textLabel, bottomView, counterStackView, counterLabel, doneButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        contentView.addSubview(mainStackView)
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        mainStackView.addArrangedSubview(topView)
        NSLayoutConstraint.activate([
            topView.heightAnchor.constraint(equalToConstant: 90)
        ])
        
        topView.addSubview(emojiView)
        NSLayoutConstraint.activate([
            emojiView.widthAnchor.constraint(equalToConstant: 24),
            emojiView.heightAnchor.constraint(equalToConstant: 24),
            emojiView.leadingAnchor.constraint(equalTo: topView.leadingAnchor, constant: 12),
            emojiView.topAnchor.constraint(equalTo: topView.topAnchor, constant: 12)
        ])
        
        emojiView.addSubview(emojiLabel)
        NSLayoutConstraint.activate([
            emojiLabel.centerXAnchor.constraint(equalTo: emojiView.centerXAnchor),
            emojiLabel.centerYAnchor.constraint(equalTo: emojiView.centerYAnchor)
        ])
        
        topView.addSubview(textLabel)
        NSLayoutConstraint.activate([
            textLabel.leadingAnchor.constraint(equalTo: topView.leadingAnchor, constant: 12),
            textLabel.trailingAnchor.constraint(equalTo: topView.trailingAnchor, constant: -12),
            textLabel.bottomAnchor.constraint(equalTo: topView.bottomAnchor, constant: -12)
        ])
        
        mainStackView.addArrangedSubview(bottomView)
        NSLayoutConstraint.activate([
            bottomView.heightAnchor.constraint(equalToConstant: 58)
        ])
        
        bottomView.addSubview(counterStackView)
        NSLayoutConstraint.activate([
            counterStackView.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: 12),
            counterStackView.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor, constant: -12),
            counterStackView.topAnchor.constraint(equalTo: bottomView.topAnchor, constant: 8)
        ])
        
        NSLayoutConstraint.activate([
            doneButton.widthAnchor.constraint(equalToConstant: 34),
            doneButton.heightAnchor.constraint(equalToConstant: 34)
        ])
        
        counterStackView.addArrangedSubview(counterLabel)
        counterStackView.addArrangedSubview(doneButton)
        
        doneButton.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
    }
    
    func configure(tracker: Tracker, completedCount: Int, isCompleted: Bool, date: Date, isFutureDate: Bool) {
        self.trackerId = tracker.id
        self.date = date
        emojiLabel.text = tracker.emoji
        textLabel.text = tracker.name
        topView.backgroundColor = tracker.color
        doneButton.tintColor = tracker.color
        counterLabel.text = "\(completedCount) дней"
        doneButton.isSelected = isCompleted
        doneButton.isEnabled = !isFutureDate
        
    }
    
    @objc private func doneButtonTapped() {
        guard let trackerId = trackerId, let date = date else { return }
        doneButton.isSelected = !doneButton.isSelected
        onDoneButtonTapped?(trackerId, date, doneButton.isSelected)
    }
}
