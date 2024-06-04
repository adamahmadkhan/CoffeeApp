//
//  ChatMessageViewController.swift
//  CoffeeApp
//
//  Created by Adam Khan on 5/31/24.
//

import UIKit

class ChatMessageViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    

    //MARK: Outlets
    @IBOutlet weak var messagesTableViewOutlet: UITableView!
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    
        self.messagesTableViewOutlet.register(UINib(nibName: "MessageTvCell", bundle: nil), forCellReuseIdentifier: "messageTvCell")
        
        // Do any additional setup after loading the view.
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "messageTvCell", for: indexPath) as! MessageTvCell
        cell.receivingViewOutlet.isHidden = false
        cell.sendingViewOutlet.isHidden = false
        if Int(indexPath.row) % 2 == 0{
            cell.receivingViewOutlet.isHidden = true
        }
        else {
            cell.sendingViewOutlet.isHidden = true
            cell.receivingMessage.text =  "Hello \n\n\n\n bye"
        }
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
