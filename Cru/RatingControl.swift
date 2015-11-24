//
//  RatingControl.swift
//  Cru
//
//  Created by Erica Solum on 11/18/15.
//  Copyright © 2015 Jamaican Hopscotch Mafia. All rights reserved.
//

import UIKit

class RatingControl: UIView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
   
   // MARK: Properties
   
   var ratingButtons = [UIButton]()
   var spacing = 5
   var stars = 5
   var rating = 0 {
      didSet {
         setNeedsLayout()
      }
   }
   
   // MARK: Initialization
   required init?(coder aDecoder: NSCoder) {
      super.init(coder: aDecoder)
      let filledStarImage = UIImage(named: "filledStar")
      let emptyStarImage = UIImage(named: "emptyStar")
      
      for _ in 0..<stars {
         let button = UIButton()
         button.setImage(emptyStarImage, forState: .Normal)
         button.setImage(filledStarImage, forState: .Selected)
         button.setImage(filledStarImage, forState: [.Highlighted, .Selected])
         button.adjustsImageWhenHighlighted = false
         button.addTarget(self, action: "ratingButtonTapped:", forControlEvents: .TouchDown)
         ratingButtons += [button]
         addSubview(button)
      }
   }
   
   override func layoutSubviews() {
      // Set the button's width and height to a square the size of the frame's height.
      let buttonSize = Int(frame.size.height)
      var buttonFrame = CGRect(x: 0, y: 0, width: buttonSize, height: buttonSize)
      
      // Offset each button's origin by the length of the button plus some spacing.
      for (index, button) in ratingButtons.enumerate() {
         buttonFrame.origin.x = CGFloat(index * (buttonSize + 5))
         button.frame = buttonFrame
      }
      
      updateButtonSelectionStates()
   }
   
   override func intrinsicContentSize() -> CGSize {
      let buttonSize = 44
      let width = (buttonSize + spacing) * stars
      
      return CGSize(width: width, height: buttonSize)
   }
   
   // MARK: Button Action
   
   func ratingButtonTapped(button: UIButton) {
      rating = ratingButtons.indexOf(button)! + 1
      updateButtonSelectionStates()
   }
   
   func updateButtonSelectionStates() {
      for (index, button) in ratingButtons.enumerate() {
         // If the index of a button is less than the rating, that button should be selected.
         button.selected = index < rating
      }
   }
}
