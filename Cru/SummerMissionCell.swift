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
    
    private let MARGIN = CGFloat(20.0)
    private let MODAL_CORNER_RADIUS = CGFloat(5.0)
    
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var imageCoverView: UIView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    
    var mission: SummerMission? {
        didSet {
            if let mission = mission {
                imageView.image = mission.image
                
                nameLabel.text = mission.name
                nameLabel.sizeToFit()
                
                dateLabel.text = mission.startDate.formatMonthDayYear() + " - " + mission.endDate.formatMonthDayYear()
            }
        }
    }
    
    // Dynamically adjusts the clarity  of cells as the user scrolls and button position
    override func applyLayoutAttributes(layoutAttributes: (UICollectionViewLayoutAttributes!)) {
        super.applyLayoutAttributes(layoutAttributes)
        adjustClarity()
    }
    
    // Adjust alpha of cell overlay
    func adjustClarity() {
        let standardHeight = UltravisualLayoutConstants.Cell.standardHeight
        let featuredHeight = UltravisualLayoutConstants.Cell.featuredHeight
        
        let height = CGRectGetHeight(frame)
        
        //let delta = height < featuredHeight ? 1 - ((featuredHeight - height) / (featuredHeight - standardHeight)) : ((featuredHeight - CGRectGetMinY(frame)) / (featuredHeight - standardHeight))
        
        let delta = 1 - ((featuredHeight - height) / (featuredHeight - standardHeight))
        
        // 3
        let minAlpha: CGFloat = 0.15
        let maxAlpha: CGFloat = 0.5
        
        if let imageCoverView = self.imageCoverView {
            imageCoverView.alpha = maxAlpha - (delta * (maxAlpha - minAlpha))
            imageCoverView.sizeToFit()
        }
    }
}
