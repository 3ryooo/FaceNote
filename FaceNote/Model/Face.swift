//
//  Face.swift
//  FaceNote
//

import Foundation
import PhotosUI

struct Face: Identifiable, Codable, Comparable, Hashable, Equatable {
    var id = UUID()
    let name: String
    let photoData: Data?
    var coordinate: CLLocationCoordinate2D?
    
    enum CodingKeys: String, CodingKey {
        case id, name, photoData, latitude, longitude
    }
    
    init(id: UUID = UUID(), name: String, photo: UIImage?, coordinate: CLLocationCoordinate2D?) {
        self.id = id
        self.name = name
        self.photoData = photo?.jpegData(compressionQuality: 0.8)
        self.coordinate = coordinate
    }
    
    var photo: UIImage? {
        guard let photoData else { return nil }
        return UIImage(data: photoData)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(photoData, forKey: .photoData)
        try container.encode(coordinate?.latitude, forKey: .latitude)
        try container.encode(coordinate?.longitude, forKey: .longitude)
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        photoData = try container.decode(Data.self, forKey: .photoData)
        if let latitude = try container.decodeIfPresent(Double.self, forKey: .id) {
            if let longitude = try container.decodeIfPresent(Double.self, forKey: .id) {
                coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            }
        }
    }
    
    static func<(lhs: Face, rhs: Face) -> Bool {
        lhs.name < rhs.name
    }
    
    static func == (lhs: Face, rhs: Face) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    
}
