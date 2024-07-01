//
//  ChatMessageViewController.swift
//  CoffeeApp
//
//  Created by Adam Khan on 5/31/24.
//

import UIKit

class ChatScreenViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextViewDelegate {
    
    

    //MARK: Outlets
    @IBOutlet weak var messagesTableViewOutlet: UITableView!
    
    //MARK: variables
    @IBOutlet weak var messageBoxTextView: UITextView!
    var viewModel = ChatMessageViewModel()
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.messagesTableViewOutlet.register(UINib(nibName: "MessageTvCell", bundle: nil), forCellReuseIdentifier: "messageTvCell")
        self.messageBoxTextView.delegate = self
        viewModel.messages.bind { data in
            print(data)
            self.messagesTableViewOutlet.reloadData()
        }
        viewModel.messageObserver { data in
            print(data)
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        viewModel.messageObserver { data in
            print(data)
        }
    }
    
    
    
    @IBAction func sendBtnPressed(_ sender: UIButton) {
        if messageBoxTextView.text != "" &&  messageBoxTextView.text != nil
        {
            viewModel.sendMessages(messageBoxTextView.text)
        }
        messageBoxTextView.text = ""
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.messages.value?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "messageTvCell", for: indexPath) as! MessageTvCell
        cell.receivingViewOutlet.isHidden = true
        cell.sendingViewOutlet.isHidden = false
        cell.sendingMessage.text = viewModel.messages.value?[indexPath.row].message
//        if Int(indexPath.row) % 2 == 0{
//            cell.receivingViewOutlet.isHidden = true
//        }
//        else {
//            cell.sendingViewOutlet.isHidden = true
//            cell.receivingMessage.text =  "Hello \n\n\n\n bye"
//        }
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
