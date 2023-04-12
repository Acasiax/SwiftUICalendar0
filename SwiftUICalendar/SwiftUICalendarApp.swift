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
            TabView{
                CalendarView()
                    .tabItem{Label("Calendar", systemImage: "calendar")}
                StreakView()
                    .tabItem{Label("Streak", systemImage: "swift")}
            }
           
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
