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
    private let reuseIdentifierPic = "ministryTeamCell"
    private let reuseIdentifierNoPic = "ministryTeamNoPicCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.estimatedRowHeight = 200
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
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

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ministryTeams.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let ministryTeam = ministryTeams[indexPath.row]
        
        if ministryTeam.imageUrl == "" {
            let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifierNoPic, forIndexPath: indexPath) as! MinistryTeamNoPictureTableViewCell
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            cell.ministryTeam = ministryTeam
            
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifierPic, forIndexPath: indexPath) as! MinistryTeamsTableViewCell
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            cell.ministryTeam = ministryTeam
            
            return cell
        }
    }
}
