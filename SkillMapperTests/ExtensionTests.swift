//
//  ExtensionTests.swift
//  SkillMapperTests
//
//  Created by Tien Bui on 7/9/2023.
//

import CoreData
import XCTest
@testable import SkillMapper

final class ExtensionTests: BaseTestCase {

    func testSkillTitleUnwrap() {
        // Given
        let skill = Skill(context: managedObjectContext)

        // When
        skill.title = "Example skill"
        // Then
        XCTAssertEqual(skill.skillTitle, "Example skill", "Changing skill should also change skillTitle.")

        // When
        skill.skillTitle = "Updated skill"
        // Then
        XCTAssertEqual(skill.title, "Updated skill", "Changing skillTitle should also change title.")
    }

    func testSkillContentUnwrap() {
        // Given
        let skill = Skill(context: managedObjectContext)

        // When
        skill.content = "Example skill"
        // Then
        XCTAssertEqual(skill.skillContent, "Example skill", "Changing skill should also change skillContent.")

        // When
        skill.skillContent = "Updated skill"
        // Then
        XCTAssertEqual(skill.content, "Updated skill", "Changing skillContent should also change content.")
    }

    func testSkillCreationDateUnwrap() {
        // Given
        let skill = Skill(context: managedObjectContext)
        let testDate = Date.now

        // When
        skill.creationDate = testDate

        // Then
        XCTAssertEqual(skill.skillCreationDate, testDate, "Changing creationDate should also change skillCreationDate.")

    }

    func testSkillTagsUnwrap() {
        // Given
        let tag = Tag(context: managedObjectContext)
        let skill = Skill(context: managedObjectContext)

        // Assert
        XCTAssertEqual(skill.skillTags.count, 0, "A new skill should have no tags.")

        // When
        skill.addToTags(tag)
        // Then
        XCTAssertEqual(skill.skillTags.count, 1, "Adding 1 tag to an skill should result in skillTags having count 1.")
    }

    func testSkillTagsList() {
        // Given
        let tag = Tag(context: managedObjectContext)
        let skill = Skill(context: managedObjectContext)

        // When
        tag.name = "My Tag"
        skill.addToTags(tag)

        // Then
        XCTAssertEqual(skill.skillTagsList, "My Tag", "Adding 1 tag to an skill should make skillTagsList be My Tag.")
    }

    func testSkillSortingIsStable() {
        // Given
        let skill1 = Skill(context: managedObjectContext)
        skill1.title = "B Skill"
        skill1.creationDate = .now

        let skill2 = Skill(context: managedObjectContext)
        skill2.title = "B Skill"
        skill2.creationDate = .now.addingTimeInterval(1)

        let skill3 = Skill(context: managedObjectContext)
        skill3.title = "A Skill"
        skill3.creationDate = .now.addingTimeInterval(100)

        let allSkills = [skill1, skill2, skill3]
        let sorted = allSkills.sorted()

        // Assert
        XCTAssertEqual([skill3, skill1, skill2], sorted, "Sorting skill arrays should use name then creation date.")
    }

    func testTagIDUnwrap() {
        // Given
        let tag = Tag(context: managedObjectContext)

        // When
        tag.id = UUID()
        // Then
        XCTAssertEqual(tag.tagID, tag.id, "Changing id should also change tagID.")
    }

    func testTagNameUnwrap() {
        // Given
        let tag = Tag(context: managedObjectContext)

        // When
        tag.name = "Example tag"
        // Then
        XCTAssertEqual(tag.tagName, "Example tag", "Changing name should also change tagName.")
    }

    func testTagActiveSkills() {
        // Given
        let tag = Tag(context: managedObjectContext)
        let skill = Skill(context: managedObjectContext)

        // Assert
        XCTAssertEqual(tag.tagActiveSkills.count, 0, "A new tag should have 0 active skills.")

        // When
        tag.addToSkills(skill)
        // Then
        XCTAssertEqual(tag.tagActiveSkills.count, 1, "A new tag with 1 new skill should have 1 active skill.")

        // When
        skill.completed = true
        // Then
        XCTAssertEqual(tag.tagActiveSkills.count, 0, "A new tag with 1 completed skill should have 0 active skills.")
    }

    func testTagSortingIsStable() {
        // Given
        let tag1 = Tag(context: managedObjectContext)
        tag1.name = "B Tag"
        tag1.id = UUID()

        let tag2 = Tag(context: managedObjectContext)
        tag2.name = "B Tag"
        tag2.id = UUID(uuidString: "FFFFFFFF-FFFF-4463-8C69-7275D037C13D")

        let tag3 = Tag(context: managedObjectContext)
        tag3.name = "A Tag"
        tag3.id = UUID()

        let allTags = [tag1, tag2, tag3]
        let sortedTags = allTags.sorted()

        // Assert
        XCTAssertEqual([tag3, tag1, tag2], sortedTags, "Sorting tag arrays should use name then UUID string.")
    }

    func testBundleDecodingAwards() {
        // Given
        let awards = Bundle.main.decode("Awards.json", as: [Award].self)

        // Assert
        XCTAssertFalse(awards.isEmpty, "Awards.json should decode to a non-empty array.")
    }

    func testDecodingString() {
        // Given
        let bundle = Bundle(for: ExtensionTests.self)
        let data = bundle.decode("DecodableString.json", as: String.self)

        // Assert
        XCTAssertEqual(data, "Never ask a starfish for directions.", "The string must match DecodableString.json.")
    }

    func testDecodingDictionary() {
        // Given
        let bundle = Bundle(for: ExtensionTests.self)
        let data = bundle.decode("DecodableDictionary.json", as: [String: Int].self)

        // Assert
        XCTAssertEqual(data.count, 3, "There should be three items decoded from DecodableDictionary.json.")
        XCTAssertEqual(data["One"], 1, "The dictionary should contain the value 1 for the key One.")
    }
}
