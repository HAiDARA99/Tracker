import UIKit

protocol EmojiCellDelegate: AnyObject {
    func didSelectEmoji(_ emoji: String)
}

class EmojiCell: UICollectionViewCell {
    static let reuseIdentifier = "EmojiCell"
    weak var delegate: EmojiCellDelegate?
    
    let emojis = ["🙂", "😻", "🌺", "🐶", "❤️", "😱",
                  "😇", "😡", "🥶", "🤔", "🙌", "🍔",
                  "🥦", "🏓", "🥇", "🎸", "🏝", "😪"]
    
    private var selectedEmojiIndex: IndexPath?
    
    var selectedEmoji: String? {
        guard let index = selectedEmojiIndex else { return nil }
        return emojis[index.item]
    }
    
    private let emojiCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 52, height: 52)
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(emojiCollectionView)
        
        NSLayoutConstraint.activate([
            emojiCollectionView.topAnchor.constraint(equalTo: contentView.topAnchor),
            emojiCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            emojiCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            emojiCollectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        emojiCollectionView.register(EmojiItemCell.self, forCellWithReuseIdentifier: EmojiItemCell.reuseIdentifier)
        emojiCollectionView.dataSource = self
        emojiCollectionView.delegate = self
    }
}

extension EmojiCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        emojis.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmojiItemCell.reuseIdentifier, for: indexPath) as! EmojiItemCell
        cell.configure(with: emojis[indexPath.item], isSelected: selectedEmojiIndex == indexPath)
        return cell
    }
}

extension EmojiCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 52, height: 52)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 6, left: 6, bottom: 6, right: 6)
    }
}

extension EmojiCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let previousIndex = selectedEmojiIndex, previousIndex != indexPath {
            collectionView.deselectItem(at: previousIndex, animated: false)
            if let previousCell = collectionView.cellForItem(at: previousIndex) as? EmojiItemCell {
                previousCell.configure(with: emojis[previousIndex.item], isSelected: false)
            }
        }
        
        selectedEmojiIndex = indexPath
        if let cell = collectionView.cellForItem(at: indexPath) as? EmojiItemCell {
            cell.configure(with: emojis[indexPath.item], isSelected: true)
        }
        delegate?.didSelectEmoji(emojis[indexPath.item])
    }
}
