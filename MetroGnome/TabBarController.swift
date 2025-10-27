//
//  TabBarController.swift
//  MetroGnome
//
//  Created by Connor Kale on 10/26/25.
//

import SwiftUI

struct TabBarController: View {
    
    
    var body: some View {
        TabView {
            RunningStats()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }

            ButtonsView()
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }

            Playlist()
                .tabItem {
                    Label("Profile", systemImage: "person.crop.circle")
                }
        }
    }
}


#Preview {
    TabBarController()
}
