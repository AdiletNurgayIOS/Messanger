//
//  LoginViewController.swift
//  Massanger
//
//  Created by Adilet on 28.01.2025.
//

import UIKit
import FirebaseAuth
import GoogleSignIn
import FirebaseCore
 

class LoginViewController: UIViewController {
    
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.clipsToBounds = true
        return scrollView
    }()
    
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "logo1")
        imageView.contentMode = .scaleAspectFit
        return imageView
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
        
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height : 0))
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
    
    
    private let loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("Log In", for: .normal)
        button.backgroundColor = .link
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        return button
    }()
    
    private let googleSignInButton: GIDSignInButton = {
        let button = GIDSignInButton()
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
 
        title = "Log In"
        view.backgroundColor = .white
        
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Register",
            style: .done,
            target: self,
            action: #selector(didTapRegister))
        
        loginButton.addTarget(self,
                              action: #selector(loginButtonTapped),
                              for: .touchUpInside)
        googleSignInButton.addTarget(self, action: #selector(signInWithGoogle), for: .touchUpInside)
        
        emailField.delegate = self
        passwordField.delegate = self
        
        //Add subView
        view.addSubview(scrollView)
        
        scrollView.addSubview(imageView)
        scrollView.addSubview(emailField)
        scrollView.addSubview(passwordField)
        scrollView.addSubview(loginButton)
        scrollView.addSubview(googleSignInButton)
        
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.frame = view.bounds
        
        let size = scrollView.width / 4
        
        imageView.frame = CGRect(x: (scrollView.width - size) / 2,
                                 y: 20,
                                 width: size,
                                 height: size)
        
        emailField.frame = CGRect(x: 30,
                                  y: imageView.bottom + 30,
                                  width: scrollView.width - 60,
                                  height: 52)
        
        passwordField.frame = CGRect(x: 30,
                                     y: emailField.bottom + 10,
                                     width: scrollView.width - 60,
                                     height: 52)
        
        loginButton.frame = CGRect(x: 50,
                                   y: passwordField.bottom + 30 ,
                                   width: scrollView.width - 90,
                                   height: 52)
        
        googleSignInButton.frame = CGRect(x: 50,
                                          y: loginButton.bottom + 10,
                                          width: scrollView.width - 90,
                                          height: 60)
    }
    
    
    
    @objc private func signInWithGoogle() {
        guard let clientID = FirebaseApp.app()?.options.clientID else {
               print("❌ Ошибка: clientID не найден")
               return
           }

           let config = GIDConfiguration(clientID: clientID)
        
        
        GIDSignIn.sharedInstance.configuration = config
        
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { result, error in
            if let error = error {
                print("Ошибка входа через гугл: \(error.localizedDescription)")
            }
            
            guard let user = result?.user, let idToken = user.idToken?.tokenString else { return }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: user.accessToken.tokenString)
            
            Auth.auth().signIn(with: credential) { authResult, error in
                if let error = error {
                    print("ошибка Firebase вход через google: \(error.localizedDescription)")
                    return
                }
                print("успешный вход через google firebase: \(authResult?.user.email ?? "Неизвестно")")
                
            }
             
        }
    }
    
    
    
    @objc private func loginButtonTapped() {
        
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
        
        guard let email = emailField.text, let password = passwordField.text, !email.isEmpty, !password.isEmpty else {
            alertUserLoginError()
            return
        }
        
        guard let password = passwordField.text, password.count >= 6 else {
            Alerts.shared.createDynamicAlert(on: self,
                                             title: "Ошибка",
                                             message: "Пароль должен быть 6 значным",
                                             actionTitle: "OK")
            return
        }
        
        
        
        FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult,error in
            guard let self = self else { return }
            
            if let error = error {
                let nsError = error as NSError
                var errorMessage = "Произошла ошибка"
                
                switch nsError.code {
                case AuthErrorCode.emailAlreadyInUse.rawValue:
                    errorMessage = "Этот email уже зарегестрирован"
                case AuthErrorCode.wrongPassword.rawValue:
                    errorMessage = "Не правильный пароль"
                case AuthErrorCode.invalidEmail.rawValue:
                    errorMessage = "Некорректный email"
                case AuthErrorCode.userNotFound.rawValue:
                    errorMessage = "Пользователь не найден"
                case AuthErrorCode.userDisabled.rawValue:
                    errorMessage = "Ваш аккаунт отключён. Обратитесь в поддержку."
                case AuthErrorCode.networkError.rawValue:
                    errorMessage = "Ошибка сети. Проверьте подключение к интернету."
                default:
                    errorMessage = error.localizedDescription
                }
                Alerts.shared.createDynamicAlert(on: self, title: "Ошибка", message: errorMessage, actionTitle: "ОК")
            }
            
            guard let user = authResult?.user else { return }
            print("пользователь зарегестрирован email: \(String(describing: user.email) )")
            self.navigationController?.dismiss(animated: true)
        }
    }
    
    
    
    func alertUserLoginError() {
        let alert = UIAlertController(title: "Woops", message: "Please enter all information to log in", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel)
        alert.addAction(action)
        
        present(alert, animated: true)
    }
    
    
    @objc private func didTapRegister() {
        let vc = RegisterViewController()
        vc.title = "Create Account"
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white // Белый фон
        appearance.titleTextAttributes = [.foregroundColor: UIColor.black] // Чёрный текст
        
        vc.navigationItem.scrollEdgeAppearance = appearance
        vc.navigationItem.standardAppearance = appearance
        
        vc.navigationController?.navigationBar.backgroundColor = .white
        navigationController?.pushViewController(vc, animated: true)
        
    }
}



extension LoginViewController: UITextFieldDelegate {
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

