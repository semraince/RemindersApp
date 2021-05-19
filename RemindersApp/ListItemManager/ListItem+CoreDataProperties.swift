//
//  ListItem+CoreDataProperties.swift
//  RemindersApp
//
//  Copyright © 2021 semra. All rights reserved.
//
//

import Foundation
import CoreData


extension ListItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ListItem> {
        return NSFetchRequest<ListItem>(entityName: "ListItem")
    }

    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var colorCode: Int32
    @NSManaged public var listImage: String?

}
