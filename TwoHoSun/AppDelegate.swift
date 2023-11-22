//
//  AppDelegate.swift
//  TwoHoSun
//
//  Created by HyunwooPark on 10/29/23.
//

import UIKit
import UserNotifications
import os.log

class AppDelegate: UIResponder, UIApplicationDelegate {
    var app: TwoHoSunApp?
    let logger = Logger(subsystem: "com.twohosun.TwoHoSun", category: "PushNotifications")

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        logger.log("Application did finish launching with options: \(self.formatDictionary(launchOptions))")

        let center = UNUserNotificationCenter.current()
        center.delegate = self
        center.requestAuthorization(options: [.badge, .sound, .alert]) { granted, error in
            if let error = error {
                self.logger.error("Authorization request failed: \(error.localizedDescription)")
            } else {
                self.logger.log("Authorization granted: \(granted)")
            }
        }
        application.registerForRemoteNotifications()
        return true
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        logger.log("Registered for remote notifications with device token: \(deviceToken.map { String(format: "%02.2hhx", $0) }.joined())")
    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        logger.error("Failed to register for remote notifications: \(error.localizedDescription)")
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        logger.log("Received remote notification: \(self.formatDictionary(userInfo))")
        if let consumerType = userInfo["consumer_type_exist"] {
            UserDefaults.standard.setValue(consumerType, forKey: "haveConsumerType")
        }
        completionHandler(.newData)
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        logger.log("Will present notification in foreground: \(self.formatDictionary(notification.request.content.userInfo))")
        completionHandler([.banner, .sound]) // Updated for iOS 14 and later
    }

    private func formatDictionary(_ dictionary: [AnyHashable: Any]?) -> String {
        guard let dictionary = dictionary else { return "None" }
        return dictionary.map { key, value in
            "\(key): \(self.decodeUnicodeStringIfNeeded(String(describing: value)))"
        }.joined(separator: ", ")
    }

    private func decodeUnicodeStringIfNeeded(_ string: String) -> String {
        // 유니코드 이스케이프 시퀀스를 정상적인 문자열로 디코딩
        if let data = string.data(using: .utf8),
           let decodedString = String(data: data, encoding: .nonLossyASCII) {
            return decodedString
        } else {
            return string
        }
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse) async {
        print(response, "typeof\(type(of: response))")
        print(response.notification.request, "typeof\(type(of: response.notification.request))")
        print(response.notification.request.content, "typeof\(type(of: response.notification.request.content))")
        let decoder = JSONDecoder()
        do {
            let data = try JSONSerialization.data(withJSONObject: response.notification.request.content.userInfo)
            let notimodel = try decoder.decode(NotificationModel.self, from: data)
            if notimodel.isComment {
                NotificationCenter.default.post(name: Notification.Name("showComment"), object: nil)
            }
            await app?.handleDeepPush(notiModel: notimodel)
        } catch {
            print(error)
        }
    }
}
