//
//  SkillRow.swift
//  SkillMapper
//
//  Created by Tien Bui on 2/8/2023.
//

import SwiftUI

struct SkillRow: View {
    @EnvironmentObject var dataController: DataController
    @ObservedObject var skill: Skill
    
    var body: some View {
        NavigationLink(value: skill) {
            HStack {
                Image(systemName: "exclamationmark.circle")
                    .imageScale(.large)
                    .opacity(skill.difficulty == 2 ? 1 : 0)

                VStack(alignment: .leading) {
                    Text(skill.skillTitle)
                        .font(.headline)
                        .lineLimit(1)

                    Text("No tags")
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }

                Spacer()

                VStack(alignment: .trailing) {
                    Text(skill.skillCreationDate.formatted(date: .numeric, time: .omitted))
                        .font(.subheadline)

                    if skill.completed {
                        Text("LEARNED")
                            .font(.body.smallCaps())
                    }
                }
                .foregroundStyle(.secondary)
            }
        }
    }
}

struct SkillRow_Previews: PreviewProvider {
    static var previews: some View {
        SkillRow(skill: Skill.example)
            .environmentObject(DataController.preview)
    }
}
