//
//  TagTests.swift
//  SkillMapperTests
//
//  Created by Tien Bui on 6/9/2023.
//

import CoreData
import XCTest
@testable import SkillMapper

final class TagTests: BaseTestCase {
    func testCreatingTagsAndSkills() {
        let targetCount = 10
        let skillCount = 10 * 10

        for _ in 0..<targetCount {
            let tag = Tag(context: managedObjectContext)

            for _ in 0..<targetCount {
                let skill = Skill(context: managedObjectContext)
                tag.addToSkills(skill)
            }
        }

        XCTAssertEqual(dataController.count(for: Tag.fetchRequest()), targetCount, "Expected \(targetCount) tags.")
        XCTAssertEqual(dataController.count(for: Skill.fetchRequest()), skillCount, "Expected \(skillCount) issues.")
    }

    func testDeletingTagDoesNotDeleteSkills() throws {
        dataController.createSampleData()

        let request = NSFetchRequest<Tag>(entityName: "Tag")
        let tags = try managedObjectContext.fetch(request)

        dataController.delete(tags[0])

        XCTAssertEqual(dataController.count(for: Tag.fetchRequest()), 4, "Expected 4 tags after deleting 1.")
        XCTAssertEqual(dataController.count(for: Skill.fetchRequest()), 50, "Expected 50 skills after deleting a tag.")

    }
}
