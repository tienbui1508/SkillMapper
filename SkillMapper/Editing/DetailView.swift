//
//  DetailView.swift
//  SkillMapper
//
//  Created by Tien Bui on 1/8/2023.
//

import SwiftUI

struct DetailView: View {
    @EnvironmentObject var dataController: DataController

    var body: some View {
        VStack {
            if let skill = dataController.selectedSkill {
                SkillView(skill: skill)
            } else {
                NoSkillView()
            }
        }
        .navigationTitle("Details")
//        .navigationBarTitleDisplayMode(.inline)
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView()
            .environmentObject(DataController.preview)
    }
}
