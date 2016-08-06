//
//  TabBarViewController.swift
//  UCLanTimetable
//
//  Created by Salah Eddin Alshaal on 28/07/16.
//  Copyright © 2016 Salah Eddin Alshaal. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        // todo screwing up the UI after (removes alerts)
//        let user = Misc.loadUser()
//        if user?.aCCOUNT_TYPE_ID == KEYS.studentTypeId{
//            if var tabBarController = self.viewControllers {
//                let indexToRemove = 1
//                if indexToRemove < tabBarController.count {
//                    tabBarController.removeAtIndex(indexToRemove)
//                    self.setViewControllers(tabBarController, animated: false)
//                }
//            }
//        }
//        else{
//            if var tabBarController = self.viewControllers {
//                let indexToRemove2 = 3
//                if indexToRemove2 < tabBarController.count {
//                    tabBarController.removeAtIndex(indexToRemove2)
//                    self.setViewControllers(tabBarController, animated: false)
//                }
//                let indexToRemove = 2
//                if indexToRemove < tabBarController.count {
//                    tabBarController.removeAtIndex(indexToRemove)
//                    self.setViewControllers(tabBarController, animated: false)
//                }
//            }
//        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
