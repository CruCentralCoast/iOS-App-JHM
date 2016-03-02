//
//  SummerMissionCell
//  Cru
//
//  Created by Quan Tran on 2/2/16.
//  Copyright © 2016 Jamaican Hopscotch Mafia. All rights reserved.
//

import Foundation

class SummerMissionCell: UICollectionViewCell {
    //MARK: Properties
    //private static let DIMENSIONS = 200
    //private let FRAME = CGRect(x: DIMENSIONS/2, y: DIMENSIONS/2, width: DIMENSIONS, height: DIMENSIONS)
    
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var imageCoverView: UIView!
    @IBOutlet private weak var nameLabel: UILabel!
    
    var mission: SummerMission? {
        didSet {
            if let mission = mission {
                imageView.image = mission.image
                nameLabel.text = mission.name
                nameLabel.font = nameLabel.font.fontWithSize(22)
            }
        }
    }
    
    // Dynamically adjusts the clarity  of cells as the user scrolls
    override func applyLayoutAttributes(layoutAttributes: (UICollectionViewLayoutAttributes!)) {
        super.applyLayoutAttributes(layoutAttributes)
        
        let standardHeight = UltravisualLayoutConstants.Cell.standardHeight
        let featuredHeight = UltravisualLayoutConstants.Cell.featuredHeight
        
        // 2
        let height = CGRectGetHeight(frame)
        
        //let delta = height < featuredHeight ? 1 - ((featuredHeight - height) / (featuredHeight - standardHeight)) : ((featuredHeight - CGRectGetMinY(frame)) / (featuredHeight - standardHeight))
        
        let delta = 1 - ((featuredHeight - height) / (featuredHeight - standardHeight))
        
        if let name = mission?.name {
            print("mission " + name + " at " + String(CGRectGetMinY(frame)))
        }
        
        // 3
        let minAlpha: CGFloat = 0.25
        let maxAlpha: CGFloat = 0.75
        
        if let imageCoverView = self.imageCoverView {
            imageCoverView.alpha = maxAlpha - (delta * (maxAlpha - minAlpha))
            imageCoverView.sizeToFit()
        }
    }
}
