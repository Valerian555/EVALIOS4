//
//  Expense+CoreDataProperties.swift
//  EVALIOS4
//
//  Created by Student08 on 14/09/2023.
//
//

import Foundation
import CoreData


extension Expense {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Expense> {
        return NSFetchRequest<Expense>(entityName: "Expense")
    }

    @NSManaged public var name: String?
    @NSManaged public var date: Date?
    @NSManaged public var value: Float
    @NSManaged public var section: ExpenseSection?

}

extension Expense : Identifiable {

}
