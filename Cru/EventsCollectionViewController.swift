//
//  EventsCollectionViewController.swift
//  Cru
//
//  Created by Deniz Tumer on 3/4/16.
//  Copyright © 2016 Jamaican Hopscotch Mafia. All rights reserved.
//

import UIKit
import Crashlytics
import DZNEmptyDataSet

class EventsCollectionViewController: UICollectionViewController, DZNEmptyDataSetDelegate, DZNEmptyDataSetSource {

    var events = [Event]()
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.revealViewController() != nil{
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        //uncomment this line out to crash the app
        //Crashlytics.sharedInstance().crash()
        

        //self.navigationController!.navigationBar.translucent = false
        
        //load events
        CruClients.getServerClient().getData(.Event, insert: insertEvent, completionHandler: finishInserting)
    }
    
    func imageForEmptyDataSet(scrollView: UIScrollView!) -> UIImage! {
        return UIImage(named: Config.noConnectionImageName)
    }
    
    //insert helper function for inserting event data
    private func insertEvent(dict: NSDictionary) {
        self.events.insert(Event(dict: dict)!, atIndex: 0)
    }

    //helper function for finishing off inserting event data
    private func finishInserting(success: Bool) {
        //TODO: handler failure here!
        self.events.sortInPlace(Event.sortEventsByDate)
        self.collectionView!.reloadData()
        
        print("HELLO THERE. DONE LOADING")
    }

    // MARK: UICollectionViewDataSource
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return events.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(Config.eventReuseIdentifier, forIndexPath: indexPath) as! EventsCollectionViewCell
    
        cell.event = events[indexPath.item]
    
        return cell
    }
    
    //function for adding functionality for clicing of cells
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let layout = collectionViewLayout as! UltravisualLayout
        let offset = layout.dragOffset * CGFloat(indexPath.item)
        if collectionView.contentOffset.y != offset {
            collectionView.setContentOffset(CGPoint(x: 0, y: offset), animated: true)
        }
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "eventDetails" {
            let eventDetailViewController = segue.destinationViewController as! EventDetailsViewController
            let selectedEventCell = sender as! EventsCollectionViewCell
            let indexPath = self.collectionView!.indexPathForCell(selectedEventCell)!
            let selectedEvent = events[indexPath.row]
            
            eventDetailViewController.event = selectedEvent
        }
    }
}
