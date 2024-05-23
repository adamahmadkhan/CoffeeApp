//
//  AuthViewController.swift
//  CoffeeApp
//
//  Created by Adam Khan on 4/22/24.
//

import UIKit
import GoogleSignIn
import JGProgressHUD
import FirebaseCore
import FirebaseAuth


class AuthScreenViewController: UIViewController,UITextFieldDelegate {
    
    
    
    //MARK: Outlets
    @IBOutlet weak var usernameTfOutlet: UITextField!
    @IBOutlet weak var invalidLoginMsg: UILabel!
    @IBOutlet weak var passwordTfOutlet: UITextField!
    
    
    //MARK: Variables
    var viewModel = AuthScreenViewModel()
    var hudProgress: JGProgressHUD?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        readyController()
        
        
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField == usernameTfOutlet {
            viewModel.setUsername(username:usernameTfOutlet.text ?? "" )
        }
        if textField == passwordTfOutlet  {
            viewModel.setPassword(password: passwordTfOutlet.text ?? "" )
        }
    }
    
    @IBAction func loginBtnPressed(_ sender: UIButton) {
        viewModel.checkUserCredientials()
    }
    
    
    @IBAction func createBtnPressed(_ sender: UIButton) {
        viewModel.accountCreation()
    }
    
    @IBAction func signInWithGooglePressed(_ sender: UIButton) {
        signInWithGoogle()
    }
    
    
    func readyController(){
        hudProgress = JGProgressHUD()
        usernameTfOutlet.delegate = self
        passwordTfOutlet.delegate = self
        viewModel.isErrorMsgHidden.bind { [self] Bool in
            invalidLoginMsg.isHidden = Bool
        }
        viewModel.isLogin.bind { [self] Bool in
            if Bool {
                let homeTabViewController = storyboard?.instantiateViewController(identifier:"homeTabBarController") as! UITabBarController
                navigationController?.pushViewController(homeTabViewController, animated: true)
            }
        }
        viewModel.errorMsg.bind { errorMessage in
            self.invalidLoginMsg.text = errorMessage
        }
        viewModel.isLoading.bind {[self] loading in
            if loading {
                hudProgress!.show(in: self.view)
            }
            else {
                hudProgress!.dismiss(afterDelay: 1, animated: true)
                
            }
        }
        
        
    }
    
    func signInWithGoogle(){
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        GIDSignIn.sharedInstance.configuration = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.signIn(withPresenting: self) {  result, error in
            if error == nil {
                self.viewModel.signInWithGoogle(GIDSignInResult: result)
            }
            else {
                print(error!)
            }
            
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
}
