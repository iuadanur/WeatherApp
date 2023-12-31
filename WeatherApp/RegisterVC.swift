//
//  RegisterVC.swift
//  WeatherApp
//
//  Created by İbrahim Utku Adanur on 24.12.2023.
//

import UIKit
import FirebaseAuth
class RegisterVC: UIViewController {

    
    @IBOutlet weak var showPasswordAgainButton: UIButton!
    
    @IBOutlet weak var showPasswordButton: UIButton!
    
    @IBOutlet weak var registerLabel: UILabel!
    
    @IBOutlet weak var infoText: UITextView!
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordAgainTextField: UITextField!
    
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var passwordAgainLabel: UILabel!

    @IBOutlet weak var registerButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customizeTextFields()
        registerButtonCustomize()
        showPasswordButton.setImage(UIImage(systemName: "eye.slash.fill"), for: .normal)
        showPasswordAgainButton.setImage(UIImage(systemName: "eye.slash.fill"), for: .normal)
       
    }
    override func viewWillAppear(_ animated: Bool) {
       
        navigationController?.navigationBar.tintColor = UIColor.white

           // Navigation bar'ın arka planını tamamen saydam yap
           navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
           navigationController?.navigationBar.shadowImage = UIImage()
       
    }
    @IBAction func registerClicked(_ sender: Any) {
        
        guard let email = emailTextField.text, !email.isEmpty else {
                makeAlert(title: "ERROR", message: "Please enter your email")
                return
            }
            
            guard let password = passwordTextField.text, !password.isEmpty else {
                makeAlert(title: "ERROR", message: "Please enter your password")
                return
            }
            
            guard let confirmPassword = passwordAgainTextField.text, !confirmPassword.isEmpty else {
                makeAlert(title: "ERROR", message: "Please enter your password again")
                return
            }
            
            guard password == confirmPassword else {
                makeAlert(title: "ERROR", message: "Passwords do not match")
                return
            }
            
        
            Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { authData, error in
                if error != nil {
                    self.makeAlert(title: "ERROR", message: error?.localizedDescription ?? "An unknown error has occured" )
                    return
                }
                self.performSegue(withIdentifier: "toRegisteredVC", sender: nil)
                
            }
        
        
        
        
    }
    func customizeTextFields(){
        emailTextField.layer.cornerRadius = 15
        
        emailTextField.attributedPlaceholder = NSAttributedString(
            string: "Email",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.black.withAlphaComponent(0.5)]
        )
        
        passwordTextField.attributedPlaceholder = NSAttributedString(
            string: "Password",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.black.withAlphaComponent(0.5)]
        )
        passwordAgainTextField.attributedPlaceholder = NSAttributedString(
            string: "Password Again",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.black.withAlphaComponent(0.5)]
        )
    }
    func registerButtonCustomize(){
                
        registerButton.layer.cornerRadius = 15
        registerButton.layer.borderWidth = 2
        registerButton.layer.borderColor = UIColor.white.cgColor
        
        view.addSubview(registerButton)
        
        
    }
    func makeAlert(title: String,message: String){
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let OKButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
        alert.addAction(OKButton)
        self.present(alert, animated: true)
    
    }
    
    
    @IBAction func showPasswordTapped(_ sender: Any) {
        
        passwordTextField.isSecureTextEntry.toggle()
            let imageName = passwordTextField.isSecureTextEntry ? "eye.slash.fill" : "eye.fill"
            showPasswordButton.setImage(UIImage(systemName: imageName), for: .normal)
    }
    
    @IBAction func showPasswordAgainTapped(_ sender: Any) {
        
        passwordAgainTextField.isSecureTextEntry.toggle()
        let imageName = passwordAgainTextField.isSecureTextEntry ? "eye.slash.fill" : "eye.fill"
        showPasswordAgainButton.setImage(UIImage(systemName: imageName), for: .normal)
    }
    
    
}
