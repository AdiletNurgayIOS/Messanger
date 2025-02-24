//
//  ChatViewController.swift
//  NewMessenger
//
//  Created by Adilet on 12.02.2025.
//

import UIKit

class ChatViewController: UIViewController {

    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Chats"
    }
    


}
