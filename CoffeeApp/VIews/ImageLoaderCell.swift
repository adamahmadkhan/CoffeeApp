//
//  ImageLoaderCell.swift
//  CoffeeApp
//
//  Created by Adam Khan on 5/16/24.
//

import UIKit
import FirebaseFirestore
import FirebaseStorage



class ImageLoaderCell: UICollectionViewCell {
    
    
    
    
    @IBOutlet weak var mainViewOutlet: UIView!
    @IBOutlet weak var loaderOutlet: UIActivityIndicatorView!
    @IBOutlet weak var imageViewOutlet: UIImageView!
    
    @IBOutlet weak var percentageOutlet: UILabel!

    
    let storageRef = Storage.storage().reference()
    var reloadItem: (()-> Void)?
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        loaderOutlet.hidesWhenStopped = true
        
    }
//    func initialzeUpload(completion: @escaping (()->Void)){
//        if let data = self.imageViewOutlet.image?.pngData() {
//            let path = Int.random(in:  0..<100)
//            loaderOutlet.startAnimating()
//            uploadImage(imageData: data,path: path)
//            func uploadImage(imageData:Data, path:Int){
//                let imageRef = storageRef.child("Custom Images/photoId: \(path).png")
//                imageRef.putData(imageData, metadata: nil) { [self](metadata, error) in
//                    if let error = error {
//                        print("Error uploading image: \(error)")
//                        return
//                    }
//                    else{
//                        DispatchQueue.main.async {
//                            self.loaderOutlet.stopAnimating()
//                            self.reloadInputViews()
//
//                        }
//                    }
//                }
//            }
//        }
//    }
//    
}
