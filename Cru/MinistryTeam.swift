//
//  File.swift
//  Cru
//
//  Created by Deniz Tumer on 3/2/16.
//  Copyright © 2016 Jamaican Hopscotch Mafia. All rights reserved.
//

import Foundation

class MinistryTeam {
    var id: String
    var parentMinistry: String
    var description: String
    var ministryName: String
    var image: UIImage!
    var teamImage: UIImage!
    var leaders: [String]
    var userIsPartOf: Bool
    
    init?(dict: NSDictionary) {
        //required initialization of variables
        self.id = ""
        self.parentMinistry = ""
        self.ministryName = ""
        self.description = ""
        self.image = nil
        self.teamImage = nil
        self.leaders = [String]()
        self.userIsPartOf = false
        
        //grabbing dictionary values
        let dId = dict.objectForKey("_id")
        let dParentMinistry = dict.objectForKey("parentMinistry")
        let dDescription = dict.objectForKey("description")
        let dMinistryName = dict.objectForKey("name")
        let dImage = dict.objectForKey("image")
//        let dTeamImage = dict.objectForKey("teamImage")
        let dLeaders = dict.objectForKey("leaders")
        
        //set up object
        if (dId != nil) {
            self.id = dId as! String
        }
        if (dParentMinistry != nil) {
            self.parentMinistry = dParentMinistry as! String
        }
        if (dDescription != nil) {
            self.description = dDescription as! String
        }
        if (dMinistryName != nil) {
            self.ministryName = dMinistryName as! String
        }
        if (dImage != nil) {
            if let imageUrl = dImage?.objectForKey("secure_url") {
                self.image = GlobalUtils.getImageFromUrl(imageUrl as! String)
            }
            else {
                print("error: no image to display")
            }
        }
        else {
            self.image = UIImage(named: "fall-retreat-still")
        }
        if (dLeaders != nil) {
            self.leaders = dLeaders as! [String]
        }
    }
}