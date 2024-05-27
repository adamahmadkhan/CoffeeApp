//
//  ImagePickerViewController.swift
//  CoffeeApp
//
//  Created by Adam Khan on 5/15/24.
//

import UIKit
import PhotosUI
import FirebaseFirestore
import FirebaseStorage

class ImagePickerViewController: UIViewController, PHPickerViewControllerDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    
    
    
    
    @IBOutlet weak var imageViewCvOutelet: UICollectionView!
    @IBOutlet weak var galleryBtnOutlet: UIButton!
    @IBOutlet weak var uploadBtnOutlet: UIButton!
    var images = [UIImage]() {
        didSet  {
            if oldValue.count < images.count {
                DispatchQueue.main.async { [self] in
                    uploadBtnOutlet.isEnabled = true
                }
            }
        }
    }
    var selected = [Int]()
    var viewModel = ImagePickerViewModel()
    //    var selectedImages  = [UIImage]()
    //    var selectedIndexes = [IndexPath]()
    var currentlyLoading = -1
    let storageRef = Storage.storage().reference()
    var  i = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imageViewCvOutelet.allowsMultipleSelection = true
        self.imageViewCvOutelet.register(UINib(nibName: "ImageLoaderCell" , bundle: nil), forCellWithReuseIdentifier: "imageLoaderCells")
        uploadBtnOutlet.isEnabled = false
        viewModel.isLoading.bind { data in
            //self.imageViewCvOutelet.reloadData()
        }
    }
    
    
    @IBAction func galleryButtonPressed(_ sender: UIButton) {
        configureImagePicker()
    }
    
    func configureImagePicker(){
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 0
        configuration.filter = .images
        let pickerViewController = PHPickerViewController(configuration: configuration)
        pickerViewController.delegate = self
        present(pickerViewController, animated: true)
    }
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        for result in results {
            result.itemProvider.loadObject(ofClass: UIImage.self) { [self] object, error in
                if let image = object as? UIImage  {
                    if !images.contains(where: { $0.pngData() == image.pngData() }) {
                            images.append(image)
                        }
                }
                DispatchQueue.main.async {
                self.imageViewCvOutelet.reloadData()
                
            }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        images.count
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width/3 - 10 , height: 150)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageLoaderCells", for: indexPath) as! ImageLoaderCell
        cell.imageViewOutlet.image = images[indexPath.row]
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //        //selectedIndexes = self.imageViewCvOutelet.indexPathsForSelectedItems!
        //        if let cell = collectionView.cellForItem(at: indexPath) as? ImageLoaderCell {
        //            cell.mainViewOutlet.backgroundColor = .green
        //        }
    }
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        //        selectedIndexes = self.imageViewCvOutelet.indexPathsForSelectedItems!
        //        if let cell = collectionView.cellForItem(at: indexPath) as? ImageLoaderCell {
        //            cell.mainViewOutlet.backgroundColor = .white
        //       }
    }
    
    @IBAction func uploadBtnPressed(_ sender: Any) {
        uploadBtnOutlet.isEnabled = false
        galleryBtnOutlet.isEnabled = false
        uploadImages()
    }
    
    func uploadImages() {
        initialzeUpload { [self] in
            if i + 1 < images.count {
                i = i + 1
                uploadImages()
            }
            else {
                i = images.count
                return {
                    galleryBtnOutlet.isEnabled = true
                }()
            }
            
        }
    }
    
    func initialzeUpload(completion: @escaping (()->Void)){
        let cell = imageViewCvOutelet.cellForItem(at: IndexPath(row: i, section: 0)) as? ImageLoaderCell
        //cell?.loaderOutlet.startAnimating()
        if let data = cell?.imageViewOutlet.image?.pngData() {
            let path = Int.random(in:  0..<100)
            let imageRef = storageRef.child("Custom Images/photoId: \(path).png")
            let uploadTask = imageRef.putData(data, metadata: nil) { (metadata, error) in
                if let error = error {
                    print("Error uploading image: \(error)")
                }
            }
            uploadTask.observe(.progress) { snapshot in
                DispatchQueue.main.async {
                    let process = Float(snapshot.progress!.completedUnitCount) / Float(snapshot.progress!.totalUnitCount)
                    print("Upload progress: \(process * 100)%")
                    cell?.percentageOutlet.text = ("\(Int(process * 100))")
                    cell?.progressBar.progress = process
                    cell?.reloadInputViews()
                }
            }
            uploadTask.observe(.success){ snapshot in
                DispatchQueue.main.async{
                   // cell?.loaderOutlet.stopAnimating()
                    completion()
                }
                
            }
        }
    }
}

