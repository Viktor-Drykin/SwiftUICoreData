//
//  SwiftUICoreDataApp.swift
//  SwiftUICoreData
//
//  Created by DataArt Viktor Drykin on 02.08.2024.
//

import SwiftUI

@main
struct SwiftUICoreDataApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
