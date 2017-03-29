//
//  LoginController.swift
//  InstagramFirebase
//
//  Created by Jairo Eli de Leon on 3/25/17.
//  Copyright © 2017 DevMountain. All rights reserved.
//

import UIKit
import Firebase

class LoginController: UIViewController {
  
  // MARK: - Properties
  
  let logoContainerView = UIView {
    $0.backgroundColor = UIColor.rgb(red: 0, green: 120, blue: 175)
  }
  
  let logoImageView = UIImageView {
    $0.image = #imageLiteral(resourceName: "Instagram_logo_white")
    $0.contentMode = .scaleAspectFill
  }
  
  lazy var emailTextField: UITextField = {
    let tf = UITextField()
    tf.placeholder = "Email"
    tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
    tf.borderStyle = .roundedRect
    tf.font = UIFont.systemFont(ofSize: 14)
    tf.keyboardType = .emailAddress
    tf.autocapitalizationType = .none
    tf.autocorrectionType = .no
    tf.returnKeyType = .next
    tf.clearButtonMode = .whileEditing
    tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
    return tf
  }()
  
  lazy var passwordTextField: UITextField = {
    let tf = UITextField()
    tf.placeholder = "Password"
    tf.isSecureTextEntry = true
    tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
    tf.borderStyle = .roundedRect
    tf.font = UIFont.systemFont(ofSize: 14)
    tf.autocapitalizationType = .none
    tf.autocorrectionType = .no
    tf.returnKeyType = .done
    tf.clearButtonMode = .whileEditing
    tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
    return tf
  }()
  
  lazy var loginButton: UIButton = {
    let button = UIButton(type: .system)
    button.setTitle("Login", for: .normal)
    button.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
    button.layer.cornerRadius = 5
    button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
    button.setTitleColor(.white, for: .normal)
    button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
    button.isEnabled = false
    return button
  }()
  
  lazy var dontHaveAccountButton: UIButton = {
    let button = UIButton(type: .system)
    
    let attributedTitle = NSMutableAttributedString(string: "Don't have an account?  ", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 14), NSForegroundColorAttributeName: UIColor.lightGray])
    
    attributedTitle.append(NSAttributedString(string: "Sign Up", attributes: [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 14), NSForegroundColorAttributeName: UIColor.rgb(red: 17, green: 154, blue: 237)]))
    
    button.setAttributedTitle(attributedTitle, for: .normal)
    button.addTarget(self, action: #selector(handleShowSignUp), for: .touchUpInside)
    return button
  }()
  
  // MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationController?.isNavigationBarHidden = true
    view.backgroundColor = .white
    
    view.addSubview(logoContainerView)
    view.addSubview(dontHaveAccountButton)
    logoContainerView.addSubview(logoImageView)
    
    setupLayout()
    setupInputFields()
  }
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
  
  
}

extension LoginController {
  
  // MARK: - Log In
  func handleShowSignUp() {
    let signUpController = SignUpController()
    navigationController?.pushViewController(signUpController, animated: true)
  }
  
  func handleTextInputChange() {
    let isFormValid = emailTextField.text?.characters.count ?? 0 > 0 && passwordTextField.text?.characters.count ?? 0 > 0
    
    if isFormValid {
      loginButton.isEnabled = true
      loginButton.backgroundColor = UIColor.rgb(red: 17, green: 154, blue: 237)
    } else {
      loginButton.isEnabled = false
      loginButton.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
    }
    
  }
  
  func handleLogin() {
    guard let email = emailTextField.text else { return }
    guard let password = passwordTextField.text else { return }
    FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, err) in
      
      if let err = err {
        print("Failed to sign in with email:", err)
        return
      }
      
      print("Successfully logged back in with user:", user?.uid ?? "")
      
      guard let mainTabBarController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController else { return }
      mainTabBarController.setupViewControllers()
      
      self.dismiss(animated: true, completion: nil)
    })
  }
  
  // MARK: - Set up
  fileprivate func setupLayout() {
    logoContainerView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 150)
    
    dontHaveAccountButton.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 50)
    
    logoImageView.anchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 200, height: 50)
    logoImageView.centerXAnchor.constraint(equalTo: logoContainerView.centerXAnchor).isActive = true
    logoImageView.centerYAnchor.constraint(equalTo: logoContainerView.centerYAnchor).isActive = true
  }
  
  fileprivate func setupInputFields() {
    let stackView = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, loginButton])
    
    stackView.axis = .vertical
    stackView.spacing = 10
    stackView.distribution = .fillEqually
    
    view.addSubview(stackView)
    stackView.anchor(top: logoContainerView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 40, paddingLeft: 40, paddingBottom: 0, paddingRight: 40, width: 0, height: 140)
  }
}
