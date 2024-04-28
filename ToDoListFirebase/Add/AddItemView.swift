//
//  AddItemView.swift
//  ToDoListFirebase
//
//  Created by Manal Qaysi 
//

import SwiftUI

struct AddItemView: View {
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject private var firebaseManager: FirebaseManager
    @State private var title = ""
    @State private var info = ""
    @State private var dueDate = Date()
    @State private var showingError = false
    @State var tasksCount : Int = 0
    var category: Category
    var body: some View {
        NavigationStack {
            Form {
                    Section(footer: Text(showingError ? "Title and details must be filled in" : "Title your task to spotlight your priorities.")
                        .foregroundStyle(showingError ? .red : .gray)){
                    TextField("Task title" , text: $title)
                    TextField("Task details" , text: $info)


                    DatePicker("Date", selection: $dueDate, in: Date()...)
                }

                Section() {
                    Button("Add Task") {
                        if !title.isEmpty && !info.isEmpty {
                            let item =  Item(id: UUID().uuidString, title: title, info: info, dueDate: dueDate)
                            let cat = Category(id: category.id, name: category.name, tasksCount: (category.tasksCount + 1))
                            Task {
                                try await firebaseManager.createItem(item, category)
                                firebaseManager.updateCategory(cat)
                    
                            }
                        dismiss()
                           
                        } else {
                            showingError = true
                        }
                    }
                    .frame(maxWidth: .infinity)
                }

            }.navigationTitle("Add Task")


        }
    }
}

#Preview {
    AddItemView(category: Category(id: "", name: "",tasksCount : 0))
        .environmentObject(FirebaseManager())
}

