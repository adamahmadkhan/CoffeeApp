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
    var viewModel = ChatScreenViewModel()
    var messages = [MessageDataModel]()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.messagesTableViewOutlet.register(UINib(nibName: "MessageTvCell", bundle: nil), forCellReuseIdentifier: "messageTvCell")
        self.messageBoxTextView.delegate = self
        viewModel.fetchMessages()
        
        viewModel.messages.bind { data in
            self.messages = data
            self.messagesTableViewOutlet.reloadData()
        }
    }

    
    
    
    @IBAction func sendBtnPressed(_ sender: UIButton) {
        if messageBoxTextView.text != "" &&  messageBoxTextView.text != nil
        {
            let time = DateFormatter.localizedString(from: Date(), dateStyle: .short, timeStyle: .short)
            viewModel.sendMessages(messageBoxTextView.text)
        }
        messageBoxTextView.text = ""
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "messageTvCell", for: indexPath) as! MessageTvCell
        cell.sendMessageViewOutlet.isHidden = false
        cell.sendMessageLabelOutlet.text = messages[indexPath.row].message
        cell.timeLabelOutet.text = messages[indexPath.row].time
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
