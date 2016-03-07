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
        
        tableView.backgroundColor = UIColor(red: 0.871, green: 0.871, blue: 0.871, alpha: 1.0)
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 50
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Get resources from database
    func insertResource(dict : NSDictionary) {
        
        resources.insert(Resource(dict: dict)!, atIndex: 0)
        
        self.tableView.insertRowsAtIndexPaths([NSIndexPath(forItem: 0, inSection: 0)], withRowAnimation: .Automatic)
        
    }
    
    //Make and format every card view
    func formatResources() {
        
        //tableView.endUpdates()
        tableView.reloadData()
        
        
    }
    
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //print("\nNum card views in the thing: \(cardViews.count)\n")
        print("\nNum Resources: \(resources.count)\n")
        return resources.count
    }
    
    //Configures each cell in the table view as a card and sets the UI elements to match with the Resource data
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "CardTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! CardTableViewCell
        //let cardView = cardViews[indexPath.row]
        
        let res = resources[indexPath.row]
       
        let url = NSURL.init(string: res.url)
        
        
        Card.getFromUrl(url) {
            (card: Card?, error: NSError?) in
                
                if(card != nil) {
                    
                    //Format card as an article
                    if (res.type == "article") {
                        //NEW CODE STARTS HERE
                        /*let articleURL = url
                        let articleData:NSMutableDictionary = NSMutableDictionary()
                        let articleBaseData:NSMutableDictionary = NSMutableDictionary()
                        articleData["htmlContent"] = "<div>Some Content</div>"
                        articleData["publicationDate"] = NSNumber(longLong: 1429063354000)
                        let articleMedia:NSMutableDictionary = NSMutableDictionary()
                        articleMedia["imageUrl"] =  "http://i2.cdn.turner.com/money/dam/assets/150414182846-high-there-image-1024x576.jpeg"
                        articleMedia["type"] = "image"
                        articleData["media"] = articleMedia
                        articleBaseData["article"] = articleData
                        
                        articleCard = ArticleCard(title: "The surprising backstory of Tinder for pot smokers", abstractContent: "That's what co-founder Todd Mitchem hopes to create with High There -- \"a social connection app for cannabis consumers.\" Users can look for dates or simply other like-minded people. But for those used to dating apps like Tinder or OkCupid, the questions will probably be a bit unfamiliar.", url: articleURL, creator: cnn, data: articleBaseData)
                        */
                        
                        //let aCard = card as! ArticleCard
                        //print("\nHTML: \(aCard.html)\n")
                        
                        /*
                        let dataArray = aCard.media!
                        print("Data items count: \(dataArray.count)\n")

                        for (key, value) in dataArray {
                            print("Property: \(key as! String)\n")
                            if value is NSNull {
                                print("Value: Null\n")
                            }
                            else {
                                print("Value: \(value as! String)\n")
                            }
                        }*/
                        
                        
                        //NEW CODE ENDS HERE
                        
                        
                        let articleCardView = CardView.createCardView(card!, layout: .ArticleCardTall)
                        if(articleCardView != nil) {
                            articleCardView!.delegate = self
                            
                            print("Added article card\n")
                            
                            cell.contentView.addSubview(articleCardView!)
                            cell.contentView.backgroundColor = UIColor(red: 0.871, green: 0.871, blue: 0.871, alpha: 1.0)
                            articleCardView!.translatesAutoresizingMaskIntoConstraints = false
                            articleCardView!.horizontallyCenterToSuperView(0)
                            
                            if(indexPath.row == 0) {
                                articleCardView!.constrainTopToSuperView(15)
                            }
                            else {
                                articleCardView!.constrainTopToSuperView(7)
                            }
                            
                            if(indexPath.row == self.resources.count-1) {
                                articleCardView!.constrainBottomToSuperView(15)
                            }
                            else {
                                articleCardView!.constrainBottomToSuperView(8)
                            }
                            
                            articleCardView!.constrainRightToSuperView(15)
                            articleCardView!.constrainLeftToSuperView(15)
                            
                        }
                        
                    }
                        
                        //Format card as an video
                    else if (res.type == "video") {
                        let videoCardView = CardView.createCardView(card!, layout: .SummaryCardTall)
                        if(videoCardView != nil) {
                            videoCardView!.delegate = self
                            //self.cardViews.append(videoCardView!)
                            print("Added video card\n")
                            
                            cell.contentView.addSubview(videoCardView!)
                            cell.contentView.backgroundColor = UIColor(red: 0.871, green: 0.871, blue: 0.871, alpha: 1.0)
                            videoCardView!.translatesAutoresizingMaskIntoConstraints = false
                            videoCardView!.horizontallyCenterToSuperView(0)
                            
                            if(indexPath.row == 0) {
                                videoCardView!.constrainTopToSuperView(15)
                            }
                            else {
                                videoCardView!.constrainTopToSuperView(7)
                            }
                            
                            if(indexPath.row == self.resources.count-1) {
                                videoCardView!.constrainBottomToSuperView(15)
                            }
                            else {
                                videoCardView!.constrainBottomToSuperView(8)
                            }
                            
                            //videoCardView!.constrainTopToSuperView(15)
                            //videoCardView!.constrainBottomToSuperView(7)
                            videoCardView!.constrainRightToSuperView(15)
                            videoCardView!.constrainLeftToSuperView(15)
                            
                        }
                        
                    }
                        
                        //Format card as an audio file
                    else if (res.type == "audio") {
                        
                        
                        //START OLD CO
                        let audioCardView = CardView.createCardView(card!, layout: .VideoCardShort)
                        if(audioCardView != nil) {
                            audioCardView!.delegate = self
                            //self.cardViews.append(audioCardView!)
                            print("Added audio card\n")
                            
                            cell.contentView.addSubview(audioCardView!)
                            cell.contentView.backgroundColor = UIColor(red: 0.871, green: 0.871, blue: 0.871, alpha: 1.0)
                            audioCardView!.translatesAutoresizingMaskIntoConstraints = false
                            audioCardView!.horizontallyCenterToSuperView(0)
                            audioCardView!.constrainTopToSuperView(10)
                            audioCardView!.constrainBottomToSuperView(10)
                            audioCardView!.constrainRightToSuperView(10)
                            audioCardView!.constrainLeftToSuperView(10)
                        }
                        
                    }
                }
                else {
                    print("\nERROR: Card view not created\n")
                }
            }
        
        return cell
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
