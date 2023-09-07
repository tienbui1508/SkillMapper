//
//  SkillMapperTests.swift
//  SkillMapperTests
//
//  Created by Tien Bui on 6/9/2023.
//

import CoreData
import XCTest
@testable import SkillMapper

class BaseTestCase: XCTestCase {
    var dataController: DataController!
    var managedObjectContext: NSManagedObjectContext!

    override func setUpWithError() throws {
        dataController = DataController(inMemory: true)
        managedObjectContext = dataController.container.viewContext
    }
}
