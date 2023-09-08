//
//  SkillViewToolbar.swift
//  SkillMapper
//
//  Created by Tien Bui on 5/9/2023.
//

import SwiftUI

struct SkillViewToolbar: View {
    @EnvironmentObject var dataController: DataController
    @ObservedObject var skill: Skill

    var body: some View {
        Menu {
            Button {
                // ⚠️ this button won't work on macOS at the moment and would be updated later
                #if os(iOS)
                UIPasteboard.general.string = skill.title
                #endif
            } label: {
                Label("Copy Skill Title", systemImage: "doc.on.doc")
            }

            Button {
                skill.completed.toggle()
                dataController.save()
            } label: {
                Label(skill.completed ? "Re-learn Skill" : "Learned Skill", systemImage: "brain.head.profile")
            }

            Divider()

            Section("Tags") {
                TagsMenuView(skill: skill)
            }
        } label: {
            Label("Action", systemImage: "ellipsis.circle")
        }
    }
}

struct SkillViewToolbar_Previews: PreviewProvider {
    static var previews: some View {
        SkillViewToolbar(skill: Skill.example)
            .environmentObject(DataController(inMemory: true))
    }
}
