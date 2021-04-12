//
//  grpc_testApp.swift
//  grpc-test
//
//  Created by Edno Fedulo on 11/04/21.
//

import SwiftUI

@main
struct grpc_testApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
