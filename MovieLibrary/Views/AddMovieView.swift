import SwiftUI
import PhotosUI  // If using PhotosPicker in iOS 16+; or see your custom ImagePicker

struct AddMovieView: View {
    @Environment(\.managedObjectContext) private var moc
    @Environment(\.presentationMode) private var presentationMode

    // Form fields
    @State private var title = ""
    @State private var yearString = ""
    @State private var rating = 0.0
    @State private var desc = ""
    
    // Poster image data
    @State private var posterData: Data? = nil
    
    // For showing alerts if validation fails
    @State private var showAlert = false

    // For showing an image picker
    @State private var showingImagePicker = false

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Movie Details")) {
                    TextField("Title", text: $title)
                    TextField("Year", text: $yearString)
                        .keyboardType(.numberPad)
                    
                    // Stepper for a double rating
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
                        HStack {
                            Text("Select Poster Image")
                            Spacer()
                            if posterData != nil {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.green)
                            } else {
                                Image(systemName: "photo")
                            }
                        }
                    }
                }

                Button("Add Movie") {
                    if validateFields() {
                        let newMovie = Movie(context: moc)
                        newMovie.id = UUID()
                        newMovie.title = title
                        newMovie.year = Int16(yearString) ?? 0
                        newMovie.rating = rating
                        newMovie.desc = desc
                        newMovie.createdAt = Date()
                        newMovie.posterData = posterData

                        do {
                            try moc.save()
                            presentationMode.wrappedValue.dismiss()
                        } catch {
                            print("Error saving new movie: \(error.localizedDescription)")
                        }
                    } else {
                        showAlert = true
                    }
                }
            }
            .navigationTitle("Add Movie")
            .alert("Invalid input", isPresented: $showAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("Please fill in all required fields correctly.")
            }
            // Present a custom or system image picker
            .sheet(isPresented: $showingImagePicker) {
                ImagePickerView(selectedData: $posterData)
            }
        }
    }

    private func validateFields() -> Bool {
        // Title is mandatory
        guard !title.trimmingCharacters(in: .whitespaces).isEmpty else { return false }
        // Year must be a valid integer
        guard Int16(yearString) != nil else { return false }
        // rating in [0..5] is fine
        return true
    }
}
