//
//  PhoneFormatter.swift
//  Cru
//
//  Created by Max Crane on 5/8/16.
//  Copyright © 2016 Jamaican Hopscotch Mafia. All rights reserved.
//

import Foundation

class PhoneFormatter {
    static func parsePhoneNumber(phoneNum : String) -> String {
        // split by '-'
        let full = phoneNum.componentsSeparatedByString("-")
        let left = full[0]
        let right = full[1]
        
        // get area code from ()
        var index1 = left.startIndex.advancedBy(1)
        let delFirstParen = left.substringFromIndex(index1)
        let index2 = delFirstParen.startIndex.advancedBy(3)
        let areaCode = delFirstParen.substringToIndex(index2)
        
        // get first three digits
        index1 = left.startIndex.advancedBy(6)
        let threeDigits = left.substringFromIndex(index1)
        
        // get last four digits
        // = right
        
        let finalPhoneNum = areaCode + threeDigits + right
        //return Int(finalPhoneNum)!
        return finalPhoneNum
        
    }
    
    static func unparsePhoneNumber(phoneNum: String) -> String{
        let str : NSMutableString = NSMutableString(string: phoneNum)
        str.insertString("(", atIndex: 0)
        str.insertString(")", atIndex: 4)
        str.insertString(" ", atIndex: 5)
        str.insertString("-", atIndex: 9)
        return str as String
    }
}