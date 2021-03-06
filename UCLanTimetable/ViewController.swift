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

        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = true
    }

    override func viewDidAppear(_ animated: Bool) {

        // check if user is already logged in

        if Misc.loadUser() != nil {
            self.performSegue(withIdentifier: "login", sender: nil)
        }
            //fill username and pass
        else if Keychain.load(KEYS.pass) != nil && Keychain.load(KEYS.username) != nil {
            // todo verify before proceeding
            emailTextBox.text = Keychain.load(KEYS.username)
            passTextBox.text = Keychain.load(KEYS.pass)
        } else {
            // delete
            Keychain.delete(KEYS.pass)
            Keychain.delete(KEYS.username)
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: Actions
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if "login" == segue.identifier {
            // Nothing really to do here, since it won't be fired unless
            // shouldPerformSegueWithIdentifier() says it's ok. In a real app,
            // this is where you'd pass data to the success view controller.
        }
    }

    @IBAction func loginButton_Clicked(_ sender: AnyObject) {
        if IsLoginFormValid() {
            EventAPI.getUserLogin(emailTextBox.text!, pass: passTextBox.text!, callback: loginCallback)
        }
    }

    func isValidEmail(_ testStr: String) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"

        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
}

extension ViewController: UITextFieldDelegate {
    // FOR HIDING/SHOWING THE KEYBOAD
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {   //delegate method
        if textField == self.emailTextBox {
            passTextBox.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }

    func IsLoginFormValid() -> Bool {

        var isFormValid: Bool = true
        // alert view for informing user
        let alertView = UIAlertController(title: "Login Problem",
                                          message: "" as String, preferredStyle:.alert)
        let okAction = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
        alertView.addAction(okAction)

        if let _ = emailTextBox.text, emailTextBox.text!.isEmpty {
            alertView.title = "email missing"
            alertView.message = "please enter an email in the field"
            isFormValid = false
        } else if !isValidEmail(emailTextBox.text!) {
            alertView.title = "Invalid e-mail"
            alertView.message = "Please enter a valid email"
            isFormValid = false
        } else if let _ = passTextBox.text, passTextBox.text!.isEmpty {
            alertView.title = "please enter a password"
            alertView.message = "Password field cannot be empty"
            isFormValid = false
        }

        if !isFormValid {
            self.present(alertView, animated: true, completion: nil)
        }

        return isFormValid
    }

    func loginCallback(_ user: AuthenticatedUser?) -> Void {
        if user == nil {
            // login failed
            let alertView = UIAlertController(title: "Login Problem",
                                              message: "" as String, preferredStyle:.alert)
            let okAction = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
            alertView.addAction(okAction)
            alertView.title = "Login failed"
            alertView.message = "Either Username or Password are incorrect"
            self.present(alertView, animated: true, completion: nil)
        } else {
            // successful login
            if rememberUserSwitch.isOn {
                Keychain.save(emailTextBox.text!, forKey: KEYS.username)
                Keychain.save(passTextBox.text!, forKey: KEYS.pass)
            }
            if !Misc.saveUser(user) {
                // todo show error that user wasn't saved
            }

            // depending on user, hide elements
            if user?.aCCOUNT_TYPE_ID == KEYS.studentTypeId {
                // hide room
            } else {
                // hide exams and attendance
            }

            self.performSegue(withIdentifier: "login", sender: nil)

        }
    }
}
