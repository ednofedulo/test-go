//
//  ContentView.swift
//  grpc-test
//
//  Created by Edno Fedulo on 11/04/21.
//

import SwiftUI
import CoreData
import GRPC
import Logging

struct ContentView: View {
    var isPreview: Bool = false
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>

    
    private func fetch(){
        if isPreview {
            for index in 1...5 {
                let dt: Data_Response = .with {
                    $0.result = "Result \(index)"
                }
                
                self.addItem(dt)
            }
        } else {
            
            GRPCManager.fetchStream { (response) in
                self.addItem(response)
            }
        }
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(items) { item in
                    Text(item.result ?? "")
                }
            }
            .toolbar {
                HStack {
                    EditButton()
                    Button("Delete all") {
                        self.deleteAll()
                    }
                    
                    Button("Reload"){
                        self.fetch()
                    }
                }
            }
        }.onAppear(perform: fetch)
    }
    
    private func deleteAll(){
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Item")
            fetchRequest.returnsObjectsAsFaults = false
            do {
                let results = try PersistenceController.shared.container.viewContext.fetch(fetchRequest)
                for object in results {
                    guard let objectData = object as? NSManagedObject else {continue}
                    PersistenceController.shared.container.viewContext.delete(objectData)
                    try PersistenceController.shared.container.viewContext.save()
                }
            } catch let error {
                debugPrint(error)
            }
    }

    private func addItem(_ response: Data_Response) {
        
        withAnimation {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()
            newItem.result = response.result
            
            do {
                try viewContext.save()
            } catch {
                
                let nsError = error as NSError
                debugPrint(nsError)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(isPreview: true).environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
    }
}
