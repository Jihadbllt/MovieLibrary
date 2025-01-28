import SwiftUI
import PhotosUI

struct ImagePickerView: UIViewControllerRepresentable {
    @Binding var selectedData: Data?

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePickerView

        init(_ parent: ImagePickerView) {
            self.parent = parent
        }

        func imagePickerController(
            _ picker: UIImagePickerController,
            didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
        ) {
            picker.dismiss(animated: true)

            if let image = info[.originalImage] as? UIImage,
               let data = image.jpegData(compressionQuality: 0.8) {
                parent.selectedData = data
            }
        }
    }
}
