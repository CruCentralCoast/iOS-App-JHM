//
//  CampusesTableViewController.swift
//  Cru
//
//  Created by Max Crane on 11/25/15.
//  Copyright © 2015 Jamaican Hopscotch Mafia. All rights reserved.
//

import UIKit
import MRProgress

class MinistryTableViewController: UITableViewController {
    var ministries = [Ministry]()            //list of ALL ministries
    var subscribedCampuses = [Campus]()      //list of subscribed campuses
    var ministryMap = [Campus: [Ministry]]() //map of all subscribed campsuses to their respective ministries
    var prevMinistries = [Ministry]()        //list of previously subscribed ministries (saved on device)
    var totalMegsUsed = 0.0
    var viewWasLoaded = false
    
    override func viewWillAppear(animated: Bool) {

        if(viewWasLoaded){
            self.reloadData()
        }//
        //viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        print("MEMORY OVERLOAD")
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewWasLoaded = true
        let campuses = SubscriptionManager.loadCampuses()
        if(campuses != nil){
            subscribedCampuses = campuses!
        }
        
        let tempMinistries = SubscriptionManager.loadMinistries()
        if(tempMinistries != nil){
            prevMinistries = tempMinistries!
        }

        ServerUtils.loadResources(Config.ministryCollection, inserter: insertMinistry, afterFunc: reloadData)
        self.tableView.reloadData()	
    }
    
    func reloadData(){
        //super.viewDidLoad()
        subscribedCampuses = SubscriptionManager.loadCampuses()!
        prevMinistries = SubscriptionManager.loadMinistries()!
                
        refreshMinistryMap()
        self.tableView.reloadData()
    }
    
    
    func refreshMinistryMap() {
        ministryMap.removeAll()
        for ministry in ministries {
            for campus in subscribedCampuses {
                if(SubscriptionManager.campusContainsMinistry(campus, ministry: ministry)) {
                    if(prevMinistries.contains(ministry)){
                        ministry.feedEnabled = true
                    }
                    else{
                        ministry.feedEnabled = false
                    }
                    
                    
                    if (ministryMap[campus] == nil){
                        ministryMap[campus] = [ministry]
                    }
                    else{
                        ministryMap[campus]!.insert(ministry, atIndex: 0)
                    }
                    
                }
            }
        }
    }
    
    
    func insertMinistry(dict : NSDictionary) {
        let newMinistry = Ministry(dict: dict)
        
        if(prevMinistries.contains(newMinistry)){
            newMinistry.feedEnabled = true
        }
        
        ministries.insert(newMinistry, atIndex: 0)
    }
    
    override func viewWillDisappear(animated: Bool) {
        saveMinistriesToDevice()
    }
    
    func saveMinistriesToDevice(){
        var subscribedMinistries = [Ministry]()
        
        for campus in subscribedCampuses{
            let campusMinistries = ministryMap[campus]
            if (campusMinistries != nil) {
                for ministry in campusMinistries! {
                    subscribedMinistries.append(ministry)
                }
            }
        }
        SubscriptionManager.saveMinistrys(subscribedMinistries, updateGCM: false)
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return subscribedCampuses.count
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return subscribedCampuses[section].name
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let campus = subscribedCampuses[section]
        return ministryMap[campus] == nil ? 0 : ministryMap[campus]!.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCellWithIdentifier("ministryCell", forIndexPath: indexPath) as! MinistryTableViewCell
        
            let ministry = getMinistryAtIndexPath(indexPath)
            cell.ministryNameLabel.text = ministry.name
        
            //display add-ons
            cell.ministryNameLabel.font = UIFont(name: "FreightSans Pro", size: 17)
            cell.ministryNameLabel.textColor = Config.introModalContentTextColor
        
  
            //let url = NSURL(string: ministry.imageUrl)
            //let data = NSData(contentsOfURL: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check
            //downloadImage(url!, imageView: cell.minstryImage) //UIImage(data: data!)
        
            asyncLoadMinistryImage(ministry, imageView: cell.minstryImage)
        
            if(ministry.feedEnabled == true){
                cell.accessoryType = .Checkmark
            }
            else{
                cell.accessoryType = .None
            }
        
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let cell = tableView.cellForRowAtIndexPath(indexPath){
            let ministry = getMinistryAtIndexPath(indexPath)
            
            if(cell.accessoryType == .Checkmark){
                cell.accessoryType = .None
                ministry.feedEnabled = false
                
                MRProgressOverlayView.showOverlayAddedTo(self.view, animated: true)
                SubscriptionManager.unsubscribeToTopic("/topics/" + ministry.id, handler: {(success) in
                    
                    let title = success ? "Successfully unsubscribed" : "Failed to unsubscribe"
                    
                    let alert = UIAlertController(title: title, message: "", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
                    
                    MRProgressOverlayView.dismissOverlayForView(self.view, animated: true, completion: {
                        self.presentViewController(alert, animated: true, completion: nil)
                    })
                })
            }
            else{
                cell.accessoryType = .Checkmark
                ministry.feedEnabled = true
                
                MRProgressOverlayView.showOverlayAddedTo(self.view, animated: true)
                SubscriptionManager.subscribeToTopic("/topics/" + ministry.id, handler: {(success) in
                    
                    let title = success ? "Successfully subscribed" : "Failed to subscribe"
                    
                    let alert = UIAlertController(title: title, message: "", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
                    
                    MRProgressOverlayView.dismissOverlayForView(self.view, animated: true, completion: {
                        self.presentViewController(alert, animated: true, completion: nil)
                    })
                })
            }
            
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
            //tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        }
        
    }
    
    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int)
    {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.font = UIFont(name: "FreightSans Pro", size: 20)!
        header.textLabel?.textColor = UIColor.blackColor()
    }
    
    func getMinistryAtIndexPath(indexPath: NSIndexPath)->Ministry{
        let row = indexPath.row
        let section = indexPath.section
        return ministryMap[subscribedCampuses[section]]![row]
    }
    
    
    
    func asyncLoadMinistryImage(min: Ministry, imageView: UIImageView){
        //let downloadQueue = dispatch_queue_create("com.cru.downloadImage", nil)
        
        
        dispatch_async(dispatch_get_main_queue(), {
            
            if(min.imageData == nil){
                //let stream = NSInputStream(URL: NSURL(string: min.imageUrl)!)
                
                let data = NSData(contentsOfURL: NSURL(string: min.imageUrl)!)
                self.totalMegsUsed += Double(data!.length)/1024.0/1024.0
                //    print("got it .... yiiissss \(Double(data!.length)/1024.0/1024.0)")
                //print("total: \(self.totalMegsUsed)")
                var image : UIImage?
                
                if data != nil{
                    min.imageData = data
                    image = UIImage(data: data!)!
                }
                
                dispatch_async(dispatch_get_main_queue(), {
                    imageView.contentMode = .ScaleAspectFit
                    
                    //alternate method of setting the image
                    //imageView.image = self.smallerImage(image!)
                    imageView.image = self.resizeImage(image!, newWidth: 150.0)
                })
            }
            
            
            
        })
        
    }
//    func getDataFromUrl(url:NSURL, completion: ((data: NSData?, response: NSURLResponse?, error: NSError? ) -> Void)) {
//        NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) in
//            completion(data: data, response: response, error: error)
//            }.resume()
//    }
//    
//    func downloadImage(url: NSURL, imageView: UIImageView){
//        //print("Download Started")
//        //print("lastPathComponent: " + (url.lastPathComponent ?? ""))
//        getDataFromUrl(url) { (data, response, error)  in
//            dispatch_async(dispatch_get_main_queue()) { () -> Void in
//                guard let data = data where error == nil else { return }
//                //print(response?.suggestedFilename ?? "")
//                //print("Download Finished")
//                imageView.image = self.resizeImage(UIImage(data: data)!, newWidth: 50.0)
//            }
//        }
//    }
//    
    
    func smallerImage(image: UIImage)->UIImage{
        let size = CGSizeApplyAffineTransform(image.size, CGAffineTransformMakeScale(0.1, 0.1))
        let hasAlpha = false
        let scale: CGFloat = 0.0 // Automatically use scale factor of main screen
        
        UIGraphicsBeginImageContextWithOptions(size, !hasAlpha, scale)
        image.drawInRect(CGRect(origin: CGPointZero, size: size))
        
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return scaledImage
    }
    
    
    func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage {
        
        let scale = newWidth / image.size.width
        let oldWidth = image.size.width
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight))
        image.drawInRect(CGRectMake(0, 0, newWidth, newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        //print("resized image: from \(oldWidth) to \(newWidth)")
        return newImage
    }
    
    
    
}
