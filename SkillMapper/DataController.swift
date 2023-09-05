//
//  DataController.swift
//  SkillMapper
//
//  Created by Tien Bui on 31/7/2023.
//

import CoreData

// swiftlint:disable line_length

enum SortType: String {
    case dateCreated = "creationDate"
    case dateModified = "modificationDate"
}

enum Status {
    case all, learning, learned
}

class DataController: ObservableObject {
    let container: NSPersistentCloudKitContainer

    @Published var selectedFilter: Filter? = Filter.all
    @Published var selectedSkill: Skill?

    @Published var filterText = ""
    @Published var filterTokens = [Tag]()

    @Published var filterEnabled = false
    @Published var filterDifficulty = -1
    @Published var filterStatus = Status.all
    @Published var sortType = SortType.dateCreated
    @Published var sortNewestFirst = true

    private var saveTask: Task<Void, Error>?

    static var preview: DataController = {
        let dataController = DataController(inMemory: true)
        dataController.createSampleData()
        return dataController
    }()

    var suggestedFilterTokens: [Tag] {
        guard filterText.starts(with: "#") else {
            return []
        }

        let trimmedFilterText = String(filterText.dropFirst()).trimmingCharacters(in: .whitespaces)
        let request = Tag.fetchRequest()

        if trimmedFilterText.isEmpty == false {
            request.predicate = NSPredicate(format: "name CONTAINS[c] %@", trimmedFilterText)
        }

        return (try? container.viewContext.fetch(request).sorted()) ?? []
    }

    init(inMemory: Bool = false) {
        container = NSPersistentCloudKitContainer(name: "Main")

        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(filePath: "/dev/null")
        }

        // Merge changes
        // Automatically apply to our view context any changes that happen to the underlying persistent store, so the two stay in sync.
        container.viewContext.automaticallyMergesChangesFromParent = true
        // If we changed the same property on two different devices, we want Core Data to compare each property individually, but if there’s a conflict it should prefer what is currently in memory.
        container.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump

        // Watching for external changes
        // tells Core Data we want to be notified when the store has changed
        container.persistentStoreDescriptions.first?.setOption(true as NSNumber, forKey: NSPersistentStoreRemoteChangeNotificationPostOptionKey)
        // tells the system to call our new remoteStoreChanged() method whenever a change happens
        NotificationCenter.default.addObserver(forName: .NSPersistentStoreRemoteChange, object: container.persistentStoreCoordinator, queue: .main, using: remoteStoreChanged)

        container.loadPersistentStores { _, error in
            if let error {
                fatalError("Fatal error loading store: \(error.localizedDescription)")
            }
        }
    }

    func remoteStoreChanged(_ notification: Notification) {
        objectWillChange.send()
    }

    func createSampleData() {
        let viewContext = container.viewContext

        for tagCounter in 1...5 {
            let tag = Tag(context: viewContext)
            tag.id = UUID()
            tag.name = "Tag \(tagCounter)"

            for skillCounter in 1...10 {
                let skill = Skill(context: viewContext)
                skill.title = "Skill \(tagCounter)-\(skillCounter)"
                skill.content = "Description goes here"
                skill.creationDate = .now
                skill.completed = Bool.random()
                skill.difficulty = Int16.random(in: 0...2)
                tag.addToSkills(skill)
            }
        }

        try? viewContext.save()
    }

    func save() {
        saveTask?.cancel()

        if container.viewContext.hasChanges {
            try? container.viewContext.save()
        }
    }

    func queueSave() {
        // cancel the task first if another change comes in, making sure that any existing queued save doesn’t happen
        saveTask?.cancel()

        saveTask = Task { @MainActor in
            try await Task.sleep(for: .seconds(3))
            save()
        }
    }

    func delete(_ object: NSManagedObject) {
        objectWillChange.send()
        container.viewContext.delete(object)
        save()
    }

    private func delete(_ fetchRequest: NSFetchRequest<NSFetchRequestResult>) {
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        batchDeleteRequest.resultType = .resultTypeObjectIDs

        if let delete = try? container.viewContext.execute(batchDeleteRequest) as? NSBatchDeleteResult {
            let changes = [NSDeletedObjectsKey: delete.result as? [NSManagedObjectID] ?? []]
            NSManagedObjectContext.mergeChanges(fromRemoteContextSave: changes, into: [container.viewContext])
        }
    }

    func deleteAll() {
        let request1: NSFetchRequest<NSFetchRequestResult> = Tag.fetchRequest()
        delete(request1)

        let request2: NSFetchRequest<NSFetchRequestResult> = Skill.fetchRequest()
        delete(request2)

        save()
    }

    func missingTags(from skill: Skill) -> [Tag] {
        let request = Tag.fetchRequest()
        let allTags = (try? container.viewContext.fetch(request)) ?? []

        let allTagsSet = Set(allTags)
        let difference = allTagsSet.symmetricDifference(skill.skillTags)

        return difference.sorted()
    }

    func skillsForSelectedFilter() -> [Skill] {
        let filter = selectedFilter ?? .all
        var predicates = [NSPredicate]()

        if let tag = filter.tag {
            let tagPredicate = NSPredicate(format: "tags CONTAINS %@", tag)
            predicates.append(tagPredicate)
        } else {
            let datePredicate = NSPredicate(format: "modificationDate > %@", filter.minModificationDate as NSDate)
            predicates.append(datePredicate)
        }

        let trimmedFilterText = filterText.trimmingCharacters(in: .whitespaces)

        if trimmedFilterText.isEmpty == false {
            let titlePredicate = NSPredicate(format: "title CONTAINS[c] %@", trimmedFilterText)
            let contentPredicate = NSPredicate(format: "content CONTAINS[c] %@", trimmedFilterText)
            let combinedPredicate = NSCompoundPredicate(orPredicateWithSubpredicates: [titlePredicate, contentPredicate])
            predicates.append(combinedPredicate)
        }

        // TODO: fix details page when search for 2 tags
        if filterTokens.isEmpty == false {
            for filterToken in filterTokens {
                let tokenPredicate = NSPredicate(format: "tags CONTAINS %@", filterToken)
                predicates.append(tokenPredicate)
            }

        }

        if filterEnabled {
            if filterDifficulty >= 0 {
                let difficultyFilter = NSPredicate(format: "difficulty = %d", filterDifficulty)
                predicates.append(difficultyFilter)
            }

            if filterStatus != .all {
                let lookForLearned = filterStatus == .learned
                let statusFilter = NSPredicate(format: "completed = %@", NSNumber(value: lookForLearned))
                predicates.append(statusFilter)
            }
        }

        let request = Skill.fetchRequest()
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        request.sortDescriptors = [NSSortDescriptor(key: sortType.rawValue, ascending: sortNewestFirst)]

        let allSkills = (try? container.viewContext.fetch(request)) ?? []

        return allSkills
    }

    func newTag() {
        let tag = Tag(context: container.viewContext)
        tag.id = UUID()
        tag.name = NSLocalizedString("New tag", comment: "Create a new tag")
        save()
    }

    func newSkill() {
        let skill = Skill(context: container.viewContext)
        skill.title = NSLocalizedString("New skill", comment: "Create a new skill")
        skill.creationDate = .now
        skill.difficulty = 1
        if let tag = selectedFilter?.tag {
            skill.addToTags(tag)
        }

        save()

        selectedSkill = skill
    }

    func count<T>(for fetchRequest: NSFetchRequest<T>) -> Int {
        (try? container.viewContext.count(for: fetchRequest)) ?? 0
    }

    func hasEarned(award: Award) -> Bool {
        switch award.criterion {
        case "skills":
            // returns true if they added a certain number of skills
            let fetchRequest = Skill.fetchRequest()
            let awardCount = count(for: fetchRequest)
            return awardCount >= award.value

        case "learned":
            // returns true if they learned a certain number of skills
            let fetchRequest = Skill.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "completed = true")
            let awardCount = count(for: fetchRequest)
            return awardCount >= award.value

        case "tags":
            // return true if they created a certain number of tags
            let fetchRequest = Tag.fetchRequest()
            let awardCount = count(for: fetchRequest)
            return awardCount >= award.value

        default:
            // an unknown award criterion; this should never be allowed
            // fatalError("Unknown award criterion: \(award.criterion)")
            return false
        }
    }

}

// swiftlint:enable line_length
