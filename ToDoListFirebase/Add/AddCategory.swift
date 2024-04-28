//
//  AddCategory.swift
//  ToDoListFirebase
//
//  Created by Manal Qaysi 
//

import SwiftUI

struct AddCategory: View {
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject private var firebaseManager: FirebaseManager
    @State private var categoryName = ""
    
    var body: some View {
        NavigationStack {
            VStack {
                TextField("Category", text: $categoryName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                Section(){
                    Button(action: {
                        let category = Category(id: UUID().uuidString,name: categoryName, tasksCount: 0)
                        Task{
                            try await firebaseManager.createCategory(category)
                            try? await firebaseManager.fetchCategories()
                            
                            
                            
                        }
                        dismiss()
                    }) {
                        Text("Create Category")
                            .padding()
                            .foregroundColor(.blue)
                            .font(.title3)
                            .background(Color.brown)
                            .cornerRadius(8)
                            .opacity(0.5)
                    }
                    
                    .padding()
                    
                    Spacer()
                }
                .navigationTitle("Add Category")
            }
        }
    }
}

#Preview {
    AddCategory()
}

