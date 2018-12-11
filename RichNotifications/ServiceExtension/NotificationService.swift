//
//  NotificationService.swift
//  ServiceExtension
//
//  Created by Shefali Goel on 22/11/18.
//  Copyright © 2018 Shefali Goel. All rights reserved.
//

//MARK::- MODULES
import UserNotifications

//MARK::- CLASS
class NotificationService: UNNotificationServiceExtension {

    //MARK::- PROPERTIES
    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?

    

    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
        
        if let bestAttemptContent = bestAttemptContent {
            // Modify the notification content here...
            bestAttemptContent.title = "\(bestAttemptContent.title) [modified]"
            
            contentHandler(bestAttemptContent)
        }
        
        //use this if content is to be changed before displayed
        //downloadVideo()
        
    }
    
    override func serviceExtensionTimeWillExpire() {
        // Called just before the extension will be terminated by the system.
        // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
        if let contentHandler = contentHandler, let bestAttemptContent =  bestAttemptContent {
            contentHandler(bestAttemptContent)
        }
    }
    
//    private func downloadVideo() {
//        guard let urlString = bestAttemptContent?.userInfo["video-url"] as? String,
//            let url = URL(string: urlString) else { return }
//
//        downloader.downloadFile(from: url, to: videoLocation, completion: attachVideo)
//    }
//
//    private func attachVideo(videoLocation: URL?) {
//        guard let videoLocation = videoLocation,
//            let bestAttemptContent = bestAttemptContent else { return }
//
//        if let attachment = try? UNNotificationAttachment(identifier: "video",
//                                                          url: videoLocation) {
//            bestAttemptContent.attachments = [ attachment ]
//            self.contentHandler?(bestAttemptContent)
//        }
//    }

}
