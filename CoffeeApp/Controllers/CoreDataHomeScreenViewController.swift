//
//  CoreDataHomeScreenViewController.swift
//  CoffeeApp
//
//  Created by Adam Khan on 7/10/24.
//

import UIKit

class CoreDataHomeScreenViewController: UIViewController,UITextFieldDelegate {
    
    
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        emailTextField.delegate = self
        
    }
    
    @IBAction func onBackClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
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
