//
//  Cancler.swift
//  Cru
//
//  Created by Max Crane on 3/2/16.
//  Copyright © 2016 Jamaican Hopscotch Mafia. All rights reserved.
//

import Foundation

class Cancler {
    
    static func confirmCancel(view: UIViewController, handler: (action: UIAlertAction)->()){
        let cancelAlert = UIAlertController(title: "Are you sure you want to leave this ride?", message: "This action is permanent", preferredStyle: UIAlertControllerStyle.Alert)
        
        cancelAlert.addAction(UIAlertAction(title: "Confirm", style: .Destructive, handler: handler))
        cancelAlert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: nil))
        view.presentViewController(cancelAlert, animated: true, completion: nil)
    }
    
    static func showCancelSuccess(view: UIViewController, handler: (UIAlertAction)->()){
        let cancelAlert = UIAlertController(title: "Ride Cancelled Successfully", message: "", preferredStyle: UIAlertControllerStyle.Alert)
        
        cancelAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: handler))

        view.presentViewController(cancelAlert, animated: true, completion: nil)
    }
    
    static func showCancelFailure(view: UIViewController){
        let cancelAlert = UIAlertController(title: "Could Not Cancel Ride", message: "", preferredStyle: UIAlertControllerStyle.Alert)
        
        cancelAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
        
        view.presentViewController(cancelAlert, animated: true, completion: nil)
    }
}