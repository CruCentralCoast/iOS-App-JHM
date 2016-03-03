//
//  MinistryTeamsCollectionViewCell.swift
//  Cru
//
//  Created by Deniz Tumer on 3/2/16.
//  Copyright © 2016 Jamaican Hopscotch Mafia. All rights reserved.
//

import UIKit

class MinistryTeamsCollectionViewCell: UICollectionViewCell {
    @IBOutlet private weak var ministryTeamImageView: UIImageView!
    @IBOutlet private weak var imageCoverView: UIView!
    @IBOutlet private weak var ministryTeamLabel: UILabel!
    @IBOutlet private weak var descriptionTextView: UITextView!
    
    var ministryTeam: MinistryTeam? {
        didSet {
            if let ministryTeam = ministryTeam {
                ministryTeamImageView.image = ministryTeam.image
                ministryTeamLabel.text = ministryTeam.ministryName
                descriptionTextView.text = ministryTeam.description
            }
        }
    }
    
    override func applyLayoutAttributes(layoutAttributes: UICollectionViewLayoutAttributes) {
        super.applyLayoutAttributes(layoutAttributes)
        
        // 1
        let standardHeight = UltravisualLayoutConstants.Cell.standardHeight
        let featuredHeight = UltravisualLayoutConstants.Cell.featuredHeight
        
        // 2
        let delta = 1 - ((featuredHeight - CGRectGetHeight(frame)) / (featuredHeight - standardHeight))
        
        // 3
        let minAlpha: CGFloat = 0.3
        let maxAlpha: CGFloat = 0.75
        imageCoverView.alpha = maxAlpha - (delta * (maxAlpha - minAlpha))
        
        let scale = max(delta, 0.5)
        ministryTeamLabel.transform = CGAffineTransformMakeScale(scale, scale)
        
        descriptionTextView.alpha = delta
    }
}
