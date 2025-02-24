//
//  AppDelegate.swift
//  NewMessenger
//
//  Created by Adilet on 02.02.2025.
//

import UIKit
import FirebaseCore
import GoogleSignIn

@main
class AppDelegate: UIResponder, UIApplicationDelegate {


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Сначала проверяем наличие файла конфигурации
        guard Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist") != nil else {
            print("Ошибка: GoogleService-Info.plist не найден")
            return true
        }
        
        // Конфигурируем Firebase
        FirebaseApp.configure()
        
        // Проверяем clientID
        if let clientID = FirebaseApp.app()?.options.clientID {
            print("ClientID успешно получен: \(clientID)")
            
            // Конфигурируем Google Sign In
            GIDSignIn.sharedInstance.configuration = GIDConfiguration(clientID: clientID)
        } else {
            print("❌ Ошибка: clientID не найден в GoogleService-Info.plist")
        }
        
        return true
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any]) -> Bool {
        return GIDSignIn.sharedInstance.handle(url)
    }
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

