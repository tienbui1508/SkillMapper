//
//  ContentView.swift
//  SkillMapper
//
//  Created by Tien Bui on 31/7/2023.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var dataController: DataController

    var body: some View {
        List(selection: $dataController.selectedSkill) {
            ForEach(dataController.skillsForSelectedFilter()) { skill in
                SkillRow(skill: skill)
            }
            .onDelete(perform: delete)
        }
        .navigationTitle("Skills")
        .searchable(
            text: $dataController.filterText,
            tokens: $dataController.filterTokens,
            suggestedTokens: .constant(dataController.suggestedFilterTokens),
            prompt: "Filter skills, or type # to add tags") { tag in
                Text(tag.tagName)
                }
        .toolbar(content: ContentViewToolbar.init)
    }

    func delete(_ offsets: IndexSet) {
        let skills = dataController.skillsForSelectedFilter()

        for offset in offsets {
            let item = skills[offset]
            dataController.delete(item)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(DataController.preview)
    }
}
