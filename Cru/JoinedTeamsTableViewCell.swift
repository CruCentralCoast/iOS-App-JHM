//
//  JoinedTeamsTableViewCell.swift
//  Cru
//
//  Created by Deniz Tumer on 4/21/16.
//  Copyright © 2016 Jamaican Hopscotch Mafia. All rights reserved.
//

import UIKit

class JoinedTeamsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var ministryName: UILabel!
    
    var ministryTeam: NSDictionary? {
        didSet {
            if let ministryTeam = ministryTeam {
                ministryName.text = ministryTeam["name"] as? String
            }
        }
    }
}
