//
//  ContentView.swift
//  CoreDataProject
//
//  Created by Bruce Gilmour on 2021-07-23.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var moc

    var body: some View {
        Text("ContentView")
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
    }
}
