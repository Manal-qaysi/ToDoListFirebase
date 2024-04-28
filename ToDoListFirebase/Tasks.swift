//
//  TaskView.swift
//  ToDoListFirebase
//
//  Created by Manal Qaysi
//

import SwiftUI

struct Tasks: View {
    @EnvironmentObject private var firebaseManager: FirebaseManager
    @State var isShowingAddItemView: Bool = false
    @State var tasksCount : Int = 0
    let category: Category

    var body: some View {
        NavigationStack {
            VStack {
                List {
                    ForEach(firebaseManager.items, id: \.id) { item in
                        NavigationLink(
                            destination: UpdateItemView(tasksCount: 0, item: item, category: category)
                        ) {
                            VStack {
                                Text(item.title)
                                Text(item.info)
                                Text(item.id)
                            }
                        }
                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                            Button {
                                Task {
                                    try await firebaseManager.deleteItem(item,category)
                                    try? await firebaseManager.fetchItems(category)
                                   
                                        let cat = Category(id: category.id, name: category.name, tasksCount: (category.tasksCount - 1))
                                        Task {
                                            try await firebaseManager.createItem(item, category)
                                            firebaseManager.updateCategory(cat)
                                
                                        }
                                  
                                       
                                }
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }.tint(.red)
                        }
                    }
                }
                
                Button {
                    Task {
                        try await firebaseManager.fetchItems(category)
                    }
                } label: {
                    Text("Fetch from DB")
                }
                
                
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        isShowingAddItemView.toggle()
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $isShowingAddItemView) {
                AddItemView(category: category)
            }
            .navigationBarTitle("Categories", displayMode: .large)
            .onAppear {
                Task {
                   try await firebaseManager.fetchItems(category)
                }
            }
        }
    }
}
