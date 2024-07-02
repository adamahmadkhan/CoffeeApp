//
//  SideMenuCells.swift
//  CoffeeApp
//
//  Created by Adam Khan on 7/2/24.
//

import UIKit

class SideMenuCells: UITableViewCell {
    
    
    
    @IBOutlet weak var iconOutlet: UIImageView!
    @IBOutlet weak var titleOutlet: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
