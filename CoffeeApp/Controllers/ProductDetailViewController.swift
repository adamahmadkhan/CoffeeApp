//
//  DetailsViewController.swift
//  CoffeeApp
//
//  Created by Adam Khan on 4/17/24.
//

import UIKit
import Kingfisher

class ProductDetailViewController: UIViewController {

    //MARK: Outlets
    @IBOutlet weak var bottomBarView: UIView!
    @IBOutlet weak var showMoreBtnOutlet: UIButton!
    @IBOutlet weak var descriptionMsgLabel: UILabel!
    @IBOutlet weak var nameOutlet: UILabel!
    @IBOutlet weak var subTitleOutlet: UILabel!
    @IBOutlet weak var imageOutlet: UIImageView!
    
    
    //MARK: Variables
    var productDetail : ProductModel?
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        readyController()
    }
    
    //MARK: Button calls
    @IBAction func showMoreBtnPressed(_ sender: UIButton) {
        showMoreBtnOutlet.isSelected = !showMoreBtnOutlet.isSelected
        if showMoreBtnOutlet.isSelected {
            descriptionMsgLabel.numberOfLines = 0
        }
        else {
            descriptionMsgLabel.numberOfLines = 3
        }
    }
    
    @IBAction func backBtnPressed(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    
    
    //MARK: User Define Functions
    func readyController(){
        descriptionMsgLabel.text = productDetail?.Description
        nameOutlet.text = productDetail?.name
        subTitleOutlet.text = "Default"
        imageOutlet.kf.setImage(with: URL(string: productDetail?.image ?? ""))
        bottomBarView.layer.cornerRadius = 25
        bottomBarView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        bottomBarView.layer.shadowColor = UIColor.black.cgColor
        bottomBarView.layer.shadowOpacity = 0.8
        bottomBarView.layer.shadowOffset = .zero
        bottomBarView.layer.shadowRadius = 10
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
