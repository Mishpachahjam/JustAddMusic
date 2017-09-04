//
//  AppDelegate.swift
//  bridge
//
//  Created by Konstantin Yurchenko on 11/7/16.
//  Copyright © 2016 Konstantin Yurchenko. All rights reserved.
//

import UIKit
import CoreData
import FBSDKCoreKit
import CoreLocation
import UserNotifications

enum NotificationType: Int {
    case BRIDGE_NOTIFICATION_TEST = 0
    case BRIDGE_NOTIFICATION_NEW_MESSAGE = 1
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate  {
    
    var window: UIWindow?
    
    var navigation_controller: UINavigationController!
    var activity_view_controller: ViewController_Activity!
    var is_debug_mode_on: Bool = false
    
    var me: User = User(id: 0, email: "", auth_token: "", is_student: false, is_instructor: false, location: CLLocation())
    var push_token: String = ""
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        self.initialize_notification_services(application: application)
        
        window = UIWindow(frame: UIScreen.main.bounds)
        if let window = window {
            window.backgroundColor = UIColor.white
            
            self.navigation_controller = UINavigationController(rootViewController: ViewController_Login())
            self.navigation_controller.setNavigationBarHidden(true, animated: false)
            window.rootViewController = self.navigation_controller
            
            if (UserDefaults.standard.string(forKey: "auth_token") != nil) {
                let view_controller = ViewController_UserProfile()
                view_controller.profile_data = self.load_login_data()
                self.navigation_controller.pushViewController(view_controller, animated: false)
            }
            
            window.makeKeyAndVisible()
        }
        
        return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(
            application,
            open: url,
            sourceApplication: sourceApplication,
            annotation: annotation)
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }
    
    // MARK: PUSH NOTIFICATIONS
    func initialize_notification_services(application: UIApplication) -> Void {
        print("initialize_notification_services")
        
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        center.requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            // Enable or disable features based on authorization.
        }
        application.registerForRemoteNotifications()
    }
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("deviceToken: \(deviceToken)")
        self.push_token = self.convert_device_token_to_string(deviceToken: deviceToken as NSData)
        print("push_token: \(self.push_token)")
        
        if (UserDefaults.standard.string(forKey: "auth_token") != nil) {
            self.update_push_token_for_user()
        }
    }
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Device token for push notifications: FAIL -- ")
        print(error.localizedDescription)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,  willPresent notification: UNNotification, withCompletionHandler   completionHandler: @escaping (_ options:   UNNotificationPresentationOptions) -> Void) {
        print("Handle push from foreground")
        print("\(notification.request.content.userInfo)")
        
        let notification_type = notification.request.content.userInfo["notification_type"] as! Int
        print(notification_type)
        
        if let aps = notification.request.content.userInfo["aps"] as? NSDictionary{
            if let alert = aps["alert"] as? String {
                switch notification_type {
                case NotificationType.BRIDGE_NOTIFICATION_NEW_MESSAGE.rawValue:
                    if (self.navigation_controller.topViewController is ViewController_MessageUser) {
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refresh_message_stream_scroll_view"), object: nil)
                    } else {
                        self.show_alert(message: alert)
                    }
                default:
                    break
                }
            }
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("Handle push from background or closed")
        // if you set a member variable in didReceiveRemoteNotification, you  will know if this is from closed or background
        print("\(response.notification.request.content.userInfo)")
    }
    
    func show_alert(message: String) {
        let alert = UIAlertController(title: "Bridge Alert", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
        self.navigation_controller.topViewController?.present(alert, animated: true, completion: nil)
    }
    
    private func convert_device_token_to_string(deviceToken: NSData) -> String {
        var device_token_string = deviceToken.description.replacingOccurrences(of: ">", with: "")
        device_token_string = device_token_string.replacingOccurrences(of: "<", with: "")
        device_token_string = device_token_string.replacingOccurrences(of: " ", with: "")
        return device_token_string
    }
    func update_push_token_for_user() {
        print("update_push_token_for_user")
        
        let parameters = NSMutableDictionary()
        parameters.setValue(self.me.id, forKey: "id")
        parameters.setValue(self.push_token, forKey: "push_token")
        
        print(self.me.auth_token)
        
        RestAPIClient.sharedInstance.update_user(parameters: parameters) { response in
            if let error_code = response["error_code"] {
                if error_code as! Int == 0 {
                    print("ok")
                } else {
                    print("error")
                }
            }
        }
    }
    // MARK: PUSH NOTIFICATIONS
    
    // MARK: View Controllers
    func show_activity_view_controller(message: String) {
        if let topViewController = UIApplication.topViewController() {
            self.activity_view_controller = ViewController_Activity()
            topViewController.navigationController?.pushViewController(self.activity_view_controller, animated: false)
        }
    }
    func show_account_type_selection(facebook_data: NSDictionary) {
        let view_controller = ViewController_AccountTypeSelection()
        
        view_controller.facebook_data = facebook_data
        
        if let topViewController = UIApplication.topViewController() {
            topViewController.navigationController?.pushViewController(
                view_controller,
                animated: false
            )
        }
    }
    func remove_activity_view_controller() {
        sleep(1)
        
        self.navigation_controller.popViewController(animated: false)
        //        if let topViewController = UIApplication.topViewController() {
        //            topViewController.navigationController?.popViewController(animated: false)
        //        }
    }
    // MARK: View Controllers
    
    // MARK: Login Data
    func save_login_data(data: NSDictionary) {
        UserDefaults.standard.set(self.me.id, forKey: "user_id")
        UserDefaults.standard.set(self.me.auth_token, forKey: "auth_token")
        UserDefaults.standard.set(self.me.is_instructor, forKey: "is_instructor")
        UserDefaults.standard.set(self.me.is_student, forKey: "is_student")
        UserDefaults.standard.set(self.me.profile_id, forKey: "profile_id")
        
        UserDefaults.standard.set(self.me.facebook_picture_url, forKey: "facebook_picture_url")
        UserDefaults.standard.set(self.me.facebook_last_name, forKey: "facebook_last_name")
        UserDefaults.standard.set(self.me.facebook_first_name, forKey: "facebook_first_name")
        
        print(data)
        
        UserDefaults.standard.set(data, forKey: "profile_data")
        
        UserDefaults.standard.synchronize()
    }
    func load_login_data() -> NSDictionary {
        self.me.id = UserDefaults.standard.integer(forKey: "user_id")
        self.me.auth_token = UserDefaults.standard.string(forKey: "auth_token")!
        self.me.is_instructor = UserDefaults.standard.bool(forKey: "is_instructor")
        self.me.is_student = UserDefaults.standard.bool(forKey: "is_student")
        self.me.profile_id = UserDefaults.standard.integer(forKey: "profile_id")
        
        self.me.facebook_last_name = UserDefaults.standard.string(forKey: "facebook_last_name")!
        self.me.facebook_first_name = UserDefaults.standard.string(forKey: "facebook_first_name")!
        self.me.facebook_picture_url = UserDefaults.standard.string(forKey: "facebook_picture_url")!
        
        return UserDefaults.standard.object(forKey: "profile_data") as! NSDictionary
    }
    func clear_login_data() {
        UserDefaults.standard.removeObject(forKey: "user_id")
        UserDefaults.standard.removeObject(forKey: "auth_token")
        UserDefaults.standard.removeObject(forKey: "is_instructor")
        UserDefaults.standard.removeObject(forKey: "is_student")
        UserDefaults.standard.removeObject(forKey: "profile_data")
        UserDefaults.standard.synchronize()
    }
    // MARK: Login Data
    
    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "bridge")
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

extension UIApplication {
    class func topViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(base: selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        return base
    }
}

let kDatabaseTimeStringFormat:String = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"

extension Date {
    func dateFromISO8601String(dateString: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale!
        dateFormatter.dateFormat = kDatabaseTimeStringFormat
        
        return dateFormatter.date(from: dateString)! as Date
    }
}

