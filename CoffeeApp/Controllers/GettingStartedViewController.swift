//
//  LoginController.swift
//  CoffeeApp
//
//  Created by Adam Khan on 4/16/24.
//

import UIKit
import Firebase
class GettingStartedViewController: UIViewController {

    //MARK: Outlets
    @IBOutlet weak var getStartedBtnOutlet: UIButton!
    @IBOutlet weak var titleOutlet: UILabel!
    @IBOutlet weak var subTitleOutet: UILabel!
    
    //MARK: Variables
    var firebaseReference = DatabaseReference.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleOutlet.text = "Coffee so good,\n your taste buds\n will love it."
        subTitleOutet.text  = "The best grain, the\n finest roast, the powerful flavor."
        getStartedBtnOutlet.layer.cornerRadius = 20
        firebaseReference = Database.database().reference()
      
    }
    
    
    
    @IBAction func getStartedBtnPressed(_ sender: UIButton) {
        let AuthScreenController = self.storyboard?.instantiateViewController(identifier: "AuthScreenViewController" ) as! AuthScreenViewController
//        let data = [["name":"Coffee tea","price":3.7,"category":"tea"],["name":"dark tea","price":4.7,"category":"tea"],["new name":"Coffee tea","price":3.7,"category":"tea"],["price":4.7,"category":"tea"]] as [[String : Any]]
//        
//        firebaseReference.childByAutoId().updateChildValues(["coffee":data])
        self.navigationController?.pushViewController(AuthScreenController, animated: true)
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
