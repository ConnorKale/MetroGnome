//
//  Settings.swift
//  MetroGnome
//
//  Created by Connor Kale on 5/23/26.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("HelloWorldBool") private var HelloWorldBool = true
    @AppStorage("ShowMiles") private var ShowMiles = true
    @AppStorage("ShowKilometers") private var ShowKilometers = true
    @AppStorage("SongIndexMethod") private var SongIndexMethod = 1
    // Show miles for pacing
    // Show kilometers for pacing
    // Show m/s
    var body: some View {
        ScrollView {
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            //Toggle("String", isOn: $BooleanVariable)
            Toggle("Turn this slider on or off", isOn: $HelloWorldBool)
            Toggle("Show miles", isOn: $ShowMiles)
            Toggle("Show km", isOn: $ShowKilometers)
            Menu {
                Button("As uploaded", action: { SongIndexMethod = 1 })
                Button("Sorted", action: { SongIndexMethod = 2 })
            } label: {
                Label("Which song indexing method", systemImage: "chevron.down")
                    .padding()
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(8)
            }
        }
    }

    }


#Preview {
    Settings()
}
