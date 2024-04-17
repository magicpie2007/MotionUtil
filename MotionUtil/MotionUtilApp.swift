//
//  MotionUtilApp.swift
//  MotionUtil
//
//  Created by hiroyuki shoji on 2024/04/15.
//

import SwiftUI
import SwiftData

@main
struct MotionUtilApp: App {
    /*
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
     */

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        //.modelContainer(sharedModelContainer)
    }
}
