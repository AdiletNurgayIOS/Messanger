//
//  ProfileViewController.swift
//  NewMessenger
//
//  Created by Adilet on 04.02.2025.
//

import UIKit
import FirebaseAuth

class ProfileViewController: UIViewController {

    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    let data = ["Log out"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Profile"
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ProfileTableViewCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(tableView)
        
        setConstraints()
        
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    

   

}


extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = data[indexPath.row]
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.textColor = .red
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let alert = UIAlertController(title: "", message: "Вы точно хотите выйти с аккаунта?", preferredStyle: .alert)
        let actionLeaveWithAccount = UIAlertAction(title: "Да", style: .destructive) { [weak self] _ in
            
            guard let strongSelf = self else { return }
            
            do {
                try FirebaseAuth.Auth.auth().signOut() // выходит с аккаунта
                let vc = LoginViewController()
                let nav = UINavigationController(rootViewController: vc)
                nav.modalPresentationStyle = .fullScreen
                strongSelf.present(nav, animated: true)
                
            } catch {
                print("Пользователь не смог выйти с аккаунта")
            }
        }
        let actionCancel = UIAlertAction(title: "Нет", style: .cancel)
        alert.addAction(actionLeaveWithAccount)
        alert.addAction(actionCancel)
        
        present(alert, animated: true)
    }
    
    
}
