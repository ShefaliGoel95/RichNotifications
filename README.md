# RichNotifications
The new iOS 10 allows to customise the UI for notifications to match the look and feel of the application, attach a static or animated (gif) image, or even a video to push notifications and add action buttons to notifications and a provision to input some text. It will be displayed right in the notification when the user force-taps it.

TOPICS COVERED:

PERMISSION HANDLING:

For app to be able to send notifications to the device, it should ask permissions to the user.
Add requestAuthorization in didFinishLaunchingWithOptions function of AppDelegate. (The function requestAuthorization will request the user permissions to send notifications related to the app. UNAuthorizationOptions( badge , sounds , alert , etc) let you define which permissions you want to grant to the app.)


NOTIFICATION ACTIONS:
iOS notifications can include actions which let you perform a functionality on a button click, or even comment and reply to a text message.
Types of Notification Actions:
1. UNNotificationAction : All actions which are simple button clicks 
2. UNTextInputNotificationAction : Any comment action which will present a textfield docked above the keyboard.


REGISTERING NOTIFICATION CATEGORIES:
Different notifications might have different actions. If you can send text messages as well as an email conversation from your app, the actions you have to respond to when you receive each of these kinds of messages would be different. Hence we have notification categories.


LOCAL NOTIFICATION WITH ATTACHMENTS:
Steps to send local notifications from your app using UserNotifications.

STEP 1: Create the notification content
UNMutableNotificatonContent encapsulates the content associated with the notification.

title : of type string indicates the title of the notification ( “Survey” in the sample )
subtitle : of type string indicates the title of the notification ( “Think and answer ” in the sample )
body : of type string indicates the body of the notification ( Enter in the textfield or “No body text” is set as default in sample )
categoryIdentifier : of type string indicates to which category the notification belongs. 
attachments: of type [UNNotificationAttachment]  specifies any attachments you want to make to the notification like an image or video. We specify the url to an image on the device. UNNotificationAttachment encapsulates your attachment.


STEP 2. Create the trigger 
Local notifications need to be triggered. Triggers are encapsulated by UNNotificationTrigger.
There are 3 types of triggers:
•	UNTimeIntervalNotificationTrigger — Schedules the notification after the specified time interval.
•	UNCalendarNotificationTrigger — Schedules the notification for a specified date.
•	UNLocationNotificationTrigger — Triggers the notification when a user enters a location specified by CLRegion.


STEP 3. Initialize the notification request with the created trigger and content.
Initialize UNNotificationRequest with a unique identifier for your notification.The same identifier is to be used in case the notification is to be updated or removed.

STEP 4.Add the notification request to the UNUserNotificationCenter.
Invoke add function to the UNUserNotificationCenter for the current application . This call will schedule your notification with the notification center.

DELEGATES:
didReceive : This delegate method gets called whenever the app is opened in the foreground after receiving the notification.
willPresent : Earlier iOS did not have a provision to receive notifications for a specific app when app was in the foreground. This can now be achieved


UPDATING NOTIFICATIONS:
Updating notifications requires you to schedule a notification request with UNUserNotificationCenter. 
This notification request should have the same identifier as the notification you want to update.
In the sample project , we are only sending notifications with a single identifier. So when a new notification is received, it will update the existing notification rather than cluttering the notification center.
We have specified a 1 sec interval for the notification trigger. If user chooses to send a notification with a modified body before the notification is delivered, the old notification scheduled with the notification center will be updated.


REMOVING NOTIFICATIONS:
You can remove delivered notifications as well as pending ones sent by the application.

Delivered : 

If the notification has already been delivered, it is encapsulated by a UNNotification. 
1. Get list of delivered notifications : You can get a list of delivered UNNotifications using the method getDeliveredNotifications
2. Filter and check : We can use the same identifier to filter and check if our notification is delivered.
3. We can remove a delivered notification using removeDeliveredNotifications


Pending :

If our notification is in the pending list, the notification still remains as a UNNotificationRequest since it hasn’t been delivered. 
1. Find out a list of pending notifications using getPendingNotificationRequests
2. Remove a pending notification by removePendingNotificationRequests



REMOTE NOTIFICATIONS AND ATTACHMENTS:
The sample is demonstrating only the local notifications as the method for enabling your app to receive remote notifications is not unfamiliar. 

Attachments can also be made to remote notifications but as maximum payload that can be sent with a push notification is 4kb so to attach files of the order of few mbs, we use Notification Service Extension.



EXTENSIONS : 


Notification Service Extension

As in iOS 10 Apple introduced the possibility to modify content of the remote notification. 
Since we need to add videos and images to our notification, and that certainly doesn’t fit the payload, we will need to download the media separately and add it to the notification.
To download the media and present it in the notification, we need to add Notification Service Extension to our project. 

Addition :
Xcode contains the template of Notification Service Extension target with a subclass of the UNNotificationServiceExtension class which provides all the necessary methods for customizing the content before it is displayed to the user.
To add the extension, in Xcode, we need to go to File -> New -> Target and select Notification Service Extension

Files :
Once you create the service extension, you get a 
1. Info.plist 
2. NotificationService.swift

Methods :
1. didReceive(_:withContentHandler:) method :
make all the changes to the notification content
this method will be called only for remote notifications with apps’ dictionary that include the `mutable-content` key with the value set to 1. 
Also, the method has limited amount of time to perform the download task and execute the provided completion block. 

2. serviceExtensionTimeWillExpire() method :
If the method does not finish in time, the system will call the serviceExtensionTimeWillExpire() method to give us one last chance to submit the changes. If we do not update the notification content before time expires, the system will display the original content.


Notification Content Extension

For customizing the notification interface you need Notification Content Extension.

Files :
Once you create the content extension, you get 
1. MainInterface.storyboard,
2. NotificationViewController.swift
3. Info.plist

Info.plist should indicate to which category the notification interface you are trying to customize belongs.
UNNotificationExtensionCategory — Specifies the category to which our notification content extension belongs. Only if the notification being delivered is of the category specified here, will the content extension be invoked.
UNNotificationExtensionDefaultContentHidden — A default content consisting of title, subtitle, body is shown underneath the customized UI. If you are already displaying these in your custom UI, you can hide it here.
UNNotificationExtensionContentSizeRatio — Specifies the size of the notification. If 1 , width and height will be the same. You override this by using preferredContentSize or autolayout constraints.


In the MainInterface.storyboard you drag the necessary elements and make the outlet connections to NotificationViewController.
As any other view controller, NotificationViewController has a viewDidLoad() where any population can be done.


NotificationViewController should extend UNNotificationContentExtension so that it can populate content in the notification based on the content received as part of the notification.


DELEGATES :
1. func didReceive(UNNotificaton) is called when notification arrives. This is where your content should be populated.
2. func didReceive(response : UNNotificationResponse) is to perform any functionality when user clicks on one of the actions
