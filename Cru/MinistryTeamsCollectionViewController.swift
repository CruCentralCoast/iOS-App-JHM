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
        if var userMinistryTeams = MinistryTeamsCollectionViewController.loadMinistryTeams(defaults) {
            
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
        
        if cell.ministryTeam!.userIsPartOf {
            //change cell to show leaders
            cell.reconfigureMinistryTeamCard()
        }
        
        return cell
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
    internal class func loadMinistryTeams(prefs: NSUserDefaults) -> [String]? {
        if let unarchivedObject = NSUserDefaults.standardUserDefaults().objectForKey(Config.ministryTeamNSDefaultsKey) as? NSData {
            return NSKeyedUnarchiver.unarchiveObjectWithData(unarchivedObject) as? [String]
        }
        
        return nil
    }
    
    @IBAction func resetSignUp(sender: AnyObject) {
        let defaults = NSUserDefaults.standardUserDefaults()
        
        var ministryTeams = MinistryTeamsCollectionViewController.loadMinistryTeams(defaults)
        
        if ministryTeams != nil {
            ministryTeams = [String]()
        }
        
        let archivedObject = NSKeyedArchiver.archivedDataWithRootObject(ministryTeams as! NSArray)
        defaults.setObject(archivedObject, forKey: Config.ministryTeamNSDefaultsKey)
        defaults.synchronize()
    }
}
