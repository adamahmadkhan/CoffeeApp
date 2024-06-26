//
//  googleAdsCells.swift
//  CoffeeApp
//
//  Created by Adam Khan on 6/21/24.
//

import UIKit
import GoogleMobileAds

class GoogleAdsCells: UICollectionViewCell {
    
    @IBOutlet weak var addBannerViewOutlet: UIView!
    
    let banner: GADBannerView = {
        let banner = GADBannerView()
        banner.adUnitID = "ca-app-pub-3940256099942544/2435281174"
        banner.load(GADRequest())
        return banner
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
//        banner.rootViewController = self
        
        banner.backgroundColor = .secondarySystemFill
        addBannerViewOutlet.addSubview(banner)
        banner.frame = CGRect(x: 0, y: 0, width: addBannerViewOutlet.bounds.width, height: addBannerViewOutlet.bounds.height)
    }

}
