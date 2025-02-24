//
//  ConversationsViewController.swift
//  NewMessenger
//
//  Created by Adilet on 04.02.2025.
//

import UIKit
import FirebaseAuth

class ConversationsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        validateAuth()
    }
    
    private func validateAuth() {
        if FirebaseAuth.Auth.auth().currentUser == nil {
            let vc = LoginViewController()
            let nav = UINavigationController(rootViewController: vc)
            nav.modalPresentationStyle = .fullScreen
            present(nav, animated: false )
        } else {
            let vc = TabBarController()
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: false)
        }
    }

}
