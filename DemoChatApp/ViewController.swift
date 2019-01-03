//
//  ViewController.swift
//  DemoChatApp
//
//  Created by Appinventiv on 31/12/18.
//  Copyright © 2018 Vikash. All rights reserved.
//

import UIKit
import MessageKit
import MessageInputBar

class ViewController: MessagesViewController {

    var messages: [Message] = []
    var member: Member!
    var chatService: ChatService!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        member = Member(name: .randomName, color: .randomColor)
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messageInputBar.delegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        
        chatService = ChatService(member: member, onRecievedMessage: {
            [weak self] message in
            self?.messages.append(message)
            self?.messagesCollectionView.reloadData()
            self?.messagesCollectionView.scrollToBottom(animated: true)
        })
        
        chatService.connect()
        
    }


}

//  To update the view, as well as handle user interaction, we need to implement four protocols:
//
//    MessagesDataSource which provides the number and content of messages.
//    MessagesLayoutDelegate which provides height, padding and alignment for different views.
//    MessagesDisplayDelegate which provides colors, styles and views that define the look of the messages.
//    MessageInputBarDelegate which handles sending and typing new messages.

extension ViewController: MessagesDataSource {
    func numberOfSections(
        in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
    
    func currentSender() -> Sender {
        return Sender(id: member.name, displayName: member.name)
    }
    
    func messageForItem(
        at indexPath: IndexPath,
        in messagesCollectionView: MessagesCollectionView) -> MessageType {
        
        return messages[indexPath.section]
    }
    
    func messageTopLabelHeight(
        for message: MessageType,
        at indexPath: IndexPath,
        in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        
        return 12
    }
    
    func messageTopLabelAttributedText(
        for message: MessageType,
        at indexPath: IndexPath) -> NSAttributedString? {
        
        return NSAttributedString(
            string: message.sender.displayName,
            attributes: [.font: UIFont.systemFont(ofSize: 12)])
    }
}

//The next protocol we need to implement is the layout delegate. Since we're not customizing the layout, this will be really easy:


extension ViewController: MessagesLayoutDelegate {
    func heightForLocation(message: MessageType,
                           at indexPath: IndexPath,
                           with maxWidth: CGFloat,
                           in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        
        return 0
    }
}

//To implement the MessagesDisplayDelegate, we'll make sure we set the member's color as the background color of the avatar view.

extension ViewController: MessagesDisplayDelegate  {
    
    func configureAvatarView(
        _ avatarView: AvatarView,
        for message: MessageType,
        at indexPath: IndexPath,
        in messagesCollectionView: MessagesCollectionView) {
        
        let message = messages[indexPath.section]
        let color = message.member.color
        avatarView.backgroundColor = color
    }
}

//The last protocol we need to implement is the input bar delegate. This allows us to actually send a new message. For now, we'll just append the message onto the array. Later on we'll actually send it to Scaledrone.

extension ViewController: MessageInputBarDelegate {
    func messageInputBar(
        _ inputBar: MessageInputBar,
        didPressSendButtonWith text: String) {

//        let newMessage = Message(
//            member: member,
//            text: text,
//            messageId: UUID().uuidString)
//
//        messages.append(newMessage)
//        inputBar.inputTextView.text = ""
//        messagesCollectionView.reloadData()
//        messagesCollectionView.scrollToBottom(animated: true)
        
        chatService.sendMessage(text)
        inputBar.inputTextView.text = ""
    }
}
