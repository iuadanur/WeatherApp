//
//  ViewController.swift
//  WeatherApp
//
//  Created by İbrahim Utku Adanur on 23.12.2023.
//

import UIKit
import FirebaseAuth

class WelcomePage: UIViewController {

    @IBOutlet weak var showPasswordButton: UIButton!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //In order to place my background image to background
        view.sendSubviewToBack(backgroundImageView)
        
        customizeTextFields()
        logInButtonCustomize()
        showPasswordButton.setImage(UIImage(systemName: "eye.slash.fill"), for: .normal)
    }
    
    @IBAction func logInClicked(_ sender: Any) {
        if emailTextField.text == "" && passwordTextField.text == ""{
            makeAlert(title: "ERROR", message: "Please enter your email and password")
        }
        if emailTextField.text == "" {
            makeAlert(title: "ERROR", message: "Please enter your email")
        }
        if passwordTextField.text == ""{
            makeAlert(title: "ERROR", message: "Please enter your password")
        }
        
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { [weak self] authResult, error in
            guard let strongSelf = self else { return }
            
            if error != nil{
                strongSelf.makeAlert(title: "Error", message: error?.localizedDescription ?? "An unknown has occured")
            }else{
                strongSelf.performSegue(withIdentifier: "toTabbar", sender: nil)
            }
        }
    }
    
    @IBAction func registerClicked(_ sender: Any) {
        
    }
//MARK: - Textfields
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
    }
//MARK: - Button Customize
    func logInButtonCustomize(){
        logInButton.layer.cornerRadius = 15
        view.addSubview(logInButton)
        registerButton.layer.cornerRadius = 15
        registerButton.layer.borderWidth = 2
        registerButton.layer.borderColor = UIColor.white.cgColor
        view.addSubview(registerButton)
    }
//MARK: - Alert
    func makeAlert(title: String,message: String){
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let OKButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
        alert.addAction(OKButton)
        self.present(alert, animated: true)
    }
//MARK: - Show Password
    @IBAction func showPasswordTapped(_ sender: Any) {
        passwordTextField.isSecureTextEntry.toggle()
            let imageName = passwordTextField.isSecureTextEntry ? "eye.slash.fill" : "eye.fill"
            showPasswordButton.setImage(UIImage(systemName: imageName), for: .normal)
    }
}

