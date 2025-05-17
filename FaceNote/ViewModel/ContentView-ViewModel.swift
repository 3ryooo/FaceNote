//
//  ContentView-ViewModel.swift
//  FaceNote
//

import Foundation
import PhotosUI

extension ContentView {
    @Observable
    class ViewModel {
        
        var store = FaceStore()
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
            try data.write(to: saveURL, options: [.atomic, .completeFileProtection])
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
