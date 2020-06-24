//
//  MessagesViewController.swift
//  MessagesExtension
//
//  Created by Neil Smyth on 10/10/16.
//  Copyright © 2016 eBookFrenzy. All rights reserved.
//

import UIKit
import Messages

class MessagesViewController: MSMessagesAppViewController {
    
    @IBOutlet weak var gridView: UIView!
    @IBOutlet var Buttons: [UIButton]!

    var gameStatus = [String](repeating: "-", count: 9)
    var currentPlayer: String = "X"
    var caption = "Want to play Tic-Tac-Toe?"
    var session: MSSession?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func buttonPressed(_ sender: AnyObject) {
        for (index, button) in Buttons.enumerated() {
            if button.isEqual(sender) {

                if gameStatus[index].isEqual("-") {
                    gameStatus[index] = currentPlayer
                    sender.setTitle(currentPlayer, for: .normal)
                    let url = prepareURL()
                    prepareMessage(url)

                }
            }
        }
    }

    func prepareMessage(_ url: URL) {


        if session == nil {
            session = MSSession()
        }

        let message = MSMessage(session: session!)

        let layout = MSMessageTemplateLayout()
        layout.caption = caption

        UIGraphicsBeginImageContextWithOptions(gridView.bounds.size, 
            gridView.isOpaque, 0);
        self.gridView.drawHierarchy(in: gridView.bounds, 
            afterScreenUpdates: true)

        layout.image = UIGraphicsGetImageFromCurrentImageContext()!;
        UIGraphicsEndImageContext();

        message.layout = layout
        message.url = url

        let conversation = self.activeConversation

        conversation?.insert(message, completionHandler: {(error) in
            if let error = error {
                print(error)
            }
        })

        self.dismiss()
    }

    func prepareURL() -> URL {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https";
        urlComponents.host = "www.ebookfrenzy.com";
        let playerQuery = URLQueryItem(name: "currentPlayer", 
                    value: currentPlayer)

        urlComponents.queryItems = [playerQuery]

        for (index, setting) in gameStatus.enumerated() {
            let queryItem = URLQueryItem(name: "position\(index)", 
                            value: setting)
            urlComponents.queryItems?.append(queryItem)
        }
        return urlComponents.url!
    }

    func decodeURL(_ url: URL) {

        let components = URLComponents(url: url, 
                resolvingAgainstBaseURL: false)

        for (index, queryItem) in (components?.queryItems?.enumerated())! {

            if queryItem.name == "currentPlayer" {
                currentPlayer = queryItem.value == "X" ? "O" : "X"
            } else if queryItem.value != "-" {
                gameStatus[index-1] = queryItem.value!
                Buttons[index-1].setTitle(queryItem.value!, for: .normal)
            }
        }
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Conversation Handling
    
    override func willBecomeActive(with conversation: MSConversation) {
        if let messageURL = conversation.selectedMessage?.url {
            decodeURL(messageURL)
        caption = "$\(conversation.localParticipantIdentifier.uuidString) made a move. It’s your Turn!"
            session = conversation.selectedMessage?.session
        }

        for (index, item) in gameStatus.enumerated() {
            if item != "-" {
                Buttons[index].setTitle(item, for: .normal)
            }
        }

    }
    
    override func didResignActive(with conversation: MSConversation) {
        // Called when the extension is about to move from the active to inactive state.
        // This will happen when the user dissmises the extension, changes to a different
        // conversation or quits Messages.
        
        // Use this method to release shared resources, save user data, invalidate timers,
        // and store enough state information to restore your extension to its current state
        // in case it is terminated later.
    }
   
    override func didReceive(_ message: MSMessage, conversation: MSConversation) {
        // Called when a message arrives that was generated by another instance of this
        // extension on a remote device.
        
        // Use this method to trigger UI updates in response to the message.
    }
    
    override func didStartSending(_ message: MSMessage, conversation: MSConversation) {
        // Called when the user taps the send button.
    }
    
    override func didCancelSending(_ message: MSMessage, conversation: MSConversation) {
        // Called when the user deletes the message without sending it.
    
        // Use this to clean up state related to the deleted message.
    }
    
    override func willTransition(to presentationStyle: MSMessagesAppPresentationStyle) {
        // Called before the extension transitions to a new presentation style.
    
        // Use this method to prepare for the change in presentation style.
    }
    
    override func didTransition(to presentationStyle: MSMessagesAppPresentationStyle) {
        // Called after the extension transitions to a new presentation style.
    
        // Use this method to finalize any behaviors associated with the change in presentation style.
    }

}
