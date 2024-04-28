//
//  FireBaseManager.swift
//  ToDoListFirebase
//
//  Created by Manal Qaysi 
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

struct Item: Codable , Identifiable{
    var id: String
    var title : String
    var info : String
    var dueDate: Date
    var timestamp: Date = .now
}

struct Category: Codable, Identifiable {
    var id: String
    var name: String
    var tasksCount: Int
    
}
class FirebaseManager: NSObject , ObservableObject {
    @Published var items: [Item] = []
    @Published var categories: [Category] = []
    let firestore: Firestore
    
    override init() {
        self.firestore = Firestore.firestore()
        super.init()
    }
   
    func createItem(_ item: Item, _ category: Category) async throws {
        do {
            print("Attempting to create item in Firestore at category: \(category.id), item: \(item.id)")
            try firestore.collection("category").document(category.id).collection("items").document(item.id).setData(from: item)
            print("Item created in category.")
        } catch {
            print("Failed to create item: \(error)")
            throw error
        }
    }


    
    func createCategory(_ category: Category) async throws {
        do{
            try  firestore.collection("category").document(category.id).setData(from: category)
            print("done")
        }
        catch{
            print("failed")
            
        }
    }
    
    func fetchItems(_ category: Category) async throws {
        let querySnapshot = try await firestore.collection("category").document(category.id).collection("items").getDocuments()
        let items = querySnapshot.documents.compactMap({try? $0.data(as: Item.self)})
        DispatchQueue.main.sync {
            self.items = items
       }
    }
    
    func fetchCategories() async throws {
        let querySnapshot = try await firestore.collection("category").getDocuments()
        let categories = querySnapshot.documents.compactMap({try? $0.data(as: Category.self)})
        DispatchQueue.main.sync {
            self.categories = categories
       }
    }
   
    func deleteItem(_ item: Item, _ category: Category) async throws {
        let documentRef = firestore.collection("category").document(category.id).collection("items").document(item.id)
        try await documentRef.delete()
        
    }
    
    func deleteCategory(_ category: Category) async throws {
        let documentRef = firestore.collection("category").document(category.id)
           try await documentRef.delete()
    }

   
    func updateItem(_ item: Item, _ category: Category){
        do {
            try firestore.collection("category")
                              .document(category.id)
                              .collection("items")
                              .document(item.id)
                              .setData(from: item)
        } catch {
            print(error.localizedDescription)
        }
    }
   
    func updateCategory( _ category: Category){
        do {
            try  firestore.collection("category").document(category.id).setData(from: category)
        } catch {
            print(error.localizedDescription)
        }
    }

}
