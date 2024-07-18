//
//  CountriesListTableViewCell.swift
//  CoffeeApp
//
//  Created by Adam Khan on 7/15/24.
//

import UIKit

class CountriesListTableViewCell: UITableViewCell {
    
    
    //MARK: OUTLETS
    @IBOutlet weak var countrySystemName: UILabel!
    @IBOutlet weak var codeLabel: UILabel!
    @IBOutlet weak var countryNameLabel: UILabel!
    @IBOutlet weak var mainViewOutlet: UIView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
