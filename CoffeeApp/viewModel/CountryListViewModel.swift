//
//  CountryListViewModel.swift
//  CoffeeApp
//
//  Created by Adam Khan on 7/15/24.
//

import Foundation

class CountryListViewModel {
   // var countriesData:DynamicType<[Countries]> = DynamicType<[Countries]>()
    var totalIncorrectNames = 0
    init() {
        
    }
    func parseJsonData(complition: @escaping ([CountriesModel]) -> Void) {
       var correctCountriesNames = [CountriesModel]()
       var inCorrectCountriesNames = [CountriesModel]()
        let path = Bundle.main.url(forResource: "countries", withExtension: "json")
        do {
            let data = try Data(contentsOf: path!)
            let dictionary = try JSONDecoder().decode([String: CountryDetails].self, from: data)
            for (countryCode, countryInfo) in dictionary {
//                let name = countryInfo["name"]
//                let diallingCode = countryInfo["diallingCode"]
                let countryDetails = countryInfo
                let country = CountriesModel(countryCode: countryCode, countryDetails: countryDetails)
                if !( getSystemName(countryCode: countryCode) == countryDetails.name ) {
                    totalIncorrectNames += 1
                    inCorrectCountriesNames.append(country)
                    //                    print("name: \(country.countryDetails?.name)")
                    //                    print("system name \(getSystemName(countryCode: countryCode))")
                }
                else {
                    correctCountriesNames.append(country)
                }
            }
        }
        catch {
            print("error:\(error)")
        }
        complition(inCorrectCountriesNames+correctCountriesNames)
    }
    func getSystemName(countryCode: String) -> String? {
        let current = Locale(identifier: "en_US")
        return current.localizedString(forRegionCode: countryCode)
    }
}

