import CoreData
import UIKit

protocol TrackerStoreDelegate: AnyObject {
    func trackerStoreDidUpdate()
}

class TrackerStore: NSObject {
    static let shared = TrackerStore()
    private let context = CoreDataManager.shared.context
    private let uiColorMarshalling = UIColorMarshalling()
    weak var delegate: TrackerStoreDelegate?
    private let recordStore = TrackerRecordStore()
    private var trackersFetchedResultsController: NSFetchedResultsController<TrackerCD>?
    private var trackers: [Tracker] {
        guard
            let objects = self.trackersFetchedResultsController?.fetchedObjects,
            let trackers = try? objects.map({ try convertToTracker($0) }) else {
            return []
        }
        return trackers
    }
    
    override init() {
        super.init()
        
        let fetchRequest = TrackerCD.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        let controller = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil)
        
        controller.delegate = self
        self.trackersFetchedResultsController = controller
        try? controller.performFetch()
    }
    
    func fetchTrackers(forDate date: Date) throws -> [Tracker] {
        let calendar = Calendar.current
        let weekdayIndex = calendar.component(.weekday, from: date)

        guard let fetchedObjects = trackersFetchedResultsController?.fetchedObjects else {
            return []
        }

        let allTrackers = try fetchedObjects.map { try convertToTracker($0) }
        
        let filtered = allTrackers.filter { tracker in
            tracker.schedule.isEmpty || tracker.schedule.contains { $0.calendarDayNumber == weekdayIndex }
        }
        return filtered
    }
    
    func convertToTracker(_ entity: TrackerCD) throws -> Tracker {
        guard
            let colorString = entity.color,
            let id = entity.id,
            let name = entity.name,
            let emoji = entity.emoji,
            let schedule = entity.schedule as? [Weekday] else {
            throw CoreDataError.objectNotFound
        }
        
        return Tracker(
            id: id,
            name: name,
            color: uiColorMarshalling.color(from: colorString),
            emoji: emoji,
            schedule: schedule)
    }
    
    func addTracker(_ tracker: Tracker, categoryTitle: String? = nil) throws {
        let trackerCD = TrackerCD(context: context)
        let color = uiColorMarshalling.hexString(from: tracker.color)
        trackerCD.id = tracker.id
        trackerCD.name = tracker.name
        trackerCD.color = color
        trackerCD.emoji = tracker.emoji
        trackerCD.schedule = tracker.schedule as NSObject
        
        let categoryName = categoryTitle ?? "По умолчанию"
        let categoryRequest = NSFetchRequest<TrackerCategoryCD>(entityName: "TrackerCategoryCD")
        categoryRequest.predicate = NSPredicate(format: "title == %@", categoryName)
        
        if let categoryCD = try context.fetch(categoryRequest).first {
            trackerCD.category = categoryCD
        } else {
            let newCategoryCD = TrackerCategoryCD(context: context)
            newCategoryCD.title = categoryName
            trackerCD.category = newCategoryCD
        }
        
        try? context.save()
        let request = TrackerCD.fetchRequest()
        if let all = try? context.fetch(request) {
            print("Сейчас в Core Data сохранено трекеров:", all.map { $0.name ?? "Без имени" })
        }
    }
    
    func updateTracker(_ updatedTracker: Tracker, with category: TrackerCategoryCD) throws {
        guard let trackerToUpdate = trackersFetchedResultsController?.fetchedObjects?.first(where: { $0.id == updatedTracker.id }) else {
            return
        }
        
        trackerToUpdate.name = updatedTracker.name
        trackerToUpdate.color = uiColorMarshalling.hexString(from: updatedTracker.color)
        trackerToUpdate.emoji = updatedTracker.emoji
        trackerToUpdate.schedule = updatedTracker.schedule as NSObject
        
        try? context.save()
    }
    
    func deleteTracker(_ model: Tracker) throws {
        let request = TrackerCD.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", model.id as CVarArg)
        guard let trackers = try? context.fetch(request) else { return }
        if let tracker = trackers.first {
            context.delete(tracker)
            try context.save()
        }
    }

}

extension TrackerStore: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.trackerStoreDidUpdate()
    }
}
