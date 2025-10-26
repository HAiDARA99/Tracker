import CoreData

protocol TrackerRecordStoreDelegate: AnyObject {
    func trackerRecordStoreDidUpdate()
}

class TrackerRecordStore: NSObject {
    static let shared = TrackerRecordStore()
    let context = CoreDataManager.shared.context
    weak var delegate: TrackerRecordStoreDelegate?
    private var recordsFetchedResultsController: NSFetchedResultsController<TrackerRecordCD>?
    var records: [TrackerRecord]? {
        guard
            let fetchedResultsController = self.recordsFetchedResultsController,
            let objects = fetchedResultsController.fetchedObjects,
            let records = try? objects.map({ try createNewRecord($0)} ) else { return [] }
        return records
    }
    
    override init() {
        super.init()
        
        let fetchRequest = TrackerRecordCD.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "trackerID", ascending: false)]
        
        let controller = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        
        controller.delegate = self
        self.recordsFetchedResultsController = controller
        try? controller.performFetch()
    }
    
    func addRecord(_ record: TrackerRecord) throws {
        _ = createCoreDataTrackerRecord(record)
        try saveContext()
    }
    
    func createCoreDataTrackerRecord(_ record: TrackerRecord) -> TrackerRecordCD {
        let newTrackerRecord = TrackerRecordCD(context: context)
        newTrackerRecord.date = record.date
        newTrackerRecord.trackerID = record.trackerId
        return newTrackerRecord
    }
    
    func createNewRecord(_ recordCD: TrackerRecordCD) throws -> TrackerRecord {
        guard
            let iD = recordCD.trackerID,
            let date = recordCD.date else {
           throw CoreDataError.objectNotFound
        }
        return TrackerRecord(trackerId: iD, date: date)
    }

    
    func deleteOneRecord(trackerId: UUID, date: Date) throws {
        let request = TrackerRecordCD.fetchRequest()
        let trackerRecords = try context.fetch(request)
        let filteredRecord = trackerRecords.first { $0.trackerID == trackerId && $0.date == date }
        if let trackerRecordCD = filteredRecord {
            context.delete(trackerRecordCD)
            try saveContext()
        }
    }
    
    func deleteAllRecordsForTracker(_ id: UUID) throws {
        let request = TrackerRecordCD.fetchRequest()
        request.predicate = NSPredicate(format: "%K == %@", #keyPath(TrackerRecordCD.trackerID), id as CVarArg)
        guard let trackerRecords = try? context.fetch(request) else { return }
        trackerRecords.forEach {
            context.delete($0)
        }
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

extension TrackerRecordStore: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
            delegate?.trackerRecordStoreDidUpdate()
    }
}
