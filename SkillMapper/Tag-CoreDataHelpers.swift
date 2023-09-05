//
//  Tag-CoreDataHelpers.swift
//  SkillMapper
//
//  Created by Tien Bui on 1/8/2023.
//

import Foundation

extension Tag {
    var tagID: UUID {
        id ?? UUID()
    }

    var tagName: String {
        name ?? ""
    }

    var tagActiveSkills: [Skill] {
        let result = skills?.allObjects as? [Skill] ?? []
        return result.filter { $0.completed == false }
    }

    static var example: Tag {
        let controller = DataController(inMemory: true)
        let viewContext = controller.container.viewContext

        let tag = Tag(context: viewContext)
        tag.id = UUID()
        tag.name = "Example Tag"
        return tag
    }
}

extension Tag: Comparable {
    public static func <(lhs: Tag, rhs: Tag) -> Bool {
        let left = lhs.tagName.localizedLowercase
        let right = rhs.tagName.localizedLowercase

        if left == right {
            return lhs.tagID.uuidString < rhs.tagID.uuidString
        } else {
            return left < right
        }
    }
}
