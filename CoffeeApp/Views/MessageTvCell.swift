//
//  MessageTvCell.swift
//  CoffeeApp
//
//  Created by Adam Khan on 5/31/24.
//

import UIKit

class MessageTvCell: UITableViewCell {

    @IBOutlet weak var receivingViewOutlet: UIView!
    @IBOutlet weak var receivingMessage: UILabel!
    
    @IBOutlet weak var sendingViewOutlet: UIView!
    @IBOutlet weak var sendingMessage: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        sendingViewOutlet.layer.cornerRadius = 20
        receivingViewOutlet.layer.cornerRadius = 20
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
