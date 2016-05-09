//
//  MainViewController.swift
//  Cru
//
//  This view controller represents the main controller for the home view and the launch screen of the Cru Central Coast Application
//
//  Created by Deniz Tumer on 11/5/15.
//  Copyright © 2015 Jamaican Hopscotch Mafia. All rights reserved.
//

import UIKit
import SideMenu

class MainViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    var items = ["Church on Sunday!", "Fall Retreat", "Bowling lessons with Pete, or was it Peter? Find out at the Event", "Idk was it peter", "Futbol"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem!.setTitleTextAttributes([NSFontAttributeName: UIFont(name: Config.fontName, size: 20)!], forState: .Normal)
        
        if self.revealViewController() != nil{
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer()) 
        }
    }
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    /* This function acts after the view is loaded and appears on the phone. */
    override func viewDidAppear(animated: Bool) {
        if !hasAppLaunchedBefore() {
            self.performSegueWithIdentifier("introSegue", sender: self)
            self.navigationItem.leftBarButtonItem?.enabled = false
        }
    }
    
    // prepare for segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "introSegue" {
            if let introViewController = segue.destinationViewController as? IntroViewController {
                introViewController.mainViewController = sender as? MainViewController
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Helper function for determining if the application has been launched before
    private func hasAppLaunchedBefore() -> Bool {
        let defaultSettings = NSUserDefaults.standardUserDefaults()
        
        if let _ = defaultSettings.stringForKey("hasLaunchedBefore") {
            return true
        }
        else {
            defaultSettings.setBool(true, forKey: "hasLaunchedBefore")
            return false
        }
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! VarietyItemCollectionViewCell
        cell.title.text = items[indexPath.row]
        print("assigned cell to \(cell.title.text)")
        return cell
    }
}

