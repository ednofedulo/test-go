//
//  Persistence.swift
//  grpc-test
//
//  Created by Edno Fedulo on 11/04/21.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        for _ in 0..<10 {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()
        }
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            debugPrint(nsError)
            
        }
        return result
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = true) {
        container = NSPersistentContainer(name: "grpc_test")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                debugPrint("Unresolved error \(error), \(error.userInfo)")
                
            }
        })
    }
}
