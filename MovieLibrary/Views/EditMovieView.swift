import SwiftUI

struct EditMovieView: View {
    @Environment(\.managedObjectContext) private var moc
    @Environment(\.presentationMode) private var presentationMode

    let movie: Movie

    @State private var title: String
    @State private var yearString: String
    @State private var rating: Double
    @State private var desc: String
    @State private var posterData: Data?

    @State private var showingImagePicker = false

    init(movie: Movie) {
        self.movie = movie
        
        // Initialize state from the existing movie
        _title = State(initialValue: movie.title ?? "")
        _yearString = State(initialValue: String(movie.year))
        _rating = State(initialValue: movie.rating)
        _desc = State(initialValue: movie.desc ?? "")
        _posterData = State(initialValue: movie.posterData)
    }

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Movie Details")) {
                    TextField("Title", text: $title)
                    
                    TextField("Year", text: $yearString)
                        .keyboardType(.numberPad)
                    
                    Stepper(value: $rating, in: 0...5, step: 0.5) {
                        Text("Rating: \(rating, specifier: "%.1f")/5")
                    }

                    TextEditor(text: $desc)
                        .frame(minHeight: 80)
                }

                Section(header: Text("Poster")) {
                    Button(action: {
                        showingImagePicker = true
                    }) {
                        Text("Change Poster Image")
                    }
                    // If we already have some data, show a small preview
                    if let data = posterData,
                       let uiImage = UIImage(data: data) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 150)
                            .cornerRadius(8)
                    } else {
                        Text("No poster selected")
                            .foregroundColor(.secondary)
                    }
                }
            }
            .navigationTitle("Edit Movie")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveChanges()
                    }
                }
            }
            .sheet(isPresented: $showingImagePicker) {
                ImagePickerView(selectedData: $posterData)
            }
        }
    }

    private func saveChanges() {
        movie.title = title
        movie.year = Int16(yearString) ?? 0
        movie.rating = rating
        movie.desc = desc
        movie.posterData = posterData

        do {
            try moc.save()
            presentationMode.wrappedValue.dismiss()
        } catch {
            print("Error saving edits: \(error.localizedDescription)")
        }
    }
}
