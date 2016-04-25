//
//  MinistryTeamViewController.swift
//  Cru
//
//  Created by Deniz Tumer on 4/21/16.
//  Copyright © 2016 Jamaican Hopscotch Mafia. All rights reserved.
//

import UIKit

class MinistryTeamViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    //view objects for hiding and showing the table view
    @IBOutlet weak var ministryTeamView: UIView!
    @IBOutlet weak var ministryTeamTableView: UITableView!
    @IBOutlet weak var joinMTeamView: UIView!
    
    //vars for holding ministry team data and the local storage manager
    var ministryTeams = [NSDictionary]()
    var ministryTeamsStorageManager: MapLocalStorageManager!
    var refreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //setup local storage manager
        ministryTeamsStorageManager = MapLocalStorageManager(key: Config.ministryTeamStorageKey)
        
        if let joinedTeams = ministryTeamsStorageManager.getObject(Config.ministryTeamStorageKey) {
            
            //check if the map object is empty or not
            if joinedTeams.count > 0 {
                toggleMinistryTableView(false)
                insertMinistryTeams()
            }
            else {
                toggleMinistryTableView(true)
            }
        }
        else {
            //show initial view
            toggleMinistryTableView(true)
        }
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "")
        self.refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.ministryTeamTableView.addSubview(self.refreshControl)
    }

    //toggle table view
    private func toggleMinistryTableView(hidden: Bool) {
        if hidden {
            joinMTeamView.hidden = false
            ministryTeamView.hidden = true
        }
        else {
            ministryTeamView.hidden = false
            joinMTeamView.hidden = true
        }
    }

    //refreshes the table view
    func refresh(sender:AnyObject)
    {
        ministryTeams.removeAll()
        self.ministryTeamTableView.reloadData()
        insertMinistryTeams()
    }
    
    //navigates to the ministry teams list
    @IBAction func onTouchSeeMore(sender: AnyObject) {
        let storyboard = UIStoryboard(name: "ministryteam", bundle: nil)
        let viewController = storyboard.instantiateViewControllerWithIdentifier("MinistryTeamsCollectionViewController")
        self.navigationController?.pushViewController(viewController, animated: true)
    }

    /* Table View Delegate code */
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ministryTeams.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // your cell coding
        let cell = tableView.dequeueReusableCellWithIdentifier("ministryTeam") as! JoinedTeamsTableViewCell
        let ministryTeam = ministryTeams[indexPath.item]
        cell.ministryTeam = ministryTeam
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let ministryTeam = ministryTeams[indexPath.item]
        
        let viewController = self.storyboard!.instantiateViewControllerWithIdentifier("MinistryTeamDetailViewController") as! MinistryTeamDetailViewController
        viewController.ministryTeam = ministryTeam
        viewController.listVC = self
        
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    //inserts ministry teams to table
    private func insertMinistryTeams() {
        //setup local storage manager
        ministryTeamsStorageManager = MapLocalStorageManager(key: Config.ministryTeamStorageKey)
        
        let keys: [String] = ministryTeamsStorageManager.getKeys()
        
        for var key in keys {
            ministryTeams.append(ministryTeamsStorageManager.getElement(key) as! NSDictionary)
        }
        
        self.ministryTeamTableView.reloadData()
        
        if let refresh = self.refreshControl {
            refresh.endRefreshing()
        }
    }
}
