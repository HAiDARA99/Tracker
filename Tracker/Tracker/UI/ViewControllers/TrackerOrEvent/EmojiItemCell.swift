import UIKit

class EmojiItemCell: UICollectionViewCell {
    static let reuseIdentifier = "EmojiItemCell"
    
    let emojiLabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 32)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let backgroundViewLayer: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 15
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(backgroundViewLayer)
        contentView.addSubview(emojiLabel)
        
        NSLayoutConstraint.activate([
            backgroundViewLayer.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            backgroundViewLayer.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            backgroundViewLayer.widthAnchor.constraint(equalToConstant: 52),
            backgroundViewLayer.heightAnchor.constraint(equalToConstant: 52),
            
            emojiLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            emojiLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            emojiLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            emojiLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor)
        ])
    }
    
    func configure(with emoji: String, isSelected: Bool) {
        emojiLabel.text = emoji
        backgroundViewLayer.backgroundColor = isSelected ? .systemGray5 : .clear
    }
}
