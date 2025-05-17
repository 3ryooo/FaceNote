//
//  DetailView.swift
//  FaceNote
//

import SwiftUI

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
    }
}

#Preview {
    DetailView(item: Face(name: "test", photo: UIImage(systemName: "photo")))
}
