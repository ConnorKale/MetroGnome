//
//  Playlist.swift
//  MetroGnome
//
//  Created by Connor Kale on 10/26/25.
//

import SwiftUI

struct DescriptionTab: View {
    
    var body: some View {
        ScrollView {
            VStack {
                Text("Hello world!")
                    .font(.title2)
                    .padding(.bottom, 50)
                
                Text("Eventually I'll write up a description of how all the stuff works")
                    .padding(.bottom, 50)
            }
        }
        .padding(20) // This is for the edge margins
        .preferredColorScheme(.dark)
    }
}


#Preview {
    DescriptionTab()
}
