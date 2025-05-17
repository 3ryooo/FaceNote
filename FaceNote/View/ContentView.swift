//
//  ContentView.swift
//  FaceNote
//

import SwiftUI

import PhotosUI
import SwiftUI

struct ContentView: View {
    
    @State private var viewModel = ViewModel()
    @State private var selectedItem: PhotosPickerItem?

    
    var body: some View {
        
        PhotosPicker(selection: $selectedItem) {
            Text("写真追加")
        }
        .onChange(of: selectedItem) {
            Task {
                guard let data = try? await selectedItem?.loadTransferable(type: Data.self) else { return }
                guard let uiImage = UIImage(data: data) else { return }
                
                viewModel.store.items.append(Face(name: "test", photo: uiImage))
            }
        }
        List {
            ForEach(viewModel.store.items) { item in
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
