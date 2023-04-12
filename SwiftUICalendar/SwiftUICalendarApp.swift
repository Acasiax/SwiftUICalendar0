//
//  SwiftUICalendarApp.swift
//  SwiftUICalendar
//
//  Created by 이윤지 on 2023/04/12.
//

import SwiftUI

@main
struct SwiftUICalendarApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
