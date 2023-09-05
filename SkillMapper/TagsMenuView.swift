//
//  TagsMenuView.swift
//  SkillMapper
//
//  Created by Tien Bui on 5/9/2023.
//

import SwiftUI

struct TagsMenuView: View {
    @EnvironmentObject var dataController: DataController
    @ObservedObject var skill: Skill

    var body: some View {
        Menu {
            // show selected tags first
            ForEach(skill.skillTags) { tag in
                Button {
                    skill.removeFromTags(tag)
                } label: {
                    Label(tag.tagName, systemImage: "checkmark")
                }
            }

            // now show unselected tags
            let otherTags = dataController.missingTags(from: skill)

            if otherTags.isEmpty == false {
                Divider()

                Section("Add Tags") {
                    ForEach(otherTags) { tag in
                        Button(tag.tagName) {
                            skill.addToTags(tag)
                        }
                    }
                }
            }
        } label: {
            Text(skill.skillTagsList)
                .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .animation(nil, value: skill.skillTagsList)
        }
    }
}

struct TagsMenuView_Previews: PreviewProvider {
    static var previews: some View {
        TagsMenuView(skill: .example)
            .environmentObject(DataController(inMemory: true))
    }
}
