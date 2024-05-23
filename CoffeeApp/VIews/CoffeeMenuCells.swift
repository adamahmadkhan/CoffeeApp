//
//  CoffeeMenuCells.swift
//  CoffeeApp
//
//  Created by Adam Khan on 4/17/24.
//

import UIKit

class CoffeeMenuCells: UICollectionViewCell {

    @IBOutlet weak var mainViewOutlet: UIView!
    @IBOutlet weak var subtitle: UILabel!
    @IBOutlet weak var titleOutlet: UILabel!
    @IBOutlet weak var priceOutlet: UILabel!
    
    @IBOutlet weak var imageOutlet: UIImageView!
    @IBOutlet weak var addCartBtnOutlet: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        mainViewOutlet.layer.cornerRadius = 10
        mainViewOutlet.clipsToBounds = true
        addCartBtnOutlet.layer.cornerRadius = 10
    }

}
