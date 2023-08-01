//
//  SkillMapperApp.swift
//  SkillMapper
//
//  Created by Tien Bui on 31/7/2023.
//

import SwiftUI

@main
struct SkillMapperApp: App {
    @StateObject var dataController = DataController()
    
    var body: some Scene {
        WindowGroup {
            NavigationSplitView {
                SidebarView()
            } content: {
                ContentView()
            } detail: {
                DetailView()
            }
            .environment(\.managedObjectContext, dataController.container.viewContext)
            .environmentObject(dataController)
        }
    }
}
