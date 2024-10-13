//
//  grailed_widgetsApp.swift
//  grailed-widgets
//
//  Created by Arron Stothart on 13/10/2024.
//

import SwiftUI

@main
struct grailed_widgetsApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
