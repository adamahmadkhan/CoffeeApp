//
//  CountryListViewModel.swift
//  CoffeeApp
//
//  Created by Adam Khan on 7/15/24.
//

import Foundation

class CountryListViewModel {
   // var countriesData:DynamicType<[Countries]> = DynamicType<[Countries]>()
    init() {
        
    }
    func parseJsonData(complition: @escaping ([Countries]) -> Void) {
       var countries = [Countries]()
        let path = Bundle.main.url(forResource: "countries", withExtension: "json")
        do {
            let data = try Data(contentsOf: path!)

            let json = try! JSONSerialization.jsonObject(with: data, options: [])
            guard let dictionary = json as? [String: [String: String]] else {
                print("Error: JSON is not a dictionary")
                return 
            }
            for (countryCode, countryInfo) in dictionary {
                let name = countryInfo["name"]
                let diallingCode = countryInfo["diallingCode"]
                let countryDetails = CountryDetails(name: name, diallingCode: diallingCode)
                let country = Countries(countryCode: countryCode, countryDetails: countryDetails)
                countries.append(country)
            }
        }
        
        catch {
            print("error:\(error)")
        }
        complition(countries)
    }
}

