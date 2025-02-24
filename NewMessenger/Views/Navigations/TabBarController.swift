//
//  TabBarController.swift
//  NewMessenger
//
//  Created by Adilet on 12.02.2025.
//

import UIKit

final class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appearance = UITabBarAppearance()
        appearance.shadowColor = UIColor.lineTabBar
        
        tabBar.standardAppearance = appearance
           if #available(iOS 15.0, *) {
               tabBar.scrollEdgeAppearance = appearance
           }
        
        tabBar.tintColor =  UIColor.systemBlue
        tabBar.unselectedItemTintColor = UIColor.gray
        
        
        setupTabBar()
        
    }
    
    private func setupTabBar() {
        let chatViewController = ChatViewController()
        let profileViewController = ProfileViewController()
        
        
        guard let messageItemImage = UIImage(systemName: "message"),
        let profileItemImage = UIImage(systemName: "person") else {
            print("не сущесвует такой картинки")
            return
        }
        
        
        self.setViewControllers([
            createNavigationController(for: chatViewController, title: "Chats", image: messageItemImage),
            createNavigationController(for: profileViewController, title: "Profile", image: profileItemImage)
            
            
        ], animated: true)
    }
    
    private func createNavigationController(for rootViewController: UIViewController, title: String, image: UIImage) -> NavigationContoller {
        let navigationController = NavigationContoller(rootViewController: rootViewController)
        navigationController.tabBarItem.title = title
        navigationController.tabBarItem.image = image
        navigationController.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        return navigationController
    }
}
