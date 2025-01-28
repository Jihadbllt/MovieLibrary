import SwiftUI

struct MovieCard: View {
    let movie: Movie

    var body: some View {
        HStack(alignment: .top) {
            // Poster image from binary data
            if let data = movie.posterData,
               let uiImage = UIImage(data: data) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 120)
                    .cornerRadius(8)
            } else {
                // Placeholder if no poster
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 80, height: 120)
                    .cornerRadius(8)
            }

            // Text info
            VStack(alignment: .leading, spacing: 6) {
                Text(movie.title ?? "Untitled")
                    .font(.headline)
                Text("Year: \(movie.year)")
                    .font(.subheadline)
                Text("Rating: \(movie.rating, specifier: "%.1f")/5")
                    .font(.subheadline)
            }
            Spacer()
        }
        .padding(.vertical, 8)
    }
}
