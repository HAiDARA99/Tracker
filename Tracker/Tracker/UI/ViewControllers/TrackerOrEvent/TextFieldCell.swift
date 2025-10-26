import UIKit

protocol TextFieldCollectionViewCellDelegate: AnyObject {
    func didUpdateTrackerName(_ name: String?)
}

class TextFieldCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "TextFieldCell"
    var delegate: TextFieldCollectionViewCellDelegate?
    
    private let maxLength = 38
    
    private let textField = {
        let field = UITextField()
        field.placeholder = "Введите название трекера"
        field.font = .systemFont(ofSize: 17, weight: .regular)
        field.textColor = .black
        field.backgroundColor = .ypBackground
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
    
    private let warningLabel = {
        let wl = UILabel()
        wl.text = "Ограничение 38 символов"
        wl.font = .systemFont(ofSize: 17, weight: .regular)
        wl.textColor = .ypRed
        wl.translatesAutoresizingMaskIntoConstraints = false
        wl.isHidden = true
        return wl
    }()
    
    private lazy var stack = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
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
        contentView.addSubview(warningLabel)
        
        NSLayoutConstraint.activate([ 
            stack.topAnchor.constraint(equalTo: contentView.topAnchor),
            stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            textField.heightAnchor.constraint(equalToConstant: 75)
        ])
        
        textField.delegate = self
        textField.addTarget(self, action: #selector(textChanged), for: .editingChanged)
    }
    
    @objc private func textChanged() {
        delegate?.didUpdateTrackerName(textField.text)
    }
    
    private func setWarning(visible: Bool) {
        guard warningLabel.isHidden == !visible else { return }

        warningLabel.isHidden = !visible
        enclosingCollectionView()?.performBatchUpdates(nil, completion: nil)
    }

    private func enclosingCollectionView() -> UICollectionView? {
        var v: UIView? = self
        while let s = v?.superview {
            if let cv = s as? UICollectionView { return cv }
            v = s
        }
        return nil
    }
}


extension TextFieldCollectionViewCell: UITextFieldDelegate {
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {

        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)

        if updatedText.count > maxLength {
            warningLabel.isHidden = false
            return false
        } else {
            warningLabel.isHidden = true
            return true
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}


