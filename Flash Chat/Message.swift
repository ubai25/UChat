//
//  Message.swift
//  Flash Chat
//
//  This is the model class that represents the blueprint for a message

class Message {
    
    init(senderIn : String, messageIn : String){
        sender = senderIn
        messageBody = messageIn
    }
    
    //TODO: Messages need a messageBody and a sender variable
    var sender : String = ""
    var messageBody : String = ""
    
    
}
