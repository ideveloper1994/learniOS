/**
 * NSCalendar+Timepiece.swift
 *
 * @package Makent
 * @subpackage Controller
 * @category Calendar
 * @author Trioangle Product Team
 * @version - Stable 1.0
 * @link http://trioangle.com
 */

import Foundation

private let supportsDateByAddingUnit = (NSCalendar.current as NSCalendar).responds(to: #selector(NSCalendar.date(byAdding:value:to:options:)))

extension NSCalendar {
    func dateByAddingDuration(_ duration: Duration, toDate date: Date, options opts: NSCalendar.Options) -> Date? {
        if supportsDateByAddingUnit {
            return self.date(byAdding: duration.unit, value: duration.value, to: date, options: .searchBackwards)!
        }
        else {
            // otherwise fallback to NSDateComponents
            return self.date(byAdding: NSDateComponents(duration) as DateComponents, to: date, options: .searchBackwards)!
        }
    }
}
