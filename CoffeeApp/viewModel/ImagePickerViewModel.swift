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
    var isLoading: DynamicType<Bool> = DynamicType<Bool>()
    var firstAttempt = true
    var images: Observers<[UIImage]> = Observers([])
    let dispatchGroup = DispatchGroup()
    var hudProgress: JGProgressHUD?
    var imagesToUpload = [UIImage]()
    init() {
        self.isLoading.value = false
        images.value = [UIImage]()
    }
    
    func loadImages(completion: @escaping () -> Void) {
        //self.isLoading.value = true
         
        let fetchOptions = PHFetchOptions()
        let options = PHImageRequestOptions()
        let imageManager = PHImageManager.default()
        options.isSynchronous = true
        options.deliveryMode = .fastFormat
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        let fetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        for index in 0 ..< fetchResult.count {
            dispatchGroup.enter()
            imageManager.requestImage(for: fetchResult.object(at: index), targetSize: PHImageManagerMaximumSize, contentMode: .aspectFill, options: options) { (image, _) in
                if let image = image {
                    self.images.value?.append(image)
                }
                self.dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            self.isLoading.value = false
            completion()
        }
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

