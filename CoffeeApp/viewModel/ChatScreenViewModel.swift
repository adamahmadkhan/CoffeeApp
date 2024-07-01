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
        
    }
    
    func sendMessages(_ message: String){
        self.ref.child("Messages").childByAutoId().setValue(message)
        
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
                    let message = data.value as? String
                    return MessageDataModel(message: message, time: "", sender: "", reciever: "")
                }
                self.messages.value = messagesData
            } else {
                print("No messages found or data is not in expected format")
            }
        }
    }

}
