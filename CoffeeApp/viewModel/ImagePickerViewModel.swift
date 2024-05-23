//
//  ImagePickerViewModel.swift
//  CoffeeApp
//
//  Created by Adam Khan on 5/16/24.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage
class ImagePickerViewModel{
    let storageRef = Storage.storage().reference()
    var isLoading: DynamicType<Bool> = DynamicType<Bool>()
    init() {
        self.isLoading.value = false
    }
    func uploadImages(image: Data, path:String){
        DispatchQueue.main.async{
            self.isLoading.value = true
        }
        let imageRef = storageRef.child("New Images/\(path).png")
        imageRef.putData(image, metadata: nil) {(metadata, error) in
            if let error = error {
                print("Error uploading image: \(error)")
                return
            }
            else{
                self.isLoading.value = false
            }
        }
    }
}
    
