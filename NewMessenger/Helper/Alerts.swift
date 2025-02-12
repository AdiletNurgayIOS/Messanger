//
//  Alerts.swift
//  NewMessenger
//
//  Created by Adilet on 04.02.2025.
//

import Foundation
import UIKit

public class Alerts {
    static let shared = Alerts()
    
    private init() {}
    
    func createDynamicAlert(on viewController: UIViewController, title: String, message: String, actionTitle: String) {
            let alert = UIAlertController(title: title,
                                          message: message,
                                          preferredStyle: .alert)
        let action = UIAlertAction(title: actionTitle, style: .cancel)
            alert.addAction(action)
            
        viewController.present(alert, animated: true)
        }
}
