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
    
    private override init() {
        let modelURL = NSBundle.mainBundle()
            .URLForResource("Model",
                            withExtension: "momd")!
        model = NSManagedObjectModel(
            contentsOfURL: modelURL)!
        
        let fileManager = NSFileManager.defaultManager()
        let docsURL = fileManager.URLsForDirectory(
                    .DocumentDirectory, inDomains: .UserDomainMask).last
//        let docsURL = fileManager.containerURLForSecurityApplicationGroupIdentifier("group.me.nikmaikl.mjournal")
        let storeURL = docsURL!
            .URLByAppendingPathComponent("base.sqlite")
        
        coordinator = NSPersistentStoreCoordinator(
            managedObjectModel: model)
        
        var store : NSPersistentStore? = nil
        
        do {
            store = try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: storeURL, options: nil)
            
        } catch {
            print(error)
        }
        
        if store == nil {
            abort()
        }
        
        context = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.MainQueueConcurrencyType)
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
