//
//  ContentView.swift
//  FaceNote
//

import SwiftUI

import PhotosUI
import SwiftUI

struct Face: Identifiable, Codable {
    var id = UUID()
    let name: String
    let photoData: Data?
    
    init(id: UUID = UUID(), name: String, photo: UIImage?) {
        self.id = id
        self.name = name
        self.photoData = photo?.jpegData(compressionQuality: 0.8)
    }
    
    var photo: UIImage? {
        guard let photoData else { return nil }
        return UIImage(data: photoData)
    }
    
    
}

@Observable
class FaceStore: Codable {
    var items: [Face] = []
    
    
    private var saveURL: URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0].appendingPathComponent("items.json")
    }
    
    func saveItems() {
        do {
            let data = try JSONEncoder().encode(items)
            try data.write(to: saveURL)
        } catch {
            print("保存失敗 \(error)")
        }
    }
    
    func loadItems() {
        do {
            let data = try Data(contentsOf: saveURL)
            items = try JSONDecoder().decode([Face].self, from: data)
        } catch {
            print("読み込み失敗\(error)")
        }
    }
    
}

struct ContentView: View {
    @State private var selectedItem: PhotosPickerItem?
    @State private var store = FaceStore()
    
    var body: some View {
        
        PhotosPicker(selection: $selectedItem) {
            Text("写真追加")
        }
        .onChange(of: selectedItem) {
            Task {
                guard let data = try? await selectedItem?.loadTransferable(type: Data.self) else { return }
                guard let uiImage = UIImage(data: data) else { return }
                
                store.items.append(Face(name: "test", photo: uiImage))
            }
        }
        List {
            ForEach(store.items) { item in
                HStack {
                    Text(item.name)
                    Spacer()
                    if let image = item.photo {
                        Image(uiImage: image)
                            .resizable()
                            .frame(width: 50, height: 50)
                    }
                }
            }
        }
    }
    
}


#Preview {
    ContentView()
}
