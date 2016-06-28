//
//  ViewController.swift
//  UCLanTimetable
//
//  Created by Salah Eddin Alshaal on 15/06/16.
//  Copyright © 2016 Salah Eddin Alshaal. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var emailTextBox: UITextField!
    @IBOutlet weak var passTextBox: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.emailTextBox.delegate = self
        self.passTextBox.delegate = self
        //todo: check if internet is available
        //todo: check if user is already logged in
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Actions
    
    @IBAction func loginButton_Clicked(sender: AnyObject) {
        
        var errorMsg: String? = nil
        
        if emailTextBox.text == "user@mail.com" && passTextBox.text == "pass" {
            //success, move to main
            self.performSegueWithIdentifier("loginSegue", sender: nil)
        }
        else if emailTextBox.text == ""{
            errorMsg = "please enter an email"
        }
        else if !isValidEmail(emailTextBox.text!){
            errorMsg = "please enter a valid email"
        }
        else if passTextBox.text == ""{
            errorMsg = "please enter a password"
        }
        else{
            errorMsg = "user name or password is not valid"
        }
        
        if (errorMsg != nil) {
            errorLabel.hidden = false
            errorLabel.text = errorMsg!
        }
        else{
            errorLabel.hidden = true
        }
    }
    
    func isValidEmail(testStr:String) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluateWithObject(testStr)
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