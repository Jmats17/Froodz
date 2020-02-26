//
//  PushNotificationService.swift
//  Froodz
//
//  Created by Justin Matsnev on 2/25/20.
//  Copyright © 2020 Justin Matsnev. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseMessaging
import UIKit
import UserNotifications

class PushNotificationService: NSObject, MessagingDelegate, UNUserNotificationCenterDelegate {
    
    var user = User.current
    
    override init() {
        super.init()
    }
    func registerForPushNotifications() {
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
            // For iOS 10 data message (sent via FCM)
            Messaging.messaging().delegate = self
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(settings)
        }
        UIApplication.shared.registerForRemoteNotifications()
        updateFirestorePushTokenIfNeeded()
    }
    func updateFirestorePushTokenIfNeeded() {
        if let token = Messaging.messaging().fcmToken {
            let usersRef = Firestore.firestore().collection("Users").document(user.documentId)
            usersRef.setData(["fcmToken": token], merge: true)
            user.fcmToken = token
            User.setCurrent(user, writeToUserDefaults: true)
        }
    }
    static func subscribeToTopic(topic: String) {
        Messaging.messaging().subscribe(toTopic: "\(topic)") { (err) in
            if let error = err {
                print(error.localizedDescription)
            } else {
                print("success")
            }
        }
    }
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        print(remoteMessage.appData)
    }
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        updateFirestorePushTokenIfNeeded()
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print(response)
    }
    
    static func sendPushNotification(to topic: String, title: String, body: String) {
        let urlString = "https://fcm.googleapis.com/fcm/send"
        let url = NSURL(string: urlString)!
        let paramString: [String : Any] = ["to" : "/topics/\(topic)",
                                           "notification" : ["title" : title, "body" : body]
        ]
        let request = NSMutableURLRequest(url: url as URL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.setValue("key=AAAAYfDwCoA:APA91bFlj70OvSUH8kMRDvVGcDTsN6-HXBwPiIixAAWnUpO-r2K4Dn_1cg2gpXmSO1TIrz6D65bRGskSKL8N2OEdGuwl29vanfOQC90juSYOg5byQVxDZN0DfpzQKBpiUs8FhFm6dAvQ", forHTTPHeaderField: "Authorization")
        request.httpBody = try? JSONSerialization.data(withJSONObject:paramString, options: [.prettyPrinted])

        let task =  URLSession.shared.dataTask(with: request as URLRequest)  { (data, response, error) in
            do {
                if let jsonData = data {
                    if let jsonDataDict  = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.allowFragments) as? [String: AnyObject] {
                        NSLog("Received data:\n\(jsonDataDict))")
                    }
                }
            } catch let err as NSError {
                print(err.debugDescription)
            }
        }
        task.resume()
    }
}
