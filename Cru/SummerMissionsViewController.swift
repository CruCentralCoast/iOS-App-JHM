//
//  SummerMissionsViewController.swift
//  Cru
//
//  Created by Max Crane on 11/17/15.
//  Copyright © 2015 Jamaican Hopscotch Mafia. All rights reserved.
//

import UIKit

class SummerMissionsViewController: UIViewController {
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    var phoneNumber = "17074546433"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if(self.revealViewController() != nil){
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        // Do any additional setup after loading the view.
        //DBClient.sendSmsText("19252127242", message: "Sent from the summer missions page...")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func textButtonPressed(sender: AnyObject) {
        
        DBClient.sendSmsText(phoneNumber, message: textField.text!)
        print("sent sms to # \(phoneNumber) with content \(textField.text!)")
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
