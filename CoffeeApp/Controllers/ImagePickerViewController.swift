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
//import Reachability
import JGProgressHUD
import Connectivity
import Photos

class ImagePickerViewController: UIViewController, PHPickerViewControllerDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    
    
    
    //MARK: Outlets
    @IBOutlet weak var imageViewCvOutelet: UICollectionView!
    @IBOutlet weak var galleryBtnOutlet: UIButton!
    @IBOutlet weak var uploadBtnOutlet: UIButton!
    
    
    
    
    //MARK: Variables
    //let serialQueue = DispatchQueue(label: "my.Label.com")
//    let connectivity: Connectivity = Connectivity()
    //let reachability = try! Reachability()
    var viewModel = ImagePickerViewModel()
    var hudProgress: JGProgressHUD?
    let storageRef = Storage.storage().reference()
    var currentlyUploading = 0
    var selectedCellsIndices = [IndexPath]()
    var uploadedImages = [UIImage]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        readyController()
        bindingFunctions()
      
        //imageViewCvOutelet.allowsMultipleSelection = false
        //connectivity.connectivityURLs = [URL(string: "https://www.google.com/")!]
        //        connectivity.isPollingEnabled = true
        //        connectivity.pollingInterval = 2
        //        configureConnectivityNotifier()
        //        connectivity.startNotifier()
        
    }
    
    //MARK: Image pickers Functions
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
        viewModel.addImages(imagesList: results) {
            DispatchQueue.main.async {
                self.imageViewCvOutelet.reloadData()
            }
        }
    }
    
    //MARK: ConnectionView Functions
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if viewModel.isLoading.value! {
            return 30
        }
        else
        {
            return viewModel.images.value!.count
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width/3 - 10 , height: 150)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if viewModel.isLoading.value! {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageLoaderCells", for: indexPath) as! ImageLoaderCell
            cell.mainViewOutlet.showAnimatedGradientSkeleton()
            return cell
        }
        
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageLoaderCells", for: indexPath) as! ImageLoaderCell
            cell.mainViewOutlet.stopSkeletonAnimation()
            cell.isUploadedIcon.isHidden = true
            cell.progressBar.isHidden  = true
            cell.percentageOutlet.isHidden = true
            cell.mainViewOutlet.backgroundColor = .white
            cell.imageViewOutlet.image = viewModel.images.value?[indexPath.row]
            cell.hideSkeleton()
            if imageViewCvOutelet.indexPathsForSelectedItems!.contains(indexPath){
                cell.mainViewOutlet.backgroundColor = .blue
                if indexPath.row == currentlyUploading {
                    cell.percentageOutlet.isHidden = false
                    cell.progressBar.isHidden = false
                }
                    else {
                        cell.percentageOutlet.isHidden = true
                        cell.progressBar.isHidden = true
                    }
            }
            else {
                cell.mainViewOutlet.backgroundColor = .white
            }
            if  uploadedImages.contains(viewModel.images.value![indexPath.row]){
                cell.isUploadedIcon.isHidden = false
            }
            else {
                cell.isUploadedIcon.isHidden = true
            }
            return cell
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? ImageLoaderCell {
        selectedCellsIndices.append(indexPath)
        viewModel.imagesToUpload.append(cell.imageViewOutlet.image!)
        cell.mainViewOutlet.backgroundColor = .blue
        }
    }
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? ImageLoaderCell {
        viewModel.imagesToUpload = viewModel.imagesToUpload.filter { $0 != cell.imageViewOutlet.image }
        selectedCellsIndices = selectedCellsIndices.filter{ $0 != indexPath }
        cell.mainViewOutlet.backgroundColor = .white
       }
    }
    
    
    //MARK: Upload and firebase Functions
    @IBAction func uploadBtnPressed(_ sender: Any) {
        uploadBtnOutlet.isEnabled = false
        galleryBtnOutlet.isEnabled = false
        manageUpload()
    }
    func manageUpload() {
        guard currentlyUploading <  imageViewCvOutelet.indexPathsForSelectedItems!.count else {
            uploadBtnOutlet.isEnabled = true
            galleryBtnOutlet.isEnabled = true
            imageViewCvOutelet.indexPathsForSelectedItems?.forEach { imageViewCvOutelet.deselectItem(at: $0, animated: false) }
            selectedCellsIndices.removeAll()
            currentlyUploading = 0
            imageViewCvOutelet.reloadData()
            return
        }
        initialzeUpload()
    }
        
    func initialzeUpload() {
        let cell = imageViewCvOutelet.cellForItem(at: selectedCellsIndices[currentlyUploading]) as? ImageLoaderCell
        //cell?.loaderOutlet.startAnimating()
        cell?.progressBar.isHidden = false
        cell?.percentageOutlet.isHidden = false
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
                DispatchQueue.main.async{ [self] in
                    // cell?.loaderOutlet.stopAnimating()
                    cell?.progressBar.isHidden  = true
                    cell?.percentageOutlet.isHidden = true
                    cell?.mainViewOutlet.backgroundColor = .white
                    cell?.isUploadedIcon.isHidden = false
                    currentlyUploading += 1
                    uploadedImages.append(cell!.imageViewOutlet.image!)
                    manageUpload()
                }
            }
        }
    }
    
    
    
    //    func monitorConnection(){
    //        let alert = UIAlertController(title: "Alert", message: "Check Internet", preferredStyle: .alert)
    //        DispatchQueue.main.async { [self] in
    //
    //
    //            reachability.whenReachable = { _ in
    //                self.dismiss(animated: true) {
    //                    self.uploadImages()
    //                }
    //            }
    //
    //
    //            reachability.whenUnreachable = { _ in
    //                self.present(alert, animated: true, completion: nil)
    //            }
    //
    //
    //            do {
    //                try reachability.startNotifier()
    //            } catch {
    //                print("Unable to start notifier")
    //            }
    //
    //        }
    //    }
    func readyController(){
        self.imageViewCvOutelet.allowsMultipleSelection = true
        self.imageViewCvOutelet.register(UINib(nibName: "ImageLoaderCell" , bundle: nil), forCellWithReuseIdentifier: "imageLoaderCells")
        uploadBtnOutlet.isEnabled = true
        hudProgress = JGProgressHUD()
        viewModel.isLoading.bind {[self] loading in
            if loading {
                hudProgress!.show(in: self.view)
            }
            else {
                hudProgress!.dismiss(afterDelay: 0.2, animated: true)
                
            }
        }
    }
    func bindingFunctions(){
        
        viewModel.loadImages {
            self.imageViewCvOutelet.reloadData()
        }
        self.viewModel.images.bind { data in
            DispatchQueue.main.async {
                if self.viewModel.images.value!.count > self.imageViewCvOutelet.numberOfItems(inSection: 0){
                    self.uploadBtnOutlet.isEnabled = true
                }
            }
        }
        
        self.viewModel.isLoading.bind { loading in
            DispatchQueue.main.async { [self] in
                if loading {
                    //hudProgress!.show(in: self.view)
                }
                else {
                    hudProgress!.dismiss(afterDelay: 0.3, animated: true)
                    
                }
            }
        }
        
    }
}
