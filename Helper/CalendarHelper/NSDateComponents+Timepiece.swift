/**
 * NSDateComponents+Timepiece.swift
 *
 * @package Makent
 * @subpackage Controller
 * @category Calendar
 * @author Trioangle Product Team
 * @version - Stable 1.0
 * @link http://trioangle.com
 */

import Foundation

extension NSDateComponents {
    convenience init(_ duration: Duration) {
        self.init()
        switch duration.unit{
        case NSCalendar.Unit.day:
            day = duration.value
        case NSCalendar.Unit.weekday:
            weekday = duration.value
        case NSCalendar.Unit.weekOfMonth:
            weekOfMonth = duration.value
        case NSCalendar.Unit.weekOfYear:
            weekOfYear = duration.value
        case NSCalendar.Unit.hour:
            hour = duration.value
        case NSCalendar.Unit.minute:
            minute = duration.value
        case NSCalendar.Unit.month:
            month = duration.value
        case NSCalendar.Unit.second:
            second = duration.value
        case NSCalendar.Unit.year:
            year = duration.value
        default:
            () // unsupported / ignore
        }
    }
}
