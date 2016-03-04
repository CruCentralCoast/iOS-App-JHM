//
//  MinistryTeamsCollectionViewCell.swift
//  Cru
//
//  Created by Deniz Tumer on 3/2/16.
//  Copyright © 2016 Jamaican Hopscotch Mafia. All rights reserved.
//

import UIKit
import Alamofire

class MinistryTeamsCollectionViewCell: UICollectionViewCell {
    //variable storing the constant for ministry tema keys in NSUserDefaults
    
    @IBOutlet private weak var ministryTeamImageView: UIImageView!
    @IBOutlet private weak var imageCoverView: UIView!
    @IBOutlet private weak var ministryTeamLabel: UILabel!
    @IBOutlet private weak var descriptionTextView: UITextView!
    @IBOutlet private weak var separator: UIView!
    @IBOutlet private weak var joinButton: UIButton!
    
    var ministryTeam: MinistryTeam? {
        didSet {
            if let ministryTeam = ministryTeam {
                ministryTeamImageView.image = ministryTeam.image
                ministryTeamLabel.text = ministryTeam.ministryName
                descriptionTextView.text = ministryTeam.description
            }
        }
    }
    
    var leaders: NSArray?
    
    override func applyLayoutAttributes(layoutAttributes: UICollectionViewLayoutAttributes) {
        super.applyLayoutAttributes(layoutAttributes)
        
        // 1
        let standardHeight = UltravisualLayoutConstants.Cell.standardHeight
        let featuredHeight = UltravisualLayoutConstants.Cell.featuredHeight
        
        // 2
        let delta = 1 - ((featuredHeight - CGRectGetHeight(frame)) / (featuredHeight - standardHeight))
        
        // 3
        let minAlpha: CGFloat = 0.4
        let maxAlpha: CGFloat = 0.85
        imageCoverView.alpha = maxAlpha - (delta * (maxAlpha - minAlpha))
        
        let scale = max(delta, 0.9)
        ministryTeamLabel.transform = CGAffineTransformMakeScale(scale, scale)
        
        descriptionTextView.alpha = delta
        separator.alpha = delta
        
        if joinButton != nil {
            joinButton.alpha = delta            
        }
    }
    
    //function for signing up to a ministry team when clicking on the sign up button
    @IBAction func ministryTeamSignUp(sender: AnyObject) {
        let defaults = NSUserDefaults.standardUserDefaults()
        //let leaders = ministryTeam!.leaders
        
        //1: Check to see if user has already signed up (info is stored locally)
        let ministryTeams = MinistryTeamsCollectionViewController.loadMinistryTeams(defaults)
        
        if ministryTeams == nil {
            registerUserInMinistry(defaults, ministries: nil)
        }
        else if !ministryTeams!.contains(ministryTeam!.id) {
            registerUserInMinistry(defaults, ministries: ministryTeams)
        }
    }
    
    //registers a user in a ministry
    private func registerUserInMinistry(prefs: NSUserDefaults, ministries: [String]!) {
        var ministryTeams: [String]!
        
        //if there are no ministry teams the user has applied to
        if ministries == nil {
            ministryTeams = [String]()
        }
        else {
            ministryTeams = ministries
        }
        
        //append on ministry team we are a part of
        ministryTeams.append(ministryTeam!.id)
        
        let archivedObject = NSKeyedArchiver.archivedDataWithRootObject(ministryTeams as NSArray)
        prefs.setObject(archivedObject, forKey: Config.ministryTeamNSDefaultsKey)
        prefs.synchronize()
        
        //sends notifications
        ServerUtils.joinMinistryTeam(ministryTeam!.id, callback: retrieveLeaderInformation)
        //reformat button
        reconfigureMinistryTeamCard()
    }
    
    //reconfigures sign up button with new action
    func reconfigureMinistryTeamCard() {
        joinButton.removeFromSuperview()
//        joinButton.setTitle("Leave Team", forState: .Normal)
//        joinButton.removeTarget(nil, action: nil, forControlEvents: .AllEvents)
//        joinButton.addTarget(self, action: "removeUserFromMinistryTeam:", forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    //callback function to pass to serverUtils
    private func retrieveLeaderInformation(leaders: NSArray) {
        self.leaders = leaders
    }
}
