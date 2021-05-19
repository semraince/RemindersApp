//
//  ReminderItem+CoreDataProperties.swift
//  RemindersApp
//
//  Copyright © 2021 semra. All rights reserved.
//
//

import Foundation
import CoreData


extension ReminderItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ReminderItem> {
        return NSFetchRequest<ReminderItem>(entityName: "ReminderItem")
    }

    @NSManaged public var id: String?
    @NSManaged public var title: String?
    @NSManaged public var notes: String?
    @NSManaged public var flag: Bool
    @NSManaged public var priority: Int32
    @NSManaged public var status: Int32
    @NSManaged public var listItemId: String?

}
