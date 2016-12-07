//
//  LogoutViewController.swift
//  UCLanTimetable
//
//  Created by Salah Eddin Alshaal on 30/06/16.
//  Copyright © 2016 Salah Eddin Alshaal. All rights reserved.
//

import UIKit
import Keychain

class LogoutViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_ animated: Bool) {
        let alert = UIAlertController(title: "Logout", message:"Are you sure you want to logout?", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Cancel", style: .default) { _ in
            // move user to first tab
            let fromView = self.tabBarController?.viewControllers![3].view
            let toView = self.tabBarController?.viewControllers![0].view

            UIView.transition(from: fromView!, to: toView!, duration: 0.5, options: UIViewAnimationOptions.transitionFlipFromLeft, completion: { (finished: Bool) -> () in

                // completion
                self.tabBarController?.selectedIndex = 0
                }
            )
            })

        alert.addAction(UIAlertAction(title: "Yes", style: .default) { _ in
            // remove credentials
            Keychain.delete(KEYS.user)
            self.performSegue(withIdentifier: "logout", sender: nil)
            })

        self.present(alert, animated: true) {}
    }
    /*
     // MARK: - Navigation

     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */

}
