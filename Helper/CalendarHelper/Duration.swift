/**
 * Duration.swift
 *
 * @package Makent
 * @subpackage Controller
 * @category Calendar
 * @author Trioangle Product Team
 * @version - Stable 1.0
 * @link http://trioangle.com
 */

import Foundation

prefix func - (duration: Duration) -> (Duration) {
    return Duration(value: -duration.value, unit: duration.unit)
}

class Duration {
    let value: Int
    let unit: NSCalendar.Unit
    fileprivate let calendar = (Calendar.current as NSCalendar)
    
    /**
     Initialize a date before a duration.
     */
    var ago: Date {
        return ago(from: Date())
    }
    
    func ago(from date: Date) -> Date {
        return calendar.dateByAddingDuration(-self, toDate: date, options: .searchBackwards)!
    }
    
    /**
     Initialize a date after a duration.
     */
    var later: Date {
        return later(from: Date())
    }
    
    func later(from date: Date) -> Date {
        return calendar.dateByAddingDuration(self, toDate: date, options: .searchBackwards)!
    }
    
    init(value: Int, unit: NSCalendar.Unit) {
        self.value = value
        self.unit = unit
    }
}
