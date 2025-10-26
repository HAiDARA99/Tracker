import UIKit
import CoreData

protocol TrackerCategoryDelegate: AnyObject {
    func trackerCategoryDidUpdate()
}

final class TrackerCategoryStore: NSObject {
    static let shared = TrackerCategoryStore()
    private let trackerStore = TrackerStore.shared
    let context = CoreDataManager.shared.context
    weak var delegate: TrackerCategoryDelegate?
    private var categoryFetchedResultsController: NSFetchedResultsController<TrackerCategoryCD>?
    
    var categories: [TrackerCategory] {
        guard let objects = categoryFetchedResultsController?.fetchedObjects,
              let categories = try? objects.map({ try self.convertToTrackerCategory($0) }) else {
            return []
        }
        return categories
    }
    
    override init() {
        super.init()
        
        let fetchRequest = TrackerCategoryCD.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        let controller = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil)
        controller.delegate = self
        self.categoryFetchedResultsController = controller
        try? controller.performFetch()
    }
    
    func fetchCategory(title: String) throws -> TrackerCategoryCD? {
        let request = TrackerCategoryCD.fetchRequest()
        request.predicate = NSPredicate(
            format: "%K == %@",
            #keyPath(TrackerCategoryCD.title), title)
        guard let category = try context.fetch(request).first else {
            throw CoreDataError.fetchFailed
        }
        return category
    }
    
    func createCategoryCD(with name: String) throws  {
        let category = TrackerCategoryCD(context: context)
        category.title = name
//        category.trackersRel = []
        try saveContext()
    }
    
    func convertToTrackerCategory(_ model: TrackerCategoryCD) throws -> TrackerCategory {
        guard let trackers = model.trackersRel else {
            throw CoreDataError.fetchFailed
        }
        guard let title = model.title else {
            throw CoreDataError.fetchFailed
        }
        
        let category = TrackerCategory(
            title: title,
            trackers: trackers.compactMap { someTracker in
                if let someTracker = someTracker as? TrackerCD {
                    return try? trackerStore.convertToTracker(someTracker)
                } else {
                    return nil
                }
            })
        return category
    }
    
    func getListOfCategories() throws -> [TrackerCategoryCD] {
        let request = TrackerCategoryCD.fetchRequest()
        request.returnsObjectsAsFaults = false
        var list: [TrackerCategoryCD]?
        do {
            list = try context.fetch(request)
        } catch {
            throw CoreDataError.fetchFailed
        }
        guard let categories = list else { fatalError("Anlak s fetchRequestom kategorii")}
        return categories
    }
    
    func updateCategory(currentTitle: String, newTitle: String) throws {
        guard let categoryToRename = categoryFetchedResultsController?.fetchedObjects?.first(where: {
            $0.title == currentTitle
        }) else {
            return
        }
        categoryToRename.title = newTitle
        try saveContext()
    }
    
    func deleteCategory(_ model: TrackerCategoryCD) throws {
        guard let object = categoryFetchedResultsController?.fetchedObjects?.first(where: { $0.title == model.title }) else {
            return
        }
        categoryFetchedResultsController?.managedObjectContext.delete(object)
        try saveContext()
    }
    
    private func saveContext() throws {
        guard context.hasChanges else { return }
        do {
            try context.save()
        } catch {
            context.rollback()
            throw error
        }
    }
}

extension TrackerCategoryStore: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.trackerCategoryDidUpdate()
    }
}
