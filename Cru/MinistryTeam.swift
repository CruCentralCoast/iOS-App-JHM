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
    
    init?(dict: NSDictionary) {
        //required initialization of variables
        self.id = ""
        self.parentMinistry = ""
        self.ministryName = ""
        self.description = ""
        self.image = nil
        self.teamImage = nil
        
        //grabbing dictionary values
        let dId = dict.objectForKey("_id")
        let dParentMinistry = dict.objectForKey("parentMinistry")
        let dDescription = dict.objectForKey("description")
        let dMinistryName = dict.objectForKey("name")
        let dImage = dict.objectForKey("image")
//        let dTeamImage = dict.objectForKey("teamImage")
        
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
                self.image = getImageFromUrl(imageUrl as! String)
            }
            else {
                print("error: no image to display")
            }
        }
        else {
            self.image = UIImage(named: "fall-retreat-still")
        }
    }
    
    // gets UIImage from cloudinary URL's
    private func getImageFromUrl(imageUrl: String) -> UIImage {
        let cloudUrl = NSURL(string: imageUrl)
        let imageData = NSData(contentsOfURL: cloudUrl!)
        
        return UIImage(data: imageData!)!
    }
}