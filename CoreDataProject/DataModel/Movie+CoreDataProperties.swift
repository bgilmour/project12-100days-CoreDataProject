//
//  Movie+CoreDataProperties.swift
//  CoreDataProject
//
//  Created by Bruce Gilmour on 2021-07-23.
//
//

import Foundation
import CoreData


extension Movie {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Movie> {
        return NSFetchRequest<Movie>(entityName: "Movie")
    }

    @NSManaged public var title: String?
    @NSManaged public var director: String?
    @NSManaged public var year: Int16

    var wrappedTitle: String {
        title ?? "Unknown Title"
    }

    var wrappedDirector: String {
        director ?? "Unknown Director"
    }

}

extension Movie : Identifiable {

}
