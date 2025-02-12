//
//  RegisterViewController.swift
//  Massanger
//
//  Created by Adilet on 28.01.2025.
//

import UIKit
import PhotosUI
import AVFoundation
import Photos
import TOCropViewController
import FirebaseAuth

class RegisterViewController: UIViewController, UINavigationControllerDelegate {
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.clipsToBounds = true
        return scrollView
    }()
    
    
    public let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person.crop.circle.fill")
        imageView.tintColor = .gray
        imageView.layer.cornerRadius = 65 
        imageView.clipsToBounds = true
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor.lightGray.cgColor
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    
    private var  firstNameField: UITextField = {
        let textField = UITextField()
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.returnKeyType = .continue
        textField.layer.cornerRadius = 12
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.placeholder = "First Name..."
        textField.keyboardType = .emailAddress
        
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        textField.leftViewMode = .always
        textField.backgroundColor = .white
        return textField
    }()
    
    private var  lastNameField: UITextField = {
        let textField = UITextField()
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.returnKeyType = .continue
        textField.layer.cornerRadius = 12
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.placeholder = "Last Name..."
        textField.keyboardType = .emailAddress
        
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        textField.leftViewMode = .always
        textField.backgroundColor = .white
        return textField
    }()
    
    private var  emailField: UITextField = {
        let textField = UITextField()
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.returnKeyType = .continue
        textField.layer.cornerRadius = 12
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.placeholder = "Email Address..."
        textField.keyboardType = .emailAddress
        
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        textField.leftViewMode = .always
        textField.backgroundColor = .white
        return textField
    }()
    
    private var  passwordField: UITextField = {
        let textField = UITextField()
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.returnKeyType = .done
        textField.layer.cornerRadius = 12
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.placeholder = "Password..."
        
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        textField.leftViewMode = .always
        textField.backgroundColor = .white
        textField.isSecureTextEntry = true
        return textField
    }()
    
    
    
    
    private let registerButton: UIButton = {
        let button = UIButton()
        button.setTitle("Register", for: .normal)
        button.backgroundColor = .systemGreen
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Register"
        view.backgroundColor = .white
        
        
        
        registerButton.addTarget(self,
                                 action: #selector(loginButtonTapped),
                                 for: .touchUpInside)
        
        
        emailField.delegate = self
        passwordField.delegate = self
        
        //Add subView
        view.addSubview(scrollView)
        
        scrollView.addSubview(imageView)
        scrollView.addSubview(firstNameField)
        scrollView.addSubview(lastNameField)
        scrollView.addSubview(emailField)
        scrollView.addSubview(passwordField)
        scrollView.addSubview(registerButton)
        
        scrollView.isUserInteractionEnabled = true
        imageView.isUserInteractionEnabled = true
        
        let gestureRecognizer = UITapGestureRecognizer(target: self,
                                                       action: #selector(didChangeProfilePic))
        
        imageView.addGestureRecognizer(gestureRecognizer)
    }
    
    @objc private func didChangeProfilePic() {
        presentPhotoActionSheet()
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.frame = view.bounds
        
        let size = scrollView.width / 3
        
        imageView.frame = CGRect(x: (scrollView.width - size) / 2,
                                 y: 20,
                                 width: size,
                                 height: size)
        
        firstNameField.frame = CGRect(x: 30,
                                      y: imageView.bottom + 30,
                                      width: scrollView.width - 60,
                                      height: 52)
        lastNameField.frame = CGRect(x: 30,
                                     y: firstNameField.bottom + 10,
                                     width: scrollView.width - 60,
                                     height: 52)
        
        
        emailField.frame = CGRect(x: 30,
                                  y: lastNameField.bottom + 10,
                                  width: scrollView.width - 60,
                                  height: 52)
        
        passwordField.frame = CGRect(x: 30,
                                     y: emailField.bottom + 10,
                                     width: scrollView.width - 60,
                                     height: 52)
        
        registerButton.frame = CGRect(x: 50,
                                      y: passwordField.bottom + 30 ,
                                      width: scrollView.width - 90,
                                      height: 52)
    }
    
    
    
    
    @objc private func loginButtonTapped() {
        firstNameField.resignFirstResponder()
        lastNameField.resignFirstResponder()
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
        
        guard let fistName = firstNameField.text,
              let lastName = lastNameField.text,
              let email = emailField.text,
              let password = passwordField.text,
              !fistName.isEmpty,
              !lastName.isEmpty,
              !email.isEmpty,
              !password.isEmpty,
              password.count >= 6 else {
            alertUserLoginError()
            return
        }
        
        DatabaseManager.shared.userExists(with: email) { [weak self] exists in
            guard let self = self else { return }
            
            guard !exists else {
                Alerts.shared.createDynamicAlert(on: self, title: "Ошибка", message: "такой email уже используется", actionTitle: "Ok")
                return
            }
            FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password) {  authResult, error in
                
                guard authResult != nil else { return }
                
                
                if let error = error {
                    let nsError = error as NSError
                    if nsError.code == AuthErrorCode.emailAlreadyInUse.rawValue {
                        Alerts.shared.createDynamicAlert(on: self, title: "Ошибка", message: "Существует такой пользователь!", actionTitle: "OK")
                    } else {
                        Alerts.shared.createDynamicAlert(on: self, title: "Ошибка", message: error.localizedDescription, actionTitle: "OK")
                    }
                    return
                }
                
                DatabaseManager.shared.insertUser(with: ChatAppUser(firstName: fistName,
                                                                    lastName: lastName,
                                                                    emailAddress: email))
                
                self.navigationController?.dismiss(animated: true)
            }
        }
        
        
        
        
        func alertUserLoginError() {
            let alert = UIAlertController(title: "Woops",
                                          message: "Please enter all information to creat a new account", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .cancel)
            alert.addAction(action)
            
            present(alert, animated: true)
        }
        
        
    }
    
    
    @objc private func didTapRegister() {
        let vc = RegisterViewController()
        vc.title = "Create Account"
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        appearance.titleTextAttributes = [.foregroundColor: UIColor.black]
        
        vc.navigationItem.scrollEdgeAppearance = appearance
        vc.navigationItem.standardAppearance = appearance
        
        vc.navigationController?.navigationBar.backgroundColor = .white
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
} 



extension RegisterViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == emailField {
            passwordField.becomeFirstResponder()
        }
        else if textField == passwordField {
            loginButtonTapped()
        }
        
        return true
    }
    
}





