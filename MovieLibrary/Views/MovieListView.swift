import SwiftUI

struct MovieListView: View {
    @Environment(\.managedObjectContext) var moc
    
    // Default fetch: sort by title ascending
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Movie.title, ascending: true)],
        animation: .default
    )
    private var movies: FetchedResults<Movie>

    @State private var searchText = ""
    @State private var selectedSort = "Title"
    private let sortOptions = ["Title", "Rating", "Year"]

    var body: some View {
        NavigationView {
            VStack {
                // Search bar
                SearchBar(text: $searchText)

                // Sorting picker
                Picker("Sort by", selection: $selectedSort) {
                    ForEach(sortOptions, id: \.self) { option in
                        Text(option).tag(option)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()

                // List of movies
                List(filteredAndSortedMovies, id: \.self) { movie in
                    NavigationLink(destination: MovieDetailView(movie: movie)) {
                        MovieCard(movie: movie)
                    }
                }
                .listStyle(.plain)
            }
            .navigationTitle("My Movies")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: AddMovieView()) {
                        Image(systemName: "plus")
                    }
                }
            }
        }
    }

    // MARK: - Filtering & Sorting

    private var filteredAndSortedMovies: [Movie] {
        // 1) Filter by search text on the title (case-insensitive)
        var temp = movies.filter { movie in
            guard let t = movie.title else { return false }
            return searchText.isEmpty || t.localizedCaseInsensitiveContains(searchText)
        }

        // 2) Sort according to selected segment
        switch selectedSort {
        case "Rating":
            // Higher rating first
            temp.sort { $0.rating > $1.rating }
        case "Year":
            // Newer year first
            temp.sort { $0.year > $1.year }
        default:
            // Alphabetical by title
            temp.sort { ($0.title ?? "") < ($1.title ?? "") }
        }

        return temp
    }
}
