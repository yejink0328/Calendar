//
//  CalendarApp.swift
//  Calendar
//
//  Created by MAX on 2023/07/14.
//

import SwiftUI

@main
struct CalendarApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(month: Date())
        }
    }
}
