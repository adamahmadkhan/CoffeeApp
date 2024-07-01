//
//  MessageDataModel.swift
//  CoffeeApp
//
//  Created by Adam Khan on 7/1/24.
//

import Foundation

struct MessageDataModel {
    var message:String?
    var time:String?
    var sender:String?
    var reciever:String?
    
    func toDictionary() -> [String: Any] {
            return [
                "message": message!,
                "time": time!,
                "sender": sender!,
                "reciever": reciever!
            ]
        }
}
