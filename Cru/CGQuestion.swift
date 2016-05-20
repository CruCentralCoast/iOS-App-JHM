//
//  CGQuestion.swift
//  Cru
//
//  Created by Peter Godkin on 5/10/16.
//  Copyright © 2016 Jamaican Hopscotch Mafia. All rights reserved.
//

import Foundation

enum CGQuestionType : String {
    
    case TEXT = "text"
    case SELECT = "select"
    
    func name()->String {
        return self.rawValue
    }
}

class CGQuestion {
    
    static let ministryField = "ministry"

    let ministry: String
    let question: String
    let type: CGQuestionType
    let options: [String]

    init(dict: NSDictionary) {
        ministry = dict[CGQuestion.ministryField] as! String
        question = dict["question"] as! String
        type = CGQuestionType(rawValue: dict["type"] as! String)!
        
        let optionStructs = dict["selectOptions"] as! [NSDictionary]
        
        options = optionStructs.map() {$0["value"] as! String}
    }
}