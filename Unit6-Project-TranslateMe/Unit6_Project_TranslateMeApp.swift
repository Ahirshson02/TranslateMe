//
//  Unit6_Project_TranslateMeApp.swift
//  Unit6-Project-TranslateMe
//
//  Created by Debbie Hirshson on 3/17/25.
//

import SwiftUI
import FirebaseCore

@main
struct Unit6_Project_TranslateMeApp: App {
    
    init() { // <-- Add an init
        FirebaseApp.configure() // <-- Configure Firebase app
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
