//
//  Filter.swift
//  SkillMapper
//
//  Created by Tien Bui on 1/8/2023.
//

import Foundation

struct Filter: Identifiable, Hashable {
    var id: UUID
    var name: String
    var icon: String
    var minModificationDate = Date.distantPast
    var tag: Tag?
    
    var activeSkillCount: Int {
        tag?.tagActiveSkills.count ?? 0
    }
    
    static var all = Filter(id: UUID(), name: "All Skills", icon: "tray.2")
    static var recent = Filter(id: UUID(), name: "Recent Skills", icon: "clock", minModificationDate: .now.addingTimeInterval(86400 * -7))
    
    // only hash id
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    // only compare id
    static func ==(lhs: Filter, rhs: Filter) -> Bool {
        lhs.id == rhs.id
    }
}
