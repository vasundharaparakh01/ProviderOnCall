//
//  AppDelegate.swift
//  AccessEMR
//
//  Created by Vasundhara Parakh on 2/25/20.
//  Copyright © 2020 smartData Enterprises (I) Ltd. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import UserNotifications
import Firebase
import FirebaseMessaging
import Messages
import CoreLocation
import GoogleMaps
import GooglePlaces

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    let gcmMessageIDKey = "gcm.message_id"
    var locationManager = CLLocationManager()
    var updatedLocation : CLLocation?
    func sharedInstance() -> AppDelegate{
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        //        let attr = NSDictionary(object: UIFont.PoppinsMedium(fontSize: 15), forKey: NSAttributedString.Key.font as NSCopying)
        //        UISegmentedControl.appearance().setTitleTextAttributes(attr as [NSObject : AnyObject] as [NSObject : AnyObject] as! [NSAttributedString.Key : Any] , for: .normal)
        
        
        
        UISegmentedControl.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.white, NSAttributedString.Key.font : UIFont.PoppinsMedium(fontSize: 17)], for: .selected)
        
        UISegmentedControl.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor :  Color.DarkGray, NSAttributedString.Key.font : UIFont.PoppinsMedium(fontSize: 17)], for: .normal)
        
        
        //Keyboard setting
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        
        //Push Notification using FCM
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { (success, error) in
                
            }
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        application.registerForRemoteNotifications()
        FirebaseConfiguration.shared.setLoggerLevel(.min)
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        
        
        if (CLLocationManager.locationServicesEnabled()) {
            self.locationManager.delegate = self
            
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
            self.locationManager.requestWhenInUseAuthorization()
            self.locationManager.startUpdatingLocation()
            
            //self.startMySignificantLocationChanges()

        } else {
            print("Location services are not enabled");
        }
        
        
        
        //For Google Map
        GMSPlacesClient.provideAPIKey(Key.Google.PlacesKey)
        GMSServices.provideAPIKey(Key.Google.PlacesKey)

        
        return true
    }
    
    func startMySignificantLocationChanges() {
        if !CLLocationManager.significantLocationChangeMonitoringAvailable() {
            print("Significnt plces not available");

            // The device does not support this service.
            return
        }
        self.locationManager.startMonitoringSignificantLocationChanges()
    }

    // MARK: UISceneSession Lifecycle
    
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
     func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
            let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
            // Print it to console
            print("APNs device token: \(deviceTokenString)")
            // Persist it in your backend in case it's new
//            UserDefaults.standard.setValue(deviceTokenString, forKey: UserDefaultKeys.udKey_deviceToken)
//            UserDefaults.standard.synchronize()
//            Messaging.messaging().apnsToken = deviceToken
        
        
        //FCN token
            let token = Messaging.messaging().fcmToken
            debugPrint("fcm token \(token ?? "")")
           
        }
        
        func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
            print("Couldn't register: \(error)")
            //Helper.printLog("Couldn't register: \(error)" as AnyObject?)
        }
        func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String) {
            debugPrint("NEW FCM Token:  ",fcmToken)
        }
        
        // Push notification received
        
        func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
          
            if let messageID = userInfo[gcmMessageIDKey] {
                print("Message ID 4: \(messageID)")
            }
            
            // Print full message.
            if  let notificationType = userInfo[AnyHashable("gcm.notification.type")] as? String,notificationType == "videocall"{
                
                NotificationCenter.default.post(name: Notification.Name(rawValue: "videoCall"), object: nil, userInfo: userInfo)
                
            }
        }
        func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
            
            self.application(application, didReceiveRemoteNotification: userInfo) { (UIBackgroundFetchResult) in
                print("rant")
            }
        }
        func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                         fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
            
            if let messageID = userInfo[gcmMessageIDKey] {
                print("Message ID 3: \(messageID)")
            }
            
            // Print full message.
            print(userInfo)
            if  let notificationType = userInfo[AnyHashable("gcm.notification.type")] as? String,notificationType == "videocall"{
                
                NotificationCenter.default.post(name: Notification.Name(rawValue: "videoCall"), object: nil, userInfo: userInfo)
                
            }
            completionHandler(UIBackgroundFetchResult.newData)
        }

    
}

extension AppDelegate : MessagingDelegate {
    // [START refresh_token]
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        debugPrint("Firebase registration token: \(fcmToken ?? "")")
        UserDefaults.standard.setValue(fcmToken ?? "", forKey: UserDefaultKeys.udKey_deviceToken)
        UserDefaults.standard.synchronize()
        //Messaging.messaging().apnsToken = fcmToken
        
    }
    
    // Receive data messages on iOS 10+ directly from FCM (bypassing APNs) when the app is in the foreground.
    // To enable direct data messages, you can set Messaging.messaging().shouldEstablishDirectChannel to true.
//    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
//        debugPrint("Received data message: (remoteMessage.appData)")
//    }
    
}
@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {
    
    // Receive displayed notifications for iOS 10 devices.
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID 2: \(messageID)")
        }
        
        // Print full message.
        if  let notificationType = userInfo[AnyHashable("gcm.notification.type")] as? String,notificationType == "videocall"{
            
            NotificationCenter.default.post(name: Notification.Name(rawValue: "videoCall"), object: nil, userInfo: userInfo)
            
        }
        
        completionHandler()
        
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                  willPresent notification: UNNotification,
                                  withCompletionHandler completionHandler:
          @escaping (UNNotificationPresentationOptions) -> Void) {
          completionHandler([.alert])}
}
//MARK:- CLLocationManagerDelegate
extension AppDelegate : CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location Error == \(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let loc = locations.first{
            print("Location Found == \(loc)")
            var shouldUpdate = false
            if let updateLoc = self.updatedLocation{
                if updateLoc.distance(from: loc) > 20
                {
                    shouldUpdate = true
                    print("Should update MAP")
                }else{
                    print("DONT update MAP")
                }
            }
            
            updatedLocation = loc
            if shouldUpdate {
                NotificationCenter.default.post(name: Notification.Name("UpdateLocation"), object: nil)
            }
            let address = CLGeocoder.init()
            address.reverseGeocodeLocation(CLLocation.init(latitude: loc.coordinate.latitude, longitude:loc.coordinate.longitude)) { (places, error) in
                if error == nil{
                    if let place = places{
                        print("Place ---- \(place.first)")
                    }
                }
            }
        }
    }
}
