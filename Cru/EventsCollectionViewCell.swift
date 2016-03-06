//
//  EventsCollectionViewCell.swift
//  Cru
//
//  Created by Deniz Tumer on 3/4/16.
//  Copyright © 2016 Jamaican Hopscotch Mafia. All rights reserved.
//

import UIKit

class EventsCollectionViewCell: UICollectionViewCell {
    @IBOutlet private weak var eventImageView: UIImageView!
    @IBOutlet private weak var imageCoverView: UIView!
    @IBOutlet private weak var eventTitleLabel: UILabel!
    
    var event: Event? {
        didSet {
            if let event = event {
                eventImageView.image = event.image
                eventTitleLabel.text = event.name
//                ministryTeamImageView.image = ministryTeam.image
//                ministryTeamLabel.text = ministryTeam.ministryName
//                descriptionTextView.text = ministryTeam.description
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
        //ministryTeamLabel.transform = CGAffineTransformMakeScale(scale, scale)
        
        //descriptionTextView.alpha = delta
        //separator.alpha = delta
    }
}
