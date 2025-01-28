import SwiftUI

struct MovieDetailView: View {
    @Environment(\.managedObjectContext) private var moc
    @Environment(\.presentationMode) private var presentationMode

    let movie: Movie

    @State private var showingEditView = false
    @State private var showingDeleteAlert = false

    var body: some View {
        VStack(spacing: 16) {
            // Poster
            if let data = movie.posterData,
               let uiImage = UIImage(data: data) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 300)
                    .cornerRadius(8)
            } else {
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 200, height: 300)
                    .cornerRadius(8)
            }

            // Text Info
            Text(movie.title ?? "Untitled")
                .font(.title)
            
            Text("Year: \(movie.year)")
                .font(.subheadline)
            
            Text("Rating: \(movie.rating, specifier: "%.1f")/5")
                .font(.subheadline)
            
            if let description = movie.desc, !description.isEmpty {
                Text(description)
                    .padding(.horizontal)
            }

            // Optionally show createdAt
            if let created = movie.createdAt {
                Text("Added on \(created.formatted(date: .numeric, time: .omitted))")
                    .foregroundColor(.secondary)
            }

            Spacer()
            
            HStack {
                Button("Edit") {
                    showingEditView = true
                }
                .padding()

                Button("Delete") {
                    showingDeleteAlert = true
                }
                .padding()
                .foregroundColor(.red)
            }
        }
        .navigationTitle(movie.title ?? "Details")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showingEditView) {
            EditMovieView(movie: movie)
        }
        .alert("Delete Movie", isPresented: $showingDeleteAlert) {
            Button("Delete", role: .destructive) {
                deleteMovie()
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Are you sure you want to remove this movie?")
        }
    }

    private func deleteMovie() {
        moc.delete(movie)
        do {
            try moc.save()
            presentationMode.wrappedValue.dismiss()
        } catch {
            print("Error deleting movie: \(error.localizedDescription)")
        }
    }
}
