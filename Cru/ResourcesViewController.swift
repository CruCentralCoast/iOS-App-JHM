//
//  ResourcesViewController.swift
//  Cru
//  Formats and displays the resources in the Cru database as cards. Handles actions for full-screen view.
//
//  Created by Erica Solum on 2/18/15.
//  Copyright © 2015 Jamaican Hopscotch Mafia. All rights reserved.
//

import UIKit
import WildcardSDK
import AVFoundation
import Alamofire

class ResourcesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITabBarDelegate, CardViewDelegate {
    //MARK: Properties
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var selectorBar: UITabBar!
    
    var resources = [Resource]()
    var cardViews = [CardView]()
    
    var currentType = ResourceType.Article
    var articleViews = [CardView]()
    var audioViews = [CardView]()
    var videoViews = [CardView]()

    override func viewDidLoad() {
        super.viewDidLoad()
        selectorBar.selectedItem = selectorBar.items![0]
        self.tableView.delegate = self
        
        //Make the line between cells invisible
        tableView.separatorColor = UIColor.clearColor()
        
        //If the user is logged in, view special resources. Otherwise load non-restricted resources.
        if (GlobalUtils.loadString(Config.leaderApiKey) == "") {
            ServerUtils.loadResources("resource", inserter: insertResource, afterFunc: formatResources)
        } else {
            ServerUtils.loadSpecialResources("resource", inserter: insertResource, afterFunc: formatResources)
        }
        
        
        tableView.backgroundColor = Colors.googleGray
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 50
        
    }
    
    //Code for the bar at the top of the view for filtering resources
    func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
        var newType: ResourceType
        var oldTypeCount = 0
        var newTypeCount = 0
        
        switch (item.title!){
            case "Articles":
                newType = ResourceType.Article
                newTypeCount = articleViews.count
            case "Audio":
                newType = ResourceType.Audio
                newTypeCount = audioViews.count
            case "Videos":
                newType = ResourceType.Video
                newTypeCount = videoViews.count
            default :
                newType = ResourceType.Article
                newTypeCount = articleViews.count
        }
        
        switch (currentType){
            case .Article:
                oldTypeCount = articleViews.count
            case .Audio:
                oldTypeCount = audioViews.count
            case .Video:
                oldTypeCount = videoViews.count
        }
        
        if(newType == currentType){
            return
        }
        else{
            currentType = newType
        }

        let numNewCells = newTypeCount - oldTypeCount

        self.tableView.beginUpdates()
        if(numNewCells < 0){
            let numCellsToRemove = -numNewCells
            for i in 0...(numCellsToRemove - 1){
                self.tableView.deleteRowsAtIndexPaths([NSIndexPath(forItem: i, inSection: 0)], withRowAnimation: .Automatic)
            }
        }
        else if(numNewCells > 0){
            for i in 0...(numNewCells - 1){
                self.tableView.insertRowsAtIndexPaths([NSIndexPath(forItem: i, inSection: 0)], withRowAnimation: .Automatic)
            }
        }
        self.tableView.endUpdates()
        self.tableView.reloadData()
    }
    
    //Automatically generated function. Might have to use later if too many resources are loaded.
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Get resources from database
    func insertResource(dict : NSDictionary) {
        let resource = Resource(dict: dict)!
        resources.insert(resource, atIndex: 0)
        let url = NSURL.init(string: resource.url)
        
        //Create card by passing in the URL to the video or article page
        Card.getFromUrl(url) {(card: Card?, error: NSError?) in
            if (error != nil) {
                print("Error getting card from url: \(error?.localizedDescription)")
            } else if(card != nil) {
                
                var cardView : CardView! = nil
                
                //Create card with Article card layout
                if (resource.type == ResourceType.Article) {
                    cardView = CardView.createCardView(card!, layout: .ArticleCardTall)!
                    self.articleViews.insert(cardView, atIndex: 0)
                }
                //Create a video card as a summary card because of the transcripts
                else if (resource.type == ResourceType.Video) {
                    cardView = CardView.createCardView(card!, layout: .SummaryCardTall)!
                    self.videoViews.insert(cardView, atIndex: 0)
                }
                //Audio is currently not supported
                else if (resource.type == ResourceType.Audio) {
                    //cardView = CardView.createCardView(card!, layout: .VideoCardShort)!
                    //self.audioViews.insert(cardView, atIndex: 0)
                }
                
                //If card was created, insert the resource into the array and insert it into the table
                if (cardView != nil) {
                    cardView.delegate = self
                    self.resources.insert(Resource(dict: dict)!, atIndex: 0)
                    if(self.currentType == resource.type){
                        self.tableView.insertRowsAtIndexPaths([NSIndexPath(forItem: 0, inSection: 0)], withRowAnimation: .Automatic)
                    }     
                }
            } else {
                print("\nERROR: Card view not created\n")
            }
        }
    }
    
    // MARK: - Table view data source
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    //Return the number of cards depending on the type of resource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch (currentType){
            case .Article:
                return articleViews.count
            case .Audio:
                return audioViews.count
            case .Video:
                return videoViews.count
        }
    }
    
    //Configures each cell in the table view as a card and sets the UI elements to match with the Resource data
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "CardTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! CardTableViewCell
        let cardView: CardView?
        
        switch (currentType){
            case .Article:
                cardView = articleViews[indexPath.row]
            case .Audio:
                cardView = audioViews[indexPath.row]
            case .Video:
                cardView = videoViews[indexPath.row]
        }
        
        //Add the newl card view to the cell
        cell.contentView.addSubview(cardView!)
        cell.contentView.backgroundColor = Colors.googleGray
        
        //Set the constraints
        self.constrainView(cardView!, row: indexPath.row)
        return cell
    }
    
    //Sets the constraints for the cards so they float in the middle of the table
    private func constrainView(cardView: CardView, row: Int) {
        cardView.delegate = self
        cardView.translatesAutoresizingMaskIntoConstraints = false
        cardView.horizontallyCenterToSuperView(0)
        
        cardView.constrainTopToSuperView(15)
        cardView.constrainBottomToSuperView(15)
        cardView.constrainRightToSuperView(15)
        cardView.constrainLeftToSuperView(15) 
    }
    
    // MARK: Actions
    func cardViewRequestedAction(cardView: CardView, action: CardViewAction) {
        
        // Let Wildcard handle the Card Action
        handleCardAction(cardView, action: action)
    }
}