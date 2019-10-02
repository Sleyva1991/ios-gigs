//
//  LoginViewController.swift
//  Gigs
//
//  Created by Steven Leyva on 10/2/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

enum LoginType {
    case signIn
    case signUp
}

class LoginViewController: UIViewController {
    
    var gigsController: GigsController!
    var loginType = LoginType.signUp
    
    @IBOutlet weak var segmentedController: UISegmentedControl!
    @IBOutlet weak var usernameTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginButton.backgroundColor = UIColor(hue: 190/360, saturation: 70/100, brightness: 80/100, alpha: 1.0)
        loginButton.tintColor = .white
        loginButton.layer.cornerRadius = 8.0
        
        segmentedController.backgroundColor = UIColor(hue: 190/360, saturation: 70/100, brightness: 80/100, alpha: 1.0)
        segmentedController.tintColor = .white
        segmentedController.layer.cornerRadius = 8.0
    }
    
    @IBAction func segmentedContollerTapped(_ sender: UISegmentedControl) {
        
        if sender.selectedSegmentIndex == 0 {
            loginType = .signUp
            loginButton.setTitle("Sign Up", for: .normal)
        } else {
            loginType = .signIn
            loginButton.setTitle("Sign In", for: .normal)
        }
    }
    
    func signUp(with user: User){
        // Create the user
        gigsController?.signUp(with: user, completion: { (error) in
            if let error = error {
                NSLog("Error occurred during sign up: \(error)")
            } else {
                let alert = UIAlertController(title: "Sign up Successful", message: "Now please log in", preferredStyle: .alert)
                
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                
                alert.addAction(okAction)
                DispatchQueue.main.async {
                    self.present(alert, animated: true)
                    self.loginType = .signIn
                    self.segmentedController.selectedSegmentIndex = 1
                    self.loginButton.setTitle("Sign In", for: .normal)
                }
            }
        })
        
    }
    
    func signIn(with user: User) {
        gigsController?.signIn(with: user, completion: { (error) in
            if let error = error {
                NSLog("Error occurred during sign in: \(error)")
            } else {
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                }
            }
        })
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        guard let username = usernameTextfield.text,
            let password = passwordTextfield.text,
            !username.isEmpty,
            !password.isEmpty else { return }
        
        let user = User(username: username, password: password)
        
        // perform login or sign up operation based on loginType
        if loginType == .signUp {
            signUp(with: user)
        } else {
            signIn(with: user)
        }
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
