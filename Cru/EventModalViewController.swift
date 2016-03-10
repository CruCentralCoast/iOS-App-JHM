//
//  EventModalViewController.swift
//  Cru
//
//  Created by Deniz Tumer on 3/9/16.
//  Copyright © 2016 Jamaican Hopscotch Mafia. All rights reserved.
//

import UIKit

class EventModalViewController: UIViewController {
    
    @IBOutlet private weak var backgroundModal: UIView!
    var eventModalClosure: ((Event)->())!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViewProperties()
    }
    
    //Configures special view properties
    private func configureViewProperties() {
        self.view.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(Config.backgroundViewOpacity)
        backgroundModal.layer.cornerRadius = Config.modalBackgroundRadius
    }
    
    @IBAction func unwindWithSelectedEvent(segue: UIStoryboardSegue) {
        if let eventPickerViewController = segue.sourceViewController as? ChooseEventTableViewController, selectedEvent = eventPickerViewController.selectedEvent {
            eventModalClosure(selectedEvent)
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
}
