//
//  AddProduct.swift
//  CoffeeApp
//
//  Created by Adam Khan on 5/7/24.
//

import UIKit
import JGProgressHUD


class AddProductViewController: UIViewController, UITextViewDelegate,UITextFieldDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //MARK: Outlet
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var nameTfOutlet: UITextField!
    @IBOutlet weak var priceTfOutlet: UITextField!
    @IBOutlet weak var uploadedImage: UIImageView!
    
    
    
    
    //MARK: Variables
    var viewModel = AddProductViewModel()
    var hudProgress: JGProgressHUD?
    
    
    
    @IBOutlet weak var height: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        height.constant = descriptionTextView.contentSize.height
        descriptionTextView.delegate = self
        nameTfOutlet.delegate = self
        priceTfOutlet.delegate = self
        hudProgress = JGProgressHUD()
        viewModel.productName = nameTfOutlet.text
        viewModel.productDescription = descriptionTextView.text
        viewModel.productPrice = priceTfOutlet.text
        
        viewModel.isLoading.bind {[self] loading in
            if loading {
                hudProgress!.show(in: self.view)
            }
            else {
                hudProgress!.dismiss(afterDelay: 1, animated: true)
                
            }
        }
        
    }
    
    @IBAction func addProductPressed(_ sender: UIButton) {
        if let data = uploadedImage.image!.pngData() {
            viewModel.addCloudData(imageData: data)
            viewModel.getAllProducts { error, products in
                if error == nil {
//                    print(products!)
                }
            }
        }
        
    }
    
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
    
    @IBAction func addImagePressed(_ sender: UIButton) {
        let imageController = UIImagePickerController()
        imageController.delegate = self
        imageController.sourceType = UIImagePickerController.SourceType.photoLibrary
        self.present(imageController, animated: true)
    }
    
}
