//
//  AppDelegate.swift
//  gestionempresarial
//
//  Created by admin on 13/04/2017.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import CoreData
import Firebase
import Charts
import SlideMenuControllerSwift
import UserNotifications
import FirebaseMessaging

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate{
   
    var window: UIWindow?
   var ref: FIRDatabaseReference!
    let gcmMessageIDKey = "gcm.message_id"
    let titlwe = "google.c.a.c_l"
    let aps = "aps"
    let time = "google.c.a.ts"
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
            
            // For iOS 10 data message (sent via FCM)
           FIRMessaging.messaging().remoteMessageDelegate = self
            
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        
        FIRApp.configure()
        
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let loginViewController = storyboard.instantiateViewController(withIdentifier: "loginView") as! ViewController
        let leftViewController = storyboard.instantiateViewController(withIdentifier: "SideViewController") as! SideViewController
        
        let nvc: UINavigationController = UINavigationController(rootViewController: loginViewController)
        
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().barTintColor=UIColor(red: 44/255, green: 63/255, blue: 82/255, alpha: 1)
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        leftViewController.mainViewController = nvc
        
        let slideMenuController = ExSlideMenuController(mainViewController:nvc, leftMenuViewController: leftViewController)
        
        // slideMenuController.automaticallyAdjustsScrollViewInsets = true
        self.window?.backgroundColor = UIColor.gray
        self.window?.rootViewController = slideMenuController
        self.window?.makeKeyAndVisible()
        
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.tokenRefreshNotification),
                                               name: .firInstanceIDTokenRefresh,
                                               object: nil)
        
        return true
    }
    
    
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        
        print(userInfo)
        
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        
        print(userInfo)
       
        
        completionHandler(UIBackgroundFetchResult.newData)
    }
    
    func tokenRefreshNotification(_ notification: Notification) {
        if let refreshedToken = FIRInstanceID.instanceID().token() {
            print("InstanceID token: \(refreshedToken)")
        }
        connectToFcm()
    }
    
    func connectToFcm() {
        // Won't connect since there is no token
        guard FIRInstanceID.instanceID().token() != nil else {
            return
        }
        
        // Disconnect previous FCM connection if it exists.
        FIRMessaging.messaging().disconnect()
        
        FIRMessaging.messaging().connect { (error) in
            if error != nil {
                print("Unable to connect with FCM. \(error?.localizedDescription ?? "")")
            } else {
                print("Connected to FCM.")
                FIRMessaging.messaging().subscribe(toTopic: "news")
            }
        }
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Unable to register for remote notifications: \(error.localizedDescription)")
    }
    
    // This function is added here only for debugging purposes, and can be removed if swizzling is enabled.
    // If swizzling is disabled then this function must be implemented so that the APNs token can be paired to
    // the InstanceID token.
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("APNs token retrieved: \(deviceToken)")
        // With swizzling disabled you must set the APNs token here.
        // FIRInstanceID.instanceID().setAPNSToken(deviceToken, type: FIRInstanceIDAPNSTokenType.sandbox)
    }
    
    
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        //connectToFcm()
        print("redesign active")
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        print("background")
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        UIApplication.shared.applicationIconBadgeNumber = 0
        print("foreground")
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
       connectToFcm()
        UIApplication.shared.applicationIconBadgeNumber = 0
        print("active")
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "gestionempresarial")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    

}

@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {
    
    // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        // Print message ID.
//        ref = FIRDatabase.database().reference()
//        let messageID = userInfo[gcmMessageIDKey]
//        let title = userInfo[titlwe] as? NSString
//        let alert = userInfo[aps] as? NSDictionary
//        let body = alert?["alert"] as? NSString
//        let stamp = userInfo[time] as? String
//        let string : String = stamp! // (Put your string here)
//        
//        let timeinterval : TimeInterval = (string as NSString).doubleValue // convert it in to NSTimeInteral
//        
//        let dateFromServer = NSDate(timeIntervalSince1970:timeinterval)
//        let dateFormater : DateFormatter = DateFormatter()
//        dateFormater.dateFormat = "yyyy-MM-dd hh:mm"
//        let time1 = dateFormater.string(from: dateFromServer as Date)
//        ref.child("Notification/\(messageID!)").setValue([
//            "title":title!,
//            "body":body!,
//            "time":time1
//            
//        ])
        print("---------------userinfor-------------------")
        
        print(userInfo)
        print("---------------userinfor-------------------")
        
        // Change this to your preferred presentation option
        completionHandler([])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        // Print message ID.
//        ref = FIRDatabase.database().reference()
//        let messageID = userInfo[gcmMessageIDKey]
//        let title = userInfo[titlwe] as? NSString
//        let alert = userInfo[aps] as? NSDictionary
//        let body = alert?["alert"] as? NSString
//        let stamp = userInfo[time] as? String
//        let string : String = stamp! // (Put your string here)
//        
//        let timeinterval : TimeInterval = (string as NSString).doubleValue // convert it in to NSTimeInteral
//        
//        let dateFromServer = NSDate(timeIntervalSince1970:timeinterval)
//        let dateFormater : DateFormatter = DateFormatter()
//        dateFormater.dateFormat = "yyyy-MM-dd hh:mm"
//        let time1 = dateFormater.string(from: dateFromServer as Date)
//        ref.child("Notification/\(messageID!)").setValue([
//            "title":title!,
//            "body":body!,
//            "time":time1
//            
//            ])

        print("---------------!!!!!!!!!!!-------------------")
        print(userInfo)
        print("---------------!!!!!!!!!!-------------------")
        
        completionHandler()
    }
}
// [END ios_10_message_handling]
// [START ios_10_data_message_handling]
extension AppDelegate : FIRMessagingDelegate {
    // Receive data message on iOS 10 devices while app is in the foreground.
    func applicationReceivedRemoteMessage(_ remoteMessage: FIRMessagingRemoteMessage) {
        print(remoteMessage.appData)
    }
}




extension UIApplication {
    
    class func topViewController(_ viewController: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = viewController as? UINavigationController {
            return topViewController(nav.visibleViewController)
        }
        if let tab = viewController as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(selected)
            }
        }
        if let presented = viewController?.presentedViewController {
            return topViewController(presented)
        }
        
        if let slide = viewController as? SlideMenuController {
            return topViewController(slide.mainViewController)
        }
        return viewController
    }
}

