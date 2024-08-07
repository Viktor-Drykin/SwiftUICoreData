//
//  ContentView.swift
//  SwiftUICoreData
//
//  Created by  Viktor Drykin on 02.08.2024.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        entity: FruitEntity.entity(),
        sortDescriptors: [.init(keyPath: \FruitEntity.name, ascending: true)]
    )
    var fruits: FetchedResults<FruitEntity>
    @State var textFieldText: String = ""

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                TextField("Add fruit here...", text: $textFieldText)
                    .font(.headline)
                    .padding(.leading)
                    .frame(maxWidth: .infinity)
                    .frame(height: 55)
                    .background(Color.purple)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding(.horizontal)
                Button {
                    addItem()
                } label: {
                    Text("Submit")
                        .font(.headline)
                        .foregroundStyle(Color.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 55)
                        .background(Color.blue)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                .padding(.horizontal)

                List {
                    ForEach(fruits) { fruit in
                        Text(fruit.name ?? "")
                            .onTapGesture {
                                updateItem(fruit)
                            }
                    }
                    .onDelete(perform: deleteItems)
                }
                .listStyle(PlainListStyle())
            }
            .navigationTitle("Fruits")
        }
    }

    private func addItem() {
        withAnimation {
            let newItem = FruitEntity(context: viewContext)
            newItem.name = textFieldText
            saveItems()
            textFieldText = ""
        }
    }

    private func updateItem(_ entity: FruitEntity) {
        withAnimation {
            let currentName = entity.name ?? ""
            let newName = currentName + "!"
            entity.name = newName
            saveItems()
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            guard let index = offsets.first else { return }
            let fruitEntity = fruits[index]
            viewContext.delete(fruitEntity)
            saveItems()
        }
    }

    private func saveItems() {
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
