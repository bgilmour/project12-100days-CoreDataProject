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
        SingerTestView()
    }

}

struct ArrayOfViews: View {
    @State private var views = [AnyView]()

    var body: some View {
        VStack {
            Button("Add Shape") {
                if Bool.random() {
                    views.append(AnyView(Circle().frame(height: 50)))
                } else {
                    views.append(AnyView(Rectangle().frame(width: 50)))
                }
            }

            ForEach(0 ..< views.count, id: \.self) {
                views[$0]
            }

            Spacer()
        }
    }
}

extension View {
    func erasedToAnyView() -> AnyView {
        AnyView(self)
    }
}

struct UsingAnyView: View {
    @State private var view = AnyView(EmptyView())

    var body: some View {
        VStack {
            Button("Random View") {
                if Bool.random() {
                    view = Text("Hello, world!")
                        .frame(width: 300)
                        .background(Color.red)
                        .erasedToAnyView()
                } else {
                    view = Text("Hello, world!")
                        .background(Color.red)
                        .erasedToAnyView()
                }
            }
            .padding()

            view
        }
    }
}

struct UsingGroup: View {
    @State private var randomChoice = Bool.random()

    var body: some View {
        VStack {
            Button("Random View") {
                randomChoice = Bool.random()
            }
            .padding()

            Group {
                if randomChoice {
                    Text("Hello, world!")
                        .frame(width: 300)
                        .background(Color.red)
                } else {
                    Text("Hello, world!")
                        .background(Color.red)
                }
            }
        }
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

    @State private var filterValue = "A"
    @State private var predicate = PredicateOp.beginsWith
    @State private var negate = false
    @State private var caseSensitive = true
    @State private var useLastName = true
    @State private var ascending = true

    var sortKeys = ["firstName", "lastName"]

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Results")) {
                    FilteredList(
                        filterKey: useLastName ? "lastName" : "firstName",
                        filterValue: filterValue,
                        predicate: predicate,
                        negate: negate,
                        caseSensitive: caseSensitive,
                        sortDescriptors: [
                            NSSortDescriptor(keyPath: useLastName ? \Singer.lastName : \Singer.firstName, ascending: ascending)
                        ]
                    ) { (singer: Singer) in
                        Text("\(singer.wrappedFirstName) \(singer.wrappedLastName)")
                    }
                }

                Section(header: Text("Key")) {
                    Toggle("Use lastName as key", isOn: $useLastName)
                }

                Section(header: Text("Predicate")) {
                    TextField("Filter", text: $filterValue)
                        .disableAutocorrection(true)
                        .autocapitalization(.none)
                    Picker("Predicate", selection: $predicate) {
                        ForEach(PredicateOp.allCases, id: \.self) {
                            Text($0.rawValue)
                        }
                    }
                    Toggle("Negate", isOn: $negate)
                    Toggle("Case sensitive", isOn: $caseSensitive)
                }

                Section(header: Text("Sorting")) {
                    Toggle("Ascending", isOn: $ascending)
                }

                Section(header: Text("Initialise")) {
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
                }
            }
            .navigationBarTitle("FilteredList")
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
