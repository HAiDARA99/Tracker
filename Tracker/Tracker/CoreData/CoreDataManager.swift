import CoreData

enum CoreDataError: Error {
    case fetchFailed
    case objectNotFound
    case filteringFailed
    case saveFailed
}

class CoreDataManager {
    static let shared = CoreDataManager()
    private init() {}
    
    lazy var persistantContainer: NSPersistentContainer = {
        DaysValueTransformer.register()
        
        let container = NSPersistentContainer(name: "TrackerCD")
        container.loadPersistentStores(completionHandler: { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    var context: NSManagedObjectContext {
        return persistantContainer.viewContext
    }
    
    func saveContext() {
        let context = persistantContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                _ = error as NSError
                fatalError("NU SHTOSH... ANLAK")
            }
        }
    }
}
