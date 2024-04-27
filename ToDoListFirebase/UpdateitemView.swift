//
//  UpdateitemView.swift
//  ToDoListFirebase
//
//  Created by Manal Qaysi 
//

import SwiftUI

struct UpdateItemView: View {
    @EnvironmentObject private var firebaseManager: FirebaseManager
    @Environment(\.dismiss) private var dismiss
    @State var title: String = ""
    @State var info: String = ""
    @State var dueDate: Date = .now
    @State var timestamp: Date = .now
    @State var tasksCount : Int
    var item: Item
    var category: Category
    
    var body: some View {
        Form{
            Section{
                TextField("title", text: $title)
                TextField("title", text: $info)
                DatePicker(selection: $dueDate) {
                    Text("Due Date")
                }
                
            }
            
            Button(action: {
                let item = Item(id: item.id,
                                title: title,
                                info: info,
                                dueDate: dueDate)
                Task {
                    firebaseManager.updateItem(item , category)
                    dismiss()
                }
            }, label: {
                Text("Update Item")
            }).frame(maxWidth: .infinity, alignment: .center)
                .font(.title3)
                .buttonStyle(.borderless)
                .foregroundStyle(.white)
                .listRowBackground(Color.blue)
        }
        .navigationTitle("Update Item")
        .onAppear{
            title = item.title
            info = item.info
            dueDate = item.dueDate
           
        }
    }
}


