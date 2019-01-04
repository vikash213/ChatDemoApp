//
//  ChatService.swift
//  DemoChatApp
//
//  Created by Vikash on 03/01/19.
//  Copyright © 2019 Vikash. All rights reserved.
//

import Foundation
import Scaledrone

class ChatService {
    private let scaledrone: Scaledrone
    private let messageCallback: (Message)-> Void
    
    private var room: ScaledroneRoom?
    
    init(member: Member, onRecievedMessage: @escaping (Message)-> Void) {
        self.messageCallback = onRecievedMessage
        self.scaledrone = Scaledrone(
            channelID: "KeWoOfAG2rIZuWxI", // Scaledrone channel id through their website. It will differ by yours
            data: member.toJSON)
        scaledrone.delegate = self
 
    }
    
    func connect() {
        scaledrone.connect()
    }
}

extension ChatService: ScaledroneDelegate {
    func scaledroneDidConnect(scaledrone: Scaledrone, error: NSError?) {
        print("Connected to Scaledrone")
        room = scaledrone.subscribe(roomName: "observable-room")
        room?.delegate = self
    }
    
    func scaledroneDidReceiveError(scaledrone: Scaledrone, error: NSError?) {
        print("Scaledrone error", error ?? "")
    }
    
    func scaledroneDidDisconnect(scaledrone: Scaledrone, error: NSError?) {
        print("Scaledrone disconnected", error ?? "")
    }
}


//To listen to new messages, there's one more protocol we need to implement: ScaledroneRoomDelegate.

extension ChatService: ScaledroneRoomDelegate {
    func scaledroneRoomDidConnect(room: ScaledroneRoom, error: NSError?) {
        print("Connected to room!")
    }
    
    func scaledroneRoomDidReceiveMessage(
        room: ScaledroneRoom,
        message: Any,
        member: ScaledroneMember?) {
        
        guard
            let text = message as? String,
            let memberData = member?.clientData,
            let member = Member(fromJSON: memberData)
            else {
                print("Could not parse data.")
                return
        }
        
        let message = Message(
            member: member,
            text: text,
            messageId: UUID().uuidString)
        messageCallback(message)
    }
    
    func sendMessage(_ message: String) {
        room?.publish(message: message)
    }
}
