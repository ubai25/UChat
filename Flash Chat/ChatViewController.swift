//
//  ViewController.swift
//  Flash Chat
//
//  Created by Angela Yu on 29/08/2015.
//  Copyright (c) 2015 London App Brewery. All rights reserved.
//

import UIKit
import Firebase
import ChameleonFramework


class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    // Declare instance variables here
    var messageArray : [Message] = [Message]()
    
    // We've pre-linked the IBOutlets
    @IBOutlet var heightConstraint: NSLayoutConstraint!
    @IBOutlet var sendButton: UIButton!
    @IBOutlet var messageTextfield: UITextField!
    @IBOutlet var messageTableView: UITableView!
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        //TODO: Set yourself as the delegate and datasource here:
        messageTableView.delegate = self
        messageTableView.dataSource = self
        
        
        //TODO: Set yourself as the delegate of the text field here:
        messageTextfield.delegate = self
        
        
        //TODO: Set the tapGesture here:
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tableViewTapped))
        messageTableView.addGestureRecognizer(tapGesture)

        //TODO: Register your MessageCell.xib file here:
        messageTableView.register(UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: "customMessageCell")
        
        configureTableView()
        retrieveMessage()
        
        messageTableView.separatorStyle = .none
    }

    ///////////////////////////////////////////
    
    //MARK: - TableView DataSource Methods
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customMessageCell", for: indexPath) as! CustomMessageCell
        
        let messageData = messageArray[indexPath.row]
        
        cell.messageBody.text = messageData.messageBody
        cell.senderUsername.text = messageData.sender
        cell.avatarImageView.image = UIImage(named: "egg")
        
        if(messageData.sender == Auth.auth().currentUser?.email){
            cell.avatarImageView.backgroundColor = UIColor.flatPowderBlueColorDark()
            cell.messageBackground.backgroundColor = UIColor.flatPowderBlue()
        }else{
            cell.avatarImageView.backgroundColor = UIColor.flatBlueColorDark()
            cell.messageBackground.backgroundColor = UIColor.flatBlue()
        }
        
        return cell
    }
    
    
    //TODO: Declare cellForRowAtIndexPath here:
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageArray.count
    }
    
    
    //TODO: Declare numberOfRowsInSection here:
    
    
    
    //TODO: Declare tableViewTapped here:
    @objc func tableViewTapped(){
        messageTextfield.endEditing(true)
    }
    
    
    //TODO: Declare configureTableView here:
    func configureTableView(){
        messageTableView.rowHeight = UITableView.automaticDimension
        messageTableView.estimatedRowHeight = 120.0
    }
    
    
    ///////////////////////////////////////////
    
    //MARK:- TextField Delegate Methods
    
    

    
    //TODO: Declare textFieldDidBeginEditing here:
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        UIView.animate(withDuration: 0.3) {
            self.heightConstraint.constant = 355
            self.view.layoutIfNeeded()
        }
    }
    
    
    
    //TODO: Declare textFieldDidEndEditing here:
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        UIView.animate(withDuration: 0.3) {
            self.heightConstraint.constant = 50
            self.view.layoutIfNeeded()
        }
    }

    
    ///////////////////////////////////////////
    
    
    //MARK: - Send & Recieve from Firebase
    
    
    
    
    
    @IBAction func sendPressed(_ sender: AnyObject) {
        
        if(!messageTextfield.text!.isEmpty){
            
            messageTextfield.isEnabled = false
            sendButton.isEnabled = false
            
            let messageDB = Database.database().reference().child("messages")
            let messagedata = ["sender" :  Auth.auth().currentUser?.email, "message" : messageTextfield.text!]
            
            messageDB.childByAutoId().setValue(messagedata){
                (error, reference) in
                
                if(error != nil){
                    print("ERROR : \(error!)")
                }else{
                    print("Message Sent!")
                    self.messageTextfield.isEnabled = true
                    self.sendButton.isEnabled = true
                    self.messageTextfield.text = ""
                }
            }
        }
    }
    
    //TODO: Create the retrieveMessages method here:
    
    func retrieveMessage(){
        let messageDb = Database.database().reference().child("messages")
        
        messageDb.observe(.childAdded) { snapshot in
            
            let snapshotValue = snapshot.value as! Dictionary<String,String>
            let sender = snapshotValue["sender"]!
            let message = snapshotValue["message"]!
            
            let messagedata = Message(senderIn: sender, messageIn: message)
            
            self.messageArray.append(messagedata)
            self.messageTableView.reloadData()
        }
    }

    
    
    
    @IBAction func logOutPressed(_ sender: AnyObject) {
        
        //TODO: Log out the user and send them back to WelcomeViewController
        
        
    }
    


}
