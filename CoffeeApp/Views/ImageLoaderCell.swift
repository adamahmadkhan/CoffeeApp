//
//  ImageLoaderCell.swift
//  CoffeeApp
//
//  Created by Adam Khan on 5/16/24.
//

import UIKit




class ImageLoaderCell: UICollectionViewCell {
    
    
    
    
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var mainViewOutlet: UIView!
    @IBOutlet weak var loaderOutlet: UIActivityIndicatorView!
    @IBOutlet weak var imageViewOutlet: UIImageView!
    
    
    @IBOutlet weak var isUploadedIcon: UIImageView!
    @IBOutlet weak var percentageOutlet: UILabel!

    
    
    
    
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
