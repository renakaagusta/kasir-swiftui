//
//  KasirApp.swift
//  Kasir
//
//  Created by renaka agusta on 01/04/22.
//

import SwiftUI

@main
struct KasirApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationView{
                ContentView()
            }.navigationViewStyle(StackNavigationViewStyle()).navigationTitle("Kasir")
        }
    }
}
