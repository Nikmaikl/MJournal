import UIKit
import CoreData

class CoreDataHelper: NSObject {
    ///singleton
    class var instance: CoreDataHelper {
        struct Singleton {
            static let instance = CoreDataHelper()
        }
        return Singleton.instance
    }
    
    let coordinator: NSPersistentStoreCoordinator
    let model: NSManagedObjectModel
    let context: NSManagedObjectContext
    
    fileprivate override init() {
        let modelURL = Bundle.main
            .url(forResource: "Model",
                            withExtension: "momd")!
        model = NSManagedObjectModel(
            contentsOf: modelURL)!
        
        let fileManager = FileManager.default
        let docsURL = fileManager.containerURL(forSecurityApplicationGroupIdentifier: "group.minikov.MJournal")
        let storeURL = docsURL!
            .appendingPathComponent("base.sqlite")
        
        coordinator = NSPersistentStoreCoordinator(
            managedObjectModel: model)
        
        var store : NSPersistentStore? = nil
        
        do {
            store = try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL, options: nil)
            
        } catch {
            print(error)
        }
        
        if store == nil {
            abort()
        }
        
        context = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.mainQueueConcurrencyType)
        context.persistentStoreCoordinator = coordinator
        super.init()
    }
    
    func save() {
        var error: NSError?
        do {
            try context.save()
            
        } catch let error1 as NSError {
            error = error1
        }
        if let error = error {  //if error != nil
            print(error.localizedDescription)
        }
    }
    
}
