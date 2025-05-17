//
//  Face.swift
//  FaceNote
//

import Foundation
import PhotosUI

struct Face: Identifiable, Codable, Comparable, Hashable {
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
    
    static func<(lhs: Face, rhs: Face) -> Bool {
        lhs.name < rhs.name
    }
    
}
