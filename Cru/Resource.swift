//
//  Resource.swift
//  Cru
//
//  Created by Erica Solum on 2/13/16.
//  Copyright © 2016 Jamaican Hopscotch Mafia. All rights reserved.
//

import UIKit

class Resource {
    // MARK: Properties
    var title: String!
    var id: String!
    var url: String!
    var type: String!
    var date: NSDateComponents!
    var tags: [String]!
    
    init?(id: String?, title: String?, url: String?, type: String?, date: String?, tags: [String]?) {
        // Initialize properties
        self.id = id
        self.title = title
        self.url = url
        self.type = type
        self.date = ServerUtils.dateFromString(date!)!
        self.tags = tags
    }
    
    convenience init?(dict : NSDictionary) {
        let id = dict["_id"] as! String?
        let title = dict["title"] as! String?
        let type = dict["type"] as! String?
        let url = dict["url"] as! String?
        let date = dict["date"] as! String?
        let tags = dict["tags"] as! [String]?
        
        
        
        self.init(id: id, title: title, url: url, type: type, date: date, tags: tags)
    }
}