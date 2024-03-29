//
//  SkillView.swift
//  SkillMapper
//
//  Created by Tien Bui on 2/8/2023.
//

import SwiftUI

struct SkillView: View {
    @EnvironmentObject var dataController: DataController
    @ObservedObject var skill: Skill

    var body: some View {
        Form {
            Section {
                VStack(alignment: .leading) {
                    TextField("Title", text: $skill.skillTitle, prompt: Text("Enter the skill title here"))
                        .font(.title)

                    Text("**Modified:** \(skill.skillModificationDate.formatted(date: .long, time: .shortened))")
                        .foregroundStyle(.secondary)

                    Text("**Status:** \(skill.skillStatus)")
                        .foregroundStyle(.secondary)

                }

                Picker("Difficulty", selection: $skill.difficulty) {
                    Text("Easy").tag(Int16(0))
                    Text("Medium").tag(Int16(1))
                    Text("Hard").tag(Int16(2))
                }

                TagsMenuView(skill: skill)
            }

            Section {
                VStack(alignment: .leading) {
                    Text("Basic Information")
                        .font(.title2)
                        .foregroundStyle(.secondary)

                    TextField(
                        "Description",
                        text: $skill.skillContent,
                        prompt: Text("Enter the skill description here"),
                        axis: .vertical)
                }
            }
        }
        .disabled(skill.isDeleted)
        .onReceive(skill.objectWillChange) { _ in
            dataController.queueSave()
        }
        .onSubmit(dataController.save)
        .toolbar {
            SkillViewToolbar(skill: skill)
        }
    }
}

struct SkillView_Previews: PreviewProvider {
    static var previews: some View {
        SkillView(skill: .example)
            .environmentObject(DataController(inMemory: true))
    }
}
