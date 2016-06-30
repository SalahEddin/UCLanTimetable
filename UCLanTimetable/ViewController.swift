//
//  ViewController.swift
//  UCLanTimetable
//
//  Created by Salah Eddin Alshaal on 15/06/16.
//  Copyright © 2016 Salah Eddin Alshaal. All rights reserved.
//

import UIKit
import Keychain

class ViewController: UIViewController {
    
    @IBOutlet weak var emailTextBox: UITextField!
    @IBOutlet weak var passTextBox: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var rememberUserSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.emailTextBox.delegate = self
        self.passTextBox.delegate = self
        //todo: check if internet is available
    }
    
    override func viewDidAppear(animated: Bool) {
        
        // check if user is already logged in
        if Keychain.load("pass") != nil && Keychain.load("username") != nil {
            // todo verify before proceeding
            self.performSegueWithIdentifier("login", sender: nil)
            return
        }
        else{
            // delete
            Keychain.delete("pass")
            Keychain.delete("username")
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Actions
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if "login" == segue.identifier {
            // Nothing really to do here, since it won't be fired unless
            // shouldPerformSegueWithIdentifier() says it's ok. In a real app,
            // this is where you'd pass data to the success view controller.
        }
    }
    
    @IBAction func loginButton_Clicked(sender: AnyObject) {
        
        let hasLoginKey = NSUserDefaults.standardUserDefaults().boolForKey("hasLoginKey")
        if hasLoginKey == false {
            NSUserDefaults.standardUserDefaults().setValue(self.emailTextBox.text, forKey: "username")
        }

        let data = Keychain.load("pass")
        print(data)
        
        let alertView = UIAlertController(title: "Login Problem",
                                          message: "" as String, preferredStyle:.Alert)
        let okAction = UIAlertAction(title: "Dismiss", style: .Default, handler: nil)
        
        alertView.addAction(okAction)
        //self.presentViewController(alertView, animated: true, completion: nil)
        
        
        if let _ = emailTextBox.text where emailTextBox.text!.isEmpty {
            alertView.title = "please enter an email"
            alertView.message = "email field cannot be empty"
        }
        else if !isValidEmail(emailTextBox.text!){
            alertView.title = "Invalid e-mail"
            alertView.message = "Please enter a valid email"
        }
        else if let _ = passTextBox.text where passTextBox.text!.isEmpty {
            alertView.title = "please enter a password"
            alertView.message = "Password field cannot be empty"
        }else if(!checkLogin(emailTextBox.text!, pass: passTextBox.text!)){
            alertView.title = "Login failed"
            alertView.message = "Either Username or Password are incorrect"
        }
        else{
            // successful login
            if(rememberUserSwitch.on){
                Keychain.save(emailTextBox.text!, forKey: "username")
                Keychain.save(passTextBox.text!, forKey: "pass")
            }
            self.performSegueWithIdentifier("login", sender: nil)
        }
        
        
        self.presentViewController(alertView, animated: true, completion: nil)
        
    }
    
    func isValidEmail(testStr:String) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluateWithObject(testStr)
    }
    
    func checkLogin(user: String, pass: String)-> Bool{
        if user == "user@mail.com" && pass == "pass" {
            return true
        }
        return false
    }
}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {   //delegate method
        if textField == self.emailTextBox {
            passTextBox.becomeFirstResponder()
        }
        else{
            textField.resignFirstResponder()
        }
        return true
    }
}