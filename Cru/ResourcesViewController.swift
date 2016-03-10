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

class ResourcesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITabBarDelegate, CardViewDelegate {
    //MARK: Properties
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var selectorBar: UITabBar!
    
    var resources = [Resource]()
    var resourceLinks = [String]()
    var cardViews = [CardView]()
    
    var currentType = ResourceType.Article
    var articleViews = [CardView]()
    var audioViews = [CardView]()
    var videoViews = [CardView]()

    override func viewDidLoad() {
        super.viewDidLoad()
        selectorBar.selectedItem = selectorBar.items![0]
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
                print("\(articleViews.count) articles")
                oldTypeCount = articleViews.count
            case .Audio:
                print("\(audioViews.count) audio")
                oldTypeCount = audioViews.count
            case .Video:
                print("\(videoViews.count) video")
                oldTypeCount = videoViews.count
        }
        
        if(newType == currentType){
            return
        }
        else{
            currentType = newType
        }

        let numNewCells = newTypeCount - oldTypeCount
        print("newTypeCount is \(newTypeCount)")
        print("oldTypeCount is \(oldTypeCount)")
        print("numNewCells is \(numNewCells)")
        
        self.tableView.beginUpdates()
        if(numNewCells < 0){
            let numCellsToRemove = -numNewCells
            print("ABOUT TO REMOVE \(numCellsToRemove) cells")
            for i in 0...(numCellsToRemove - 1){
                print("meep")
                self.tableView.deleteRowsAtIndexPaths([NSIndexPath(forItem: i, inSection: 0)], withRowAnimation: .Automatic)
            }
        }
        else if(numNewCells > 0){
            for i in 0...(numNewCells - 1){
                print("beep")
                self.tableView.insertRowsAtIndexPaths([NSIndexPath(forItem: i, inSection: 0)], withRowAnimation: .Automatic)
            }
        }
        self.tableView.endUpdates()
        self.tableView.reloadData()
        //print("selected \(item.title)")
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
                
                if (resource.type == ResourceType.Article) {
                    cardView = CardView.createCardView(card!, layout: .ArticleCardTall)!
                    self.articleViews.insert(cardView, atIndex: 0)
                } else if (resource.type == ResourceType.Video) {
                    cardView = CardView.createCardView(card!, layout: .SummaryCardTall)!
                    self.videoViews.insert(cardView, atIndex: 0)
                } else if (resource.type == ResourceType.Audio) {
                    cardView = CardView.createCardView(card!, layout: .VideoCardShort)!
                    self.audioViews.insert(cardView, atIndex: 0)
                }
                
                if (cardView != nil) {
                    cardView.delegate = self
                    self.resources.insert(Resource(dict: dict)!, atIndex: 0)
                    //self.cardViews.insert(cardView, atIndex: 0)
                    if(self.currentType == resource.type){
                        self.tableView.insertRowsAtIndexPaths([NSIndexPath(forItem: 0, inSection: 0)], withRowAnimation: .Automatic)
                    }
                    
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
        //print("\nNum Resources: \(resources.count)\n")
        //return cardViews.count
        
        switch (currentType){
        case .Article:
            print("\(articleViews.count) articles")
            return articleViews.count
        case .Audio:
            print("\(audioViews.count) audio")
            return audioViews.count
        case .Video:
            print("\(videoViews.count) video")
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
        
        //let cardView = cardViews[indexPath.row]
        
        cell.contentView.addSubview(cardView!)
        cell.contentView.backgroundColor = Colors.googleGray
        
        self.constrainView(cardView!, row: indexPath.row)
        
        
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
