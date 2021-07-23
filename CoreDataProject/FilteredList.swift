//
//  FilteredList.swift
//  CoreDataProject
//
//  Created by Bruce Gilmour on 2021-07-23.
//

import SwiftUI
import CoreData

struct FilteredList<T: NSManagedObject, Content: View>: View {
    var fetchRequest: FetchRequest<T>
    var results: FetchedResults<T> { fetchRequest.wrappedValue }
    let content: (T) -> Content

    init(filterKey: String, filterValue: String, @ViewBuilder content: @escaping (T) -> Content) {
        fetchRequest = FetchRequest<T>(
            entity: T.entity(),
            sortDescriptors: [],
            predicate: NSPredicate(format: "%K beginswith %@", filterKey, filterValue)
        )
        self.content = content
    }

    var body: some View {
        List(results, id: \.self) { result in
            content(result)
        }
    }
}
