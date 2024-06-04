//
//  ImagePickerViewModel.swift
//  CoffeeApp
//
//  Created by Adam Khan on 5/16/24.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage
import UIKit
import PhotosUI
import JGProgressHUD



class ImagePickerViewModel{
    let storageRef = Storage.storage().reference()
    var isLoading: Observers<Bool> = Observers(false)
    var firstAttempt = true
    var images = DynamicType<[UIImage]>()
    let queue1 = OperationQueue()
    let queue2 = OperationQueue()
    let dispatchGroup = DispatchGroup()
    var hudProgress: JGProgressHUD?
    init() {
        self.isLoading.value = false
        images.value = [UIImage]()
    }
    
    func loadImages(completion: @escaping ([UIImage]) -> Void){
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        let fetchResult = PHAsset.fetchAssets(with: fetchOptions)
        
        let imageManager = PHImageManager.default()
        let options = PHImageRequestOptions()
        options.isSynchronous = true
        
    }
    
    
    
    func addImages(imagesList:[PHPickerResult],completion: @escaping()->Void){
       
                for image in imagesList {
                    dispatchGroup.enter()
                    isLoading.value = true
                    image.itemProvider.loadObject(ofClass: UIImage.self) { [self] object, error in
                        defer { dispatchGroup.leave() }
                        if !firstAttempt {
                            if let image = object as? UIImage  {
                                if !(images.value!.contains(where: { $0.pngData() == image.pngData() })) {
                                    self.images.value!.append(image)
                                }
                            }
                        }
                        else {
                            if let image = object as? UIImage  {
                                self.images.value!.append(image)
                            }
                            
                        }
                    }
                }
        dispatchGroup.notify(queue: .main) {
            self.firstAttempt = false
            self.isLoading.value = false
            completion()
        }
       
            //queue1.addOperation(operation1)
           // queue2.addOperation(operation2)
            //queue2.waitUntilAllOperationsAreFinished()
            //operation1.addDependency(operation2)
            
            //        queue.addOperations([operation1, operation2], waitUntilFinished: true)
            //        //operation2.addDependency(operation1)
            //
            //        let operation3 = BlockOperation {
            //            print("Operation 1 is starting")
            //            Thread.sleep(forTimeInterval: 1)
            //            print("Operation 1 is finishing")
            //        }
            //
            //        let operation4 = BlockOperation {
            //            print("Operation 2 is starting")
            //            Thread.sleep(forTimeInterval: 1)
            //            print("Operation 2 is finishing")
            //        }
            //
            //        operation4.addDependency(operation3)
            //
            //        print("Adding operations")
            //        let queue = OperationQueue()
            //        queue.addOperation(operation3)
            //        queue.addOperation(operation4)
            //        queue.waitUntilAllOperationsAreFinished()
            //        print("Done!")
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

