//
//  HomeScreenViewModel.swift
//  CoffeeApp
//
//  Created by Adam Khan on 4/19/24.
//

import Foundation
import FirebaseCore
import FirebaseFirestore
let db = Firestore.firestore()


class HomeScreenViewModel {
    
    var isLoading: DynamicType<Bool> = DynamicType<Bool>()
    var products: DynamicType<[ProductModel]> = DynamicType<[ProductModel]>()
    
    init(){
        self.isLoading.value = false
    }
    
    func getAllProducts() {
        self.isLoading.value = true
        db.collection("products").getDocuments { snapshot, error in
            if let error = error {
                print(error)
            } else {
                let products = snapshot?.documents.compactMap { document in
                    let data = document.data()
                    let name = data["name"] as? String ?? ""
                    let price = data["price"] as? String ?? ""
                    let description = data["Description"] as? String ?? ""
                    let imageURL =  data["image"] as? String ?? "https://firebasestorage.googleapis.com/v0/b/coffeeshopapp-4ba3d.appspot.com/o/products%2Fimage7.png?alt=media&token=26a1132e-3905-452d-8b1f-d59c732c5ede"
                    return ProductModel(Description: description, name: name, price: price, image: imageURL)
                }
                self.products.value = products
                self.isLoading.value = false
                
            }
        }
        
    }
}
