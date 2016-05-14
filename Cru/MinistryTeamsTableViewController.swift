//
//  MinistryTeamsTableViewController.swift
//  Cru
//
//  Created by Deniz Tumer on 5/13/16.
//  Copyright © 2016 Jamaican Hopscotch Mafia. All rights reserved.
//

import UIKit

class MinistryTeamsTableViewController: UITableViewController {

    var ministryTeamsStorageManager: MapLocalStorageManager!
    var ministryTeams = [MinistryTeam]()
    private let reuseIdentifier = "ministryTeamCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //setup local storage manager
        ministryTeamsStorageManager = MapLocalStorageManager(key: Config.ministryTeamStorageKey)
        
        //load ministry teams
        CruClients.getServerClient().getData(.MinistryTeam, insert: insertMinistryTeam, completionHandler: finishInserting)

    }
    
    //inserts individual ministry teams into the collection view
    private func insertMinistryTeam(dict : NSDictionary) {
        self.ministryTeams.insert(MinistryTeam(dict: dict)!, atIndex: 0)
    }
    
    //reload the collection view data and store whether or not the user is in the repsective ministries
    private func finishInserting(success: Bool) {
        //TODO: handle failure
        self.tableView.reloadData()
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let ministryTeam = ministryTeams[indexPath.row]
        let descLength = ministryTeam.description.characters.count
        
        print(ministryTeam.ministryName + ": " + String(Double(descLength) / 40))
        
        return 350.0
        //return 120.0 + (CGFloat(Double(descLength) / 40.0) * 25.0) + 8.0
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ministryTeams.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier, forIndexPath: indexPath) as! MinistryTeamsTableViewCell
        let ministryTeam = ministryTeams[indexPath.row]
        
        cell.ministryTeam = ministryTeam
        
        return cell
    }
}
