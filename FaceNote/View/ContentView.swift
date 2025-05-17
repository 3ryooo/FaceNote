//
//  ContentView.swift
//  FaceNote
//

import SwiftUI

import PhotosUI
import SwiftUI

struct Face: Identifiable, Hashable {
    var id = UUID()
    let name: String
    let photo: UIImage?
}

@Observable
class FaceStore {
    var items: [Face] = []
}

struct ContentView: View {
    @State private var selectedItem: PhotosPickerItem?
    @State private var store = FaceStore()
    
    var body: some View {
        
        PhotosPicker(selection: $selectedItem) {
            Text("フォトピッカーを表示")
        }
        .onChange(of: selectedItem) {
            Task {
                guard let data = try? await selectedItem?.loadTransferable(type: Data.self) else { return }
                guard let uiImage = UIImage(data: data) else { return }
                
                store.items.append(Face(name: "test", photo: uiImage))
                
                print(store.items)
            }
        }
        List {
            ForEach(store.items, id: \.self) { item in
                Text(item.name)
            }
        }
    }
}



#Preview {
    
    ContentView()
}
