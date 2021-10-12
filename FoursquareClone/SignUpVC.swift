//
//  ViewController.swift
//  FoursquareClone
//
//  Created by cem bayat on 8.10.2021.
//

import UIKit
import Parse

class SignUpVC: UIViewController{
    
    
    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        /*
        let parseObject = PFObject(className: "Fruits")
        parseObject["name"] = "Banana"
        parseObject["calories"] = 150
        
        parseObject.saveInBackground { bool, error in
            
            if error != nil {
                print(error?.localizedDescription)
            } else if bool == true {
                print("uploaded")
            }
            
        }
        
        let query = PFQuery(className: "Fruits")
        //query.whereKey("name", equalTo: "Apple")
        query.whereKey("calories", lessThan: 140)
        query.findObjectsInBackground { objects, error in
            
            if error != nil {
                print(error?.localizedDescription)
            } else {
                print(objects)
            }
            
        }
        
        */
        
        
        
        
    }

    
    @IBAction func signInBtnClicked(_ sender: Any) {
        
        if usernameTextField.text! != "" && passwordTextField.text! != "" {
            
            //giriş yapma kısmı
            PFUser.logInWithUsername(inBackground: usernameTextField.text!, password: passwordTextField.text!) { user, error in
                
                if error != nil {
                    self.makeAlert(title: "Error", message: error?.localizedDescription ?? "Error")
                } else {
                    // segue işlemi
                    self.performSegue(withIdentifier: "toPlacesVC", sender: nil)
                }
            }
            
        } else {
            
            self.makeAlert(title: "Error", message: "Enter username and password")
            
        }
        
    }
    
    
    @IBAction func singUpBtnClicked(_ sender: Any) {
        
        if usernameTextField.text?.isEmpty == true || passwordTextField.text?.isEmpty == true {
            
            makeAlert(title: "Error", message: "Please enter username & password")
            
        } else {
            
            //kayıt olma işlemi
            
            let user = PFUser()
            
            user.username = usernameTextField.text!
            user.password = passwordTextField.text!
            
            user.signUpInBackground { bool, error in
                
                if error != nil {
                    
                    self.makeAlert(title: "Error", message: error?.localizedDescription ?? "Error")
                    
                } else {
                    
                    //Segue
                    self.makeAlert(title: "Success", message: "Successfully Sign Up 🥳")
                    //self.performSegue(withIdentifier: "toPlacesVC", sender: nil)
                }
                
            }
            
        }
        
    }
    

    func makeAlert(title : String, message : String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        let okBtn = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        
        alert.addAction(okBtn)
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
}
