import UIKit
import CoreData

protocol TrackerCategoryStoreProtocol {
    func trackerCategoryStoreDidUpdate()
}

class TrackerCategoryStore {
    static let shared = TrackerCategoryStore()
}

