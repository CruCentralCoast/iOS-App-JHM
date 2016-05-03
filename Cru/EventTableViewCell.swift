//
//  EventTableViewCell.swift
//  Cru
//
//  Created by Deniz Tumer on 4/28/16.
//  Copyright © 2016 Jamaican Hopscotch Mafia. All rights reserved.
//

import UIKit

class EventTableViewCell: UITableViewCell {
    @IBOutlet weak var eventTitleLabel: UILabel!
    
    var event: Event! {
        didSet {
            eventTitleLabel.text = event.name
        }
    }
}
