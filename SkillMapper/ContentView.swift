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
        .searchable(text: $dataController.filterText, tokens: $dataController.filterTokens, suggestedTokens: .constant(dataController.suggestedFilterTokens), prompt: "Filter skills, or type # to add tags") { tag in
            Text(tag.tagName)
        }
        .toolbar {
            Menu {
                Button(dataController.filterEnabled ? "Turn Filter Off" : "Turn Filter On") {
                    dataController.filterEnabled.toggle()
                }
                
                Divider()
                
                Menu("Sort By") {
                    Picker("Sort By", selection: $dataController.sortType)  {
                        Text("Date Created").tag(SortType.dateCreated)
                        Text("Date Modified").tag(SortType.dateModified)
                    }
                    
                    Divider()
                    
                    Picker("Sort Order", selection: $dataController.sortNewestFirst)  {
                        Text("Newest to Oldest").tag(true)
                        Text("Oldest to Newest").tag(false)
                    }
                }
                
                Picker("Status", selection: $dataController.filterStatus) {
                    Text("All").tag(Status.all)
                    Text("Learning").tag(Status.learning)
                    Text("Learned").tag(Status.learned)
                }
                .disabled(dataController.filterEnabled == false)
                
                Picker("Difficulty", selection: $dataController.filterDifficulty) {
                    Text("All").tag(-1)
                    Text("Easy").tag(0)
                    Text("Medium").tag(1)
                    Text("Hard").tag(2)
                }
                .disabled(dataController.filterEnabled == false)
                
            } label: {
                Label("Filter", systemImage: "line.3.horizontal.decrease.circle")
                    .symbolVariant(dataController.filterEnabled ? .fill : .none)
            }
            
            Button(action: dataController.newSkill) {
                Label("New skill", systemImage: "square.and.pencil")
            }
        }
        
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
