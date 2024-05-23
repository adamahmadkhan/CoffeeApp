//
//  HomeScreenViewController.swift
//  CoffeeApp
//
//  Created by Adam Khan on 4/16/24.
//

import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import JGProgressHUD
import SkeletonView
import Kingfisher
import SDWebImage


class HomeScreenViewController: UIViewController,UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    
    
    //MARK: Outlets
    @IBOutlet weak var coffeeCategoryCvOutlet: UICollectionView!
    @IBOutlet weak var coffeeMenuCVOutlet: UICollectionView!
    @IBOutlet weak var topBarImageView: UIImageView!
    
    
    //MARK: Variable
    let db = Firestore.firestore()
    var hudProgress: JGProgressHUD?
    var viewModel = HomeScreenViewModel()
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topBarImageView.layer.cornerRadius = 20
        self.coffeeCategoryCvOutlet.register(UINib(nibName: "CoffeeTypesCell", bundle: nil), forCellWithReuseIdentifier: "CoffeeTypesCells")
        self.coffeeMenuCVOutlet.register(UINib(nibName: "CoffeeMenuCells", bundle: nil), forCellWithReuseIdentifier: "coffeMenuCell")
        viewModel.getAllProducts()
        viewModel.products.bind { data in
            print(data)
            self.coffeeMenuCVOutlet.reloadData()
        }
        viewModel.isLoading.bind { data in
            self.coffeeMenuCVOutlet.reloadData()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        viewModel.getAllProducts()
        coffeeMenuCVOutlet.reloadData()
        
        
//        Auth.auth().addStateDidChangeListener { auth, user in
//            let user = Auth.auth().currentUser
//            if let user = user {
//              
//              let uid = user.uid
//                print(uid)
//              let email = user.email
//                print(email)
//              }
//            
//            }
        }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == coffeeMenuCVOutlet{
            return viewModel.products.value?.count ?? 5
        }
        else{
            return 5
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == coffeeMenuCVOutlet {
            return CGSize(width: collectionView.frame.width/2 - 10 , height:240)
        }
        else
        {
            return CGSize(width: 30, height:  collectionView.frame.height)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if(collectionView == coffeeCategoryCvOutlet) {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CoffeeTypesCells", for: indexPath) as! CoffeeTypesCell
//            if indexPath.row == 1 {
//                cell.titleOutlet.text = "Adammmmmmmm"
//            }
            return cell
        }
        else {
            if viewModel.isLoading.value!{
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "coffeMenuCell", for: indexPath) as! CoffeeMenuCells
                cell.mainViewOutlet.showAnimatedGradientSkeleton()
                coffeeMenuCVOutlet.isScrollEnabled = false
                return  cell
            }
            else{
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "coffeMenuCell", for: indexPath) as! CoffeeMenuCells
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    cell.mainViewOutlet.stopSkeletonAnimation()
                    //cell.hideSkeleton(transition: .crossDissolve(0.5))
                    self.coffeeMenuCVOutlet.isScrollEnabled = true
                    self.coffeeMenuCVOutlet.reloadData()
                    cell.hideSkeleton()
                    
                }
                let cellData = viewModel.products.value![indexPath.item]
                cell.titleOutlet.text  = cellData.name
                cell.priceOutlet.text = cellData.price
                cell.imageOutlet.kf.indicatorType = .activity
                cell.imageOutlet.kf.setImage(with: URL(string: cellData.image!))
                cell.subtitle.text = "Default"
                
                return  cell
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == coffeeMenuCVOutlet {
            let detailScreenModal = self.storyboard?.instantiateViewController(identifier: "detailScreen") as! DetailsViewController
            detailScreenModal.productDetail = viewModel.products.value?[indexPath.item]
            detailScreenModal.modalTransitionStyle = .flipHorizontal
            detailScreenModal.modalPresentationStyle = .fullScreen
            self.present(detailScreenModal, animated: true)
        }
    }
    
  
}