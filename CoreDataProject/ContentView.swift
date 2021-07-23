//
//  ContentView.swift
//  CoreDataProject
//
//  Created by Bruce Gilmour on 2021-07-23.
//

import SwiftUI
import CoreData

struct ContentView: View {

    var body: some View {
        CountryCandyTestView()
    }

}

struct CountryCandyTestView: View {
    @Environment(\.managedObjectContext) private var moc

    @FetchRequest(entity: Country.entity(), sortDescriptors: []) var countries: FetchedResults<Country>

    var body: some View {
        VStack {
            List {
                ForEach(countries, id: \.self) { country in
                    Section(header: Text(country.wrappedFullName)) {
                        ForEach(country.candyArray, id: \.self) { candy in
                            Text(candy.wrappedName)
                        }
                    }
                }
            }
        }

        Button("Add") {
            let candy1 = Candy(context: moc)
            candy1.name = "Mars"
            candy1.origin = Country(context: moc)
            candy1.origin?.shortName = "UK"
            candy1.origin?.fullName = "United Kingdom"

            let candy2 = Candy(context: moc)
            candy2.name = "KitKat"
            candy2.origin = Country(context: moc)
            candy2.origin?.shortName = "UK"
            candy2.origin?.fullName = "United Kingdom"

            let candy3 = Candy(context: moc)
            candy3.name = "Twix"
            candy3.origin = Country(context: moc)
            candy3.origin?.shortName = "UK"
            candy3.origin?.fullName = "United Kingdom"

            let candy4 = Candy(context: moc)
            candy4.name = "Toblerone"
            candy4.origin = Country(context: moc)
            candy4.origin?.shortName = "CH"
            candy4.origin?.fullName = "Switzerland"

            try? moc.save()
        }
    }
}

struct SingerTestView: View {
    @Environment(\.managedObjectContext) private var moc

    @State private var lastNameFilter = "A"

    var body: some View {
        VStack {
            FilteredList(filterKey: "lastName", filterValue: lastNameFilter) { (singer: Singer) in
                Text("\(singer.wrappedFirstName) \(singer.wrappedLastName)")
            }

            Button("Add Examples") {
                let taylor = Singer(context: moc)
                taylor.firstName = "Taylor"
                taylor.lastName = "Swift"

                let ed = Singer(context: moc)
                ed.firstName = "Ed"
                ed.lastName = "Sheeran"

                let adele = Singer(context: moc)
                adele.firstName = "Adele"
                adele.lastName = "Adkins"

                try? moc.save()
            }

            Button("Show A") {
                lastNameFilter = "A"
            }

            Button("Show S") {
                lastNameFilter = "S"
            }
        }
    }
}

struct ShipTestView: View {
    @Environment(\.managedObjectContext) private var moc

    @FetchRequest(
        entity: Ship.entity(),
        sortDescriptors: [],
        //predicate: NSPredicate(format: "universe == %@", "Star Wars")
        //predicate: NSPredicate(format: "name < %@", "F")
        predicate: NSPredicate(format: "universe in %@", ["Aliens", "Firefly", "Star Trek"])
        //predicate: NSPredicate(format: "name beginswith %@", "E")
        //predicate: NSPredicate(format: "name beginswith[c] %@", "e")
        //predicate: NSPredicate(format: "not name beginswith[c] %@", "e")
    )
    var ships: FetchedResults<Ship>

    var body: some View {
        VStack {
            List(ships, id: \.self) { ship in
                Text(ship.name ?? "Unknown name")
            }

            Button("Add Examples") {
                let ship1 = Ship(context: self.moc)
                ship1.name = "Enterprise"
                ship1.universe = "Star Trek"

                let ship2 = Ship(context: self.moc)
                ship2.name = "Defiant"
                ship2.universe = "Star Trek"

                let ship3 = Ship(context: self.moc)
                ship3.name = "Millennium Falcon"
                ship3.universe = "Star Wars"

                let ship4 = Ship(context: self.moc)
                ship4.name = "Executor"
                ship4.universe = "Star Wars"

                try? self.moc.save()
            }
        }
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
