//
//  CGLeaderCell.swift
//  Cru
//
//  Created by Peter Godkin on 5/26/16.
//  Copyright © 2016 Jamaican Hopscotch Mafia. All rights reserved.
//

import UIKit

class CGLeaderCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var phone: UILabel!
    
    @IBOutlet weak var email: UILabel!
    
    private var user: User!
    
    func setUser(user: User) {
        self.user = user
        name.text = user.name
        phone.text = user.phone
        email.text = user.email
    }
    
}
