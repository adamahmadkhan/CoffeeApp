//
//  AddProduct.swift
//  CoffeeApp
//
//  Created by Adam Khan on 5/7/24.
//

import UIKit
import JGProgressHUD
import GoogleMobileAds


class AddProductViewController: UIViewController, UITextViewDelegate,UITextFieldDelegate,UIImagePickerControllerDelegate, GADFullScreenContentDelegate, UINavigationControllerDelegate {
    
    //MARK: Outlet
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var nameTfOutlet: UITextField!
    @IBOutlet weak var priceTfOutlet: UITextField!
    @IBOutlet weak var uploadedImage: UIImageView!
    @IBOutlet weak var height: NSLayoutConstraint!
    @IBOutlet weak var outterView: UIView!
    @IBOutlet weak var innerView: UIView!
    
    //MARK: Variables
    var viewModel = AddProductViewModel()
    var hudProgress: JGProgressHUD?
    var interstitial: GADInterstitialAd?
    
    
    

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        readyController()
        bindlingFunctions()
        Task {
            await loadAd()
            
            //interstitial?.present(fromRootViewController: self)
        }
       
    }
    override func viewWillDisappear(_ animated: Bool) {
        interstitial?.present(fromRootViewController: self)
    }
    
 
    //MARK: Buttons calls
    @IBAction func addProductPressed(_ sender: UIButton) {
        if let data = uploadedImage.image!.pngData() {
            viewModel.addCloudData(imageData: data)
            viewModel.getAllProducts { error, products in
                if error == nil {
                    print(products!)
                }
            }
        }
        
    }
    
    @IBAction func addImagePressed(_ sender: UIButton) {
        let imageController = UIImagePickerController()
        imageController.delegate = self
        imageController.sourceType = UIImagePickerController.SourceType.photoLibrary
        self.present(imageController, animated: true)
    }
    
    //MARK: TextFields
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField == nameTfOutlet
        {
            viewModel.productName = nameTfOutlet.text
        }
        else if textField == priceTfOutlet
        {
            viewModel.productPrice = priceTfOutlet.text
            
        }
    }
    
    
    func textViewDidChange(_ textView: UITextView) {
        height.constant = textView.contentSize.height
        viewModel.productDescription = descriptionTextView.text
    }
    
    
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            uploadedImage.image = image
        }
        self.dismiss(animated: true)
       
    }
    
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        Task{
            await loadAd()
        }
    }
    func adWillDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
       
    }
    
    func readyController() {
        height.constant = descriptionTextView.contentSize.height
        descriptionTextView.delegate = self
        nameTfOutlet.delegate = self
        priceTfOutlet.delegate = self
        hudProgress = JGProgressHUD()
        viewModel.productName = nameTfOutlet.text
        viewModel.productDescription = descriptionTextView.text
        viewModel.productPrice = priceTfOutlet.text
        
    }
    func loadAd() async {
        do {
              interstitial = try await GADInterstitialAd.load(withAdUnitID: "ca-app-pub-3940256099942544/5135589807", request: GADRequest())
              interstitial?.fullScreenContentDelegate = self
            } catch {
              print("Failed to load interstitial ad with error: \(error.localizedDescription)")
            }
    }
    func bindlingFunctions(){
        viewModel.isLoading.bind {[self] loading in
            if loading {
                hudProgress!.show(in: self.view)
            }
            else {
                hudProgress!.dismiss(afterDelay: 1, animated: true)
                interstitial?.present(fromRootViewController: self)
            }
        }
    }
}
