import UIKit

protocol ColorCellDelegate: AnyObject {
    func didSelectColor(_ color: UIColor)
}

class ColorCell: UICollectionViewCell {
    static let reuseIdentifier = "ColorCell"
    weak var delegate: ColorCellDelegate?
    
    private let colors: [UIColor] = {
        let colorNames = (1...18).map { "ColorSection\($0)" }
        let colors = colorNames.compactMap { UIColor(named: $0) }
        return colors
    }()
    
    private var selectedColorIndex: IndexPath?
    
    var selectedColor: UIColor? {
        guard let index = selectedColorIndex else { return nil }
        return colors[index.item]
    }
    
    private let colorCollectionView: UICollectionView = {
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
        contentView.addSubview(colorCollectionView)
        
        NSLayoutConstraint.activate([
            colorCollectionView.topAnchor.constraint(equalTo: contentView.topAnchor),
            colorCollectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            colorCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            colorCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
        ])
        
        colorCollectionView.register(ColorItemCell.self, forCellWithReuseIdentifier: ColorItemCell.reuseIdentifier)
        colorCollectionView.delegate = self
        colorCollectionView.dataSource = self
    }
}

extension ColorCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ColorItemCell.reuseIdentifier, for: indexPath) as! ColorItemCell
        cell.configure(color: colors[indexPath.item], isSelected: selectedColorIndex == indexPath)
        return cell
    }
}

extension ColorCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize(width: 52, height: 52)
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 6, left: 6, bottom: 6, right: 6)
    }
}

extension ColorCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let previousIndex = selectedColorIndex, previousIndex != indexPath {
            collectionView.deselectItem(at: previousIndex, animated: false)
            if let previousCell = collectionView.cellForItem(at: previousIndex) as? ColorItemCell {
                previousCell.configure(color: colors[previousIndex.item], isSelected: false)
            }
        }
        
        selectedColorIndex = indexPath
        if let cell = collectionView.cellForItem(at: indexPath)
            as? ColorItemCell {
            cell.configure(color: colors[indexPath.item], isSelected: true)
        }
        delegate?.didSelectColor(colors[indexPath.item])
    }
}
