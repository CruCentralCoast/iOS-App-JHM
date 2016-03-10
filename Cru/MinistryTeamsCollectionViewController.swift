//
//  MinistryTeamsCollectionViewController.swift
//  Cru
//
//  Created by Deniz Tumer on 3/2/16.
//  Copyright © 2016 Jamaican Hopscotch Mafia. All rights reserved.
//

import UIKit

class MinistryTeamsCollectionViewController: UICollectionViewController {

    var ministryTeams = [MinistryTeam]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //load ministry teams
        ServerUtils.loadResources(Config.ministryTeamResourceLoaderKey, inserter: insertMinistryTeam, afterFunc: finishInserting)

        //set background color of page and accelleration of cells
        collectionView!.backgroundColor = UIColor.blackColor()
        collectionView!.decelerationRate = UIScrollViewDecelerationRateFast
    }
    
    private func insertMinistryTeam(dict : NSDictionary) {
        self.ministryTeams.insert(MinistryTeam(dict: dict)!, atIndex: 0)
    }
    
    //reload the collection view data and store whether or not the user is in the repsective ministries
    private func finishInserting() {
        //load preference defaults on phone
        let defaults = NSUserDefaults.standardUserDefaults()
        
        //reload collection view data
        self.collectionView!.reloadData()
        
        //initial
        //1: grab ministry teams user is a part of
        //2: match those to ministry teams in the collection view
        //3: ministry teams that the user is a part of change card so that it shows leaders info and button
        //   is "leave ministry team"
        
        //when user clicks sign up
        //1: send user's info to ministry team leaders (notification, text, email, etc.)
        //2: change button, show leader info
        
        //if there are ministry teams stored on the phone
        if var userMinistryTeams = loadMinistryTeams(defaults) {
            
            userMinistryTeams.sortInPlace()
            
            for ministryId in userMinistryTeams {
                if let found = ministryTeams.indexOf({$0.id == ministryId}) {
                    ministryTeams[found].userIsPartOf = true
                }
            }
        }
    }

    // MARK: UICollectionViewDataSource
    //tells the collection view how many sections there are
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }

    //tells the collection view how many cells there are
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ministryTeams.count
    }

    //function for adding scrolling functionality for cells
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(Config.ministryTeamReuseIdentifier, forIndexPath: indexPath) as! MinistryTeamsCollectionViewCell
        
        cell.ministryTeam = ministryTeams[indexPath.item]
        
        //THIS BUTTON SHOULD ONLY APPEAR IF USER IS NOT ALREADY IN MINISTRY TEAM
        cell.joinButton?.layer.setValue(indexPath.row, forKey: "index")
        cell.joinButton?.addTarget(self, action: "joinMinistryTeam:", forControlEvents: UIControlEvents.TouchUpInside)
        
        if cell.ministryTeam!.userIsPartOf {
            //change cell to show leaders
        }
        
        return cell
    }
    
    //target action on ministry
    func joinMinistryTeam(sender: UIButton) {
        let index = sender.layer.valueForKey("index") as! Int
        let ministry = ministryTeams[index]
        var user = GlobalUtils.loadDictionary("user")
        
        if user == nil {
            user = ["name": "Deniz Tumer", "phone": "1234567890"]
        }
        
        ServerUtils.joinMinistryTeam(ministry.id, fullName: user!["name"] as! String, phone: user!["phone"] as! String, callback: showLeaderInformation(sender))
        
        showCompletionAlert()
    }
    
    func showCompletionAlert() {
        let alert = UIAlertController(title: "Thank You!", message: "Thank you for signing up for this ministry team. You will be sent the leader's information shortly", preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func showLeaderInformation(sender: UIButton) -> (NSArray -> Void) {
        return { (response: NSArray) in
            for leader in response {
                print(leader)
            }
            
            sender.removeFromSuperview()
        }
    }
    
    //function for adding functionality for clicing of cells
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let layout = collectionViewLayout as! UltravisualLayout
        let offset = layout.dragOffset * CGFloat(indexPath.item)
        if collectionView.contentOffset.y != offset {
            collectionView.setContentOffset(CGPoint(x: 0, y: offset), animated: true)
        }
    }
    
    //loads the ministry team array object from NSUserDefaults
    private func loadMinistryTeams(prefs: NSUserDefaults) -> [String]? {
        if let unarchivedObject = NSUserDefaults.standardUserDefaults().objectForKey(Config.ministryTeamNSDefaultsKey) as? NSData {
            return NSKeyedUnarchiver.unarchiveObjectWithData(unarchivedObject) as? [String]
        }
        
        return nil
    }
    
    //registers a user in a ministry
    private func registerUserInMinistry(prefs: NSUserDefaults, ministries: [String]!) {
        var ministryTeams: [String]!
        
        //if there are no ministry teams the user has applied to
        if ministries == nil {
            ministryTeams = [String]()
        }
        else {
            ministryTeams = ministries
        }
        
        //append on ministry team we are a part of
        //ministryTeams.append(ministryTeam!.id)
        
        let archivedObject = NSKeyedArchiver.archivedDataWithRootObject(ministryTeams as NSArray)
        prefs.setObject(archivedObject, forKey: Config.ministryTeamNSDefaultsKey)
        prefs.synchronize()
        
        //sends notifications
        //ServerUtils.joinMinistryTeam(ministryTeam!.id, callback: retrieveLeaderInformation)
    }
    
    @IBAction func resetSignUp(sender: AnyObject) {
        let defaults = NSUserDefaults.standardUserDefaults()
//        
//        let archivedObject = NSKeyedArchiver.archivedDataWithRootObject(ministryTeams as! NSArray)
//        defaults.setObject(archivedObject, forKey: Config.ministryTeamNSDefaultsKey)
//        defaults.synchronize()
    }
}
