//
//  Journal+CoreDataProperties.swift
//  AppPrototype
//
//  Created by Cuello-Wolffe, Benjamin on 10/05/2023.
//
//

import Foundation
import CoreData


extension Journal {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Journal> {
        return NSFetchRequest<Journal>(entityName: "Journal")
    }

    @NSManaged public var dates: Date?
    @NSManaged public var latitudes: Double
    @NSManaged public var locationNames: String?
    @NSManaged public var longitudes: Double
    @NSManaged public var photoIDLists: NSObject?
    @NSManaged public var photoLists: Data?
    @NSManaged public var textEntries: String?
    @NSManaged public var titles: String?
    @NSManaged public var addressNames: String?
    @NSManaged public var cities: String?
    @NSManaged public var countries: String?

}

extension Journal : Identifiable {

}
