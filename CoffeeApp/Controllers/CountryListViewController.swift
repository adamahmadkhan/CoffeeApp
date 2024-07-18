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
    var countries = [CountriesModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.countriesTableViewOutlet.register(UINib(nibName: "CountriesListTableViewCell", bundle: nil), forCellReuseIdentifier: "countriesListTableViewCell")
        viewModel.parseJsonData { [self] data in
            print(data)
            countries = data
            countriesTableViewOutlet.reloadData()
        }
        countriesTableViewOutlet.estimatedRowHeight = 150
    }
    @IBAction func onBackClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "countriesListTableViewCell", for: indexPath) as! CountriesListTableViewCell
        let cellData = countries[indexPath.row]
        cell.codeLabel.text = cellData.countryCode
        cell.countryNameLabel.text = cellData.countryDetails?.name
        cell.countrySystemName.text = viewModel.getSystemName(countryCode: cellData.countryCode ?? "")
        cell.mainViewOutlet.backgroundColor = cell.countryNameLabel.text == cell.countrySystemName.text ? .lightGray : UIColor(red: 220/255.0, green: 90/255.0, blue: 90/255.0, alpha: 1)
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "countriesListTableViewCell") as! CountriesListTableViewCell
        cell.codeLabel.isHidden = true
        cell.countryNameLabel.text = "Total countries  Names \(countries.count)"
        cell.countrySystemName.text = "Total incorrect Names \(viewModel.totalIncorrectNames)"
        cell.mainViewOutlet.backgroundColor = .systemGray
        return cell.contentView
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
