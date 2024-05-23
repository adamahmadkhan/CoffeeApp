//
//  ApplicationSessionMannager.swift
//  CoffeeApp
//
//  Created by Adam Khan on 5/1/24.
//

import Foundation
import EasyStash
class ApplicationSessionMannager {
    
    static let shared = ApplicationSessionMannager()
    var storage : Storage!
    
    
    private init(){
        var options = Options()
        options.folder = "Users"
        storage = try! Storage(options: options)
    }
    func saveTokenData(tokenData : TokenResponseModel?) {
        if let tokenData{
            saveLoginState(login: true)
            try! storage.save(object: tokenData, forKey: "tokenData")
        }
    }
    func getTokendata() -> TokenResponseModel? {
        
        return (try? storage.load(forKey: "tokenData", as: TokenResponseModel.self)) ?? nil
    }
    
    func saveLoginState(login : Bool){
        try! storage.save(object: login, forKey: "loginState")
    }
    
    func getLoginState() -> Bool {
        let state = try? storage.load(forKey: "loginState", as: Bool.self)
        return state ?? false
    }
}
