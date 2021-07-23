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
        WizardTestView()
    }

}

struct WizardTestView: View {
    @Environment(\.managedObjectContext) private var moc

    @FetchRequest(entity: Wizard.entity(), sortDescriptors: []) var wizards: FetchedResults<Wizard>

    var body: some View {
        List(wizards, id: \.self) { wizard in
            Text(wizard.name ?? "Unknown")
        }

        Button("Add") {
            let wizard = Wizard(context: moc)
            wizard.name = "Harry Potter"
        }

        Button("Save") {
            do {
                try moc.save()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}

struct Student: Hashable {
    let name: String
}

struct StudentTestView: View {
    let students = [Student(name: "Harry Potter"), Student(name: "Hermione Granger")]

    var body: some View {
        List {
            ForEach(students, id: \.self) { student in
                Text(student.name)
            }
        }
    }
}

struct ListForEachTestView: View {
    var body: some View {
        List {
            ForEach([2, 4, 6, 8, 10], id: \.self) {
                Text("\($0) is even")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
    }
}
