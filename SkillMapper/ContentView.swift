//
//  ContentView.swift
//  SkillMapper
//
//  Created by Tien Bui on 31/7/2023.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var dataController: DataController
    
    var skills: [Skill] {
        let filter = dataController.selectedFilter ?? .all
        var allSkills: [Skill]

        if let tag = filter.tag {
            allSkills = tag.skills?.allObjects as? [Skill] ?? []
        } else {
            let request = Skill.fetchRequest()
            request.predicate = NSPredicate(format: "modificationDate > %@", filter.minModificationDate as NSDate)
            allSkills = (try? dataController.container.viewContext.fetch(request)) ?? []
        }

        return allSkills.sorted()
    }
    
    var body: some View {
        List {
            ForEach(skills) { skill in
                SkillRow(skill: skill)
            }
            .onDelete(perform: delete)
        }
        .navigationTitle("Skills")
    }
    
    func delete(_ offsets: IndexSet) {
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
