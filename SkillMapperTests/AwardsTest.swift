//
//  AwardsTest.swift
//  SkillMapperTests
//
//  Created by Tien Bui on 7/9/2023.
//

import CoreData
import XCTest
@testable import SkillMapper

final class AwardsTest: BaseTestCase {
    let awards = Award.allAwards

    func testAwardIDMatchesName() {
        for award in awards {
            XCTAssertEqual(award.id, award.name, "Award ID should always match its name.")
        }
    }

    func testNewUserHasUnlockedNoAwards() {
        for award in awards {
            XCTAssertFalse(dataController.hasEarned(award: award), "New users should have no earned awards")
        }
    }

    func testCreatingSkillUnlocksAwards() {
        let values = [1, 10, 20, 50, 100, 250, 500, 1000]

        for (count, value) in values.enumerated() {
            var skills = [Skill]()

            for _ in 0..<value {
                let skill = Skill(context: managedObjectContext)
                skills.append(skill)
            }

            let matches = awards.filter { award in
                award.criterion == "skills" && dataController.hasEarned(award: award)
            }

            XCTAssertEqual(matches.count, count + 1, "Adding \(value) skills should unlock \(count + 1) awards.")
            dataController.deleteAll()
        }
    }

    func testCompletingSkillUnlocksAwards() {
        let values = [1, 10, 20, 50, 100, 250, 500, 1000]

        for (count, value) in values.enumerated() {
            var skills = [Skill]()

            for _ in 0..<value {
                let skill = Skill(context: managedObjectContext)
                skill.completed = true
                skills.append(skill)
            }

            let matches = awards.filter { award in
                award.criterion == "learned" && dataController.hasEarned(award: award)
            }

            XCTAssertEqual(matches.count, count + 1, "Learned \(value) skills should unlock \(count + 1) awards.")
            dataController.deleteAll()
        }
    }
}
