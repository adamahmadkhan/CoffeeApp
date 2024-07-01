//
//  chatMessageViewModel.swift
//  CoffeeApp
//
//  Created by Adam Khan on 6/27/24.
//

import Foundation
import FirebaseCore
import Firebase


class ChatScreenViewModel {
    
    var messages:DynamicType<[MessageDataModel]> = DynamicType<[MessageDataModel]>()
    //    var recieverMessages = DynamicType<String>()
    let ref = Database.database().reference()
    
    init(){
        observeMessages()
    }
    
    func sendMessages(_ message: String){
        let time = "\(DateFormatter.localizedString(from: Date(), dateStyle: .short, timeStyle: .short))"
        let messageDict = MessageDataModel(message: message, time: time, sender: "adam", reciever: "reciever").toDictionary() as NSDictionary
        self.ref.child("Messages").childByAutoId().setValue(messageDict)
        
    }
    func recieveMessages(_ message: String){
        
    }
    func fetchMessages() {
        ref.child("Messages").getData { [self] error, snapshot in
            if let error = error {
                print("Error fetching data: \(error)")
                return
            }
            
            if let snapshotData = snapshot?.value as? [String: Any] {
                let messagesData = snapshotData.compactMap{ data in
                    let messageData = data.value as? [String:Any]
                    let message = messageData?["message"] as? String
                    let time = messageData?["time"] as? String
                    let sender = messageData?["sender"] as? String
                    let reciver = messageData?["reciever"] as? String
                    return MessageDataModel(message: message, time: time, sender: sender, reciever: reciver)
                }
                self.messages.value = messagesData
            } else {
                print("No messages found or data is not in expected format")
            }
        }
    }
    func observeMessages() {
        ref.child("Messages").observe(.childAdded) { snapshot in
            if let messageData = snapshot.value as? [String:Any] {
                let message = messageData["message"] as? String
                let time = messageData["time"] as? String
                let sender = messageData["sender"] as? String
                let reciver = messageData["reciever"] as? String
                self.messages.value?.append(MessageDataModel(message: message, time: time, sender: sender, reciever: reciver))
            }
            
            
            }
        }
    }
 
