//
//  Constants.swift
//  RichNotificationsDemo
//
//  Created by Shefali Goel on 21/11/18.
//  Copyright © 2018 Shefali Goel. All rights reserved.
//

import Foundation


enum StringConstants : String{
    case sampleBody = "No text body"
    case notificationTitle = "Survey"
    case notificationSubtitle = "Think and answer"
    case image = "https://i.stack.imgur.com/9z6nS.png"
    case video = "https://s3-us-west-2.amazonaws.com/notificationvideos/recipe2.mp4"
}


enum Identifiers : String{
    case like = "like"
    case comment = "comment"
    case reply = "reply"
    case archive = "archive"
    case local = "local"
    case recipe = "recipe"
    case email = "email"
    case imageId = "img.jpeg"
    case videoId = "video.mp4"
    case question = "question"
}

enum Titles : String {
    case like = "Like"
    case comment = "Comment"
    case reply = "Reply"
    case archive = "Archive"
    case question = "Do you like brownies?"
}

