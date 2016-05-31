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
    
    @IBOutlet weak var meetingTime: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var descript: UITextView!
    @IBOutlet weak var ministry: UILabel!
    @IBOutlet weak var table: UITableView!
    
    private var leaveCallback: (Void->Void)!

    @IBAction func leaveGroup(sender: AnyObject) {
        GlobalUtils.saveString(Config.communityGroupKey, value: "")
        leaveCallback()
    }
    
    override func viewWillAppear(animated: Bool) {
        let groupId = GlobalUtils.loadString(Config.communityGroupKey)
        if (groupId != "") {
            loadCommunityGroup(groupId)
        }
    }

    private func loadCommunityGroup(id: String) {
        CruClients.getServerClient().getById(DBCollection.CommunityGroup, insert: insertGroup, completionHandler: loadLeaders, id: id)
    }

    private func insertGroup(dict: NSDictionary) {
        group = CommunityGroup(dict: dict)
        meetingTime.text = group.meetingTime
        print("Name: \(group.name)")
        name.text = group.name
        descript.text = group.description
        ministry.text = group.parentMinitry
    }
    
    private func loadLeaders(success: Bool) {
        print("load leaders \(success)")
        if (success) {
            CruClients.getServerClient().getDataIn(DBCollection.CommunityGroup, parentId: group.id, child: DBCollection.Leader, insert: insertLeader, completionHandler: finishInserting)
        }
    }
    
    private func insertLeader(dict: NSDictionary) {
        print("leader: \(dict)")
        let cell = self.table.dequeueReusableCellWithIdentifier("cell")!
        let leaderCell = cell as! CGLeaderCell
        leaderCell.setUser(User(dict: dict))
        leaders.append(leaderCell)
        table.insertRowsAtIndexPaths([NSIndexPath(forItem: 0, inSection: 0)], withRowAnimation: .Automatic)
    }
    
    private func finishInserting(success: Bool) {
        table.reloadData()
        MRProgressOverlayView.dismissOverlayForView(self.view, animated: true)
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return leaders.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return leaders[indexPath.row]
    }
    
    func setLeaveCallback(callback: Void->Void) {
        leaveCallback = callback
    }

}
