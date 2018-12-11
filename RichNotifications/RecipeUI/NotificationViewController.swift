//
//  NotificationViewController.swift
//  RecipeUI
//
//  Created by Shefali Goel on 22/11/18.
//  Copyright © 2018 Shefali Goel. All rights reserved.
//

//MARK::- MODULES
import UIKit
import UserNotifications
import UserNotificationsUI


//MARK::- CLASS
class NotificationViewController: UIViewController {
    
    //MARK::- OUTLETS
    @IBOutlet var titleLabel: UILabel?
    @IBOutlet var subtitleLabel: UILabel?
    @IBOutlet var descriptionLabel: UILabel?
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet var resultLabel: UILabel?
    @IBOutlet weak var playerView: PlayerView!
    @IBOutlet weak var constraintImageViewHeight: NSLayoutConstraint!
    
    //MARK::- PROPERTIES
    var videoPlayer : VideoPlayer?
    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?
    private lazy var urlSession: URLSession = URLSession()

    //MARK::- VIEW CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}


//MARK::- UNNOTIFICATION CONTENT EXTENSION
// extend UNNotificationContentExtension so that it can populate content in the notification based on the content received as part of the notification.
extension NotificationViewController : UNNotificationContentExtension{
    
    //called when action is performed
    func didReceive(_ response: UNNotificationResponse, completionHandler completion: @escaping (UNNotificationContentExtensionResponseOption) -> Void) {
        if response.actionIdentifier == Identifiers.like.rawValue {
            resultLabel?.text = Messages.like.rawValue
            completion(.doNotDismiss)
        }else if response.actionIdentifier == Identifiers.question.rawValue {
            resultLabel?.text = Messages.answer.rawValue + ((response as? UNTextInputNotificationResponse)?.userText ?? "" )
            completion(.doNotDismiss)
        }else{
            completion(.dismiss)
        }
    }
    

    //called when notification arrives. This is where your content should be populated.
    func didReceive(_ notification: UNNotification) {
        let bestAttemptContent = (notification.request.content.mutableCopy() as? UNMutableNotificationContent)
        if let bestAttemptContent = bestAttemptContent {
            
            
            if bestAttemptContent.categoryIdentifier == Identifiers.recipe.rawValue {
                
                
                titleLabel?.text = bestAttemptContent.title
                subtitleLabel?.text = bestAttemptContent.subtitle
                descriptionLabel?.text = bestAttemptContent.body
                let attachment = bestAttemptContent.attachments.first
                
                
                
                //use passed urls in case of remote notifications
                
                let imageStr = "https://i.stack.imgur.com/9z6nS.png"
                let videoStr = "https://s3-us-west-2.amazonaws.com/notificationvideos/recipe2.mp4"             
                
                if attachment?.identifier == Identifiers.imageId.rawValue {
                    //guard let imageurl = attachment?.url else { return }
                    let imageurl = URL(string: imageStr)
                    if let data = try? Data(contentsOf: imageurl!){
                        self.imageView?.image = UIImage(data: data)
                    }
                    self.playerView?.isHidden = true
                    self.constraintImageViewHeight?.constant = 200
                    
                }else if attachment?.identifier == Identifiers.videoId.rawValue {
                    let videoURL = URL(string: videoStr)
                    //guard let videoURL = attachment?.url else { return }
                    self.videoPlayer = VideoPlayer(url: videoURL!)
                    self.videoPlayer?.setUpPlayerInView(view: self.playerView)
                    self.videoPlayer?.play()
                    self.playerView?.isHidden = false
                    self.constraintImageViewHeight.constant = 200
                    
                }else{
                    self.constraintImageViewHeight?.constant = 0
                }
                
            }
        }
    }
}

