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
    
    @Environment(\.scenePhase) var scenePhase

    
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
            // trigger  a save for any kind of phase change that isn’t the app moving back to being active
            .onChange(of: scenePhase) { phase in
                if phase != .active {
                    dataController.save()
                }
            }
        }
    }
}
