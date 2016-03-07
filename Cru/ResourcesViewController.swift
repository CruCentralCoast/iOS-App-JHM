//
//  ResourcesViewController.swift
//  Cru
//
//  Created by Max Crane on 11/17/15.
//  Copyright © 2015 Jamaican Hopscotch Mafia. All rights reserved.
//

import UIKit
import WildcardSDK
import AVFoundation
import Alamofire

class ResourcesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CardViewDelegate {
    //MARK: Properties
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    
    var resources = [Resource]()
    var resourceLinks = [String]()
    var cardViews = [CardView]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.tableView.delegate = self
        
        tableView.separatorColor = UIColor.clearColor()
        //loadSampleResources()
        
        //tableView.beginUpdates()
        if (GlobalUtils.loadString(Config.leaderApiKey) == "") {
            ServerUtils.loadResources("resource", inserter: insertResource, afterFunc: formatResources)
        } else {
            ServerUtils.loadSpecialResources("resource", inserter: insertResource, afterFunc: formatResources)
        }
        
        //tableView.reloadData()
        
        tableView.backgroundColor = Colors.googleGray
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 50
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Get resources from database
    func insertResource(dict : NSDictionary) {
        
        let resource = Resource(dict: dict)!
        
        resources.insert(resource, atIndex: 0)
        
        let url = NSURL.init(string: resource.url)
        
        Card.getFromUrl(url) {(card: Card?, error: NSError?) in
            
            if (error != nil) {
                print("Error getting card from url: \(error?.localizedDescription)")
            } else if(card != nil) {
                
                var cardView : CardView! = nil
                
                if (resource.type == "article") {
                    cardView = CardView.createCardView(card!, layout: .ArticleCardTall)!
                } else if (resource.type == "video") {
                    cardView = CardView.createCardView(card!, layout: .SummaryCardTall)!
                } else if (resource.type == "audio") {
                    cardView = CardView.createCardView(card!, layout: .VideoCardShort)!
                }
                
                if (cardView != nil) {
                    cardView.delegate = self
                    self.resources.insert(Resource(dict: dict)!, atIndex: 0)
                    self.cardViews.insert(cardView, atIndex: 0)
                    self.tableView.insertRowsAtIndexPaths([NSIndexPath(forItem: 0, inSection: 0)], withRowAnimation: .Automatic)
                }
            } else {
                print("\nERROR: Card view not created\n")
            }
        }
    }
    
    
    
    //Make and format every card view
    func formatResources() {
        
        //tableView.endUpdates()
        //		tableView.reloadData()
        
        
    }
    
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //print("\nNum card views in the thing: \(cardViews.count)\n")
        print("\nNum Resources: \(resources.count)\n")
        return cardViews.count
    }
    
    //Configures each cell in the table view as a card and sets the UI elements to match with the Resource data
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "CardTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! CardTableViewCell
        let cardView = cardViews[indexPath.row]
        
        cell.contentView.addSubview(cardView)
        cell.contentView.backgroundColor = Colors.googleGray
        
        self.constrainView(cardView, row: indexPath.row)
        
        
        return cell
    }
    
    private func constrainView(cardView: CardView, row: Int) {
        cardView.delegate = self
        cardView.translatesAutoresizingMaskIntoConstraints = false
        cardView.horizontallyCenterToSuperView(0)
        
        if(row == 0) {
            cardView.constrainTopToSuperView(15)
        }
        else {
            cardView.constrainTopToSuperView(7)
        }
        
        if(row == self.resources.count-1) {
            cardView.constrainBottomToSuperView(15)
        }
        else {
            cardView.constrainBottomToSuperView(8)
        }
        
        cardView.constrainRightToSuperView(15)
        cardView.constrainLeftToSuperView(15)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        /*for subview in self.tableView.subviews {
            if (NSStringFromClass(subview.dynamicType) == "UITableViewWrapperView")
            {
                print("Things")
                tableView.bounds.size.width = UIScreen.mainScreen().bounds.size.width
                subview.frame = CGRectMake(0, 0, tableView.bounds.size.width, tableView.bounds.size.height);
                print("\nTable view bounds: \(UIScreen.mainScreen().bounds.size.width)")
            }
        }*/
    }
    
    
    
    // MARK: Actions
    func cardViewRequestedAction(cardView: CardView, action: CardViewAction) {
        
        // Let Wildcard handle the Card Action
        handleCardAction(cardView, action: action)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
