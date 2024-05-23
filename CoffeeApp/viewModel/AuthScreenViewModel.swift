//
//  AuthScreenViewModel.swift
//  CoffeeApp
//
//  Created by Adam Khan on 4/22/24.
//

import Foundation
import Firebase
import GoogleSignIn

class AuthScreenViewModel{
    private var username:String?
    private var password:String?
    var isErrorMsgHidden = DynamicType<Bool>()
    var isLogin = DynamicType<Bool>()
    var errorMsg = DynamicType<String>()
    var isLoading: DynamicType<Bool> = DynamicType<Bool>()
    
    
    
    
    
    init() {
        self.isErrorMsgHidden.value = true
        self.isLogin.value = false
    }
    func setUsername(username:String){
        self.username = username
    }
    func setPassword(password:String){
        self.password = password
    }
    func checkUserCredientials(){
        isLoading.value = true
    Auth.auth().signIn(withEmail: username ?? "" , password: password ?? "", completion: { [self]
            result, error in
            
            isLoading.value = false
            if error == nil {
              
               
                let userToken = TokenResponseModel(token: "", refreshToken: result!.user.refreshToken!)
                ApplicationSessionMannager.shared.saveTokenData(tokenData: userToken)
                self.isErrorMsgHidden.value = true
                self.isLogin.value = true
            }
            else {
                print(error!)
                if let error  = error as? NSError{
                    print(error.code)
                    if let firebaseError = FirebaseAuthError(rawValue: error.code)
                    {
                        errorMsg.value = firebaseError.description
                    }
                    else  {
                        errorMsg.value = "Unknown error"
                    }
//                    if error.code == 17008{
//                        print("Email Error")
//                    }
                }
                self.isErrorMsgHidden.value = false
            }
        })
        
    }
    func signInWithGoogle(GIDSignInResult result:  GIDSignInResult?){
        isLoading.value = true
        guard let user = result?.user, let idToken = user.idToken?.tokenString
        else {
         return
        }

        let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: user.accessToken.tokenString)
       

        Auth.auth().signIn(with: credential) { [self] result, error in
            if error == nil
            {
                isLoading.value = false
                let userToken = TokenResponseModel(token: user.accessToken.tokenString, refreshToken: result?.user.refreshToken)
                print(userToken.token!)
                ApplicationSessionMannager.shared.saveTokenData(tokenData: userToken)
                isLogin.value = true
            }
        }
      }
    
    
   
    
    
    func accountCreation(){
        isLoading.value = true
        Auth.auth().createUser(withEmail: username ?? "", password: password ?? "", completion: { [self] result, error in
            if error == nil {
                isLoading.value = false
                print (result!)
                let userToken = TokenResponseModel(token: "", refreshToken: result!.user.refreshToken!)
                ApplicationSessionMannager.shared.saveTokenData(tokenData: userToken)
                self.isErrorMsgHidden.value = true
                self.isLogin.value = true
            }
            else {
                print(error!)
                if let error  = error as? NSError{
                    print(error.code)
                    if let firebaseError = FirebaseAuthError(rawValue: error.code)
                    {
                        errorMsg.value = firebaseError.description
                    }
                    else  {
                        errorMsg.value = "Unknown error"
                    }
//                    if error.code == 17008{
//                        print("Email Error")
//                    }
                }
                self.isErrorMsgHidden.value = false
            }
            
        })
        
    }
}

enum FirebaseAuthError: Int {
    case invalidEmail = 17008
    case userNotFound = 17011
    case emailAlreadyInUse = 17007
    case passwordMismatch = 17009
    case emailNotFound = 17004
    case shortPassword = 17026
    
    
    var description: String {
        switch self {
        case .invalidEmail:
            return "The email address is badly formatted."
        case .userNotFound:
            return "There is no user record corresponding to this identifier. The user may have been deleted."
        case .emailAlreadyInUse:
            return "The email address is already in use by another account."
        case .passwordMismatch:
            return "The password is invalid or the user does not have a password."
        case .emailNotFound:
            return "Invalid User Credientials"
        case .shortPassword:
            return  "The password must be 6 characters long or more"
        }
    }
}





