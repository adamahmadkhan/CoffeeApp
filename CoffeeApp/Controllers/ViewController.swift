//
//  ViewController.swift
//  CoffeeApp
//
//  Created by Adam Khan on 4/16/24.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
//        let loginController = self.storyboard?.instantiateViewController(identifier: "GettingStartedViewController") as! GettingStartedViewController
//        self.navigationController?.pushViewController(loginController, animated: true)
        let gettingStartedViewController = storyboard?.instantiateViewController(identifier:"GettingStartedViewController") as! GettingStartedViewController
        navigationController?.pushViewController(gettingStartedViewController, animated: true)

        
    }


}

