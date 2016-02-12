//
//  DateExtension.swift
//  Cru
//
//  An extension for NSDateComponents that returns formatted String representations of the Date.
//
//  Created by Quan Tran on 2/11/16.
//  Copyright © 2016 Jamaican Hopscotch Mafia. All rights reserved.
//

import Foundation


extension NSDateComponents
{
    /**
     Returns a MM-DD-YYYY representaton of the date using the default separator.
     */
    func formatMDY() -> String {
        return formatMDY(" ")
    }
    
    /**
     Returns a MM-DD-YYYY representaton of the date using the given separator.
     */
    func formatMDY(separator : String) -> String {
        return String(self.month) + separator + String(self.month) + separator + String(self.year)
    }
    
    /**
     Returns a YYYY-MM-DD representaton of the date using the default separator.
     */
    func formatYMD() -> String {
        return formatYMD(" ")
    }
    
    /**
     Returns a YYYY-MM-DD representaton of the date using the given separator.
     */    func formatYMD(separator
        : String) -> String {
            return String(self.year) + separator + String(self.month) + separator + String(self.day)
    }
    
    /**
     Returns a YYYY-MM-DD representaton of the date using the given separator.
     */
    func formattedTime() -> String {
        return String(self.hour) + ":" + String(self.minute)
    }
}