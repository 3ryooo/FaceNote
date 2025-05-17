//
//  DetailView.swift
//  FaceNote
//

import SwiftUI
import MapKit

struct DetailView: View {
    
    let item: Face
    
    var body: some View {
        Text(item.name)
            .font(.title.weight(.heavy))
        if let image = item.photo {
            Image(uiImage: image)
                .resizable()
                .scaledToFit()
        }
        Map {
            if let location = item.coordinate {
                Marker("Spot", coordinate: location)
            }
        }
    }
}

#Preview {
    DetailView(item: Face(name: "test", photo: UIImage(systemName: "photo"), coordinate: nil))
}
