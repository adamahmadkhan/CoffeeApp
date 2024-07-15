//
//  CountryListViewController.swift
//  CoffeeApp
//
//  Created by Adam Khan on 7/15/24.
//

import UIKit

class CountryListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
   
    

    @IBOutlet weak var countriesTableViewOutlet: UITableView!
    let viewModel = CountryListViewModel()
    var countries = [Countries]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.countriesTableViewOutlet.register(UINib(nibName: "CountriesListTableViewCell", bundle: nil), forCellReuseIdentifier: "countriesListTableViewCell")
        viewModel.parseJsonData { [self] data in
            print(data)
            countries = data
            countriesTableViewOutlet.reloadData()
        }
    }
    @IBAction func onBackClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "countriesListTableViewCell", for: indexPath) as! CountriesListTableViewCell
        cell.codeLabel.text = countries[indexPath.row].countryCode
        cell.countryNameLabel.text = countries[indexPath.row].countryDetails?.name
        cell.countrySystemName.text = getCountryName(countryCode:  countries[indexPath.row].countryCode ?? "" )
        return cell
    }
    func getCountryName(countryCode: String) -> String? {
        let current = Locale(identifier: "en_US")
        return current.localizedString(forRegionCode: countryCode)
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
