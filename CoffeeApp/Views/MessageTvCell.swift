//
//  MessageTvCell.swift
//  CoffeeApp
//
//  Created by Adam Khan on 5/31/24.
//

import UIKit

class MessageTvCell: UITableViewCell {
    @IBOutlet weak var sendMessageViewOutlet: UIView!
    @IBOutlet weak var sendMessageLabelOutlet: UILabel!
    @IBOutlet weak var timeLabelOutet: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        sendMessageViewOutlet.layer.cornerRadius = 10
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
