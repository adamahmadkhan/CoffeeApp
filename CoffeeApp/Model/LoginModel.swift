//
//  LoginModel.swift
//  CoffeeApp
//
//  Created by Adam Khan on 5/1/24.
//

import Foundation

struct TokenResponseModel: Codable {
    var token:String?
    var refreshToken:String?
}
