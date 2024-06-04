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
    let connectivity: Connectivity = Connectivity()
    //let reachability = try! Reachability()
    var selected = [Int]()
    var viewModel = ImagePickerViewModel()
    var hudProgress: JGProgressHUD?
    var currentlyLoading = -1
    var currentlySelected: IndexPath?
    let storageRef = Storage.storage().reference()
    var  i = 0
    var totalImages = 0
    var allPhotos = PHFetchResult<PHAsset>()
    
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        //monitorConnection()
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
        viewModel.images.value?.count ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width/3 - 10 , height: 150)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageLoaderCells", for: indexPath) as! ImageLoaderCell
        cell.imageViewOutlet.image = viewModel.images.value?[indexPath.row]
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //            if let cell = collectionView.cellForItem(at: indexPath) as? ImageLoaderCell {
        //                cell.mainViewOutlet.backgroundColor = .green
        //            }
    }
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        //        selectedIndexes = self.imageViewCvOutelet.indexPathsForSelectedItems!
        //                if let cell = collectionView.cellForItem(at: indexPath) as? ImageLoaderCell {
        //                    cell.mainViewOutlet.backgroundColor = .white
        //               }
    }
    
    
    //MARK: Upload and firebase Functions
    @IBAction func uploadBtnPressed(_ sender: Any) {
        uploadBtnOutlet.isEnabled = false
        galleryBtnOutlet.isEnabled = false
        uploadImages()
    }
    func uploadImages() {
        guard i < viewModel.images.value!.count else {
                galleryBtnOutlet.isEnabled = true
                return
            }
            initialzeUpload()
        }
        
    func initialzeUpload() {
        let cell = imageViewCvOutelet.cellForItem(at: IndexPath(row: i, section: 0)) as? ImageLoaderCell
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
                    i += 1
                    uploadImages()
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
        uploadBtnOutlet.isEnabled = false
        hudProgress = JGProgressHUD()
        viewModel.isLoading.bind { data in
            //self.imageViewCvOutelet.reloadData()
        }
    }
    func bindingFunctions(){
        
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
                    hudProgress!.show(in: self.view)
                }
                else {
                    hudProgress!.dismiss(afterDelay: 0.3, animated: true)
                    
                }
            }
        }
        
    }
}
