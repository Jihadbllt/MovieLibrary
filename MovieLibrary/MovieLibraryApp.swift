//
//  MovieLibraryApp.swift
//  MovieLibrary
//
//  Created by Jihad Ballout on 28/01/2025.
//

import SwiftUI

@main
struct MovieLibraryApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
