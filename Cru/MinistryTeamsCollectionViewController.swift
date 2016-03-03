//
//  MinistryTeamsCollectionViewController.swift
//  Cru
//
//  Created by Deniz Tumer on 3/2/16.
//  Copyright © 2016 Jamaican Hopscotch Mafia. All rights reserved.
//

import UIKit

private let reuseIdentifier = "ministryteam"

class MinistryTeamsCollectionViewController: UICollectionViewController {

    var ministryTeams = [MinistryTeam]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //load ministry teams
        ServerUtils.loadResources("ministryteam", inserter: insertMinistryTeam, afterFunc: finishInserting)

        //set background color of page and accelleration of cells
        collectionView!.backgroundColor = UIColor.lightGrayColor()
        collectionView!.decelerationRate = UIScrollViewDecelerationRateFast
    }
    
    private func insertMinistryTeam(dict : NSDictionary) {
        self.ministryTeams.insert(MinistryTeam(dict: dict)!, atIndex: 0)
    }
    
    private func finishInserting() {
        self.collectionView!.reloadData()
    }

    // MARK: UICollectionViewDataSource
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ministryTeams.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! MinistryTeamsCollectionViewCell
        
        cell.ministryTeam = ministryTeams[indexPath.item]
        
        return cell
    }
}
