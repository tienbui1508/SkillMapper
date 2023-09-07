//
//  DevelopmentTests.swift
//  SkillMapperTests
//
//  Created by Tien Bui on 7/9/2023.
//

import CoreData
import XCTest
@testable import SkillMapper

final class DevelopmentTests: BaseTestCase {

    func testSampleDataCreationWorks() {
        dataController.createSampleData()

        XCTAssertEqual(dataController.count(for: Tag.fetchRequest()), 5, "There should be 5 sample tags.")
        XCTAssertEqual(dataController.count(for: Skill.fetchRequest()), 50, "There should be 50 sample skills.")
    }

    func testDeleteAllClearsEverything() {
        dataController.createSampleData()
        dataController.deleteAll()

        XCTAssertEqual(dataController.count(for: Tag.fetchRequest()), 0, "deleteAll() should leave 0 sample tags.")
        XCTAssertEqual(dataController.count(for: Skill.fetchRequest()), 0, "deleteAll() should leave 0 sample skills.")
    }

    func testExampleTagHasNoSkills() {
        let tag = Tag.example
        XCTAssertEqual(tag.skills?.count, 0, "The example tag should have 0 skills.")
    }

    func testExampleSkillIsHardDifficulty() {
        let skill = Skill.example
        XCTAssertEqual(skill.difficulty, 2, "The example skill should be hard difficulty.")

    }
}
