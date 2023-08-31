//
//  Skill-CoreDataHelpers.swift
//  SkillMapper
//
//  Created by Tien Bui on 1/8/2023.
//

import Foundation

extension Skill {
    var skillTitle: String {
        get { title ?? "" }
        set { title = newValue }
    }

    var skillContent: String {
        get { content ?? "" }
        set { content = newValue }
    }

    var skillCreationDate: Date {
        creationDate ?? .now
    }

    var skillModificationDate: Date {
        modificationDate ?? .now
    }
    
    var skillTags: [Tag] {
        let result = tags?.allObjects as? [Tag] ?? []
        return result.sorted()
    }
    
    var skillStatus: String {
        if completed {
            return "Learned"
        } else {
            return "Learning"
        }
    }
    
    var skillTagsList: String {
        guard let tags else { return "No tags" }

        if tags.count == 0 {
            return "No tags"
        } else {
            return skillTags.map(\.tagName).formatted()
        }
    }
    
    static var example: Skill {
        let controller = DataController(inMemory: true)
        let viewContext = controller.container.viewContext

        let skill = Skill(context: viewContext)
        skill.title = "Example Skill"
        skill.content = "This is an example skill."
        skill.difficulty = 2
        skill.creationDate = .now
        return skill
    }
}

extension Skill: Comparable {
    public static func <(lhs: Skill, rhs: Skill) -> Bool {
        let left = lhs.skillTitle.localizedLowercase
        let right = rhs.skillTitle.localizedLowercase

        if left == right {
            return lhs.skillCreationDate < rhs.skillCreationDate
        } else {
            return left < right
        }
    }
}
