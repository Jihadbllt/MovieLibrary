import SwiftUI

@main
struct MovieLibraryApp: App {
    @StateObject private var dataController = DataController()

    var body: some Scene {
        WindowGroup {
            MovieListView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}
