//
//  NoSkillView.swift
//  SkillMapper
//
//  Created by Tien Bui on 2/8/2023.
//

import SwiftUI

struct NoSkillView: View {
    @EnvironmentObject var dataController: DataController

    var body: some View {
        Text("No Skill Selected")
            .font(.title)
            .foregroundStyle(.secondary)

        Button("New skill", action: dataController.newSkill)
    }
}

struct NoSkillView_Previews: PreviewProvider {
    static var previews: some View {
        NoSkillView()
    }
}
