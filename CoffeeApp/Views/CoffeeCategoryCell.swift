//
//  CoffeeTypesCell.swift
//  CoffeeApp
//
//  Created by Adam Khan on 4/16/24.
//

import UIKit

class CoffeeCategoryCell: UICollectionViewCell {

    @IBOutlet weak var titleOutlet: UILabel!
    @IBOutlet weak var mainViewOutlet: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        mainViewOutlet.layer.cornerRadius = 10
        
        
    }

}
