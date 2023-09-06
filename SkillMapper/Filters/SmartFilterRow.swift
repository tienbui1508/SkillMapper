//
//  SmartFilterRow.swift
//  SkillMapper
//
//  Created by Tien Bui on 5/9/2023.
//

import SwiftUI

struct SmartFilterRow: View {
    var filter: Filter
    var body: some View {
        NavigationLink(value: filter) {
            Label(filter.name, systemImage: filter.icon)
        }
    }
}

struct SmartFilterView_Previews: PreviewProvider {
    static var previews: some View {
        SmartFilterRow(filter: .all)
    }
}
