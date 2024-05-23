//
//  AddProductViewModel.swift
//  CoffeeApp
//
//  Created by Adam Khan on 5/8/24.
//

import Foundation
import FirebaseCore
import FirebaseFirestore
import FirebaseStorage

class AddProductViewModel{
    
    var isLoading: DynamicType<Bool> = DynamicType<Bool>()
    var productName: String?
    var productDescription: String?
    var productPrice: String?
    //var imageData: Data?
    let db = Firestore.firestore()
    let storageRef = Storage.storage().reference()
    
    init() {
        self.isLoading.value = false
    }
    func addCloudData(imageData:Data){
        self.isLoading.value = true
        let name = productName ?? "product Id \(Int.random(in:  0..<100))"
        let imageRef = storageRef.child("products/\(name).png")
        imageRef.putData(imageData, metadata: nil) { [self] (metadata, error) in
            if let error = error {
                print("Error uploading image: \(error)")
                return
            }
            imageRef.downloadURL { [self] (url, error) in
                if let error = error {
                    print("Error getting download URL: \(error)")
                    return
                }
                guard let url = url else {
                    print("Missing download URL")
                    return
                }
                db.collection("products").document(productName ?? "product id \(Int.random(in:  0..<100))").setData([
                    "name": name,
                    "price": self.productPrice ?? "",
                    "Description": self.productDescription ?? "",
                    "image":url.absoluteString
                ]) { error in
                    if error == nil{
                        print("done")
                        self.isLoading.value = false
                    }
                }
            }
        }
    }
            
            //
            //          let ref = db.collection("users").addDocument(data: [
            //            "first": "Ada",
            //            "last": "Lovelace",
            //            "born": 1815
            //          ])
            //        do {
            //            let snapshot = try db.collection("users").getDocuments()
            //            for document in snapshot.documents {
            //              print("\(document.documentID) => \(document.data())")
            //            }
            //          } catch {
            //            print("Error getting documents: \(error)")
            //          }
            
            
            func getAllProducts(completion: @escaping (Error?, [ProductModel]?) -> Void) {
                db.collection("products").getDocuments { snapshot, error in
                    if let error = error {
                        completion(error,nil)
                    } else {
                        let products = snapshot?.documents.compactMap { document in
                            let data = document.data()
                            let name = data["name"] as? String ?? ""
                            let price = data["price"] as? String ?? ""
                            let description = data["Description"] as? String ?? ""
                            let imageURL =  data["image"] as? String ?? "https://firebasestorage.googleapis.com/v0/b/coffeeshopapp-4ba3d.appspot.com/o/products%2Fimage7.png?alt=media&token=26a1132e-3905-452d-8b1f-d59c732c5ede"
                            return ProductModel(Description: description, name: name, price: price, image: imageURL)
                        }
                        completion(nil, products)
                        
                    }
                }
            }
        }
    
