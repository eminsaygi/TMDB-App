//
//  LoginViewController.swift
//  TMDB-App
//
//  Created by Emin Saygı on 30.11.2022.
//

import UIKit
import SafariServices


class LoginViewController: UIViewController {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet var appNameLabel: UILabel!
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var logoImage: UIImageView!
    @IBOutlet var usernameTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var incorrectCredentialsMessage: UILabel!
    @IBOutlet var loginButtonCircular: UIButton!
    @IBOutlet var signUp: UIButton!
    
    let notificationCenter = NotificationCenter.default
    
    var token = ""
    var isLogin = false
    override func viewDidLoad() {
        
        super.viewDidLoad()
        loginButtonCircular.layer.cornerRadius = 15
        incorrectCredentialsMessage.isHidden = true
        notificationCenter.addObserver(self, selector: #selector(handleKeyboard(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(handleKeyboard(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleContainerViewTap))
        self.view.addGestureRecognizer(tapRecognizer)
        tapRecognizer.cancelsTouchesInView = false;
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        WebServices.shared.fetchRequestToken { data in
            DispatchQueue.main.async {
                self.token = data.requestToken
            }
        }
        navigationController?.setNavigationBarHidden(true, animated: animated)
        
    }
    
    @IBAction func signUpAction(_ sender: UIButton) {
        
        let vc = SFSafariViewController(url: URL(string: "https://www.themoviedb.org/signup")!)
        present(vc, animated: true)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    
    
    @objc func handleKeyboard(notification: Notification) {
        
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: self.view)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            scrollView.contentOffset = .zero
        } else {
            scrollView.contentOffset = CGPoint(x: 0,
                                               y: keyboardViewEndFrame.height)
        }
        
        scrollView.scrollIndicatorInsets = UIEdgeInsets(top: 0,
                                                        left: 0,
                                                        bottom: scrollView.contentOffset.y,
                                                        right: 0)
        
    }
    
    
    @objc func handleContainerViewTap() {
        
        self.view.endEditing(true)
    }
    
    
    
    @IBAction func login(_ sender: UIButton) {
        
        
        if let username = usernameTextField.text, !username.isEmpty,
           let password = passwordTextField.text, !password.isEmpty {
          WebServices.shared.login(token: token, userName: username, password: password) { data in
            if data.success {
              DispatchQueue.main.async {
                self.performSegue(withIdentifier: "tabBarVC", sender: nil)
              }
            } else {
              // Show the incorrect credentials message
              self.incorrectCredentialsMessage.isHidden = false
            }
          }
        } else {
          // Show an error message
          self.incorrectCredentialsMessage.isHidden = false
          self.incorrectCredentialsMessage.text = "Please enter a valid username and password."
        }
        
        
        
        
        }
       
        
        
        
    }
    





