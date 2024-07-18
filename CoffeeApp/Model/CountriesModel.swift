//
//  Countries.swift
//  CoffeeApp
//
//  Created by Adam Khan on 7/15/24.
//

import Foundation

struct CountriesModel: Codable {
    let countryCode: String?
    let countryDetails: CountryDetails?
}
struct CountryDetails: Codable{
    let name: String?
    let diallingCode: String?
}
