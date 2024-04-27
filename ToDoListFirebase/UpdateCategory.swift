//
//  UpdateCategory.swift
//  ToDoListFirebase
//
//  Created by Manal Qaysi
//

import SwiftUI

struct updateCategory: View {
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject private var firebaseManager: FirebaseManager
    @State private var categoryName = ""
    @State var tasksCount : Int = 0
    var category: Category
    var body: some View {
        NavigationStack {
            VStack {
                TextField("Category", text: $categoryName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
            }
                Section(){
                    Button(action: {
                        let category = Category(id: category.id,name: categoryName)
                        Task{
                            try await firebaseManager.createCategory(category)
       
                        }
                        dismiss()
                    }) {
                        Text("Update Category")
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
                
                .navigationTitle("Update Category")
                .onAppear {
                    categoryName = category.name
                    
                }
            }
        }
    }


#Preview {
    updateCategory(category: Category(id: "", name: ""))
}


