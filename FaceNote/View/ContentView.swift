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
        
        NavigationStack {
            PhotosPicker(selection: $selectedItem) {
                Text("写真追加")
            }
            .onChange(of: selectedItem) {
                Task {
                    guard let data = try? await selectedItem?.loadTransferable(type: Data.self) else { return }
                    guard let uiImage = UIImage(data: data) else { return }
                    
                    viewModel.store.items.append(Face(name: "test", photo: uiImage))
                    selectedItem = nil
                }
            }
            List {
                ForEach(viewModel.store.items) { item in
                    NavigationLink(value: item) {
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
            .navigationDestination(for: Face.self) { item in
                DetailView(item: item)
            }
            
        }
        
    }
    
}


#Preview {
    
    
    
    ContentView()
}
