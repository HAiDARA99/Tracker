import UIKit

class ColorItemCell: UICollectionViewCell {
    static let reuseIdentifier = "ColorItemCell"
    
    let colorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        return view
    }()
    
    private let backgroundBorderLayer: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.cornerRadius = 10
        view.layer.borderWidth = 3
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
        contentView.addSubview(backgroundBorderLayer)
        contentView.addSubview(colorView)
        
        NSLayoutConstraint.activate([
            backgroundBorderLayer.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            backgroundBorderLayer.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            backgroundBorderLayer.widthAnchor.constraint(equalToConstant: 52),
            backgroundBorderLayer.heightAnchor.constraint(equalToConstant: 52),
            
            colorView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            colorView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            colorView.widthAnchor.constraint(equalToConstant: 40),
            colorView.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    func configure(color: UIColor, isSelected: Bool) {
        colorView.backgroundColor = color
        backgroundBorderLayer.layer.borderColor = isSelected ? color.withAlphaComponent(0.3).cgColor : UIColor.clear.cgColor
    }
}
