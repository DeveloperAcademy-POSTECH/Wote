//
//  AppDelegate.swift
//  TwoHoSun
//
//  Created by HyunwooPark on 10/29/23.
//

import UIKit
import UserNotifications

class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    func application(_ application: UIApplication, 
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        // 푸시 알림을 위한 설정
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Request authorization failed: \(error)")
            } else {
                print("Authorization granted: \(granted)")
            }
        }
        application.registerForRemoteNotifications()
        return true
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // 디바이스 토큰 처리
        let tokenString = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
            print("Device Token: \(tokenString)")
//        print("Device Token: \(deviceToken)")
    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        // 푸시 알림 등록 실패 처리
        print("Failed to register for remote notifications: \(error)")
    }
    
    // UNUserNotificationCenterDelegate 메서드 구현
    // 예: func userNotificationCenter(_:willPresent:withCompletionHandler:) 등
}
