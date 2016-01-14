//
//  IntroDescriptionViewController.swift
//  Cru
//
//  Created by Deniz Tumer on 1/12/16.
//  Copyright © 2016 Jamaican Hopscotch Mafia. All rights reserved.
//

import UIKit

class IntroDescriptionViewController: UIViewController {

    @IBOutlet weak var modalWindow: UIView!
    @IBOutlet var modalBackground: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        modalWindow.layer.cornerRadius = 15.0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func presentNextModal(sender: AnyObject) {
        self.presentViewController(IntroCampusesViewController(), animated: true, completion: nil)
    }
    
    @IBAction func dismissIntroModal(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
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
