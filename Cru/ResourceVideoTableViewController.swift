//
//  ResourceVideoTableViewController.swift
//  Cru
//
//  Created by Deniz Tumer on 11/30/15.
//  Copyright © 2015 Jamaican Hopscotch Mafia. All rights reserved.
//

import UIKit

class ResourceVideoTableViewController: UITableViewController {

    //MARK: Properties
    var videoObjects = [NSString]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        loadSampleVideos()
    }
    
    //function for loading sample data about videos
    func loadSampleVideos() {
        let video1: NSString = "<iframe width=300 height=200 src=https://www.youtube.com/embed/5qwyoi3sQPI allowfullscreen></iframe>"
        let video2: NSString = "<iframe width=300 height=200 src=https://www.youtube.com/embed/6Zf79Ns8_oY allowfullscreen></iframe>"
        let video3: NSString = "<iframe width=300 height=200 src=https://www.youtube.com/embed/6Zf79Ns8_oY allowfullscreen></iframe>"
        let video4: NSString = "<iframe width=300 height=200 src=https://www.youtube.com/embed/6Zf79Ns8_oY allowfullscreen></iframe>"
        let video5: NSString = "<iframe width=300 height=200 src=https://www.youtube.com/embed/6Zf79Ns8_oY allowfullscreen></iframe>"
        
        videoObjects += [video1, video2, video3, video4, video5]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return videoObjects.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "ResourceVideoTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! ResourceVideoTableViewCell
        
        let video = videoObjects[indexPath.row]
        
        cell.embededVideo.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)
        cell.embededVideo.loadHTMLString(video as String, baseURL: nil)
        cell.embededVideo.scrollView.scrollEnabled = false

        return cell
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
