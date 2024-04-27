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
    @DocumentID var id: String? = ""
    var title : String
    var info : String
    var dueDate: Date
    var timestamp: Date = .now
}

struct Category: Codable, Identifiable {
    @DocumentID var id: String? = ""
    var name: String
    var items: [Item] = []
    
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
            guard let categoryId = category.id, let itemId = item.id else { return }
            print("Attempting to create item in Firestore at category: \(categoryId), item: \(itemId)")
            try firestore.collection("category").document(categoryId).collection("items").document(itemId).setData(from: item)
            print("Item created in category.")
        } catch {
            print("Failed to create item: \(error)")
            throw error
        }
    }


    
    func createCategory(_ category: Category) async throws {
        guard let categoryId = category.id else { return }
        do{
            try  firestore.collection("category").document(categoryId).setData(from: category)
            print("done")
        }
        catch{
            print("failed")
            
        }
    }
    /*
    func fetchItems(_ category: Category) async throws {
        guard let categoryId = category.id else { return }
        let querySnapshot = try await firestore.collection("category").document(categoryId).collection("items").getDocuments()
        let items = querySnapshot.documents.compactMap({try? $0.data(as: Item.self)})
    
        DispatchQueue.main.sync {
            self.items = items

       }
    }
    */
    func getTasks(completion: @escaping ()->Void){

    }
    func fetchCategories(_ completion: ()->Void?) async throws {
        let querySnapshot = try await firestore.collection("category").getDocuments()
        let categories = querySnapshot.documents.compactMap({try? $0.data(as: Category.self)})
        DispatchQueue.main.sync {
            self.categories = categories
            completion()
       }
    }
   
    func deleteItem(_ item: Item, _ category: Category) async throws {
        guard let categoryId = category.id, let itemId = item.id else { return }
        let documentRef = firestore.collection("category").document(categoryId).collection("items").document(itemId)
        try await documentRef.delete()
    }
    
    func deleteCategory(_ category: Category) async throws {
        guard let categoryId = category.id else { return }
        let documentRef = firestore.collection("category").document(categoryId)
           try await documentRef.delete()
    }

    func updateCount(_ category: Category, completion: (Error?)->Void) {
        guard let categoryId = category.id else { return }
        let docRef = firestore.collection("category").document(categoryId)
        
        docRef.setData(["taskCouunt": 0], merge: true) { error in
            guard error == nil else { return }
            
        }
    }
   
    func updateItem(_ item: Item, _ category: Category){
        guard let categoryId = category.id, let itemId = item.id else { return }
        do {
            try firestore.collection("category")
                              .document(categoryId)
                              .collection("items")
                              .document(itemId)
                              .setData(from: item)
        } catch {
            print(error.localizedDescription)
        }
    }
   
    func updateCategory( _ category: Category){
        guard let categoryId = category.id else { return }
        do {
            try  firestore.collection("category").document(categoryId).setData(from: category)
        } catch {
            print(error.localizedDescription)
        }
    }

}
