//
//  MinistryTeamNoPictureTableViewCell.swift
//  Cru
//
//  Created by Deniz Tumer on 5/17/16.
//  Copyright © 2016 Jamaican Hopscotch Mafia. All rights reserved.
//

import UIKit

class MinistryTeamNoPictureTableViewCell: UITableViewCell {
    @IBOutlet weak var ministryTeamNameLabel: UILabel!
    @IBOutlet weak var ministryDescriptionLabel: UITextView!
    
    var ministryTeam: MinistryTeam! {
        didSet {
            ministryTeamNameLabel.text = ministryTeam.ministryName
            ministryDescriptionLabel.text = ministryTeam.description
        }
    }
}
