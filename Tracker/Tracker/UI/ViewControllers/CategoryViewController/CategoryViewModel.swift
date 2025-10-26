//
//  CategoryViewModel.swift
//  Tracker
//
//  Created by Рауль on 27.09.2025.
//

import UIKit

final class CategoryViewModel: NSObject {
    
    weak var delegate: CategoryViewControllerDelegate?
    var onChange: (() -> Void)?

    private let categoryStore = TrackerCategoryStore.shared
    private let trackerStore = TrackerStore.shared
    private let recordStore = TrackerRecordStore.shared
    
    private var selectedCategory: String = ""
    private(set) var categories: [TrackerCategory] = [] {
        didSet {
            onChange?()
        }
    }
    
    func categoriesNumber() -> Int {
        categories.count
    }
    
    func didSelectCategory() {
        delegate?.selectedCategory = selectedCategory
        delegate?.didSelectCategory()
    }
    
    func setTextLabel(cell: UITableViewCell) {
        selectedCategory = cell.textLabel?.text ?? ""
    }
    
    func initSelectedCategory() {
        selectedCategory = delegate?.selectedCategory ?? ""
    }
    
    func checkTextSelectedCategory(cell: UITableViewCell) -> Bool {
         selectedCategory == (cell.textLabel?.text ?? "")
    }
    
    func deleteCategory(_ title: String) {
        guard let trackers = categories.first(where: { $0.title == title })?.trackers else {
            return
        }
        do {
            try trackers.forEach({ try trackerStore.deleteTracker($0) })
        } catch {
            //TODO: ALERT
        }
        do {
           try trackers.forEach { try recordStore.deleteAllRecordsForTracker($0.id) }
        } catch {
            //TODO: ALERT
        }
        
        if let categoryToDelete = try? categoryStore.fetchCategory(title: title) {
            do {
                try categoryStore.deleteCategory(categoryToDelete)
            } catch {
                //TODO: ALERT
            }
        } else {
            return
        }
    }
    // MARK: - Initializers
    override init() {
        super.init()
        categoryStore.delegate = self
        trackerCategoryDidUpdate()
    }
}
//MARK: - TrackerCategoryDelegate
extension CategoryViewModel: TrackerCategoryDelegate {
    func trackerCategoryDidUpdate() {
        categories = categoryStore.categories
    }
}
