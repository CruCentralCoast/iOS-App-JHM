//
//  ResourcesViewController.swift
//  Cru
//
//  Created by Max Crane on 11/17/15.
//  Copyright © 2015 Jamaican Hopscotch Mafia. All rights reserved.
//

import UIKit
import WildcardSDK

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
        ServerUtils.loadResources("resource", inserter: insertResource, afterFunc: formatResources)
        
        
        //tableView.reloadData()
        
        
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
                        let articleCardView = CardView.createCardView(card!, layout: .ArticleCardTall)
                        if(articleCardView != nil) {
                            articleCardView!.delegate = self
                            
                            print("Added article card\n")
                            
                            cell.contentView.addSubview(articleCardView!)
                            cell.contentView.backgroundColor = UIColor(red: 0.871, green: 0.871, blue: 0.871, alpha: 1.0)
                            articleCardView!.translatesAutoresizingMaskIntoConstraints = false
                            articleCardView!.horizontallyCenterToSuperView(0)
                            articleCardView!.constrainTopToSuperView(10)
                            articleCardView!.constrainBottomToSuperView(10)
                            articleCardView!.constrainRightToSuperView(10)
                            articleCardView!.constrainLeftToSuperView(10)
                            
                        }
                        
                    }
                        
                        //Format card as an video
                    else if (res.type == "video") {
                        let videoCardView = CardView.createCardView(card!, layout: .VideoCardShortFull)
                        if(videoCardView != nil) {
                            videoCardView!.delegate = self
                            //self.cardViews.append(videoCardView!)
                            print("Added video card\n")
                            
                            cell.contentView.addSubview(videoCardView!)
                            cell.contentView.backgroundColor = UIColor(red: 0.871, green: 0.871, blue: 0.871, alpha: 1.0)
                            videoCardView!.translatesAutoresizingMaskIntoConstraints = false
                            videoCardView!.horizontallyCenterToSuperView(0)
                            videoCardView!.constrainTopToSuperView(10)
                            videoCardView!.constrainBottomToSuperView(10)
                            videoCardView!.constrainRightToSuperView(10)
                            videoCardView!.constrainLeftToSuperView(10)
                            
                        }
                        
                    }
                        
                        //Format card as an audio file
                    else if (res.type == "audio") {
                        let audioCardView = CardView.createCardView(card!, layout: .VideoCardShortFull)
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
        /*self.tableView.beginUpdates()
        tableView.insertRowsAtIndexPaths([
            NSIndexPath(forRow: cardViews.count-1, inSection: 0)
            ], withRowAnimation: .Automatic)
        
        self.tableView.endUpdates()
        
        tableView.reloadData()*/
        
        
        
        
        for subview in self.tableView.subviews {
            if (NSStringFromClass(subview.dynamicType) == "UITableViewWrapperView")
            {
                print("Things")
                tableView.bounds.size.width = UIScreen.mainScreen().bounds.size.width
                subview.frame = CGRectMake(0, 0, tableView.bounds.size.width, tableView.bounds.size.height);
                print("\nTable view bounds: \(UIScreen.mainScreen().bounds.size.width)")
            }
        }
    }
    
    
    
    //action function for changing the segmented view
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
