//
//  Message.swift
//  DemoChatApp
//
//  Created by Appinventiv on 31/12/18.
//  Copyright © 2018 Vikash. All rights reserved.

import Foundation
import UIKit
import MessageKit

struct Member {
    let name: String
    let color: UIColor
    let image: String
}

struct Message {
    let member: Member
    let text: String
    let messageId: String
}

extension Member {
    var toJSON: Any {
        return [
            "name": name,
            "color": color.hexString,
            "image": image
        ]
    }
    
    init?(fromJSON json: Any) {
        guard
            let data = json as? [String: Any],
            let name = data["name"] as? String,
            let hexColor = data["color"] as? String,
            let image = data["image"] as? String
            else {
                print("Couldn't parse Member")
                return nil
        }
        
        self.name = name
        self.color = UIColor(hex: hexColor)
        self.image = image
    }
}

extension Message: MessageType {
    var sender: Sender {
        return Sender(id: member.name, displayName: member.name)
    }
    
    var sentDate: Date {
        return Date()
    }
    
    var kind: MessageKind {
        return .text(text)
    }
}
