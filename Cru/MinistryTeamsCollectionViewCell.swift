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
    @IBOutlet weak var joinButton: UIButton!
    
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
        let minAlpha: CGFloat = 0.6
        let maxAlpha: CGFloat = 0.9
        imageCoverView.alpha = maxAlpha - (delta * (maxAlpha - minAlpha))
        
        let scale = max(delta, 0.9)
        ministryTeamLabel.transform = CGAffineTransformMakeScale(scale, scale)
        
        descriptionTextView.alpha = delta
        separator.alpha = delta
        
        if joinButton != nil {
            joinButton.alpha = delta            
        }
    }
}