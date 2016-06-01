//
//  DisplayCGVC.swift
//  Cru
//
//  Created by Peter Godkin on 5/26/16.
//  Copyright © 2016 Jamaican Hopscotch Mafia. All rights reserved.
//

import UIKit
import MRProgress

class DisplayCGVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var leaders = [CGLeaderCell]()
    var group: CommunityGroup!
    var cells = [UITableViewCell]()
    @IBOutlet weak var table: UITableView!
    private var leaveCallback: (Void->Void)!

    @IBAction func leaveGroup(sender: AnyObject) {
        GlobalUtils.saveString(Config.communityGroupKey, value: "")
        leaveCallback()
    }
    
  
    
    override func viewDidLoad() {
        let groupId = GlobalUtils.loadString(Config.communityGroupKey)
        if (groupId != "") {
            loadCommunityGroup(groupId)
        }
        table.estimatedRowHeight = 300
        table.rowHeight = UITableViewAutomaticDimension
    }

    private func loadCommunityGroup(id: String) {
        CruClients.getServerClient().getById(DBCollection.CommunityGroup, insert: insertGroup, completionHandler: loadLeaders, id: id)
    }

    private func insertGroup(dict: NSDictionary) {
        group = CommunityGroup(dict: dict)
        
        if let cell = table.dequeueReusableCellWithIdentifier("cell")! as? CGDetailTableViewCell{
            cell.cellTitle.text = "Meeting Time:"
            cell.cellValue.text = group.getMeetingTime()
            cells.append(cell)
            table.insertRowsAtIndexPaths([NSIndexPath(forItem: 0, inSection: 0)], withRowAnimation: .Automatic)
        }
        
        if let cell = table.dequeueReusableCellWithIdentifier("cell")! as? CGDetailTableViewCell{
            cell.cellTitle.text = "Name:"
            cell.cellValue.text = group.name
            cells.append(cell)
            table.insertRowsAtIndexPaths([NSIndexPath(forItem: 0, inSection: 0)], withRowAnimation: .Automatic)
        }
        
        if let cell = table.dequeueReusableCellWithIdentifier("cell")! as? CGDetailTableViewCell{
            cell.cellTitle.text = "Description:"
            cell.cellValue.text = group.description
            cells.append(cell)
            table.insertRowsAtIndexPaths([NSIndexPath(forItem: 0, inSection: 0)], withRowAnimation: .Automatic)
        }
        
        if let cell = table.dequeueReusableCellWithIdentifier("cell")! as? CGDetailTableViewCell{
            cell.cellTitle.text = "Ministry:"
            cell.cellValue.text = group.parentMinitry
            cells.append(cell)
            table.insertRowsAtIndexPaths([NSIndexPath(forItem: 0, inSection: 0)], withRowAnimation: .Automatic)
        }
        
        self.table.reloadData()
    }
    
    private func loadLeaders(success: Bool) {
        if (success) {
            //CruClients.getServerClient().getDataIn(DBCollection.CommunityGroup, parentId: group.id, child: DBCollection.Leader, insert: insertLeader, completionHandler: finishInserting)
            
            if (group.leaders != nil && group.leaders.count > 0) {
                CruClients.getServerClient().getData(.User, insert: insertLeader, completionHandler: finishInserting, params: ["_id":["$in": group.leaders]])
            }
            
        }
    }
    
    private func insertLeader(dict: NSDictionary) {
        if let cell = self.table.dequeueReusableCellWithIdentifier("leaderCell")! as? CGLeaderCell{
            cell.setUser(User(dict: dict))
            cells.append(cell)
            table.insertRowsAtIndexPaths([NSIndexPath(forItem: 0, inSection: 0)], withRowAnimation: .Automatic)
        }
    }
    
    private func finishInserting(success: Bool) {
        table.reloadData()
        MRProgressOverlayView.dismissOverlayForView(self.view, animated: true)
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return cells[indexPath.row]
    }
    
    func setLeaveCallback(callback: Void->Void) {
        leaveCallback = callback
    }

}
