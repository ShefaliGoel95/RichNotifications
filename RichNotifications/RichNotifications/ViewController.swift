//
//  ViewController.swift
//  RichNotifications
//
//  Created by Shefali Goel on 22/11/18.
//  Copyright © 2018 Shefali Goel. All rights reserved.
//

//MARK::- MODULES
import UIKit
import UserNotifications

//MARK::- ENUMERATIONS
enum NotificationType : Int{
    case text = 0
    case image = 1
    case video = 2
}

//MARK::- CLASS
class ViewController: UIViewController {
    
    //MARK::- OUTLETS
    @IBOutlet weak var removeButton: UIButton!
    @IBOutlet weak var notificationBodyField: UITextField!
    
    //MARK::- PROPERTIES
    var notificationBodyString = StringConstants.sampleBody.rawValue
    
    //MARK::- VIEW CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        notificationBodyField?.delegate = self
        UNUserNotificationCenter.current().delegate = self
        self.setNotificationCategories()
    }
    
    //MARK::- REGISTERING NOTIFICATION CATEGORIES
    private func setNotificationCategories() {
        
        
        //___________________DEFINE ACTIONS
        
        let likeAction = UNNotificationAction(identifier: Identifiers.like.rawValue , title: Titles.like.rawValue, options: [])
        let commentAction = UNTextInputNotificationAction(identifier: Identifiers.comment.rawValue, title: Titles.comment.rawValue, options: [])
        let questionAction = UNTextInputNotificationAction(identifier: Identifiers.question.rawValue, title: Titles.question.rawValue, options: [])
        let replyAction = UNNotificationAction(identifier: Identifiers.reply.rawValue, title: Titles.reply.rawValue, options: [])
        let archiveAction = UNNotificationAction(identifier: Identifiers.archive.rawValue, title: Titles.archive.rawValue, options: [])
        
        //__________________DEFINE CATEGORIES
        
        //“local” will be used to illustrate scheduling a local notification which has only a like action
        let localCat =  UNNotificationCategory(identifier: Identifiers.local.rawValue , actions: [likeAction], intentIdentifiers: [], options: [])
        
        //“recipe” for a recipe feed notification on which users might be able to comment in addition to liking the feed
        let customCat =  UNNotificationCategory(identifier: Identifiers.recipe.rawValue , actions: [likeAction, questionAction], intentIdentifiers: [], options: [])
        
        //“email” notification which has “archive” and “reply” actions.
        let emailCat =  UNNotificationCategory(identifier: Identifiers.email.rawValue , actions: [replyAction, archiveAction], intentIdentifiers: [], options: [])
        
        UNUserNotificationCenter.current().setNotificationCategories([localCat, customCat, emailCat])
        
        //UNNotificationAction  :  simple button clicks
        //UNTextInputNotificationAction  :  comment, will present a textfield docked above the keyboard.
        
    }
}



//MARK::- SENDING LOCAL NOTIFICATIONS
extension ViewController{
    
    
    @IBAction func onClickSendNotification(_ sender: AnyObject) {
        self.view.endEditing(true)
        notificationBodyField.resignFirstResponder()
        
        //MARK::-  STEP 1: Create the notification content
        let content = UNMutableNotificationContent()
        content.title = StringConstants.notificationTitle.rawValue
        content.subtitle = StringConstants.notificationSubtitle.rawValue
        if let characters = notificationBodyField?.text?.characters, let text = notificationBodyField.text , characters.count > 0 {
            content.body = text
        }else{
            content.body = notificationBodyString
        }
        content.categoryIdentifier = Identifiers.recipe.rawValue
        
        
        switch sender.tag{
        case NotificationType.text.rawValue :
            content.attachments = []
            
            
        case NotificationType.image.rawValue :
            guard let imageURL = URL(string: StringConstants.image.rawValue) else { return }
            guard let imageData = NSData(contentsOf: imageURL) else { return }
            guard let attachment = UNNotificationAttachment.create(imageFileIdentifier: Identifiers.imageId.rawValue, data: imageData, options: nil) else { return  }
            content.attachments = [attachment]
            
            
        case NotificationType.video.rawValue :
            guard let videoURL = URL(string: StringConstants.video.rawValue) else { return }
            guard let videoData = NSData(contentsOf: videoURL) else { return }
            guard let attachment = UNNotificationAttachment.create(imageFileIdentifier: Identifiers.videoId.rawValue, data: videoData, options: nil) else { return  }
            content.attachments = [attachment]
            
        
            
        default:
            break
            
        }
        
        
        //MARK::-  STEP 2: Create the trigger
        
        //Local notifications need to be triggered. Triggers are encapsulated by UNNotificationTrigger.
        //Types of triggers:
        //1. UNTimeIntervalNotificationTrigger — Schedules the notification after the specified time interval.
        //2. UNCalendarNotificationTrigger — Schedules the notification for a specified date.
        //3. UNLocationNotificationTrigger — Triggers the notification when a user enters a location specified by CLRegion.
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1 , repeats: false)
        
        
        //MARK::-  STEP 3: Initialize the notification request with the created trigger and content.
        let request = UNNotificationRequest(identifier: "localNotification", content: content, trigger: trigger)
        
        
        //MARK::- STEP 4: Add the notification request to the UNUserNotificationCenter.
        UNUserNotificationCenter.current().add(request) { (error) in
            print(error)
        }
        notificationBodyField?.text = ""
    }
}

//MARK::- TEXTFIELD DELEGATES
extension ViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

//MARK::- NOTIFICATION DELEGATES
extension ViewController : UNUserNotificationCenterDelegate{
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        if response.notification.request.identifier == "localNotification" {
            removeButton?.isEnabled = true
            completionHandler()
        }
    }
    
    //MARK::- Receiving Notifications While App is In Foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        removeButton?.isEnabled = true // temp
        completionHandler([.alert, .sound, .badge])
    }
}



//MARK::- UPDATING NOTIFICATIONS

// requires you to schedule a notification request with UNUserNotificationCenter.
// should have the same identifier as the notification you want to update
// will update the existing notification rather than cluttering the notification center.
// specified a 1 sec interval for the notification trigger. If user chooses to send a notification with a modified body before the notification is delivered, the old notification scheduled with the notification center will be updated.


extension ViewController{
    //same identifier logic
    
}


//MARK::- REMOVING NOTIFICATIONS
//can remove delivered notifications as well as pending ones sent by the application.
extension ViewController{
    
    
    @IBAction func onClickRemoveNotification(_ sender: AnyObject) {
        
        //As soon as the user chooses to send a notification, we enable the remove button.
        removeButton.isEnabled = false
        
        
        //get a list of delivered UNNotifications
        UNUserNotificationCenter.current().getDeliveredNotifications { (notifications) in
            
            //use the same to filter of assigned  identifier “localIdentifier” and check if our notification is delivered.
            let isLocal = notifications.contains(where: { (notification) -> Bool in
                return notification.request.identifier == "localNotification"
            })
            if isLocal {
                //remove a delivered notification
                UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers:  ["localNotification"])
            }else{
                //find out a list of pending notifications
                UNUserNotificationCenter.current().getPendingNotificationRequests(completionHandler: { (notificationRequests) in
                    
                    let isLocal = notificationRequests.contains(where: { (request) -> Bool in
                        return request.identifier == "localNotification"
                    })
                    
                    //remove a pending notification
                    if isLocal {
                        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["localNotification"])
                    }
                })
            }
        }
    }
}


//time interval must be at least 60 if repeating

//local notification : in which the app creates the notification details locally and passes it to device (“alerts for things that are happening in the background” )
//remote notification : that uses a server to push data to a user device by using the Apple Push Notification Service.(“alerts for things that happening immediately and involve a client/server relationship.”)

