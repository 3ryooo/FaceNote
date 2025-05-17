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
    @State private var nameAlert = false
    @State private var tempName = ""
    @State private var tempImage: UIImage? = nil
    
    
    var body: some View {
        
        NavigationStack {
            PhotosPicker(selection: $selectedItem) {
                Text("写真追加")
            }
            .onChange(of: selectedItem) {
                Task {
                    guard let data = try? await selectedItem?.loadTransferable(type: Data.self) else { return }
                    guard let uiImage = UIImage(data: data) else { return }
                    
                    tempImage = uiImage
                    
                    nameAlert = true
                    
                }
            }
            .alert("名前を入力", isPresented: $nameAlert) {
                TextField("名前", text: $tempName)
                Button("保存") {
                    nameAlert = false
                    
                    if let image = tempImage {
                        viewModel.store.items.append(Face(name: tempName, photo: image))
                    }
                    
                    tempImage = nil
                    tempName = ""
                    selectedItem = nil
                }
                Button("キャンセル", role: .cancel) {
                    tempImage = nil
                    tempName = ""
                    selectedItem = nil
                }
            }
            List {
                ForEach(viewModel.store.items.sorted()) { item in
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
