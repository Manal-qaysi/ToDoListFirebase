//
//  ContentView.swift
//  ToDoListFirebase
//
//  Created by Manal Qaysi
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject private var firebaseManager: FirebaseManager
    @State private var selectedCategory: Category?
    @State private var isShowingAddCategory = false
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(firebaseManager.categories, id: \.id) { category in
                    let tasksCount = category.tasksCount
                    HStack {
                        Spacer()
                        Menu {
                            Button {
                                selectedCategory = category
                            } label: {
                                Label("Edit", systemImage: "pencil")
                                    .foregroundStyle(.blue)
                            }
                            Button("Delete", role: .destructive) {
                                Task {
                                    do {
                                        try await firebaseManager.deleteCategory(category)
                                        try? await firebaseManager.fetchCategories()
                                    } catch {
                                        print("Error deleting category: \(error)")
                                    }
                                    
                                }
                            }.foregroundStyle(.red)
                        } label: {
                            Image(systemName: "ellipsis.circle")
                                .foregroundStyle(.blue)
                        }
                        
                        NavigationLink(destination: Tasks(category: category)) {
                            VStack(alignment: .leading) {
                                Text("\(category.name) (\(tasksCount))")
                                    .frame(alignment: .leading)
                            }
                        }
                    }
                }
                
                
            }
            .navigationTitle("To Do")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        isShowingAddCategory = true
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(item: $selectedCategory) { category in
                updateCategory(category: category)
            }
            .sheet(isPresented: $isShowingAddCategory) {
                AddCategory()
            }
            .onAppear {
                Task {
                    do {
                        try await firebaseManager.fetchCategories()
                    } catch {
                        print("Error fetching categories: \(error)")
                    }
                }
            }
        }
    }
    
    // Function to calculate total tasks count
    func totalTasksCount() -> Int {
        var total = 0
        for category in firebaseManager.categories {
            total += category.tasksCount
        }
        return total
    }
}


#Preview {
    ContentView()
        .environmentObject(FirebaseManager())
}
