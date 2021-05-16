//
//  Tasks+CoreDataProperties.swift
//  ToDoList
//
//  Created by Антон Белый on 16.05.2021.
//
//

import Foundation
import CoreData


extension Tasks {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Tasks> {
        return NSFetchRequest<Tasks>(entityName: "Tasks")
    }

    @NSManaged public var title: String?
    @NSManaged public var createdDate: Date?

}

extension Tasks : Identifiable {

}
