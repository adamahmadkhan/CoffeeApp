//
//  SideMenuViewController.swift
//  CoffeeApp
//
//  Created by Adam Khan on 7/2/24.
//

import UIKit

class SideMenuViewController: UIViewController,UITabBarDelegate,UITableViewDataSource {
   
    

    
    @IBOutlet weak var tableViewOutlet: UITableView!
    var onDismissedClosure: (() -> Void)?
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableViewOutlet.register(UINib(nibName: "SideMenuCells", bundle: nil), forCellReuseIdentifier: "sideMenu")
    }
    
    @IBAction func onCloseBtnClicked(_ sender: UIButton) {
        guard let _ = onDismissedClosure else { return }
        onDismissedClosure!()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "sideMenu", for: indexPath) as! SideMenuCells
        return cell
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
