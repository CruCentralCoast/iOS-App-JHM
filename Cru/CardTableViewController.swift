//
//  CardTableViewController.swift
//  This is a custom table view controller class for displaying resources as cards
//  in the Resources section of the app.
//
//  Created by Erica Solum on 2/14/16.
//  Copyright © 2016 Jamaican Hopscotch Mafia. All rights reserved.
//

import UIKit
import WildcardSDK

class CardTableViewController: UITableViewController, CardViewDelegate {
    
    // MARK: Properties
    var resources = [Resource]()
    var resourceLinks = [String]()
    var cardViews = [CardView]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.tableView.separatorColor = UIColor.clearColor()
        //loadSampleResources()
        self.tableView.reloadData()
        
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 50
        
        
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    func insertResource(dict : NSDictionary) {
        self.tableView.beginUpdates()
        resources.insert(Resource(dict: dict)!, atIndex: 0)
        self.tableView.insertRowsAtIndexPaths([NSIndexPath(forItem: 0, inSection: 0)], withRowAnimation: .Automatic)
        self.tableView.endUpdates()
    }
    
    func loadSampleResources() {
        
        let videoURL = NSURL.init(string: "https://www.youtube.com/watch?v=EgRqJTHJNKQ")
        
        Card.getFromUrl(videoURL) {
            (card: Card?, error: NSError?) in
            
            if(card != nil) {
                print("\nCard was created from URL\n")
                let videoCardView = CardView.createCardView(card!, layout: .VideoCardShortFull)
                videoCardView!.delegate = self
                self.cardViews += [videoCardView!]
                print("\nNum card views: \(self.cardViews.count)\n")
                
                self.tableView.insertRowsAtIndexPaths([NSIndexPath(forItem: 0, inSection: 0)], withRowAnimation: .Automatic)
            }
            else {
                print("\nYoyoyo Didn't get a card? \n")
            }
        }
        
        let videoURL2 = NSURL.init(string: "https://www.youtube.com/watch?v=j62bxcmWJX4")
        //let videoCard = Card.init(webUrl: videoURL, cardType: "video")
        
        Card.getFromUrl(videoURL2) {
            (card: Card?, error: NSError?) in
            
            if(card != nil) {
                print("\nCard was created from URL\n")
                let videoCardView2 = CardView.createCardView(card!, layout: .VideoCardShortFull)
                videoCardView2!.delegate = self
                self.cardViews += [videoCardView2!]
                print("\nNum card views: \(self.cardViews.count)\n")
                
                self.tableView.insertRowsAtIndexPaths([NSIndexPath(forItem: 0, inSection: 0)], withRowAnimation: .Automatic)
                
                
            }
            
        }
        
        let videoURL3 = NSURL.init(string: "https://www.youtube.com/watch?v=w1CePmWyCKU")
        //let videoCard = Card.init(webUrl: videoURL, cardType: "video")
        
        Card.getFromUrl(videoURL3) {
            (card: Card?, error: NSError?) in
            
            if(card != nil) {
                print("\nCard was created from URL\n")
                let videoCardView3 = CardView.createCardView(card!, layout: .VideoCardShortFull)
                videoCardView3!.delegate = self
                self.cardViews += [videoCardView3!]
                print("\nNum card views: \(self.cardViews.count)\n")
                
                self.tableView.insertRowsAtIndexPaths([NSIndexPath(forItem: 0, inSection: 0)], withRowAnimation: .Automatic)
                
            }
            
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("\nNum card views in the thing: \(cardViews.count)\n")
        return cardViews.count
    }

    //Configures each cell in the table view as a card and sets the UI elements to match with the Resource data
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "CardTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! CardTableViewCell
        let cardView = cardViews[indexPath.row]
        
        
        cell.contentView.addSubview(cardView)
        cell.contentView.backgroundColor = UIColor(red: 0.871, green: 0.871, blue: 0.871, alpha: 1.0)
        cardView.translatesAutoresizingMaskIntoConstraints = false
        cardView.horizontallyCenterToSuperView(0)
        cardView.constrainTopToSuperView(10)
        cardView.constrainBottomToSuperView(10)
        cardView.constrainRightToSuperView(10)
        cardView.constrainLeftToSuperView(10)
        
        
        
        //cell.contentView.superview?.superview?.superview?.superview?.constrainToSuperViewEdges()
        //self.tableView.superview?.superview?.superview?.constrainToSuperViewEdges()
        
        /*cell.titleLabel.text = resource.title
        cell.timeLabel.text = resource.date
        if(resource.imageName != "") {
            cell.imageView!.image = UIImage(named: resource.imageName)
        }*/

        return cell
    }
    override func viewDidAppear(animated: Bool) {
        print("SADFLK;ADSFADF")
        for subview in self.tableView.subviews {
            if (NSStringFromClass(subview.dynamicType) == "UITableViewWrapperView")
            {
                print("Things")
                tableView.bounds.size.width = UIScreen.mainScreen().bounds.size.width
                subview.frame = CGRectMake(0, 0, tableView.bounds.size.width, tableView.bounds.size.height);
                print("\nTable view bbounds: \(UIScreen.mainScreen().bounds.size.width)")
            }
        }
        
        
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
