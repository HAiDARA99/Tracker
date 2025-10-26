//
//  CategoryCell.swift
//  Tracker
//
//  Created by Рауль on 27.09.2025.
//

import UIKit

class CategoryCell: UITableViewCell {
    static let identifier = "Cell"
    var viewModel: CategoryViewModel?

    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Configure
    func configureCell(indexPath: IndexPath) {
        guard let viewModel = viewModel else { return }

        selectionStyle = .none
        textLabel?.text = viewModel.categories[indexPath.row].title

        // ✅ Фон и скругления — через backgroundView
        if viewModel.categoriesNumber() == 1 {
            backgroundView?.layer.cornerRadius = 16
            backgroundView?.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
        } else if indexPath.row == viewModel.categoriesNumber() - 1 {
            backgroundView?.layer.cornerRadius = 16
            backgroundView?.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
        } else {
            backgroundView?.layer.cornerRadius = 0
            separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        }

        accessoryType = viewModel.checkTextSelectedCategory(cell: self) ? .checkmark : .none
    }

    // MARK: - Setup
    private func setupView() {
        let bg = UIView()
        bg.backgroundColor = .ypBackground
        bg.layer.masksToBounds = true
        backgroundView = bg

        detailTextLabel?.textColor = .ypGray
        detailTextLabel?.font = .systemFont(ofSize: 17, weight: .regular)
    }
}
