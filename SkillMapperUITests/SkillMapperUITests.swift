//
//  SkillMapperUITests.swift
//  SkillMapperUITests
//
//  Created by Tien Bui on 8/9/2023.
//

import XCTest

extension XCUIElement {
    func clear() {
        guard let stringValue = self.value as? String else {
            XCTFail("Failed to clear text in XCUIElement.")
            return
        }

        let deleteString = String(repeating: XCUIKeyboardKey.delete.rawValue, count: stringValue.count)
        typeText(deleteString)
    }
}

final class SkillMapperUITests: XCTestCase {
    var app: XCUIApplication!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test.
        app = XCUIApplication()
        app.launchArguments = ["enable-testing"]
        app.launch()
    }

    func testAppStartsWithNavigationBar() throws {

        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssertTrue(app.navigationBars.element.exists, "There should be a navigation bar when the app launches.")
    }

    func testAppHasBasicButtonsOnLaunch() throws {
        XCTAssertTrue(app.navigationBars.buttons["Filters"].exists, "There should be a Filters button launch.")
        XCTAssertTrue(app.navigationBars.buttons["Filter"].exists, "There should be a Filter button launch.")
        XCTAssertTrue(app.navigationBars.buttons["New Skill"].exists, "There should be a New skill button launch.")
    }

    func testNoSkillsAtStart() {
        XCTAssertEqual(app.cells.count, 0, "There should be no list rows initially.")
    }

    func testCreatingAndDeletingSkills() {
        for tapCount in 1...5 {
            app.buttons["New Skill"].tap()
            app.buttons["Skills"].tap()

            XCTAssertEqual(app.cells.count, tapCount, "There should be \(tapCount) rows in the list.")
        }

        for tapCount in (0...4).reversed() {
            app.cells.firstMatch.swipeLeft()
            app.buttons["Delete"].tap()

            XCTAssertEqual(app.cells.count, tapCount, "There should be \(tapCount) rows in the list.")
        }
    }

    func testEditingSkillTitleUpdatesCorrectly() {
        XCTAssertEqual(app.cells.count, 0, "There should be no list rows initially.")

        app.buttons["New Skill"].tap()

        app.textFields["Enter the skill title here"].tap()
        app.textFields["Enter the skill title here"].clear()
        app.typeText("My New Skill")

        app.buttons["Skills"].tap()
        XCTAssertTrue(app.buttons["My New Skill"].exists, "A My New Skill cell should now exist.")
    }

    func testEditingSkillDifficultyShowsIcon() {
        app.buttons["New Skill"].tap()
        app.buttons["Difficulty, Medium"].tap()
        app.buttons["Hard"].tap()

        app.buttons["Skills"].tap()

        let identifier = "New skill Hard Difficulty"
        XCTAssert(app.images[identifier].exists, "A hard-difficulty skill needs an icon next to it.")
    }

    func testAllAwardsShowLockedAlert() {
        app.buttons["Filters"].tap()
        app.buttons["Show awards"].tap()

        for award in app.scrollViews.buttons.allElementsBoundByIndex {
            if app.windows.element.frame.contains(award.frame) == false {
                app.swipeUp()
            }

            award.tap()
            XCTAssertTrue(app.alerts["Locked"].exists, "There should be a Locked alert showing for awards.")
            app.buttons["OK"].tap()
        }
    }
}
