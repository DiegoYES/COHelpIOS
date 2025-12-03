//
//  T_Registros+CoreDataProperties.swift
//  Proyecto02
//
//  Created by MacBook Pro on 17/11/25.
//
//

import Foundation
import CoreData


extension T_Registros {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<T_Registros> {
        return NSFetchRequest<T_Registros>(entityName: "T_Registros")
    }

    @NSManaged public var habitLog: String?
    @NSManaged public var amount: Double
    @NSManaged public var date: Date?

}

extension T_Registros : Identifiable {

}
