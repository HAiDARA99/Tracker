import UIKit

protocol TextFieldCollectionViewCellDelegate: AnyObject {
    func didUpdateTrackerName(_ name: String?)
}

class TextFieldCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "TextFieldCell"
    var delegate: TextFieldCollectionViewCellDelegate?
    
    private let textField = {
        let field = UITextField()
        field.placeholder = "Введите название трекера"
        field.font = .systemFont(ofSize: 17, weight: .regular)
        field.textColor = .black
        field.backgroundColor = UIColor(named: "BackgroundDay")
        field.translatesAutoresizingMaskIntoConstraints = false
        field.layer.cornerRadius = 10
        field.layer.masksToBounds = true
        field.clearButtonMode = .whileEditing
        field.keyboardType = .default
        field.autocapitalizationType = .sentences
        field.spellCheckingType = .no
        field.isUserInteractionEnabled = true
        field.autocorrectionType = .no
        
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: field.frame.height))
        field.leftView = leftView
        field.leftViewMode = .always
        return field
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(textField)
        
        NSLayoutConstraint.activate([
            textField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            textField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            textField.topAnchor.constraint(equalTo: contentView.topAnchor),
            textField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        textField.delegate = self
        textField.addTarget(self, action: #selector(textChanged), for: .editingChanged)
    }
    
    @objc private func textChanged() {
        delegate?.didUpdateTrackerName(textField.text)
    }
}


extension TextFieldCollectionViewCell: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}


